/**
 * Smart Trigger Hooks
 *
 * Pre-configured hooks for intelligent auto-launch of tmux visualization.
 * Each hook represents a different strategy for when to "wow" the user.
 *
 * @module hooks/SmartTriggers
 * @version 1.0.0
 */

import { HookPoint, ActivationEvent, EventContext } from './01_HOOK_REGISTRY';
import { TmuxLauncher, LaunchConfig } from './02_TMUX_LAUNCHER';
import { Logger } from '../utils/logger';

const logger = new Logger('SmartTriggers');

// ============================================================================
// Utility Functions
// ============================================================================

/**
 * Check if two dates are on the same day
 */
function isSameDay(date1: Date, date2: Date): boolean {
  return (
    date1.getFullYear() === date2.getFullYear() &&
    date1.getMonth() === date2.getMonth() &&
    date1.getDate() === date2.getDate()
  );
}

/**
 * Wait for a condition to become true
 */
async function waitFor(
  condition: () => boolean,
  timeout: number = 5000
): Promise<void> {
  const start = Date.now();
  while (!condition()) {
    if (Date.now() - start > timeout) {
      throw new Error('Timeout waiting for condition');
    }
    await new Promise((resolve) => setTimeout(resolve, 100));
  }
}

/**
 * Sleep for a given duration
 */
function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

/**
 * Extract step count from message
 */
function extractSteps(message: string): string[] {
  const steps: string[] = [];

  // Pattern 1: Numbered steps
  const numberedPattern = /(?:^|\n)\d+\.\s+(.+)/g;
  let match;
  while ((match = numberedPattern.exec(message)) !== null) {
    steps.push(match[1]);
  }

  // Pattern 2: "First...then...finally"
  if (steps.length === 0) {
    const sequencePattern =
      /(?:first|then|next|after that|finally)[,:]?\s+(.+?)(?=\n|first|then|next|after that|finally|$)/gi;
    while ((match = sequencePattern.exec(message)) !== null) {
      steps.push(match[1].trim());
    }
  }

  return steps;
}

/**
 * Analyze task complexity (1-10 scale)
 */
function analyzeComplexity(task: EventContext['task']): number {
  if (!task) return 1;

  let complexity = 1;

  // More steps = more complex
  complexity += Math.min(task.steps.length, 5);

  // Longer description = more complex
  if (task.description.length > 100) complexity += 1;
  if (task.description.length > 300) complexity += 1;

  // Duration factor
  if (task.estimatedDuration > 60) complexity += 1;
  if (task.estimatedDuration > 300) complexity += 1;

  return Math.min(complexity, 10);
}

// ============================================================================
// Hook Implementations
// ============================================================================

/**
 * Hook 1: First Complex Task of the Day
 *
 * Triggers on the user's first complex task each day.
 * This creates a consistent "morning wow" moment.
 */
export const firstComplexTaskHook: HookPoint = {
  id: 'first-complex-task-of-day',
  name: 'First Complex Task',
  description: 'Launch on first complex task of each day',
  event: ActivationEvent.TASK_STARTED,

  condition: (ctx: EventContext) => {
    if (!ctx.config.autoLaunch.enabled) return false;
    if (ctx.config.autoLaunch.frequency === 'manual') return false;

    const lastLaunch = ctx.user.lastVisualizationLaunch;
    const isNewDay = !lastLaunch || !isSameDay(lastLaunch, new Date());
    const complexity = ctx.task ? analyzeComplexity(ctx.task) : 0;
    const isComplex = complexity >= 5;

    logger.debug('First complex task check:', { isNewDay, complexity, isComplex });

    return isNewDay && isComplex;
  },

  action: async (ctx: EventContext) => {
    logger.info('Triggering first complex task launch');

    const launcher = TmuxLauncher.getInstance();

    const config: LaunchConfig = {
      mode: 'impressive',
      playIntroAnimation: true,
      showTooltip: 'Your agents are analyzing the task...',
      fadeIn: true,
      showProgressBar: true,
    };

    await launcher.launch(config);
  },

  priority: 100,
  cooldown: 60 * 60 * 1000, // 1 hour
  enabled: true,
};

