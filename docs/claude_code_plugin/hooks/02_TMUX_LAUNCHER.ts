/**
 * tmux Launcher
 *
 * Handles detection, launching, and management of tmux visualization sessions.
 * Supports multiple launch strategies with graceful fallbacks.
 *
 * @module hooks/TmuxLauncher
 * @version 1.0.0
 */

import * as vscode from 'vscode';
import { exec } from 'child_process';
import { promisify } from 'util';
import { Logger } from '../utils/logger';
import { StateManager } from '../storage/StateManager';

const execAsync = promisify(exec);

// ============================================================================
// Types
// ============================================================================

export interface TmuxAvailability {
  available: boolean;
  version?: string;
  path?: string;
  error?: string;
}

export enum LaunchStrategy {
  TMUX_SPLIT = 'tmux_split', // Split current tmux session
  TMUX_NEW_SESSION = 'tmux_new_session', // New tmux session
  VSCODE_TERMINAL = 'vscode_terminal', // VSCode integrated terminal
  NEW_TERMINAL_WINDOW = 'new_terminal_window', // Separate terminal window
  BROWSER_OVERLAY = 'browser_overlay', // WebView fallback
}

export interface LaunchConfig {
  mode: 'impressive' | 'subtle' | 'orchestration' | 'tutorial' | 'persistent';
  strategy?: LaunchStrategy;
  width?: number;
  height?: number;
  splitCurrent?: boolean;
  maximize?: boolean;
  fadeIn?: boolean;
  duration?: number;
  playIntroAnimation?: boolean;
  showTooltip?: string;
  showStepBreakdown?: boolean;
  expectedPhases?: number;
  autoHide?: boolean;
  showProgressBar?: boolean;
  showWelcomeMessage?: boolean;
  playFullAnimation?: boolean;
  callToAction?: {
    text: string;
    url: string;
  };
}

export interface TmuxSession {
  name: string;
  created: Date;
  panes: number;
  active: boolean;
}

// ============================================================================
// tmux Launcher
// ============================================================================

export class TmuxLauncher {
  private static instance: TmuxLauncher;
  private logger: Logger;
  private stateManager: StateManager;
  private activeSessions: Set<string> = new Set();
  private readonly MAX_SESSIONS = 3;
  private readonly SESSION_PREFIX = 'flickering-scenery-';
  private tmuxAvailability?: TmuxAvailability;

  private constructor() {
    this.logger = new Logger('TmuxLauncher');
    this.stateManager = StateManager.getInstance();
    this.loadState();
  }

  static getInstance(): TmuxLauncher {
    if (!TmuxLauncher.instance) {
      TmuxLauncher.instance = new TmuxLauncher();
    }
    return TmuxLauncher.instance;
  }

  // ==========================================================================
  // Detection & Capability Checking
  // ==========================================================================

  /**
   * Detect if tmux is available and get version info
   */
  async detectTmux(): Promise<TmuxAvailability> {
    // Return cached result if available
    if (this.tmuxAvailability) {
      return this.tmuxAvailability;
    }

    try {
      const { stdout: path } = await execAsync('which tmux');

      if (!path.trim()) {
        this.tmuxAvailability = {
          available: false,
          error: 'tmux not found in PATH',
        };
        return this.tmuxAvailability;
      }

      const { stdout: version } = await execAsync('tmux -V');
      const versionMatch = version.match(/tmux (\d+\.\d+)/);

      this.tmuxAvailability = {
        available: true,
        version: versionMatch?.[1] || 'unknown',
        path: path.trim(),
      };

      this.logger.info(`tmux detected: ${this.tmuxAvailability.version}`);
      return this.tmuxAvailability;
    } catch (error) {
      this.logger.warn('tmux not available:', error);
      this.tmuxAvailability = {
        available: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      };
      return this.tmuxAvailability;
    }
  }

  /**
   * Check if we're currently inside a tmux session
   */
  isInTmux(): boolean {
    return !!process.env.TMUX;
  }

  /**
   * Check if running in a terminal (vs GUI)
   */
  async isRunningInTerminal(): Promise<boolean> {
    return process.env.TERM !== undefined;
  }

  /**
   * Choose best launch strategy based on environment
   */
  async chooseLaunchStrategy(): Promise<LaunchStrategy> {
    const tmux = await this.detectTmux();
    const inTerminal = await this.isRunningInTerminal();
    const inTmux = this.isInTmux();
    const inVSCode = !!vscode.env.appName;

    this.logger.debug('Environment:', {
      tmux: tmux.available,
      inTerminal,
      inTmux,
      inVSCode,
    });

    if (inTmux && tmux.available) {
      return LaunchStrategy.TMUX_SPLIT;
    } else if (tmux.available && inTerminal) {
      return LaunchStrategy.TMUX_NEW_SESSION;
    } else if (inVSCode) {
      return LaunchStrategy.VSCODE_TERMINAL;
    } else if (tmux.available) {
      return LaunchStrategy.NEW_TERMINAL_WINDOW;
    } else {
      return LaunchStrategy.BROWSER_OVERLAY;
    }
  }

