# Practical Examples: Detail Control in Claude Code

**Version**: 1.0.0
**Last Updated**: 2025-11-07

---

## Quick Reference Examples

### Example 1: File Search (Low Detail)

```javascript
// User request
"Find all React components in the project"

// Claude Code invocation
Task({
  subagent_type: "Explore",
  thoroughness: "quick",
  model: "haiku",  // Fast model for simple task
  description: "Find React components",
  prompt: `
    Find all React component files in this project.

    Output: Simple list of file paths only.
    Detail level: Quick (file names only, no analysis)
  `
})

// Expected output
[
  'src/components/Button.tsx',
  'src/components/Header.tsx',
  'src/pages/Home.tsx',
  // ... more files
]
```

### Example 2: Feature Understanding (Medium Detail)

```javascript
// User request
"How does authentication work in this app?"

// Claude Code invocation
Task({
  subagent_type: "Explore",
  thoroughness: "medium",
  model: "sonnet",
  description: "Understand auth system",
  prompt: `
    Explain how authentication works in this application.

    Detail level: Medium

    Provide:
    1. Main auth files (with line references)
    2. Flow description (3-5 paragraphs)
    3. Key functions/classes
    4. Configuration overview

    Do NOT:
    - Analyze every line of code
    - Include test files in detail
    - Provide implementation suggestions
  `
})

// Expected output structure
{
  "files": [
    "src/auth/AuthContext.tsx:1-150",
    "src/api/authApi.ts:10-89"
  ],
  "flow": "The authentication system uses JWT tokens...",
  "keyComponents": [
    "AuthContext: Manages auth state",
    "useAuth(): Custom hook for components"
  ],
  "config": {
    "tokenStorage": "localStorage",
    "refreshInterval": "15min"
  }
}
```

### Example 3: Comprehensive Analysis (High Detail)

```javascript
// User request
"Complete security audit of the payment processing system"

// Claude Code invocation
Task({
  subagent_type: "security-analyzer",
  thoroughness: "very thorough",
  model: "opus",  // Most capable model
  description: "Security audit payment system",
  prompt: `
    Perform comprehensive security audit of payment processing system.

    Detail level: Very thorough (exhaustive analysis)

    Analyze:
    1. All payment-related files
    2. Data flow from cart to confirmation
    3. Encryption methods
    4. API security
    5. Input validation
    6. Error handling
    7. Logging practices
    8. PCI DSS compliance
    9. Third-party integrations
    10. Test coverage

    For each finding, provide:
    - File and line number
    - Severity (Critical/High/Medium/Low)
    - Description
    - Proof of concept (if applicable)
    - Remediation steps
    - References to standards

    Output format: Detailed markdown report
  `
})
```

---

## Real-World Scenarios

### Scenario A: Onboarding to New Codebase

#### Step 1: Quick Overview (5 minutes)

```javascript
const overview = await Task({
  subagent_type: "Explore",
  thoroughness: "quick",
  model: "haiku",
  prompt: `
    Quick overview of this codebase:
    - Project type (framework/language)
    - Main directories and their purposes
    - Entry point files
    - Package manager and key dependencies

    Output: 5-10 bullet points
  `
});

console.log(overview);
// Output:
// - Next.js 14 application (TypeScript)
// - src/app/: Next.js App Router pages
// - src/components/: Reusable UI components
// - src/lib/: Utility functions and API clients
// - Entry: src/app/page.tsx
// - Uses: React 18, Tailwind CSS, Prisma ORM
```

#### Step 2: Key Features Understanding (15 minutes)

```javascript
const features = await Task({
  subagent_type: "Explore",
  thoroughness: "medium",
  model: "sonnet",
  prompt: `
    Identify and explain the main features of this application:

    For each feature, provide:
    1. Name and description
    2. Key files (top 3-5)
    3. User flow summary
    4. Technical approach

    Detail level: Medium (understand without deep diving)
  `
});

console.log(features);
// Output:
// Feature 1: User Authentication
//   Files: src/app/auth/, src/lib/auth.ts
//   Flow: Email/password → JWT token → Protected routes
//   Tech: NextAuth.js with Prisma adapter
//
// Feature 2: Product Catalog
//   Files: src/app/products/, src/components/ProductCard.tsx
//   Flow: Fetch from API → Display grid → Detail view
//   Tech: Server components with ISR
```