/**
 * Hook 2: Multi-Step Task Detection
 *
 * Triggers when Claude breaks down a task into multiple steps.
 * This shows the orchestration in action.
 */
export const multiStepTaskHook: HookPoint = {
  id: 'multi-step-task',
  name: 'Multi-Step Task',
  description: 'Launch when Claude breaks down a task into steps',
  event: ActivationEvent.MESSAGE_RECEIVED,

  condition: (ctx: EventContext) => {
    if (!ctx.config.autoLaunch.enabled) return false;
    if (ctx.config.autoLaunch.frequency === 'manual') return false;

    const message = ctx.claude.currentMessage;

    // Detect Claude's "breakdown" language
    const breakdownPatterns = [
      /let me break this down/i,
      /i'll tackle this in (\d+) steps/i,
      /here's my approach:/i,
      /first.*then.*finally/i,
      /step \d+:/i,
      /\d+\.\s+\w+/g, // Numbered list
    ];

    const hasBreakdown = breakdownPatterns.some((pattern) =>
      pattern.test(message)
    );

    logger.debug('Multi-step check:', { hasBreakdown, messageLength: message.length });

    return hasBreakdown;
  },

  action: async (ctx: EventContext) => {
    logger.info('Triggering multi-step task launch');

    // Extract steps
    const steps = extractSteps(ctx.claude.currentMessage);

    const launcher = TmuxLauncher.getInstance();

    const config: LaunchConfig = {
      mode: 'orchestration',
      expectedPhases: steps.length,
      showStepBreakdown: true,
      fadeIn: true,
      showTooltip: `Orchestrating ${steps.length} agents for this task...`,
    };

    // Wait for perfect timing (when Claude finishes describing approach)
    await sleep(2000);

    await launcher.launch(config);
  },

  priority: 90,
  cooldown: 30 * 60 * 1000, // 30 minutes
  enabled: true,
};

/**
 * Hook 3: Random Surprise (10% of tasks)
 *
 * Randomly triggers to keep users engaged and surprised.
 * Creates unpredictability and delight.
 */
export const randomSurpriseHook: HookPoint = {
  id: 'random-surprise',
  name: 'Random Surprise',
  description: 'Randomly launch for 10% of tasks',
  event: ActivationEvent.TASK_STARTED,

  condition: (ctx: EventContext) => {
    if (!ctx.config.autoLaunch.enabled) return false;
    if (ctx.config.autoLaunch.frequency !== 'smart') return false;

    // Don't trigger if visualization was recently shown
    const lastLaunch = ctx.user.lastVisualizationLaunch;
    if (lastLaunch && Date.now() - lastLaunch.getTime() < 15 * 60 * 1000) {
      return false;
    }

    // Use configured probability (default 10%)
    const probability = ctx.config.autoLaunch.smartProbability;
    const shouldTrigger = Math.random() < probability;

    logger.debug('Random surprise check:', { probability, shouldTrigger });

    return shouldTrigger;
  },

  action: async (ctx: EventContext) => {
    logger.info('Triggering random surprise launch');

    const launcher = TmuxLauncher.getInstance();

    const config: LaunchConfig = {
      mode: 'subtle',
      fadeIn: true,
      duration: 5000, // Auto-hide after 5 seconds
      showTooltip: '✨ Agents activated',
    };

    await launcher.launch(config);
  },

  priority: 50,
  cooldown: 15 * 60 * 1000, // 15 minutes
  enabled: true,
};

/**
 * Hook 4: First Install Magic
 *
 * Creates the ultimate first impression.
 * This is the "viral moment" - make it count!
 */
