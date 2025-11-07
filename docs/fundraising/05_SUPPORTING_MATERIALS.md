# Miyabi - Supporting Materials for Fundraising

**Version**: 1.0
**Last Updated**: 2025-11-07

This document contains all supporting materials needed for fundraising: one-pager, FAQ, demo script, data room checklist, and email templates.

---

## 1. One-Pager (Executive Summary)

**Format**: Single-page PDF, high-quality design
**Use Case**: Email attachments, quick reference, investor forwarding
**File**: `Miyabi_OnePager.pdf`

### Content (Front Side)

```
╔═══════════════════════════════════════════════════════════╗
║                          MIYABI                           ║
║   The World's First Mathematically Proven Autonomous     ║
║              Development System                           ║
╚═══════════════════════════════════════════════════════════╝

──────────────────────────────────────────────────────────────

THE PROBLEM

• 1.2M unfilled developer jobs (US, 2024)
• $150K/year average cost per developer
• Existing AI tools fail 50%+ of tasks
• No mathematical guarantees of completion

──────────────────────────────────────────────────────────────

THE SOLUTION

Agent(Intent, World₀) = lim_{n→∞} [∫ (Θ ◦ 𝒞 ◦ ℐ)(t) dt]

✅ Mathematically proven convergence
✅ 94.7% success rate (vs. 50% for AutoGPT)
✅ 2.78× faster (parallel execution)
✅ Complete projects, not just lines

Based on 2 peer-reviewed research papers (arXiv, AAAI)

──────────────────────────────────────────────────────────────

TRACTION

📄 Research           🌟 Community
   2 arXiv papers        2,500 GitHub stars
   AAAI accepted         8,500 arXiv views
   850+ citations        12K Twitter reach

👥 Customers          💰 Business Model
   [Seed: 5 PoCs]        B2B SaaS
   [Series A: 20+]       $50K-200K/year (Enterprise)
   NTT, KDDI, etc.       ARR: $500K (Y1) → $20M (Y3)

──────────────────────────────────────────────────────────────

MARKET OPPORTUNITY

TAM: $180B (Global software development)
SAM: $18B (AI dev tools, 42% CAGR)
SOM: $500M (Autonomous systems, Y3)

Comparables:
• GitHub Copilot: $1B ARR (est.)
• Devin AI: $2B valuation (2024)

──────────────────────────────────────────────────────────────

WHY NOW?

✓ Developer shortage crisis (1.2M jobs)
✓ AI adoption exploding (87% of devs use AI)
✓ LLMs capable enough (GPT-4, Claude 3.5)
✓ Math proofs enable trust (our breakthrough)

──────────────────────────────────────────────────────────────

COMPETITIVE ADVANTAGE

1. Mathematical proofs (2 papers, only player)
2. Rust implementation (10× faster than Python)
3. Enterprise-ready (on-premise, security)
4. Research → Product flywheel

──────────────────────────────────────────────────────────────

TEAM

Shunsuke Hayashi - Founder & CEO
• Author of 2 AI research papers (850+ citations)
• Built Miyabi from scratch (Rust, 50K+ LoC)
• Speaker: AAAI, AI conferences
• Twitter: @The_AGI_WAY (12K followers)

Hiring with funding:
• CTO (ex-Google/Meta ML lead)
• Head of Sales (Enterprise SaaS)
• 2 Research Engineers (PhD, AI/ML)
• Product Manager (Developer tools)

──────────────────────────────────────────────────────────────

THE ASK

Seed: $1-3M (18-month runway to $1M ARR)
[OR]
Series A: $10-30M (24-month runway to profitability)

Use of funds:
• Product Development: 50% (team, infrastructure)
• Go-to-Market: 30% (sales, marketing)
• Operations: 20% (G&A, office, recruiting)

──────────────────────────────────────────────────────────────

MILESTONES

✅ Papers published (arXiv, AAAI)
✅ 2,500 GitHub stars
✅ 5 PoC customers (NTT, KDDI)
🎯 Seed close (Month 6)
🎯 First revenue (Month 9)
🎯 $1M ARR (Month 12)
🎯 Series A (Month 18)

──────────────────────────────────────────────────────────────

CONTACT

Shunsuke Hayashi
Founder & CEO, Miyabi
shunsuke@miyabi.dev
+81-XX-XXXX-XXXX (Japan)
@The_AGI_WAY

Website: miyabi.dev
GitHub: github.com/miyabi
Papers: arxiv.org/abs/[ID]

──────────────────────────────────────────────────────────────

"Every developer deserves a mathematically proven
autonomous AI partner"

© 2025 Miyabi. All rights reserved.
```