#### Step 3: Deep Dive on Critical Path (30 minutes)

```javascript
const deepDive = await Task({
  subagent_type: "Explore",
  thoroughness: "very thorough",
  model: "opus",
  prompt: `
    Comprehensive analysis of the checkout and payment flow:

    Detail level: Very thorough

    Document:
    1. Complete user journey (step-by-step)
    2. All involved files with line-by-line references
    3. Data models and validation
    4. State management approach
    5. API endpoints and payloads
    6. Error handling strategy
    7. Security measures
    8. Third-party integrations (Stripe, etc.)
    9. Edge cases and error states
    10. Testing approach

    Include code snippets for critical sections.
    Create sequence diagram of the flow.
  `
});
```

### Scenario B: Bug Investigation

#### Progressive Detail Escalation

```javascript
// Phase 1: Quick scan for obvious issues
const quickScan = await Task({
  subagent_type: "Explore",
  thoroughness: "quick",
  prompt: `
    User reports: "Cart total is sometimes incorrect"

    Quick scan for obvious issues:
    - Find cart calculation logic
    - Check for NaN or undefined handling
    - Look for race conditions (async issues)

    Output: List of suspicious code locations
  `
});

// Phase 2: If issues found, medium detail analysis
if (quickScan.suspiciousLocations.length > 0) {
  const analysis = await Task({
    subagent_type: "Explore",
    thoroughness: "medium",
    prompt: `
      Analyze these suspicious locations: ${quickScan.suspiciousLocations}

      For each:
      - Explain the logic
      - Identify potential bugs
      - Suggest hypothesis for "incorrect total" issue

      Detail level: Medium (understand logic, propose theories)
    `
  });

  // Phase 3: If still unclear, thorough investigation
  if (analysis.requiresDeeperInvestigation) {
    const thorough = await Task({
      subagent_type: "Explore",
      thoroughness: "very thorough",
      model: "opus",
      prompt: `
        Deep investigation of cart calculation bug:

        Context: ${analysis}

        Perform:
        1. Trace complete data flow from product addition to total calculation
        2. Analyze all mathematical operations
        3. Check state updates and re-renders
        4. Test edge cases (discounts, taxes, shipping)
        5. Review related tests
        6. Identify root cause

        Provide:
        - Root cause explanation
        - Proof with code references
        - Fix proposal with implementation details
      `
    });
  }
}
```

### Scenario C: Multi-Domain Analysis

#### Different Detail Levels per Domain

```javascript
// Analyzing a full-stack application
const results = await Promise.all([
  // Frontend: UI/UX review (medium detail)
  Task({
    subagent_type: "ui-ux-reviewer",
    thoroughness: "medium",
    prompt: `
      Review frontend UI/UX:
      - Component structure and reusability
      - Accessibility (WCAG 2.1)
      - Responsive design
      - Performance (lazy loading, etc.)

      Detail level: Medium (identify issues, no deep technical dive)
    `
  }),

  // Backend: Security audit (high detail)
  Task({
    subagent_type: "security-analyzer",
    thoroughness: "very thorough",
    model: "opus",
    prompt: `
      Comprehensive backend security audit:
      - API authentication and authorization
      - SQL injection risks
      - XSS vulnerabilities
      - CSRF protection
      - Data encryption
      - Secret management
      - Rate limiting
      - OWASP Top 10 compliance

      Detail level: Very thorough (exhaustive, critical for production)
    `
  }),

  // Database: Schema review (medium detail)
  Task({
    subagent_type: "Explore",
    thoroughness: "medium",
    prompt: `
      Database schema review:
      - Table structure and relationships
      - Index optimization opportunities
      - Migration history
      - Query performance concerns

      Detail level: Medium (overview with key insights)
    `
  }),

  // Tests: Coverage scan (quick)
  Task({
    subagent_type: "Explore",
    thoroughness: "quick",
    model: "haiku",
    prompt: `
      Quick test coverage scan:
      - Number of test files
      - Coverage percentage (if available)
      - Areas lacking tests

      Detail level: Quick (high-level metrics only)
    `
  })
]);

const [frontend, backend, database, tests] = results;
```

