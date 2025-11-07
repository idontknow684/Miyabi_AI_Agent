/**
 * Hook Registry System
 *
 * Central registry for auto-launch hooks that trigger tmux visualization
 * based on Claude Code events and user interactions.
 *
 * @module hooks/HookRegistry
 * @version 1.0.0
 */

import * as vscode from 'vscode';
import { TmuxLauncher, LaunchConfig } from './TmuxLauncher';
import { StateManager } from '../storage/StateManager';
import { Logger } from '../utils/logger';

// ============================================================================
// Event System
// ============================================================================

/**
 * Claude Code activation events we can hook into
 */
export enum ActivationEvent {
  WORKSPACE_OPENED = 'onStartupFinished',
  FIRST_INTERACTION = 'onDidReceiveFirstMessage',
  TASK_STARTED = 'onDidStartTask',
  COMMAND_EXECUTED = 'onDidExecuteCommand',
  FILE_CHANGED = 'onDidChangeWorkspace',
  MESSAGE_RECEIVED = 'onDidReceiveMessage',
  RESPONSE_STARTED = 'onDidStartResponse',
  RESPONSE_COMPLETED = 'onDidCompleteResponse',
}

/**
 * Context provided to hooks when events fire
 */
export interface EventContext {
  // Task information
  task?: {
    description: string;
    complexity: number; // 1-10
    steps: string[];
    estimatedDuration: number; // seconds
    isMultiStep: boolean;
  };

  // User information
  user: {
    isFirstTime: boolean;
    installDate: Date;
    lastVisualizationLaunch?: Date;
    totalLaunches: number;
    hasSeenTutorial: boolean;
  };

  // Claude Code state
  claude: {
    currentMessage: string;
    messageHistory: Message[];
    isThinking: boolean;
    responseStartTime?: Date;
  };

  // Workspace state
  workspace: {
    path: string;
    fileCount: number;
    language: string;
    isGitRepo: boolean;
  };

  // System state
  system: {
    tmuxAvailable: boolean;
    terminalOpen: boolean;
    displaySize: { width: number; height: number };
    platform: NodeJS.Platform;
  };

  // Extension config
  config: FlickeringSceneryConfig;
}

export interface Message {
  role: 'user' | 'assistant';
  content: string;
  timestamp: Date;
}

export interface FlickeringSceneryConfig {
  autoLaunch: {
    enabled: boolean;
    frequency: 'always' | 'smart' | 'manual';
    smartProbability: number;
  };
  visual: {
    mode: 'fullscreen' | 'split' | 'pip';
    theme: 'dark' | 'light' | 'auto';
    animations: boolean;
  };
  notifications: {
    sound: boolean;
    tooltip: boolean;
    firstTimeHelp: boolean;
  };
}

// ============================================================================
// Hook System
// ============================================================================

/**
 * A hook that can trigger visualization launch
 */
export interface HookPoint {
  id: string;
  name: string;
  description: string;
  event: ActivationEvent;
  condition: (context: EventContext) => boolean | Promise<boolean>;
  action: (context: EventContext) => Promise<void>;
  priority: number; // Higher = executes first
  cooldown?: number; // Minimum time between triggers (ms)
  enabled: boolean;
}

/**
 * Registry for managing auto-launch hooks
 */
export class HookRegistry {
  private static instance: HookRegistry;
  private hooks: Map<ActivationEvent, HookPoint[]> = new Map();
  private lastTrigger: Map<string, number> = new Map();
  private eventListeners: Map<string, vscode.Disposable> = new Map();
  private logger: Logger;
  private stateManager: StateManager;

  private constructor() {
    this.logger = new Logger('HookRegistry');
    this.stateManager = StateManager.getInstance();
    this.loadState();
  }

  static getInstance(): HookRegistry {
    if (!HookRegistry.instance) {
      HookRegistry.instance = new HookRegistry();
    }
    return HookRegistry.instance;
  }

  // ==========================================================================
  // Hook Registration
  // ==========================================================================

  /**
   * Register a hook for auto-launch
   */
  register(hook: HookPoint): void {
    this.logger.info(`Registering hook: ${hook.name} (${hook.id})`);

    const existing = this.hooks.get(hook.event) || [];

    // Remove any existing hook with same ID
    const filtered = existing.filter(h => h.id !== hook.id);

    // Add new hook
    filtered.push(hook);

    // Sort by priority (highest first)
    filtered.sort((a, b) => b.priority - a.priority);

    this.hooks.set(hook.event, filtered);

    // Save state
    this.saveState();
  }