  // ==========================================================================
  // Main Launch Method
  // ==========================================================================

  /**
   * Launch visualization with automatic strategy selection and fallbacks
   */
  async launch(config: LaunchConfig): Promise<void> {
    this.logger.info('Launching visualization', config);

    // Choose strategy if not specified
    if (!config.strategy) {
      config.strategy = await this.chooseLaunchStrategy();
    }

    try {
      await this.launchWithStrategy(config);
    } catch (error) {
      this.logger.error('Launch failed, trying fallback:', error);
      await this.launchWithFallback(config);
    }
  }

  /**
   * Launch with specific strategy
   */
  private async launchWithStrategy(config: LaunchConfig): Promise<void> {
    switch (config.strategy) {
      case LaunchStrategy.TMUX_SPLIT:
        await this.launchViaTmuxSplit(config);
        break;
      case LaunchStrategy.TMUX_NEW_SESSION:
        await this.launchViaTmuxNewSession(config);
        break;
      case LaunchStrategy.VSCODE_TERMINAL:
        await this.launchViaVSCodeTerminal(config);
        break;
      case LaunchStrategy.NEW_TERMINAL_WINDOW:
        await this.launchViaNewTerminalWindow(config);
        break;
      case LaunchStrategy.BROWSER_OVERLAY:
        await this.launchViaBrowserOverlay(config);
        break;
      default:
        throw new Error(`Unknown strategy: ${config.strategy}`);
    }

    // Update state
    this.stateManager.recordLaunch();
  }

  /**
   * Try fallback strategies if primary fails
   */
  private async launchWithFallback(config: LaunchConfig): Promise<void> {
    const fallbacks: LaunchStrategy[] = [
      LaunchStrategy.VSCODE_TERMINAL,
      LaunchStrategy.BROWSER_OVERLAY,
    ];

    for (const strategy of fallbacks) {
      try {
        this.logger.info(`Trying fallback strategy: ${strategy}`);
        config.strategy = strategy;
        await this.launchWithStrategy(config);
        return;
      } catch (error) {
        this.logger.warn(`Fallback ${strategy} failed:`, error);
      }
    }

    // All fallbacks failed - show notification
    vscode.window.showWarningMessage(
      '⚠️ Could not launch Flickering Scenery visualization. ' +
        'Install tmux for the best experience.',
      'Install tmux',
      'Dismiss'
    ).then(choice => {
      if (choice === 'Install tmux') {
        vscode.env.openExternal(vscode.Uri.parse('https://github.com/tmux/tmux/wiki/Installing'));
      }
    });
  }

  // ==========================================================================
  // Launch Strategies
  // ==========================================================================

  /**
   * Strategy 1: Split current tmux session (best UX)
   */
  private async launchViaTmuxSplit(config: LaunchConfig): Promise<void> {
    this.logger.info('Launching via tmux split');

    const sessionName = `${this.SESSION_PREFIX}viz`;

    // Check if our visualization session exists
    const sessions = await this.listSessions();
    const existingSession = sessions.find(s => s.name === sessionName);

    if (existingSession) {
      // Switch to existing session
      this.logger.info('Switching to existing session');
      await execAsync(`tmux switch-client -t ${sessionName}`);
    } else {
      // Create new session
      await this.createVisualizationSession(sessionName, config);

      // Split current window and attach to new session
      if (config.splitCurrent) {
        await execAsync(
          `tmux split-window -h -p 50 "tmux attach-session -t ${sessionName}"`
        );
      } else {
        await execAsync(`tmux attach-session -t ${sessionName}`);
      }
    }

    this.activeSessions.add(sessionName);
  }

  /**
   * Strategy 2: New tmux session
   */
  private async launchViaTmuxNewSession(config: LaunchConfig): Promise<void> {
    this.logger.info('Launching via tmux new session');

    const sessionName = `${this.SESSION_PREFIX}${Date.now()}`;

    await this.createVisualizationSession(sessionName, config);
    await execAsync(`tmux attach-session -t ${sessionName}`);

    this.activeSessions.add(sessionName);
  }