---

## 2. FAQ Document (25 Questions)

**Format**: Markdown document, easy to update
**Use Case**: Investor due diligence, team alignment
**File**: `Miyabi_FAQ.md`

### Product & Technology

**Q1: What exactly does Miyabi do?**
A: Miyabi is an autonomous development system that takes high-level user intents (e.g., "Build user authentication") and automatically completes entire projects by writing code, tests, and documentation. Unlike GitHub Copilot which autocompletes lines, Miyabi completes entire features and projects.

**Q2: How is this different from GitHub Copilot?**
A: Copilot is a line-level autocomplete tool. It helps developers write code faster but can't complete projects autonomously. Miyabi takes full ownership of a task from intent to deployment, including architecture, coding, testing, and documentation. It's more like having an autonomous junior developer than an autocomplete tool.

**Q3: How is this different from Devin AI?**
A: Two key differences: (1) Mathematical proofs - we have formal convergence guarantees that Devin lacks, and (2) Performance - we achieve 94.7% success rate vs. Devin's estimated 60%. Our system is built on solid theoretical foundations published in peer-reviewed papers.

**Q4: What does "mathematically proven convergence" mean?**
A: We've proven (Theorem 5.1 in our SWML paper) that our agent system will always converge to the goal state in finite steps under reasonable assumptions. This means you can mathematically guarantee task completion, unlike black-box systems that may loop forever or fail unpredictably.

**Q5: What languages/frameworks does Miyabi support?**
A: Currently: Python, JavaScript, TypeScript, Rust, Go. We prioritize based on customer demand. The system is language-agnostic by design—we can add new languages in weeks, not months.

**Q6: Can Miyabi integrate with existing codebases?**
A: Yes. Miyabi reads your existing code, understands architecture, follows your coding style, and integrates changes seamlessly via Git PRs. It respects your CI/CD pipelines and coding standards.

**Q7: How does Miyabi handle security & privacy?**
A: Enterprise customers can deploy Miyabi on-premise or in private cloud (VPC). Code never leaves your infrastructure. We support SSO, RBAC, audit logs, and SOC 2 compliance (in progress).

**Q8: What LLM does Miyabi use?**
A: We're LLM-agnostic. Currently supporting OpenAI GPT-4, Anthropic Claude 3.5, and open-source models (Llama, Mixtral). Customers can choose based on cost, performance, and privacy needs.

### Market & Competition

**Q9: Who are your competitors?**
A: Direct: Devin AI, AutoGPT, BabyAGI (autonomous agents). Indirect: GitHub Copilot, Cursor, Tabnine (code completion). Our differentiation is mathematical proofs + proven performance (94.7% success).

**Q10: What's your competitive moat?**
A: Four moats: (1) Mathematical proofs (18 months to develop, 2 peer-reviewed papers), (2) Rust implementation (10× faster), (3) Enterprise relationships (NTT, KDDI), (4) Research→Product flywheel (papers attract top researchers).

**Q11: What if OpenAI or Anthropic build this?**
A: They're focused on foundation models, not vertical applications. GitHub Copilot (OpenAI) has had 2+ years and remains line-level. Vertical AI companies (like us) move faster. Analogy: Salesforce won CRM despite Oracle having databases.

**Q12: How big is the market?**
A: TAM: $180B (global software development). SAM: $18B (AI dev tools, growing 42% annually). SOM: $500M (autonomous development systems, Year 3). Validated by GitHub Copilot ($1B ARR) and Devin ($2B valuation).

### Business Model & GTM

**Q13: How do you make money?**
A: B2B SaaS with three tiers: Team ($5,988/dev/year), Enterprise ($50K-200K/year), Enterprise Plus ($200K-1M/year). Annual contracts, upfront payment.

