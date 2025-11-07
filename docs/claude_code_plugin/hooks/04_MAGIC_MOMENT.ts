/**
 * Magic Moment Orchestrator
 *
 * Choreographs the perfect reveal timing, animations, and effects
 * to create an unforgettable "WTF moment" that goes viral.
 *
 * @module hooks/MagicMoment
 * @version 1.0.0
 */

import * as vscode from 'vscode';
import { EventContext } from './01_HOOK_REGISTRY';
import { LaunchConfig } from './02_TMUX_LAUNCHER';
import { Logger } from '../utils/logger';
import { StateManager } from '../storage/StateManager';

const logger = new Logger('MagicMoment');

// ============================================================================
// Types
// ============================================================================

interface TransitionEffect {
  type: 'fade' | 'slide' | 'zoom' | 'curtain';
  duration: number; // ms
  easing: 'linear' | 'ease-in' | 'ease-out' | 'ease-in-out';
}

interface TourStep {
  pane: string;
  message: string;
  duration?: number;
}

interface CallToAction {
  text: string;
  url: string;
  button?: string;
}

// ============================================================================
// Transition Effects
// ============================================================================

const TRANSITION_EFFECTS = {
  subtle: {
    type: 'fade' as const,
    duration: 1000,
    easing: 'ease-in-out' as const,
  },
  dramatic: {
    type: 'curtain' as const,
    duration: 1500,
    easing: 'ease-out' as const,
  },
  instant: {
    type: 'fade' as const,
    duration: 300,
    easing: 'ease-out' as const,
  },
  cinematic: {
    type: 'zoom' as const,
    duration: 2000,
    easing: 'ease-in-out' as const,
  },
} as const;

// ============================================================================
// Sound Effects
// ============================================================================

const SOUNDS = {
  whoosh: 'assets/sounds/whoosh.mp3', // Launch sound
  phase_complete: 'assets/sounds/ding.mp3', // Phase transition
  convergence: 'assets/sounds/success.mp3', // Goal achieved
  error: 'assets/sounds/error.mp3', // Error state
  startup: 'assets/sounds/startup.mp3', // Initial boot
} as const;

// ============================================================================
// Magic Moment Orchestrator
// ============================================================================

export class MagicMoment {
  private static instance: MagicMoment;
  private logger: Logger;
  private stateManager: StateManager;

  private constructor() {
    this.logger = new Logger('MagicMoment');
    this.stateManager = StateManager.getInstance();
  }

  static getInstance(): MagicMoment {
    if (!MagicMoment.instance) {
      MagicMoment.instance = new MagicMoment();
    }
    return MagicMoment.instance;
  }

  // ==========================================================================
  // Main Orchestration
  // ==========================================================================

  /**
   * Orchestrate the perfect reveal timing
   */
  async orchestrate(
    context: EventContext,
    config: LaunchConfig
  ): Promise<void> {
    this.logger.info('Orchestrating magic moment', config.mode);

    try {
      // Phase 1: Wait for Claude's response to start
      await this.waitForClaudeResponse(context);

      // Phase 2: Detect the "magic words"
      const magicPhrase = this.detectMagicPhrase(
        context.claude.currentMessage
      );

      if (magicPhrase) {
        // Phase 3: Launch exactly when Claude says "Let me..."
        this.logger.info(`Magic phrase detected: "${magicPhrase}"`);
        await this.launchOnCue(magicPhrase, config);
      } else {
        // Fallback: Launch 2 seconds into response
        await this.sleep(2000);
        await this.launch(config);
      }

      // Phase 4: Fade-in animation
      if (config.fadeIn) {
        await this.animateFadeIn(config);
      }

      // Phase 5: Show tooltip (first time only)
      if (context.user.totalLaunches === 0 && config.showTooltip) {
        await this.showTooltip(config.showTooltip);
      }

      // Phase 6: Optional sound effect
      if (context.config.notifications.sound) {
        await this.playSound('whoosh');
      }

      // Phase 7: First-time experience
      if (context.user.isFirstTime && config.mode === 'tutorial') {
        await this.showFirstTimeExperience(context);
      }
    } catch (error) {
      this.logger.error('Magic moment failed:', error);
      throw error;
    }
  }