  /**
   * Strategy 3: VSCode integrated terminal
   */
  private async launchViaVSCodeTerminal(config: LaunchConfig): Promise<void> {
    this.logger.info('Launching via VSCode terminal');

    const terminal = vscode.window.createTerminal({
      name: 'Flickering Scenery',
      iconPath: new vscode.ThemeIcon('organization'),
      location: vscode.TerminalLocation.Panel,
    });

    terminal.show();

    // Get script path
    const scriptPath = this.getScriptPath();
    const sessionName = `${this.SESSION_PREFIX}vscode`;

    // Launch tmux in the terminal
    terminal.sendText(
      `cd "${scriptPath}" && tmux new-session -s ${sessionName} "./run.sh"`
    );

    // Optional: Maximize terminal panel
    if (config.maximize) {
      await vscode.commands.executeCommand('workbench.action.toggleMaximizedPanel');
    }

    this.activeSessions.add(sessionName);
  }

  /**
   * Strategy 4: New terminal window
   */
  private async launchViaNewTerminalWindow(config: LaunchConfig): Promise<void> {
    this.logger.info('Launching via new terminal window');

    const scriptPath = this.getScriptPath();
    const sessionName = `${this.SESSION_PREFIX}external`;
    const platform = process.platform;

    if (platform === 'darwin') {
      // macOS: Use osascript
      await execAsync(`osascript -e 'tell application "Terminal"
        do script "cd \\"${scriptPath}\\" && tmux new-session -s ${sessionName} \\"./run.sh\\""
        activate
      end tell'`);
    } else if (platform === 'linux') {
      // Linux: Try common terminals
      const terminals = ['gnome-terminal', 'konsole', 'xterm'];
      let launched = false;

      for (const term of terminals) {
        try {
          await execAsync(
            `${term} -e "cd ${scriptPath} && tmux new-session -s ${sessionName} ./run.sh"`
          );
          launched = true;
          break;
        } catch {
          continue;
        }
      }

      if (!launched) {
        throw new Error('No terminal emulator found');
      }
    } else if (platform === 'win32') {
      // Windows: Use Windows Terminal or cmd
      await execAsync(
        `start cmd /c "cd ${scriptPath} && tmux new-session -s ${sessionName} run.bat"`
      );
    }

    this.activeSessions.add(sessionName);
  }

  /**
   * Strategy 5: Browser overlay (WebView fallback)
   */
  private async launchViaBrowserOverlay(config: LaunchConfig): Promise<void> {
    this.logger.info('Launching via browser overlay');

    // Create WebView panel
    const panel = vscode.window.createWebviewPanel(
      'flickeringScenery',
      'Flickering Scenery Visualization',
      vscode.ViewColumn.Beside,
      {
        enableScripts: true,
        retainContextWhenHidden: true,
      }
    );

    // Load visualization HTML
    panel.webview.html = this.getWebViewHTML(config);

    // Handle messages from WebView
    panel.webview.onDidReceiveMessage((message) => {
      this.handleWebViewMessage(message);
    });
  }

  // ==========================================================================
  // tmux Session Management
  // ==========================================================================

  /**
   * Create tmux session with visualization layout
   */
  private async createVisualizationSession(
    name: string,
    config: LaunchConfig
  ): Promise<void> {
    const width = config.width || 200;
    const height = config.height || 60;

    // Create session
    await execAsync(
      `tmux new-session -d -s ${name} -x ${width} -y ${height}`
    );

    // Setup panes
    await this.setupTmuxLayout(name);

    // Start agent visualization scripts
    await this.startAgentScripts(name);

    this.logger.info(`Created tmux session: ${name}`);
  }

  /**
   * Setup tmux panes layout
   */
  private async setupTmuxLayout(sessionName: string): Promise<void> {
    const scriptPath = this.getScriptPath();

    // Layout: 8 panes (status bar + orchestrator + 6 agents)
    await execAsync(`tmux send-keys -t ${sessionName}:0.0 "cd ${scriptPath}" C-m`);

    // Split into 4 rows
    await execAsync(`tmux split-window -t ${sessionName}:0.0 -v -p 75`); // Row 1
    await execAsync(`tmux split-window -t ${sessionName}:0.1 -v -p 66`); // Row 2
    await execAsync(`tmux split-window -t ${sessionName}:0.2 -v -p 50`); // Row 3

    // Split row 2 into 3 columns (for θ₁, θ₂, θ₃)
    await execAsync(`tmux split-window -t ${sessionName}:0.1 -h -p 66`);
    await execAsync(`tmux split-window -t ${sessionName}:0.2 -h -p 50`);

    // Split row 3 into 3 columns (for θ₄, θ₅, θ₆)
    await execAsync(`tmux split-window -t ${sessionName}:0.4 -h -p 66`);
    await execAsync(`tmux split-window -t ${sessionName}:0.5 -h -p 50`);
  }