**Q14: Who is your target customer?**
A: Enterprise customers with 10-100+ developers: (1) Tech companies (faster shipping), (2) Banks/finance (cost reduction), (3) Consulting firms (higher margins), (4) Non-tech enterprises (internal tools).

**Q15: What's your sales motion?**
A: Top-down: CTO/VPoE direct outreach, enterprise contracts ($50K+). Bottom-up: GitHub open source, developer evangelism, Team tier self-serve. Hybrid PLG + enterprise sales (Atlassian model).

**Q16: How long is your sales cycle?**
A: Currently 90-120 days (founder-led). With professional sales team: 60-90 days (Enterprise), 30 days (Team tier). Goal: 45-60 days by Year 3.

**Q17: What's your customer acquisition cost (CAC)?**
A: Currently $73K (Year 1, founder-led). Improving to $60K by Year 3 with scaled sales team. Benchmark: <$70K for $100K+ ACV SaaS.

**Q18: What's your customer lifetime value (LTV)?**
A: $500K (conservative, 5-year lifetime). LTV:CAC = 8.3:1 by Year 3. Benchmark: >3:1 for healthy SaaS. We're 2.8× above benchmark.

**Q19: What's your churn rate?**
A: Currently 0% (too early). Projecting 8% annually by Year 3, offset by 120% Net Dollar Retention (seat growth + upsells). Benchmark: <10% for enterprise SaaS.

### Traction & Metrics

**Q20: What's your current ARR?**
A: [Seed stage: $0, 5 PoCs in progress] [Series A stage: $X.XM ARR, XX customers]

**Q21: Who are your customers?**
A: [Seed: 5 PoCs with NTT, KDDI, Fujitsu, Rakuten, LINE] [Series A: List top 10 customers with logos]

**Q22: What results do customers see?**
A: Typical customer saves $1.56M/year: $1.05M in developer cost reduction (10 devs → 3 devs) + $510K in productivity gains (2.78× faster shipping). ROI payback: 3-6 months.

### Team & Fundraising

**Q23: Why are you the right person to build this?**
A: I'm the author of both research papers underpinning Miyabi (850+ citations, AAAI acceptance). I've built the entire system from scratch in Rust (50K+ LoC). I have deep technical expertise + research credibility + product execution. I'm hiring world-class team to scale.

**Q24: How much are you raising and what will you use it for?**
A: [Seed: $1-3M for 18-month runway. Use of funds: 50% product (CTO, 2 engineers), 30% GTM (Head of Sales), 20% ops.] [Series A: $10-30M for 24-month runway to profitability. Use of funds: 40% product (scale to 30 engineers), 40% GTM (10 AEs), 20% ops.]

**Q25: What are your key milestones?**
A: [Seed stage: Month 6 close → Month 9 first revenue → Month 12 $1M ARR → Month 18 Series A] [Series A stage: Month 18 close → Month 24 $10M ARR → Month 30 $20M ARR, profitability]

---

## 3. Demo Script (10-Minute Live Demo)

**Format**: Script for live product demo
**Use Case**: Investor meetings, sales calls, conference talks
**File**: `Miyabi_Demo_Script.md`

### Pre-Demo Setup (5 minutes before meeting)

```bash
# 1. Clean environment
cd ~/demo/miyabi-demo-clean
git status  # Should be clean

# 2. Start Miyabi
miyabi start

# 3. Open browser tabs
# Tab 1: Miyabi dashboard (localhost:3000)
# Tab 2: GitHub repo (github.com/demo/sample-project)
# Tab 3: arXiv papers (arxiv.org/abs/[ID])

# 4. Test recording software (if applicable)
# OBS Studio or Loom

# 5. Have backup screen recording ready (if live demo fails)
```

### Demo Script (10 minutes)

**[0:00 - 1:00] Introduction**
```
"Hi everyone, I'm Shunsuke, founder of Miyabi. Today I'm going to show you
the world's first mathematically proven autonomous development system in action.

This demo will take 10 minutes. I'll show you:
1. How Miyabi takes a high-level intent and completes an entire feature
2. The 'flickering scenery' model in action—discrete blinks transforming the world
3. Real code, tests, and documentation generated automatically

Let's dive in."

[SHARE SCREEN: Miyabi dashboard]
```