  /**
   * Wait for Claude's response to begin
   */
  private async waitForClaudeResponse(
    context: EventContext,
    timeout: number = 5000
  ): Promise<void> {
    const start = Date.now();

    while (!context.claude.currentMessage || context.claude.currentMessage.length === 0) {
      if (Date.now() - start > timeout) {
        this.logger.warn('Timeout waiting for Claude response');
        return;
      }
      await this.sleep(100);
    }

    this.logger.debug('Claude response detected');
  }

  /**
   * Detect "magic phrases" that trigger launch
   */
  private detectMagicPhrase(message: string): string | null {
    const phrases = [
      /let me (break this down|analyze|tackle|start|begin)/i,
      /i'll (start by|begin with|first|tackle)/i,
      /here's (what|how) i'll/i,
      /to accomplish this, i'll/i,
      /i can help.*by/i,
      /let's (start|begin|get started)/i,
    ];

    for (const phrase of phrases) {
      const match = message.match(phrase);
      if (match) {
        return match[0];
      }
    }

    return null;
  }

  /**
   * Launch exactly when magic phrase appears
   */
  private async launchOnCue(
    phrase: string,
    config: LaunchConfig
  ): Promise<void> {
    // Add slight delay for dramatic effect
    await this.sleep(500);
    await this.launch(config);
  }

  /**
   * Execute the launch
   */
  private async launch(config: LaunchConfig): Promise<void> {
    this.logger.info('Launching visualization');
    // Actual launch happens in TmuxLauncher
    // This is just for orchestration timing
  }

  // ==========================================================================
  // Animations
  // ==========================================================================

  /**
   * Animate fade-in effect
   */
  private async animateFadeIn(config: LaunchConfig): Promise<void> {
    const effect = config.mode === 'tutorial'
      ? TRANSITION_EFFECTS.cinematic
      : TRANSITION_EFFECTS.subtle;

    this.logger.debug('Animating fade-in', effect);

    // For tmux, we can control this via status bar messages
    // For WebView, we use CSS transitions

    await this.sleep(effect.duration);
  }

  /**
   * Show tooltip overlay
   */
  private async showTooltip(message: string, duration: number = 3000): Promise<void> {
    this.logger.debug('Showing tooltip:', message);

    // Show VSCode notification
    const notification = vscode.window.setStatusBarMessage(
      `🎭 ${message}`,
      duration
    );

    // Auto-dismiss
    setTimeout(() => notification.dispose(), duration);
  }

  // ==========================================================================
  // First-Time Experience
  // ==========================================================================

  /**
   * Show comprehensive first-time experience
   */
  async showFirstTimeExperience(context: EventContext): Promise<void> {
    this.logger.info('Starting first-time experience');

    // Step 1: Welcome overlay
    await this.showWelcomeOverlay();

    // Step 2: Wait for user to absorb
    await this.sleep(3000);

    // Step 3: Guided tour of panes
    await this.tourPanes([
      {
        pane: 'status',
        message: 'Global status and convergence tracking',
        duration: 2000,
      },
      {
        pane: 'orchestrator',
        message: 'Main orchestrator coordinates everything',
        duration: 2000,
      },
      {
        pane: 'theta1',
        message: 'θ₁ analyzes and understands your request',
        duration: 2000,
      },
      {
        pane: 'theta2',
        message: 'θ₂ generates the execution plan',
        duration: 2000,
      },
      {
        pane: 'theta3',
        message: 'θ₃ allocates resources to subagents',
        duration: 2000,
      },
      {
        pane: 'theta4',
        message: 'θ₄ executes tasks in parallel',
        duration: 2000,
      },
      {
        pane: 'theta5',
        message: 'θ₅ integrates results into world state',
        duration: 2000,
      },
      {
        pane: 'theta6',
        message: 'θ₆ learns from outcomes for future tasks',
        duration: 2000,
      },
    ]);

    // Step 4: Show call-to-action
    await this.showCallToAction({
      text: '⭐ Like what you see? Star us on GitHub!',
      url: 'https://github.com/ShunsukeHayashi/AI_Agent',
      button: 'Star Now',
    });

    // Mark tutorial as seen
    this.stateManager.setState('hasSeenTutorial', true);
  }