export const firstInstallHook: HookPoint = {
  id: 'first-install',
  name: 'First Install Experience',
  description: 'Launch spectacular intro on first use',
  event: ActivationEvent.FIRST_INTERACTION,

  condition: (ctx: EventContext) => {
    const isFirstTime = ctx.user.isFirstTime && ctx.user.totalLaunches === 0;

    logger.debug('First install check:', { isFirstTime, totalLaunches: ctx.user.totalLaunches });

    return isFirstTime;
  },

  action: async (ctx: EventContext) => {
    logger.info('Triggering FIRST INSTALL experience 🎉');

    // Wait for Claude to respond first
    await waitFor(() => ctx.claude.currentMessage.length > 0, 10000);

    // Add extra delay for dramatic effect
    await sleep(1000);

    const launcher = TmuxLauncher.getInstance();

    const config: LaunchConfig = {
      mode: 'tutorial',
      showWelcomeMessage: true,
      playFullAnimation: true,
      playIntroAnimation: true,
      fadeIn: true,
      showTooltip: '🎭 Welcome to Flickering Scenery!',
      callToAction: {
        text: '⭐ Star on GitHub',
        url: 'https://github.com/ShunsukeHayashi/AI_Agent',
      },
      maximize: true,
    };

    await launcher.launch(config);
  },

  priority: 200, // Highest priority
  cooldown: Infinity, // Only once ever
  enabled: true,
};

/**
 * Hook 5: Long-Running Task
 *
 * Shows agents working on extended tasks.
 * Keeps visualization up for the entire duration.
 */
export const longRunningTaskHook: HookPoint = {
  id: 'long-running-task',
  name: 'Long-Running Task',
  description: 'Launch for tasks estimated to take > 1 minute',
  event: ActivationEvent.TASK_STARTED,

  condition: (ctx: EventContext) => {
    if (!ctx.config.autoLaunch.enabled) return false;
    if (ctx.config.autoLaunch.frequency === 'manual') return false;

    const isLongRunning = ctx.task && ctx.task.estimatedDuration > 60;

    logger.debug('Long-running task check:', {
      isLongRunning,
      duration: ctx.task?.estimatedDuration,
    });

    return !!isLongRunning;
  },

  action: async (ctx: EventContext) => {
    logger.info('Triggering long-running task launch');

    // Wait 5 seconds before launching (let user see task description first)
    await sleep(5000);

    const launcher = TmuxLauncher.getInstance();

    const config: LaunchConfig = {
      mode: 'persistent',
      autoHide: false, // Keep open for long tasks
      showProgressBar: true,
      showTooltip: 'Agents working on extended task...',
      fadeIn: true,
    };

    await launcher.launch(config);
  },

  priority: 80,
  cooldown: 20 * 60 * 1000, // 20 minutes
  enabled: true,
};

/**
 * Hook 6: Always Launch (for "always" mode)
 *
 * Launches on every task when frequency is set to "always".
 * Can be overwhelming but some users want maximum visibility.
 */
export const alwaysLaunchHook: HookPoint = {
  id: 'always-launch',
  name: 'Always Launch',
  description: 'Launch for every task (when frequency = always)',
  event: ActivationEvent.TASK_STARTED,

  condition: (ctx: EventContext) => {
    const shouldLaunch =
      ctx.config.autoLaunch.enabled &&
      ctx.config.autoLaunch.frequency === 'always';

    logger.debug('Always launch check:', { shouldLaunch });

    return shouldLaunch;
  },

  action: async (ctx: EventContext) => {
    logger.info('Triggering always-launch');

    const launcher = TmuxLauncher.getInstance();

    const config: LaunchConfig = {
      mode: 'subtle',
      fadeIn: true,
      showTooltip: 'Agents activated',
    };

    await launcher.launch(config);
  },

  priority: 60,
  cooldown: 5 * 60 * 1000, // 5 minutes (prevent spam)
  enabled: true,
};