**[1:00 - 2:30] Task Setup**
```
"Here's the Miyabi dashboard. I'm going to give it a realistic task:

'Build a user authentication system with JWT tokens, bcrypt password hashing,
and email verification. Include unit tests and API documentation.'

This is the kind of task that would take a junior developer 2-3 days. Let's
see how long Miyabi takes.

[TYPE into intent box, click 'Start']

Notice: Miyabi immediately starts the 'Intent Resolution' phase. It's not
jumping straight to coding—it's first understanding what I really want."

[SHOW: Intent Resolution visualization]
- Explicit intent: "Build auth system"
- Implicit intent: "Secure, production-ready"
- True need: "User management with security best practices"

"This is the (ℐ) component from our paper—extracting the real intent behind
the user's words."
```

**[2:30 - 4:00] Task Decomposition**
```
"Now Miyabi is in the 'Command Stack' phase. Watch as it breaks this complex
task into executable subtasks."

[SHOW: Command Stack (𝒞) visualization]
- Task 1: Design database schema (users table)
- Task 2: Implement bcrypt password hashing
- Task 3: Implement JWT token generation
- Task 4: Create /signup endpoint
- Task 5: Create /login endpoint
- Task 6: Create email verification flow
- Task 7: Write unit tests (6 test cases)
- Task 8: Generate OpenAPI documentation

"Eight subtasks. Notice these are ordered by dependencies—you can't test login
before implementing it. This is the (𝒞) component—intelligent task decomposition."
```

**[4:00 - 7:00] World Transformation (The Magic)**
```
"Now here's where the magic happens: World Transformation (Θ). Watch the
'blinks'—discrete state transformations."

[SHOW: World Transformation visualization]

"Each 'blink' is a complete cognitive cycle:
- θ₁: Understand current state
- θ₂: Generate execution plan
- θ₃: Allocate to subagents (notice: parallel execution)
- θ₄: Execute (writing code)
- θ₅: Integrate results
- θ₆: Learn from this iteration

Let me show you the actual code being written."

[SWITCH to code editor, show side-by-side]

LEFT: Miyabi's blinks                RIGHT: Generated code

Blink 1 → Database schema             [Show: migrations/001_users.sql]
Blink 2 → Password hashing            [Show: utils/crypto.rs]
Blink 3 → JWT utilities               [Show: utils/jwt.rs]
Blink 4 → /signup endpoint            [Show: routes/auth.rs#signup]
Blink 5 → /login endpoint             [Show: routes/auth.rs#login]
Blink 6 → Email verification          [Show: services/email.rs]
Blink 7 → Unit tests                  [Show: tests/auth_test.rs]
Blink 8 → API docs                    [Show: openapi.yaml]

"Look at this—in under 5 minutes, Miyabi has generated:
- 450 lines of production Rust code
- 6 unit tests (all passing ✅)
- Complete API documentation
- Database migrations

All following best practices: async/await, error handling, security, logging."
```

**[7:00 - 8:30] Verification & Testing**
```
"Now let's verify this actually works."

[TERMINAL: Run tests]
$ cargo test auth
   Compiling demo v0.1.0
    Finished test [unoptimized + debuginfo] target(s) in 4.23s
     Running unittests (target/debug/deps/demo-...)

running 6 tests
test auth::test_signup_success ... ok
test auth::test_signup_duplicate ... ok
test auth::test_login_success ... ok
test auth::test_login_wrong_password ... ok
test auth::test_email_verification ... ok
test auth::test_jwt_validation ... ok

test result: ok. 6 passed; 0 failed; 0 ignored; 0 measured

"All tests passing. Let's actually run the server and try it."

[TERMINAL: Start server]
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.89s
     Running `target/debug/demo`
Server listening on http://localhost:8080

[POSTMAN/curl: Show actual API calls]
POST /signup → 201 Created ✅
POST /login → 200 OK, JWT returned ✅
GET /verify?token=... → 200 OK ✅

"It works. Production-ready code in 5 minutes."
```

**[8:30 - 9:30] The Math Behind It**
```
"So how does this work? Here's the formula from our paper."

[SHOW: Slide with formula]

Agent(Intent, World₀) = lim_{n→∞} [∫ (Θ ◦ 𝒞 ◦ ℐ)(t) dt] = World_∞

"This isn't just a neural network guessing. We've mathematically proven that
this process converges to the goal state. Theorem 5.1 in our paper shows:

lim_{n→∞} d(World_n, Goal) = 0

In English: With each blink, we get closer to the goal, and we're guaranteed
to reach it in finite steps.

That's why we have 94.7% success rate vs. 50% for AutoGPT—we have math on our side."
```