  /**
   * Show welcome overlay
   */
  private async showWelcomeOverlay(): Promise<void> {
    const panel = vscode.window.createWebviewPanel(
      'flickeringSceneryWelcome',
      '🎭 Welcome to Flickering Scenery',
      vscode.ViewColumn.One,
      {
        enableScripts: true,
      }
    );

    panel.webview.html = this.getWelcomeHTML();

    // Auto-close after 5 seconds
    setTimeout(() => panel.dispose(), 5000);
  }

  /**
   * Tour panes sequentially
   */
  private async tourPanes(steps: TourStep[]): Promise<void> {
    for (const step of steps) {
      // Show tooltip for this pane
      await this.showTooltip(
        `${step.pane}: ${step.message}`,
        step.duration || 2000
      );

      // Wait for duration
      await this.sleep(step.duration || 2000);
    }
  }

  /**
   * Show call-to-action
   */
  async showCallToAction(cta: CallToAction): Promise<void> {
    this.logger.info('Showing call-to-action:', cta.text);

    const choice = await vscode.window.showInformationMessage(
      cta.text,
      cta.button || 'Open',
      'Later'
    );

    if (choice === (cta.button || 'Open')) {
      vscode.env.openExternal(vscode.Uri.parse(cta.url));

      // Track CTA click
      this.stateManager.incrementCounter('ctaClicks');
    }
  }

  // ==========================================================================
  // Optimizations for Different Modes
  // ==========================================================================

  /**
   * Optimize for first impression (maximize wow factor)
   */
  async optimizeFirstImpression(): Promise<void> {
    this.logger.info('Optimizing for first impression');

    // 1. Full-screen takeover
    await vscode.commands.executeCommand('workbench.action.toggleFullScreen');

    // 2. Cinematic intro animation
    await this.playIntroAnimation({
      showLogo: true,
      showFormula: true, // Display 𝔸(ℐ, W₀) = W_∞
      duration: 3000,
    });

    // 3. Agents "boot up" sequentially
    await this.sequentialAgentBoot([
      { agent: 'θ₁', delay: 0 },
      { agent: 'θ₂', delay: 300 },
      { agent: 'θ₃', delay: 600 },
      { agent: 'θ₄', delay: 900 },
      { agent: 'θ₅', delay: 1200 },
      { agent: 'θ₆', delay: 1500 },
    ]);

    // 4. Show impressive stats
    await this.showStats({
      message: 'Orchestrating 6 AI agents across 8 tmux panes',
      fadeAfter: 2000,
    });
  }

  /**
   * Play intro animation
   */
  private async playIntroAnimation(options: {
    showLogo: boolean;
    showFormula: boolean;
    duration: number;
  }): Promise<void> {
    this.logger.debug('Playing intro animation');

    const panel = vscode.window.createWebviewPanel(
      'flickeringSceneryIntro',
      'Flickering Scenery',
      vscode.ViewColumn.One,
      { enableScripts: true }
    );

    panel.webview.html = this.getIntroAnimationHTML(options);

    // Auto-close after duration
    setTimeout(() => panel.dispose(), options.duration);

    await this.sleep(options.duration);
  }

  /**
   * Boot agents sequentially
   */
  private async sequentialAgentBoot(
    agents: Array<{ agent: string; delay: number }>
  ): Promise<void> {
    for (const { agent, delay } of agents) {
      await this.sleep(delay);
      await this.showTooltip(`${agent} agent online`, 1000);
    }
  }

  /**
   * Show stats overlay
   */
  private async showStats(options: {
    message: string;
    fadeAfter: number;
  }): Promise<void> {
    await this.showTooltip(options.message, options.fadeAfter);
  }

  // ==========================================================================
  // Sound Effects
  // ==========================================================================