  /**
   * Unregister a hook
   */
  unregister(hookId: string): void {
    this.logger.info(`Unregistering hook: ${hookId}`);

    for (const [event, hooks] of this.hooks.entries()) {
      const filtered = hooks.filter(h => h.id !== hookId);
      this.hooks.set(event, filtered);
    }

    this.saveState();
  }

  /**
   * Unregister all hooks
   */
  unregisterAll(): void {
    this.logger.info('Unregistering all hooks');
    this.hooks.clear();
    this.lastTrigger.clear();
    this.saveState();
  }

  /**
   * Get all registered hooks for an event
   */
  getHooks(event: ActivationEvent): HookPoint[] {
    return this.hooks.get(event) || [];
  }

  /**
   * Get all registered hooks
   */
  getAllHooks(): HookPoint[] {
    const all: HookPoint[] = [];
    for (const hooks of this.hooks.values()) {
      all.push(...hooks);
    }
    return all;
  }

  // ==========================================================================
  // Event Triggering
  // ==========================================================================

  /**
   * Trigger hooks for an event
   */
  async trigger(event: ActivationEvent, context: EventContext): Promise<void> {
    const hooks = this.getHooks(event);

    if (hooks.length === 0) {
      return;
    }

    this.logger.debug(`Triggering ${hooks.length} hooks for event: ${event}`);

    for (const hook of hooks) {
      if (!hook.enabled) {
        continue;
      }

      // Check cooldown
      const lastRun = this.lastTrigger.get(hook.id) || 0;
      const elapsed = Date.now() - lastRun;

      if (hook.cooldown && elapsed < hook.cooldown) {
        this.logger.debug(
          `Hook ${hook.id} in cooldown (${elapsed}ms / ${hook.cooldown}ms)`
        );
        continue;
      }

      try {
        // Check condition
        const shouldRun = await Promise.resolve(hook.condition(context));

        if (shouldRun) {
          this.logger.info(`Executing hook: ${hook.name}`);

          // Record trigger time
          this.lastTrigger.set(hook.id, Date.now());

          // Execute action
          await hook.action(context);

          // Update state
          this.saveState();

          // Only execute one hook per event (highest priority wins)
          break;
        }
      } catch (error) {
        this.logger.error(`Hook ${hook.id} failed:`, error);
      }
    }
  }

  // ==========================================================================
  // Event Listeners (VSCode Integration)
  // ==========================================================================

  /**
   * Setup VSCode event listeners
   */
  setupEventListeners(context: vscode.ExtensionContext): void {
    this.logger.info('Setting up VSCode event listeners');

    // Workspace opened
    const onWorkspaceOpened = vscode.workspace.onDidChangeWorkspaceFolders(() => {
      this.trigger(ActivationEvent.WORKSPACE_OPENED, this.buildContext());
    });

    // File changed
    const onFileChanged = vscode.workspace.onDidChangeTextDocument((e) => {
      this.trigger(ActivationEvent.FILE_CHANGED, this.buildContext());
    });

    // Command executed
    const onCommandExecuted = vscode.commands.registerCommand(
      'flickeringScenery.internal.onCommand',
      (command: string) => {
        this.trigger(ActivationEvent.COMMAND_EXECUTED, this.buildContext());
      }
    );

    // Store disposables
    this.eventListeners.set('workspace', onWorkspaceOpened);
    this.eventListeners.set('file', onFileChanged);
    this.eventListeners.set('command', onCommandExecuted);

    context.subscriptions.push(onWorkspaceOpened, onFileChanged, onCommandExecuted);
  }

  /**
   * Trigger event manually (for testing or explicit calls)
   */
  async triggerManual(
    event: ActivationEvent,
    contextOverride?: Partial<EventContext>
  ): Promise<void> {
    const context = this.buildContext(contextOverride);
    await this.trigger(event, context);
  }

  // ==========================================================================
  // Context Building
  // ==========================================================================