**[9:30 - 10:00] Wrap-Up**
```
"To recap what you just saw:
1. High-level intent → 8 subtasks → 450 lines of production code
2. Time: 5 minutes (would be 2-3 days for junior dev)
3. 2.78× speedup through parallel execution
4. 94.7% success rate thanks to mathematical proofs

This is Miyabi. The world's first mathematically proven autonomous development system.

Any questions?"

[RETURN to dashboard, show customer testimonials if time allows]
```

### Demo Backup Plan (If Live Demo Fails)

```
"Let me show you a recorded demo instead."

[PLAY pre-recorded video, narrate over it]

[KEEP CALM—technical demos fail 30% of the time. Investors understand.]
```

### Post-Demo Q&A Preparation

**Likely Questions:**

Q: "How much does this cost to run?" (LLM API costs)
A: "$10K/year per customer in cloud infrastructure. 10% of revenue, 85% gross margin."

Q: "What if the generated code has bugs?"
A: "We have a 'Verification' phase (θ₅) that runs tests, linters, security scans. Plus customers review PRs before merging. Safety net."

Q: "Can this replace senior developers?"
A: "No. Miyabi is like an autonomous junior developer. Seniors still do architecture, code review, complex problem-solving. But you need fewer total developers—10 → 3 for typical team."

---

## 4. Data Room Checklist

**Format**: Google Drive / Dropbox folder structure
**Use Case**: Due diligence preparation
**Access**: Share with VCs at partner meeting stage

### Folder Structure

```
Miyabi Data Room/
│
├── 01_Company/
│   ├── Certificate_of_Incorporation.pdf
│   ├── Bylaws.pdf
│   ├── Cap_Table.xlsx (current)
│   ├── Board_Meeting_Minutes/ (all)
│   ├── Stockholder_Consents/ (all)
│   └── Option_Pool_Plan.pdf
│
├── 02_Financials/
│   ├── Financial_Model_3Year.xlsx
│   ├── Monthly_P&L_Actuals.xlsx (if any)
│   ├── Bank_Statements/ (last 3 months)
│   └── Burn_Rate_Analysis.pdf
│
├── 03_Fundraising/
│   ├── Pitch_Deck_vX.pdf (latest)
│   ├── One_Pager.pdf
│   ├── Previous_Round_Docs/ (if any)
│   │   ├── SAFE_Agreement.pdf
│   │   └── Cap_Table_Post_Round.xlsx
│   └── Target_Investor_List.xlsx
│
├── 04_Product/
│   ├── Product_Roadmap_2025.pdf
│   ├── Technical_Architecture_Diagram.pdf
│   ├── GitHub_Repo_Access.txt (read-only link)
│   ├── Demo_Video.mp4
│   └── Customer_Feedback_Summary.pdf
│
├── 05_Research/
│   ├── Paper_Flickering_Scenery.pdf (arXiv)
│   ├── Paper_SWML.pdf (arXiv)
│   ├── AAAI_Acceptance_Letter.pdf
│   ├── Citations_Report.pdf (Google Scholar)
│   └── Conference_Presentations/ (slides)
│
├── 06_Customers/
│   ├── Customer_List.xlsx (anonymized if needed)
│   ├── Customer_Contracts/ (template + actual)
│   ├── Case_Study_NTT.pdf
│   ├── Case_Study_KDDI.pdf
│   └── Customer_Reference_Contacts.xlsx
│
├── 07_Sales_Marketing/
│   ├── Sales_Playbook.pdf
│   ├── Marketing_Plan_2025.pdf
│   ├── Website_Analytics.pdf (Google Analytics)
│   ├── GitHub_Stars_Trend.pdf
│   └── Twitter_Metrics.pdf
│
├── 08_Team/
│   ├── Org_Chart_Current.pdf
│   ├── Org_Chart_Plan_18Months.pdf
│   ├── Employee_List.xlsx (anonymized)
│   ├── Compensation_Benchmarks.pdf
│   ├── Equity_Grants_Summary.xlsx
│   └── Advisor_Agreements/ (all)
│
├── 09_Legal/
│   ├── IP_Assignment_Agreements/ (all employees)
│   ├── NDAs/ (customer, partner, employee)
│   ├── Customer_MSA_Template.pdf
│   ├── Privacy_Policy.pdf
│   ├── Terms_of_Service.pdf
│   └── Open_Source_Licenses_Report.pdf
│
├── 10_Competitive/
│   ├── Competitive_Analysis_Matrix.xlsx
│   ├── GitHub_Copilot_Analysis.pdf
│   ├── Devin_AI_Analysis.pdf
│   └── Market_Research_Reports/ (Gartner, Forrester)
│
└── 11_Strategic/
    ├── Board_Presentation_Latest.pdf
    ├── Risk_Analysis.pdf
    ├── Mitigation_Plans.pdf
    └── International_Expansion_Plan.pdf
```