---

## Code Snippets

### Control Pattern 1: Explicit Thoroughness

```typescript
interface TaskConfig {
  subagent_type: string;
  thoroughness: 'quick' | 'medium' | 'very thorough';
  model?: 'haiku' | 'sonnet' | 'opus';
  prompt: string;
}

// Usage
const config: TaskConfig = {
  subagent_type: "Explore",
  thoroughness: "medium",
  model: "sonnet",
  prompt: "Analyze authentication system"
};

await Task(config);
```

### Control Pattern 2: Dynamic Detail Selection

```typescript
function selectDetailLevel(taskComplexity: number, timeConstraint: number): string {
  if (timeConstraint < 60) {
    return 'quick';  // Less than 1 minute
  }

  if (taskComplexity > 8) {
    return 'very thorough';  // Complex task
  }

  return 'medium';  // Default
}

// Usage
const complexity = assessComplexity(userRequest);
const timeLimit = getTimeLimit();
const detail = selectDetailLevel(complexity, timeLimit);

await Task({
  subagent_type: "Explore",
  thoroughness: detail,
  prompt: userRequest
});
```

### Control Pattern 3: Iterative Refinement

```typescript
async function iterativeAnalysis(topic: string) {
  let currentDetail = 'quick';
  let result = null;
  let iteration = 0;
  const MAX_ITERATIONS = 3;

  while (iteration < MAX_ITERATIONS) {
    result = await Task({
      subagent_type: "Explore",
      thoroughness: currentDetail,
      prompt: `Analyze ${topic} at ${currentDetail} detail level`
    });

    // Check if user is satisfied
    const satisfied = await askUser("Is this sufficient?");
    if (satisfied) break;

    // Increase detail level
    currentDetail = nextDetailLevel(currentDetail);
    iteration++;
  }

  return result;
}

function nextDetailLevel(current: string): string {
  const levels = ['quick', 'medium', 'very thorough'];
  const index = levels.indexOf(current);
  return levels[Math.min(index + 1, levels.length - 1)];
}
```

### Control Pattern 4: Conditional Escalation

```typescript
async function smartSecurityScan(component: string) {
  // Start with quick scan
  const quickResult = await Task({
    subagent_type: "security-analyzer",
    thoroughness: "quick",
    model: "haiku",
    prompt: `Quick security scan of ${component}`
  });

  // Parse severity
  const maxSeverity = getMaxSeverity(quickResult);

  // Escalate if needed
  if (maxSeverity >= 'HIGH') {
    console.log("⚠️ High severity issues found, escalating to thorough analysis...");

    return await Task({
      subagent_type: "security-analyzer",
      thoroughness: "very thorough",
      model: "opus",
      prompt: `
        Comprehensive security audit of ${component}.

        Previous quick scan found: ${quickResult.summary}

        Perform exhaustive analysis:
        - Verify all findings
        - Find related vulnerabilities
        - Assess exploitability
        - Provide detailed remediation
      `
    });
  }

  return quickResult;
}

function getMaxSeverity(result: any): string {
  // Extract maximum severity from results
  const severities = result.findings.map(f => f.severity);
  if (severities.includes('CRITICAL')) return 'CRITICAL';
  if (severities.includes('HIGH')) return 'HIGH';
  if (severities.includes('MEDIUM')) return 'MEDIUM';
  return 'LOW';
}
```

---

## CLI Usage Examples

### Example 1: Quick Command

```bash
# Quick file search
claude-code task --agent Explore --detail quick \
  --prompt "Find all API route handlers"
```

### Example 2: Standard Analysis

```bash
# Medium detail analysis
claude-code task --agent Explore --detail medium \
  --prompt "Explain how the caching system works"
```

### Example 3: Comprehensive Report

```bash
# Thorough analysis with best model
claude-code task --agent Explore --detail thorough \
  --model opus \
  --prompt "Complete documentation of the authentication system" \
  --output auth-docs.md
```