  /**
   * Build event context from current state
   */
  private buildContext(override?: Partial<EventContext>): EventContext {
    const state = this.stateManager.getState();
    const config = this.getConfig();

    const context: EventContext = {
      user: {
        isFirstTime: state.totalLaunches === 0,
        installDate: state.installDate,
        lastVisualizationLaunch: state.lastVisualizationLaunch,
        totalLaunches: state.totalLaunches,
        hasSeenTutorial: state.hasSeenTutorial,
      },
      claude: {
        currentMessage: '',
        messageHistory: [],
        isThinking: false,
      },
      workspace: {
        path: vscode.workspace.workspaceFolders?.[0]?.uri.fsPath || '',
        fileCount: 0, // TODO: Compute
        language: vscode.window.activeTextEditor?.document.languageId || 'unknown',
        isGitRepo: false, // TODO: Detect
      },
      system: {
        tmuxAvailable: false, // TODO: Detect
        terminalOpen: vscode.window.terminals.length > 0,
        displaySize: { width: 1920, height: 1080 }, // TODO: Detect
        platform: process.platform,
      },
      config,
      ...override,
    };

    return context;
  }

  /**
   * Get current configuration
   */
  private getConfig(): FlickeringSceneryConfig {
    const config = vscode.workspace.getConfiguration('flickeringScenery');

    return {
      autoLaunch: {
        enabled: config.get('autoLaunch.enabled', true),
        frequency: config.get('autoLaunch.frequency', 'smart'),
        smartProbability: config.get('autoLaunch.smartProbability', 0.1),
      },
      visual: {
        mode: config.get('visual.mode', 'split'),
        theme: config.get('visual.theme', 'auto'),
        animations: config.get('visual.animations', true),
      },
      notifications: {
        sound: config.get('notifications.sound', false),
        tooltip: config.get('notifications.tooltip', true),
        firstTimeHelp: config.get('notifications.firstTimeHelp', true),
      },
    };
  }

  // ==========================================================================
  // State Persistence
  // ==========================================================================

  /**
   * Save hook state
   */
  private saveState(): void {
    const state = {
      lastTrigger: Object.fromEntries(this.lastTrigger),
      enabledHooks: this.getAllHooks()
        .filter(h => h.enabled)
        .map(h => h.id),
    };

    this.stateManager.setState('hookRegistry', state);
  }

  /**
   * Load hook state
   */
  private loadState(): void {
    const state = this.stateManager.getState('hookRegistry');

    if (state) {
      this.lastTrigger = new Map(Object.entries(state.lastTrigger || {}));
    }
  }

  // ==========================================================================
  // Utility Methods
  // ==========================================================================

  /**
   * Enable/disable a hook
   */
  setEnabled(hookId: string, enabled: boolean): void {
    for (const hooks of this.hooks.values()) {
      const hook = hooks.find(h => h.id === hookId);
      if (hook) {
        hook.enabled = enabled;
        this.saveState();
        return;
      }
    }
  }

  /**
   * Reset cooldown for a hook (for testing)
   */
  resetCooldown(hookId: string): void {
    this.lastTrigger.delete(hookId);
  }

  /**
   * Reset all cooldowns
   */
  resetAllCooldowns(): void {
    this.lastTrigger.clear();
  }

  /**
   * Get time until hook can run again
   */
  getTimeUntilReady(hookId: string): number {
    const hook = this.getAllHooks().find(h => h.id === hookId);
    if (!hook || !hook.cooldown) {
      return 0;
    }

    const lastRun = this.lastTrigger.get(hookId) || 0;
    const elapsed = Date.now() - lastRun;
    const remaining = hook.cooldown - elapsed;

    return Math.max(0, remaining);
  }

  /**
   * Get hook statistics
   */
  getStats(): HookStats {
    const all = this.getAllHooks();

    return {
      totalHooks: all.length,
      enabledHooks: all.filter(h => h.enabled).length,
      disabledHooks: all.filter(h => !h.enabled).length,
      hooksOnCooldown: all.filter(h => this.getTimeUntilReady(h.id) > 0).length,
      hooksByEvent: Object.fromEntries(
        Array.from(this.hooks.entries()).map(([event, hooks]) => [
          event,
          hooks.length,
        ])
      ),
    };
  }

  /**
   * Dispose (cleanup)
   */
  dispose(): void {
    this.logger.info('Disposing HookRegistry');

    for (const disposable of this.eventListeners.values()) {
      disposable.dispose();
    }

    this.eventListeners.clear();
    this.saveState();
  }
}

// ============================================================================
// Types
// ============================================================================

interface HookStats {
  totalHooks: number;
  enabledHooks: number;
  disabledHooks: number;
  hooksOnCooldown: number;
  hooksByEvent: Record<string, number>;
}

// ============================================================================
// Exports
// ============================================================================

export default HookRegistry;