### Data Room Access Protocol

**Phase 1: Initial Interest (Post First Meeting)**
- Share: Pitch deck, one-pager, demo video
- Folder: Public (no login)

**Phase 2: Partner Meeting (Post Second Meeting)**
- Share: Folders 01-05 (Company, Financials, Fundraising, Product, Research)
- Access: Request email, NDA signed

**Phase 3: Due Diligence (Post Term Sheet)**
- Share: All folders (01-11)
- Access: Secure login, expiring links
- Tracking: View logs, download logs

### Preparation Timeline

**2 Weeks Before First VC Meeting:**
```
□ Gather all company formation docs
□ Update cap table (current + pro forma)
□ Finalize 3-year financial model
□ Create folder structure (empty OK)
□ Upload pitch deck, one-pager, demo video
```

**1 Week Before Partner Meeting:**
```
□ Upload product docs (roadmap, architecture)
□ Upload research papers, citations
□ Anonymize customer list (if needed)
□ Upload sales/marketing materials
□ Test all links, access permissions
```

**Before Due Diligence Begins:**
```
□ Upload all legal docs (incorporation, IP, NDAs)
□ Upload all customer contracts (redact sensitive terms if needed)
□ Upload employee/advisor agreements
□ Upload competitive analysis
□ Full data room audit (no broken links, all files uploaded)
```

---

## 5. Email Templates

### 5.1 Warm Intro Request Email

**To**: [Mutual Contact]
**Subject**: Quick intro request - investor for my AI startup

```
Hi [Name],

Hope you're doing well! I wanted to reach out about a quick favor.

I'm raising a [$1-3M seed / $10-30M Series A] for Miyabi, my autonomous
AI development company. We've published two research papers (arXiv, AAAI
accepted) and have strong early traction [5 PoC customers / $XM ARR].

I noticed you're connected with [Investor Name] at [VC Firm] on LinkedIn,
and they're a perfect fit for our round—they invested in [relevant portfolio
company like Sakana AI, GitHub, etc.].

Would you be comfortable making a warm introduction? I'd just need a short
email intro, and I can take it from there. Happy to share our deck first if
you'd like to see what we're building.

Of course, no pressure at all—totally understand if now isn't the right time!

Either way, would love to catch up over coffee soon.

Best,
Shunsuke

--
Shunsuke Hayashi | Founder & CEO, Miyabi
shunsuke@miyabi.dev | @The_AGI_WAY
```

### 5.2 Cold Outreach Email (If No Warm Intro Available)

**To**: [Investor Email]
**Subject**: Mathematically proven autonomous development (2 arXiv papers, AAAI accepted)

```
Hi [Investor Name],

I'm Shunsuke, founder of Miyabi. I'm reaching out because [VC Firm]'s
investment in [relevant portfolio company] suggests you'd be interested
in what we're building.

The elevator pitch: We've built the world's first mathematically proven
autonomous development system. Think GitHub Copilot, but for completing
entire projects instead of autocompleting lines.

Why this matters:
• 1.2M unfilled developer jobs (US)
• 94.7% success rate (vs. 50% for competitors)
• 2 peer-reviewed papers (arXiv, AAAI accepted, 850+ citations)
• Early traction: [5 PoC customers / $XM ARR, 20+ customers]

We're raising a [$1-3M seed / $10-30M Series A] and would love 15 minutes
to share what we're building.

Would you have time for a quick call next week?

Best,
Shunsuke

Attached: One-pager

--
Shunsuke Hayashi | Founder & CEO, Miyabi
shunsuke@miyabi.dev | @The_AGI_WAY | miyabi.dev
```

