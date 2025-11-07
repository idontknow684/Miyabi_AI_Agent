# ROI Calculator & Demo Script

**Version**: 1.0
**Last Updated**: 2025-11-07
**Owner**: VP of Sales

---

## ROI Calculator Framework

### Input Variables

**Customer Inputs** (gathered during discovery):
1. **Number of Developers**: `N` (e.g., 100)
2. **Average Developer Hourly Cost**: `$C` (e.g., $100/hour)
   - Calculation: Annual salary + benefits + overhead / 2,080 hours
   - Example: $200K total comp / 2,080 hours = $96/hour → round to $100
3. **Current Time Spent on Toil**: `T%` (default: 40%)
   - Toil = Manual PRs, code reviews, testing, deployment
   - Industry avg: 30-50%
4. **Current PR Review Time**: `D` days (e.g., 3 days)

---

### Calculation Logic

#### **1. Annual Developer Cost (Baseline)**

```
Total Developer Cost = N × $C × 40 hours/week × 52 weeks/year
```

**Example**:
```
100 developers × $100/hour × 40 hours/week × 52 weeks/year
= 100 × $100 × 2,080 hours
= $20,800,000/year
```

---

#### **2. Annual Toil Cost (Current State)**

```
Toil Cost = Total Developer Cost × T%
```

**Example**:
```
$20,800,000 × 40% = $8,320,000/year wasted on toil
```

---

#### **3. Time Saved with Miyabi**

**Assumptions** (conservative):
- Miyabi automates 70% of toil tasks
- Remaining 30% still requires human oversight

```
Time Saved = T% × 70% = 40% × 70% = 28% of total developer time
```

**Example**:
```
28% of developer time = 28% × 40 hours/week = 11.2 hours/week per developer
```

---

#### **4. Annual Savings**

```
Annual Savings = Total Developer Cost × Time Saved %
```

**Example**:
```
$20,800,000 × 28% = $5,824,000/year
```

---

#### **5. Miyabi Cost**

```
Miyabi Annual Cost = N × $299/seat/month × 12 months
```

**Example**:
```
100 developers × $299/month × 12 months = $358,800/year
```

---

#### **6. Net Savings**

```
Net Savings = Annual Savings - Miyabi Cost
```

**Example**:
```
$5,824,000 - $358,800 = $5,465,200/year
```

---

#### **7. ROI Percentage**

```
ROI = (Net Savings / Miyabi Cost) × 100%
```

**Example**:
```
($5,465,200 / $358,800) × 100% = 1,523% ROI
```

---

#### **8. Payback Period**

```
Payback Period = Miyabi Cost / (Annual Savings / 12 months)
```

**Example**:
```
$358,800 / ($5,824,000 / 12) = 0.74 months ≈ 3 weeks
```

---

### ROI Summary Table (Example)

| Metric | Current State | With Miyabi | Improvement |
|--------|---------------|-------------|-------------|
| **Developer Headcount** | 100 | 100 | - |
| **Hours on Toil** | 16 hours/week | 4.8 hours/week | -70% |
| **Hours on Creative Work** | 24 hours/week | 35.2 hours/week | +47% |
| **PR Review Time** | 3 days | 1 day | -67% |
| **Annual Toil Cost** | $8,320,000 | $2,496,000 | -$5,824,000 |
| **Miyabi Cost** | $0 | $358,800 | +$358,800 |
| **Net Savings** | - | **$5,465,200** | - |
| **ROI** | - | **1,523%** | - |
| **Payback Period** | - | **3 weeks** | - |

---

## ROI Calculator Spreadsheet

### Excel/Google Sheets Template

**Sheet 1: Inputs**

| Input Variable | Value | Notes |
|----------------|-------|-------|
| Number of Developers | 100 | Total engineering team |
| Avg Hourly Cost | $100 | Salary + benefits + overhead / 2,080 hours |
| Current Toil % | 40% | Time on manual PRs, reviews, testing |
| Current PR Review Time | 3 days | Average from Issue → Merged PR |

---

**Sheet 2: Calculations**

| Calculation | Formula | Result |
|-------------|---------|--------|
| Total Developer Cost | `B2 * B3 * 2080` | $20,800,000 |
| Annual Toil Cost | `B5 * B4` | $8,320,000 |
| Time Saved % | `B4 * 0.7` | 28% |
| Annual Savings | `B5 * B7` | $5,824,000 |
| Miyabi Annual Cost | `B2 * 299 * 12` | $358,800 |
| Net Savings | `B8 - B9` | $5,465,200 |
| ROI % | `(B10 / B9) * 100` | 1,523% |
| Payback Period (months) | `B9 / (B8 / 12)` | 0.74 |

---

**Sheet 3: Sensitivity Analysis**

What if developer count changes?