/**
 * Hook 7: Error Recovery
 *
 * Launches when Claude encounters an error and needs to retry.
 * Shows agents working to fix the problem.
 */
export const errorRecoveryHook: HookPoint = {
  id: 'error-recovery',
  name: 'Error Recovery',
  description: 'Launch when Claude retries after an error',
  event: ActivationEvent.MESSAGE_RECEIVED,

  condition: (ctx: EventContext) => {
    if (!ctx.config.autoLaunch.enabled) return false;

    const message = ctx.claude.currentMessage.toLowerCase();

    // Detect error recovery language
    const errorPatterns = [
      /let me try (again|another approach)/i,
      /i'll retry/i,
      /that didn't work.*let me/i,
      /i encountered an error/i,
      /fixing.*error/i,
    ];

    const isErrorRecovery = errorPatterns.some((pattern) =>
      pattern.test(message)
    );

    logger.debug('Error recovery check:', { isErrorRecovery });

    return isErrorRecovery;
  },

  action: async (ctx: EventContext) => {
    logger.info('Triggering error recovery launch');

    const launcher = TmuxLauncher.getInstance();

    const config: LaunchConfig = {
      mode: 'orchestration',
      showTooltip: 'Agents analyzing error and retrying...',
      fadeIn: true,
      showProgressBar: true,
    };

    await launcher.launch(config);
  },

  priority: 85,
  cooldown: 10 * 60 * 1000, // 10 minutes
  enabled: true,
};

/**
 * Hook 8: Convergence Detected
 *
 * Launches when we detect Claude is iteratively refining a solution.
 * Shows the "convergence to W_∞" in action.
 */
export const convergenceDetectedHook: HookPoint = {
  id: 'convergence-detected',
  name: 'Convergence Detected',
  description: 'Launch when iterative refinement is detected',
  event: ActivationEvent.MESSAGE_RECEIVED,

  condition: (ctx: EventContext) => {
    if (!ctx.config.autoLaunch.enabled) return false;

    const history = ctx.claude.messageHistory;

    // Need at least 3 back-and-forth messages
    if (history.length < 6) return false;

    const message = ctx.claude.currentMessage.toLowerCase();

    // Detect iterative language
    const iterativePatterns = [
      /let me refine/i,
      /improving on/i,
      /iterating/i,
      /version \d+/i,
      /take \d+/i,
      /revised/i,
      /updated approach/i,
    ];

    const isIterative = iterativePatterns.some((pattern) =>
      pattern.test(message)
    );

    logger.debug('Convergence check:', { isIterative, historyLength: history.length });

    return isIterative;
  },

  action: async (ctx: EventContext) => {
    logger.info('Triggering convergence launch');

    const launcher = TmuxLauncher.getInstance();

    const config: LaunchConfig = {
      mode: 'orchestration',
      showTooltip: 'Converging to optimal solution (W_∞)...',
      fadeIn: true,
      showProgressBar: true,
    };

    await launcher.launch(config);
  },

  priority: 75,
  cooldown: 15 * 60 * 1000, // 15 minutes
  enabled: true,
};

// ============================================================================
// Hook Collection
// ============================================================================

/**
 * All pre-configured smart trigger hooks
 */
export const ALL_SMART_TRIGGERS: HookPoint[] = [
  firstInstallHook,
  firstComplexTaskHook,
  multiStepTaskHook,
  longRunningTaskHook,
  errorRecoveryHook,
  convergenceDetectedHook,
  alwaysLaunchHook,
  randomSurpriseHook,
];

/**
 * Register all smart triggers with the hook registry
 */
export function registerAllSmartTriggers(
  registry: import('./01_HOOK_REGISTRY').HookRegistry
): void {
  logger.info('Registering all smart triggers');

  for (const hook of ALL_SMART_TRIGGERS) {
    registry.register(hook);
  }

  logger.info(`Registered ${ALL_SMART_TRIGGERS.length} smart triggers`);
}

export default ALL_SMART_TRIGGERS;