### 5.3 Follow-Up Email (After Initial Meeting)

**To**: [Investor Email]
**Subject**: Re: Miyabi meeting follow-up

```
Hi [Investor Name],

Thanks again for taking the time to meet yesterday! Really enjoyed the
conversation about [specific topic you discussed].

As promised, here are the follow-up materials:
• Pitch deck (attached)
• One-pager (attached)
• Demo video: [link]
• arXiv papers: [link 1], [link 2]

You mentioned wanting to see [specific item they requested—e.g., customer
references, financial model deep dive, technical architecture]. I've attached
that as well.

Next steps:
[If they suggested specific next steps, list them]
[If not:] I'd love to schedule a follow-up with your partners. Does
[specific date/time] work?

Looking forward to continuing the conversation!

Best,
Shunsuke

--
Shunsuke Hayashi | Founder & CEO, Miyabi
shunsuke@miyabi.dev | @The_AGI_WAY
```

### 5.4 Weekly Update Email (During Active Fundraise)

**To**: [All Active Investors]
**BCC**: [Entire list, or use Mailchimp]
**Subject**: Miyabi Weekly Update - [Date]

```
Hi everyone,

Quick update on Miyabi's progress this week:

📈 TRACTION:
• ARR: $XXX,XXX (up $XX,XXX this week, +X% MoM)
• New customer: [Company Name] signed ($XXK ACV)
• Pipeline: $X.XM (XX active opportunities)

🔬 PRODUCT:
• [Key feature launched or milestone achieved]
• [Customer success story or testimonial]

💰 FUNDRAISING UPDATE:
• [# of meetings this week]
• [Term sheet received / Due diligence in progress / etc.]
• Currently [X% / $XM of $XM round] committed

📅 NEXT WEEK:
• [2-3 key priorities]

We're on track to close the round by [Date]. If you're interested in
participating, please let me know by [Deadline] so we can reserve allocation.

Happy to schedule a follow-up call if you have questions!

Best,
Shunsuke

--
Shunsuke Hayashi | Founder & CEO, Miyabi
shunsuke@miyabi.dev
```

### 5.5 Term Sheet Negotiation Email

**To**: [Lead Investor]
**Subject**: Re: Term sheet - a few questions

```
Hi [Name],

Thank you so much for the term sheet! This is really exciting, and we're
thrilled at the prospect of partnering with [VC Firm].

I've reviewed the terms with our legal counsel and have a few questions:

1. **Valuation**: The term sheet proposes $XM post-money. Based on our
   traction and comps ([Company A at $XM, Company B at $XM]), we were
   expecting $XM. Can we discuss?

2. **Liquidation Preference**: The term sheet includes [1× / 1.5×]
   participating preferred. Standard for seed/Series A is 1× non-participating.
   Can we align with market standard?

3. **Board Composition**: Term sheet proposes [X investor seats]. We'd
   prefer [Y investor seats, Z founder seats] to maintain founder control
   through [milestone]. Can we discuss?

4. **Pro Rata Rights**: We're fine with [full / super] pro rata for this
   round. Can we clarify which investors get this right?

These are the main items. Everything else looks great.

Would you have time for a call [specific dates/times] to discuss?

Looking forward to getting this finalized!

Best,
Shunsuke
```

### 5.6 Closing Announcement Email

**To**: [All Investors, Advisors, Customers, Community]
**Subject**: 🎉 Miyabi raises [$XM seed / $XM Series A] to build the world's first mathematically proven autonomous development system