| # Developers | Miyabi Cost | Annual Savings | Net Savings | ROI % |
|--------------|-------------|----------------|-------------|-------|
| 50 | $179,400 | $2,912,000 | $2,732,600 | 1,523% |
| 100 | $358,800 | $5,824,000 | $5,465,200 | 1,523% |
| 200 | $717,600 | $11,648,000 | $10,930,400 | 1,523% |
| 500 | $1,794,000 | $29,120,000 | $27,326,000 | 1,523% |

---

## Demo Script (10-Minute Live Demo)

### Pre-Demo Setup (5 Min Before Call)

**Technical Setup**:
- [ ] Test Zoom screen share (share single window, not entire screen)
- [ ] Open GitHub demo repo (`miyabi-demo-enterprise`)
- [ ] Open Miyabi dashboard (logged in)
- [ ] Close all other tabs (focus!)
- [ ] Mute Slack notifications
- [ ] Test audio, video

**Mental Prep**:
- [ ] Review prospect notes (pain points, company, role)
- [ ] Prepare 1-2 personalized examples
- [ ] Have objection responses ready

---

### Demo Flow (10 Minutes)

#### **0:00-1:00 - Setup & Context** (1 min)

**Script**:
```
"Hi [First Name], thanks for joining!

Quick agenda for the next 10 minutes:
1. I'll show you how Miyabi works - this is a LIVE demo, not a recording
2. I'll create a real GitHub issue
3. You'll watch Miyabi process it in real-time
4. We'll review the PR together
5. Q&A (5 minutes)

Sound good? Great. Let me share my screen."
```

**Action**: Share screen (GitHub repo)

---

#### **1:00-2:00 - Create GitHub Issue** (1 min)

**Script**:
```
"I'm in our demo GitHub repo. This is a real Next.js application.

I'll create a new issue - let's do something realistic:
'Add user authentication with JWT and role-based access control'

In the description, I'll add acceptance criteria:
• User registration with email/password
• JWT token generation on login
• Middleware to verify JWT on protected routes
• Role-based access (admin, user, guest)
• 80%+ test coverage
• Security scan (CodeQL, Gitleaks)

[Type issue description]

Okay, submitting... Issue #547 created.

Now watch what happens next."
```

**Action**: Create issue, submit

---

#### **2:00-3:00 - Agent Activity (Real-Time Commentary)** (1 min)

**Script**:
```
"Within seconds, Miyabi's CoordinatorAgent has picked up the issue.

[Show Miyabi dashboard, agent activity log]

You can see here - it's analyzing the requirements...
Breaking it down into 4 subtasks:
1. Auth service implementation
2. JWT middleware
3. Role-based access control
4. Integration tests

This is the planning phase. Now CodeGenAgent will start generating code."
```

**Action**: Show agent dashboard, activity log

---

#### **3:00-8:00 - Code Generation (Live)** (5 min)

**Script**:
```
"Now CodeGenAgent is generating files.

[Show files appearing in GitHub UI]

You can see files being created:
• auth-service.ts (125 lines) - handles registration, login
• jwt-middleware.ts (48 lines) - verifies JWT tokens
• rbac.ts (62 lines) - role-based permissions
• auth.test.ts (215 lines) - comprehensive test suite

[Pause to let them absorb]

This usually takes 8-10 minutes. To save time, I've prepared one that's just finishing.

[Switch to pre-prepared PR]

Here's a PR that just completed. Let's review it."
```