### Example 4: Parallel Multi-Detail

```bash
# Run multiple agents with different detail levels
claude-code task parallel \
  --job1 "agent=Explore,detail=quick,prompt='List all components'" \
  --job2 "agent=Explore,detail=medium,prompt='Analyze state management'" \
  --job3 "agent=security-analyzer,detail=thorough,prompt='Security audit'"
```

---

## Configuration Files

### .claude/agents/custom-detail-config.json

```json
{
  "agents": {
    "quick-explorer": {
      "type": "Explore",
      "default_thoroughness": "quick",
      "default_model": "haiku",
      "use_cases": [
        "File searches",
        "Quick scans",
        "List generation"
      ]
    },
    "standard-analyzer": {
      "type": "Explore",
      "default_thoroughness": "medium",
      "default_model": "sonnet",
      "use_cases": [
        "Feature understanding",
        "Code review",
        "Bug investigation"
      ]
    },
    "deep-auditor": {
      "type": "security-analyzer",
      "default_thoroughness": "very thorough",
      "default_model": "opus",
      "use_cases": [
        "Security audits",
        "Compliance checks",
        "Production readiness"
      ]
    }
  },
  "detail_levels": {
    "quick": {
      "max_files": 50,
      "max_time_seconds": 60,
      "depth": "surface"
    },
    "medium": {
      "max_files": 200,
      "max_time_seconds": 300,
      "depth": "moderate"
    },
    "very thorough": {
      "max_files": null,
      "max_time_seconds": 1800,
      "depth": "exhaustive"
    }
  }
}
```

---

## Troubleshooting

### Issue 1: Agent Takes Too Long

```javascript
// Problem: Agent is taking forever

// Solution: Reduce detail level
// Before (too detailed)
Task({
  subagent_type: "Explore",
  thoroughness: "very thorough",
  prompt: "Find all React components"
})

// After (appropriate detail)
Task({
  subagent_type: "Explore",
  thoroughness: "quick",  // ← Reduced
  model: "haiku",          // ← Faster model
  prompt: "Find all React components"
})
```

### Issue 2: Insufficient Detail in Results

```javascript
// Problem: Agent response lacks necessary detail

// Solution: Increase thoroughness and/or specify requirements
// Before (vague)
Task({
  subagent_type: "Explore",
  thoroughness: "quick",
  prompt: "Analyze auth system"
})

// After (explicit)
Task({
  subagent_type: "Explore",
  thoroughness: "very thorough",  // ← Increased
  model: "opus",                   // ← Better model
  prompt: `
    Comprehensive analysis of auth system:

    Must include:
    1. All auth-related files (with line refs)
    2. Complete flow diagram
    3. Security assessment
    4. Configuration details
    5. Integration points

    Minimum 500 words.
  `
})
```

### Issue 3: Agent Goes Off-Track

```javascript
// Problem: Agent analyzes unrelated code

// Solution: Add explicit constraints
Task({
  subagent_type: "Explore",
  thoroughness: "medium",
  prompt: `
    Analyze authentication system.

    Constraints:
    - ONLY analyze files in src/auth/ directory
    - EXCLUDE test files
    - FOCUS ON user authentication (not authorization)
    - IGNORE third-party library internals

    Stay within these boundaries.
  `
})
```

---

## Performance Benchmarks

### Typical Execution Times

| Detail Level | Files Analyzed | Avg Time | Model | Cost (approx) |
|--------------|----------------|----------|-------|---------------|
| Quick        | 10-50          | 30-90s   | Haiku | $0.01-0.05    |
| Medium       | 50-200         | 2-5min   | Sonnet| $0.10-0.30    |
| Very Thorough| 200+           | 5-15min  | Opus  | $0.50-2.00    |

---

## Further Examples

For more examples, see:
- [Real-World Case Studies](./case-studies/)
- [Integration Patterns](./integration-patterns.md)
- [Advanced Techniques](./advanced-techniques.md)

---

**Questions?**
Open an issue: https://github.com/anthropics/claude-code/issues