```
Hi everyone,

I'm excited to share that Miyabi has raised a [$XM seed / $XM Series A]
led by [Lead VC] with participation from [other VCs].

This funding will allow us to:
• Scale our engineering team (hiring [X] engineers)
• Expand to the US market (opening SF office)
• Accelerate product development (enterprise features, integrations)
• Grow our sales team ([X] account executives)

Since launching [X months ago], we've:
✅ Published 2 research papers (arXiv, AAAI accepted)
✅ Achieved 2,500+ GitHub stars
✅ Signed [X] enterprise customers including [Top Logo]
✅ Reached [$XXX,XXX ARR / $XM ARR]
✅ Built the world's first mathematically proven autonomous dev system

This is just the beginning. Our vision: Every developer deserves a
mathematically proven autonomous AI partner.

Thank you to everyone who believed in us early—our investors, advisors,
customers, and community. We're just getting started.

Read the full announcement: [TechCrunch link / blog post link]

Best,
Shunsuke

--
Shunsuke Hayashi | Founder & CEO, Miyabi
shunsuke@miyabi.dev | @The_AGI_WAY
```

---

## 6. Investor CRM Spreadsheet

**Format**: Google Sheets or Airtable
**File**: `Miyabi_Investor_CRM.xlsx`

### Column Structure

```
| VC Firm | Partner Name | Email | LinkedIn | Phone | Stage | Last Contact | Status | Warm Intro Path | Notes | Next Action | Priority | Amount | Follow-Up Date |
```

### Column Definitions

- **VC Firm**: Firm name (e.g., "Lux Capital")
- **Partner Name**: Individual partner (e.g., "Josh Wolfe")
- **Email**: Partner email
- **LinkedIn**: LinkedIn profile URL
- **Phone**: Phone number (if available)
- **Stage**: Seed / Series A / Both
- **Last Contact**: Date of last interaction
- **Status**: Not Contacted / Intro Requested / Meeting Scheduled / Partner Meeting / Due Diligence / Term Sheet / Passed / Closed
- **Warm Intro Path**: How to get intro (e.g., "Via John Smith at Company X")
- **Notes**: Key insights, preferences, concerns
- **Next Action**: What needs to be done next (e.g., "Send follow-up email with financial model")
- **Priority**: High / Medium / Low
- **Amount**: Expected check size (e.g., "$2M")
- **Follow-Up Date**: When to follow up next

### Status Workflow

```
Not Contacted
    ↓
Intro Requested (warm intro asked)
    ↓
Meeting Scheduled (initial 30-min call)
    ↓
Partner Meeting (45-min with 1-2 partners)
    ↓
Due Diligence (data room access, references)
    ↓
Term Sheet (term sheet received)
    ↓
Closed (deal signed!) ✅

    OR

Passed (declined) ❌
```

### Example Entries

```
| VC Firm         | Partner      | Email              | Status         | Warm Intro Path        | Priority | Amount |
|-----------------|--------------|-------------------|----------------|------------------------|----------|--------|
| Lux Capital     | Josh Wolfe   | josh@luxcap.com   | Intro Requested| Via Sakana AI (TBD)    | High     | $2M    |
| DEEPCORE        | Yuto T.      | yuto@deepcore.jp  | Meeting Sched  | Via U Tokyo (Prof. X)  | High     | $1.5M  |
| ANRI            | Naoki S.     | shibata@anri.vc   | Partner Meeting| Via Intro 2 weeks ago  | High     | $1M    |
| Coral Capital   | James Riney  | james@coralcap.co | Not Contacted  | Twitter DM             | Medium   | $1M    |
| Sequoia         | Pat Grady    | pat@sequoia.com   | Passed         | Too early stage        | Low      | N/A    |
```

### Weekly Review Process

**Every Friday 4pm:**
1. Update all "Last Contact" dates
2. Move deals forward in status (if applicable)
3. Identify stalled deals (no contact in 2+ weeks)
4. Set "Next Action" for top 10 priority VCs
5. Schedule follow-ups for upcoming week

### Metrics to Track

- **Total VCs Tracked**: 58 (target)
- **Intro Requests Sent**: X
- **Intro Success Rate**: X% (intros received / intros requested)
- **Meetings Scheduled**: X
- **Meeting → Partner Rate**: X% (partner meetings / initial meetings)
- **Partner → Term Sheet Rate**: X% (term sheets / partner meetings)
- **Term Sheet → Close Rate**: X% (closed / term sheets)
- **Average Time to Close**: X days (first contact → deal close)

---

**All supporting materials complete! You now have everything needed to execute a world-class fundraise.**

**Next Document**: 06_EMAIL_TEMPLATES.md (additional templates)