**Action**: Show pre-prepared PR (Issue #545)

---

#### **8:00-9:00 - PR Review** (1 min)

**Script**:
```
"Here's the PR Miyabi created: Issue #545 - Add user authentication.

[Scroll through PR]

Notice:
• Clean, readable code (follows your coding standards)
• Comprehensive tests (87% coverage)
• Security scan passed (CodeQL, Gitleaks - no vulnerabilities)
• Documentation (README updated, JSDoc comments)

This PR is production-ready. Your team would review it like any other PR - approve or request changes.

[Pause]

Before Miyabi:
• Junior developer: 2-3 days
• Senior developer: 1 day

With Miyabi: 10 minutes.

That's a 95% time saving."
```

**Action**: Show PR, scroll through code, show security checks

---

#### **9:00-10:00 - Results & ROI** (1 min)

**Script**:
```
"Let's talk ROI for [Company].

[Open ROI calculator, plug in their numbers]

• [N] developers × $[C]/hour × 40% toil = $[X] wasted annually
• With Miyabi: Save 70% of toil = $[Y] saved
• Miyabi cost: $[Z]/year
• Net savings: $[Y - Z]
• Payback period: [Weeks]

[Pause to let it sink in]

Based on [Similar Company]'s results, you'd see:
• 70% faster code reviews (3 days → 1 day)
• 3x more features shipped
• Happier developers (90+ NPS)

Questions?"
```

**Action**: Show ROI calculator, plug in their numbers

---

### Q&A Prompts (5 Min After Demo)

**Common Questions & Responses**:

**Q: "Is the code quality good enough?"**
```
A: "Great question. Here's how we ensure quality:

1. ReviewAgent runs CodeQL + Gitleaks (same tools you use manually)
2. 80%+ test coverage required (enforced)
3. Human review still required (you approve PR)
4. [Customer] has 95% PR acceptance rate, 0 production incidents in 6 months"

[Show ReviewAgent security scan in PR]
```

---

**Q: "How much does it cost?"**
```
A: "Pricing is simple:
• Free tier: 50 issues/month (great for trying it out)
• Team tier: $99/seat/month (unlimited issues)
• Enterprise tier: $299/seat/month (custom agents, SSO, premium support)

For [Company] with [N] developers, that's $[Cost]/month.

But remember - you're saving $[Savings]/month in developer productivity.

Net result: $[Net Savings]/month positive impact.

Want me to send over a detailed pricing breakdown?"
```

---

**Q: "How long to implement?"**
```
A: "Fast. Here's the typical timeline:
• Week 1: Setup (GitHub integration, configure agents)
• Week 2-3: Pilot (10 developers, 1 repo)
• Week 4: Rollout to full team

Most customers are live in 2-3 weeks.

[Customer] went from kickoff to 100 developers in 4 weeks."
```

---

**Q: "Can we do a PoC?"**
```
A: "Absolutely. We recommend a 60-day PoC:
• 30 days setup + training
• 30 days evaluation (process 100+ issues)
• Measure: Code review time, NPS, developer satisfaction

Free for 60 days - no cost, no risk.

Success criteria: 50% code review time reduction. If we don't hit it, we'll keep working until we do.

Want to discuss a PoC?"
```

---

### Post-Demo Actions (Immediate)

**Same Day** (within 2 hours):
1. [ ] Send thank-you email with resources
2. [ ] Update CRM (demo completed, notes, next steps)
3. [ ] Send calendar invite for next meeting (technical deep-dive or PoC scoping)

**Email Template**:
```
Hi [First Name],

Great demo today! Here are the resources I promised:

• ROI Calculator (customized for [Company]): [Link]
• Technical Whitepaper: [Link]
• Case Study - [Similar Company]: [Link]
• Security Docs (SOC 2, Pen Test): [Link]

Next steps:
1. Review materials above
2. Share with your team
3. Technical deep-dive (60 min) - [Calendar Invite]

Looking forward to it!

Best,
[Your Name]
```

---

## Demo Best Practices

### Do's ✅

1. **Live Demo Always** - Never use recordings (shows authenticity)
2. **Real Code** - Use real GitHub repos (not mock data)
3. **Personalize** - Use their company name, tech stack
4. **Pause Often** - Let them absorb, ask questions
5. **Show ROI** - Always quantify savings ($X saved)
6. **Handle Objections** - Address concerns proactively
7. **Clear CTA** - End with "Do you want to do a PoC?"

### Don'ts ❌

1. **Don't Rush** - Slow down, let them see the magic
2. **Don't Over-Feature** - Show 1-2 features deeply, not 10 shallowly
3. **Don't Use Jargon** - Speak their language (business outcomes, not tech specs)
4. **Don't Ignore Questions** - Pause demo, answer fully
5. **Don't End Weakly** - Always have clear next steps

---

## Competitive Demos

### "We Already Use GitHub Copilot"

**Response**:
```
"Copilot is great for line-by-line suggestions. Miyabi handles the entire workflow.

Let me show you the difference:

[Demo Copilot: autocomplete a function]
'Copilot helps you write code faster - line by line'

[Demo Miyabi: Issue → PR → Deploy]
'Miyabi automates the entire workflow - no human intervention'

Many customers use both:
• Copilot for coding (when you're writing code manually)
• Miyabi for workflows (when you want full automation)

[Customer] uses both - 4x productivity gain."
```

---

### "We're Building This In-House"

**Response**:
```
"I respect that. We see this often.

Quick question: How long do you estimate it will take?

[They say: '6-12 months']

Here's what that costs:
• 3 engineers × $200K × 1 year = $600K
• Opportunity cost: 12 months not shipping features
• Maintenance: Ongoing (agents break, models change)

With Miyabi:
• Live in 2 weeks
• $300K/year (for 100 developers)
• We handle maintenance, updates, new models

You save $300K in Year 1, plus 12 months of shipping features.

Want to see a PoC to validate?"
```

---

## Success Metrics (Demo Tracking)

### Key Metrics (Track in CRM)

| Metric | Target | Current |
|--------|--------|---------|
| **Demo-to-PoC Rate** | 60% | TBD |
| **Demo-to-No-Show Rate** | <20% | TBD |
| **Demo Duration** | 10 min (+ 5 min Q&A) | TBD |
| **Questions per Demo** | 3-5 | TBD |
| **CTA Acceptance** | 70% (agree to next step) | TBD |

### Post-Demo Survey (Send 24 Hours After)

**Questions**:
1. "How would you rate the demo? (1-10)"
2. "What was most impressive?"
3. "What concerns do you still have?"
4. "How likely are you to purchase Miyabi? (1-10)"

---

**Maintained by**: VP of Sales
**Last Updated**: 2025-11-07
**Version**: 1.0