  /**
   * Start visualization scripts in each pane
   */
  private async startAgentScripts(sessionName: string): Promise<void> {
    const scriptPath = this.getScriptPath();

    // Pane 0: Status bar
    await execAsync(
      `tmux send-keys -t ${sessionName}:0.0 "cd ${scriptPath} && ./scripts/status_bar.sh" C-m`
    );

    // Pane 1-3: θ₁, θ₂, θ₃
    await execAsync(
      `tmux send-keys -t ${sessionName}:0.1 "cd ${scriptPath} && ./scripts/subagent.sh theta1" C-m`
    );
    await execAsync(
      `tmux send-keys -t ${sessionName}:0.2 "cd ${scriptPath} && ./scripts/subagent.sh theta2" C-m`
    );
    await execAsync(
      `tmux send-keys -t ${sessionName}:0.3 "cd ${scriptPath} && ./scripts/subagent.sh theta3" C-m`
    );

    // Pane 4: Orchestrator
    await execAsync(
      `tmux send-keys -t ${sessionName}:0.4 "cd ${scriptPath} && ./scripts/orchestrator.sh" C-m`
    );

    // Pane 5-7: θ₄, θ₅, θ₆
    await execAsync(
      `tmux send-keys -t ${sessionName}:0.5 "cd ${scriptPath} && ./scripts/subagent.sh theta4" C-m`
    );
    await execAsync(
      `tmux send-keys -t ${sessionName}:0.6 "cd ${scriptPath} && ./scripts/subagent.sh theta5" C-m`
    );
    await execAsync(
      `tmux send-keys -t ${sessionName}:0.7 "cd ${scriptPath} && ./scripts/subagent.sh theta6" C-m`
    );

    // Pane 8: Event log
    await execAsync(
      `tmux send-keys -t ${sessionName}:0.8 "cd ${scriptPath} && ./scripts/event_log.sh" C-m`
    );
  }

  /**
   * List all tmux sessions
   */
  async listSessions(): Promise<TmuxSession[]> {
    try {
      const { stdout } = await execAsync('tmux list-sessions -F "#{session_name}:#{session_created}:#{session_windows}:#{session_attached}"');

      return stdout.trim().split('\n').map(line => {
        const [name, created, windows, attached] = line.split(':');
        return {
          name,
          created: new Date(parseInt(created) * 1000),
          panes: parseInt(windows),
          active: attached === '1',
        };
      });
    } catch {
      return [];
    }
  }

  /**
   * Kill a tmux session
   */
  async killSession(name: string): Promise<void> {
    try {
      await execAsync(`tmux kill-session -t ${name}`);
      this.activeSessions.delete(name);
      this.logger.info(`Killed session: ${name}`);
    } catch (error) {
      this.logger.warn(`Failed to kill session ${name}:`, error);
    }
  }

  /**
   * Cleanup all visualization sessions
   */
  async cleanup(): Promise<void> {
    this.logger.info('Cleaning up tmux sessions');

    for (const session of this.activeSessions) {
      await this.killSession(session);
    }

    this.activeSessions.clear();
    this.saveState();
  }

  // ==========================================================================
  // Utilities
  // ==========================================================================

  /**
   * Get path to visualization scripts
   */
  private getScriptPath(): string {
    // TODO: Get actual path from extension context
    return '/Users/shunsuke/Dev/AI_Agent/docs/tmux_visualization';
  }

  /**
   * Get WebView HTML
   */
  private getWebViewHTML(config: LaunchConfig): string {
    // TODO: Implement WebView HTML
    return `
      <!DOCTYPE html>
      <html>
        <head>
          <title>Flickering Scenery</title>
          <style>
            body { background: #000; color: #0f0; font-family: monospace; }
          </style>
        </head>
        <body>
          <h1>Flickering Scenery Visualization</h1>
          <p>WebView fallback - install tmux for full experience</p>
        </body>
      </html>
    `;
  }

  /**
   * Handle WebView messages
   */
  private handleWebViewMessage(message: any): void {
    this.logger.debug('WebView message:', message);
    // TODO: Implement message handling
  }

  // ==========================================================================
  // State Management
  // ==========================================================================

  private saveState(): void {
    this.stateManager.setState('tmuxLauncher', {
      activeSessions: Array.from(this.activeSessions),
    });
  }

  private loadState(): void {
    const state = this.stateManager.getState('tmuxLauncher');
    if (state?.activeSessions) {
      this.activeSessions = new Set(state.activeSessions);
    }
  }

  /**
   * Dispose (cleanup)
   */
  dispose(): void {
    this.cleanup();
  }
}

export default TmuxLauncher;