  /**
   * Play sound effect
   */
  async playSound(sound: keyof typeof SOUNDS): Promise<void> {
    // Note: VSCode doesn't have native audio support
    // Options:
    // 1. Use system sound (macOS: afplay, Linux: aplay, Windows: SoundPlayer)
    // 2. WebView with <audio> tag
    // 3. Terminal bell (simple but limited)

    this.logger.debug('Playing sound:', sound);

    try {
      const platform = process.platform;

      if (platform === 'darwin') {
        // macOS
        const { exec } = require('child_process');
        exec(`afplay ${SOUNDS[sound]}`);
      } else if (platform === 'linux') {
        // Linux
        const { exec } = require('child_process');
        exec(`aplay ${SOUNDS[sound]}`);
      } else if (platform === 'win32') {
        // Windows - use PowerShell
        const { exec } = require('child_process');
        exec(`powershell -c (New-Object Media.SoundPlayer "${SOUNDS[sound]}").PlaySync()`);
      }
    } catch (error) {
      this.logger.warn('Failed to play sound:', error);
    }
  }

  // ==========================================================================
  // HTML Templates
  // ==========================================================================

  /**
   * Get welcome HTML
   */
  private getWelcomeHTML(): string {
    return `
      <!DOCTYPE html>
      <html>
        <head>
          <style>
            body {
              background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
              color: white;
              font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
              display: flex;
              align-items: center;
              justify-content: center;
              height: 100vh;
              margin: 0;
            }
            .welcome {
              text-align: center;
              max-width: 600px;
              animation: fadeIn 1s ease-in;
            }
            h1 {
              font-size: 3em;
              margin-bottom: 0.2em;
            }
            p {
              font-size: 1.2em;
              line-height: 1.6;
              opacity: 0.9;
            }
            .formula {
              font-family: 'Georgia', serif;
              font-size: 1.5em;
              margin: 1em 0;
              padding: 1em;
              background: rgba(255, 255, 255, 0.1);
              border-radius: 8px;
            }
            @keyframes fadeIn {
              from { opacity: 0; transform: translateY(20px); }
              to { opacity: 1; transform: translateY(0); }
            }
          </style>
        </head>
        <body>
          <div class="welcome">
            <h1>🎭 Welcome to Flickering Scenery</h1>
            <p>
              Claude is orchestrating multiple AI agents to complete your task.
            </p>
            <div class="formula">
              𝔸(ℐ, W₀) = lim<sub>n→∞</sub> (Θ ◦ 𝒞 ◦ ℐ)<sup>n</sup> = W<sub>∞</sub>
            </div>
            <p>
              Watch as they progress through 6 phases:<br>
              <strong>θ₁ Understand → θ₂ Generate → θ₃ Allocate →<br>
              θ₄ Execute → θ₅ Integrate → θ₆ Learn</strong>
            </p>
          </div>
        </body>
      </html>
    `;
  }

  /**
   * Get intro animation HTML
   */
  private getIntroAnimationHTML(options: {
    showLogo: boolean;
    showFormula: boolean;
    duration: number;
  }): string {
    return `
      <!DOCTYPE html>
      <html>
        <head>
          <style>
            body {
              background: #000;
              color: #0f0;
              font-family: monospace;
              display: flex;
              align-items: center;
              justify-content: center;
              height: 100vh;
              margin: 0;
              overflow: hidden;
            }
            .logo {
              font-size: 4em;
              animation: pulse 2s infinite;
            }
            .formula {
              font-size: 2em;
              margin-top: 1em;
              animation: fadeIn 1s ease-in 1s both;
            }
            @keyframes pulse {
              0%, 100% { opacity: 1; }
              50% { opacity: 0.5; }
            }
            @keyframes fadeIn {
              from { opacity: 0; }
              to { opacity: 1; }
            }
          </style>
        </head>
        <body>
          <div>
            ${options.showLogo ? '<div class="logo">🎭 Flickering Scenery</div>' : ''}
            ${options.showFormula ? '<div class="formula">𝔸(ℐ, W₀) = W<sub>∞</sub></div>' : ''}
          </div>
        </body>
      </html>
    `;
  }

  // ==========================================================================
  // Utilities
  // ==========================================================================

  private sleep(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}

export default MagicMoment;
