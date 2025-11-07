# Customer Acquisition Strategy

**Version**: 1.0
**Last Updated**: 2025-11-07
**Owner**: VP of Marketing & Demand Generation

---

## Ideal Customer Profile (ICP)

### Primary ICP: Enterprise (Fortune 500 / Japanese IT Giants)

#### Firmographic Criteria
- **Company Size**: 1,000-50,000 employees
- **Engineering Team**: 100-5,000 developers
- **Industry**: Technology, Financial Services, Manufacturing, Telecom
- **Geography**: US (West Coast, NYC), Japan (Tokyo, Osaka), EU (London, Berlin)
- **Annual Revenue**: $500M - $50B
- **Tech Stack**: GitHub Enterprise, AWS/Azure/GCP, CI/CD automation

#### Technographic Signals
- ✅ Using GitHub Enterprise (required)
- ✅ Active GitHub Actions usage (100+ runs/day)
- ✅ Microservices architecture (10+ repos)
- ✅ Agile/Scrum methodology
- ✅ DevOps team (10+ people)
- ✅ Recent Copilot adoption (looking for more automation)

#### Psychographic Criteria
- **Pain Points**:
  - Developer bottlenecks (30-40% time on toil)
  - Slow code review cycles (3-5 days average)
  - Difficulty hiring senior developers
  - Manual PR creation and testing
  - Inconsistent code quality
- **Goals**:
  - 10x developer productivity
  - Reduce time-to-market by 50%
  - Standardize development workflows
  - Improve code quality and security
- **Buying Behavior**:
  - Requires PoC/pilot before purchase
  - Long sales cycles (90-180 days)
  - Multiple stakeholders (VP Eng, CTO, CISO, Procurement)
  - Budget: $500K-$5M/year for dev tools

#### Key Decision Makers & Buying Committee

**Primary Champion**: **VP of Engineering / Engineering Director**
- **Pain**: Team productivity, developer velocity
- **Metrics**: Story points/sprint, deployment frequency
- **Objections**: "Will it replace my developers?", "How secure is AI-generated code?"
- **Win Strategy**: Show 3x productivity gains, emphasize augmentation not replacement

**Technical Evaluator**: **Principal/Staff Engineer**
- **Pain**: Code quality, technical debt
- **Metrics**: Code coverage, bug rate, security vulnerabilities
- **Objections**: "AI code is buggy", "Hard to review AI-generated code"
- **Win Strategy**: Demo ReviewAgent, show 80%+ test coverage, security scanning

**Economic Buyer**: **CTO / VP of Technology**
- **Pain**: Budget constraints, ROI pressure
- **Metrics**: Cost per developer, development cost as % of revenue
- **Objections**: "Too expensive", "Unproven ROI"
- **Win Strategy**: ROI calculator showing $500K savings, 6-month payback

**Security Gatekeeper**: **CISO / Security Architect**
- **Pain**: AI security risks, compliance
- **Metrics**: Vulnerability count, audit compliance
- **Objections**: "AI introduces security risks", "Not SOC 2 compliant"
- **Win Strategy**: SOC 2 Type II cert, security whitepaper, penetration test results

**Procurement/Legal**: **Procurement Manager / General Counsel**
- **Pain**: Contract terms, vendor risk
- **Metrics**: Contract value, vendor diversity
- **Objections**: "Unfavorable terms", "Unclear liability"
- **Win Strategy**: Standard MSA, clear IP assignment, Apache 2.0 license advantages

#### Target Accounts (Top 50 Enterprise)

**United States (20 accounts)**:
- **Tech Giants**: Google, Microsoft, Meta, Amazon, Apple
- **Financial Services**: JPMorgan Chase, Goldman Sachs, Visa, Mastercard
- **Enterprise Software**: Salesforce, Oracle, Adobe, Intuit, Workday
- **Infrastructure**: Cloudflare, Datadog, HashiCorp, MongoDB
- **Emerging**: Snowflake, Databricks, Stripe, Figma

**Japan (20 accounts)**:
- **Telecom**: NTT Data, KDDI, SoftBank, Rakuten Mobile
- **IT Services**: Hitachi, Fujitsu, NEC, Nomura Research Institute
- **Financial**: Mitsubishi UFJ, Mizuho, Nomura Securities
- **Manufacturing**: Toyota Connected, Sony, Panasonic, Ricoh
- **E-commerce**: Rakuten, LINE, Mercari, Yahoo Japan

**Europe (10 accounts)**:
- **UK**: HSBC, Barclays, BT Group, Sky
- **Germany**: SAP, Siemens, Deutsche Bank
- **France**: BNP Paribas, Société Générale
- **Nordics**: Spotify, Klarna

---

### Secondary ICP: SMB Tech Companies

#### Firmographic Criteria
- **Company Size**: 50-500 employees
- **Engineering Team**: 10-100 developers
- **Industry**: SaaS, Fintech, E-commerce, Dev Tools
- **Geography**: Global (remote-first companies)
- **Annual Revenue**: $10M - $100M
- **Stage**: Series A - Series C startups, bootstrapped companies

#### Technographic Signals
- ✅ GitHub Teams/Business
- ✅ CI/CD automation (GitHub Actions, CircleCI)
- ✅ AWS/GCP/Azure
- ✅ Modern stack (React, Node.js, Python, Go)
- ✅ Product-led growth mindset

#### Key Decision Makers

**Primary Buyer**: **VP Engineering / Head of Engineering**
- **Pain**: Scaling engineering without over-hiring
- **Metrics**: Velocity, sprint completion rate
- **Budget**: $50K-$200K/year for dev tools
- **Decision Speed**: Fast (7-30 days)

**Technical Evaluator**: **Senior/Lead Engineer**
- **Pain**: Code review bottlenecks
- **Metrics**: PR merge time, bug rate
- **Influence**: High (hands-on evaluation)

#### Target Accounts (500 SMB prospects)

**Segments**:
- **SaaS**: 200 companies (e.g., Airtable, Notion, Linear clones)
- **Fintech**: 100 companies (e.g., Plaid, Stripe competitors)
- **Dev Tools**: 100 companies (e.g., Vercel, Supabase users)
- **E-commerce**: 50 companies (Shopify app developers)
- **AI/ML**: 50 companies (OpenAI API consumers)

**Lead Sources**:
- Y Combinator portfolio (current batch + last 3 years)
- TechCrunch funding announcements (Series A-C)
- GitHub trending repositories (10K+ stars)
- BuiltWith scraping (GitHub + modern stack)

---

### Tertiary ICP: Individual Developers (Freemium)

#### Profile
- **Role**: Full-stack developers, indie hackers, OSS maintainers
- **Experience**: 2-10 years
- **Pain**: Repetitive tasks, manual PR creation, code review overhead
- **Motivation**: Personal productivity, learning, side projects
- **Budget**: $0-$49/month

#### Acquisition Strategy
- **Product-Led Growth**: Free tier with 50 issues/month
- **Viral Loop**: "Powered by Miyabi" badge on PRs
- **Community**: Discord, Twitter, Reddit (r/programming)
- **Content**: YouTube tutorials, blog posts (dev.to, Hashnode)

#### Conversion Funnel
1. **Free User** (50 issues/month)
2. **Power User** (hits limit, needs more)
3. **Team Tier** ($99/seat/month) - when collaborating with others
4. **Enterprise Referral** - recommends to employer

---

## Customer Journey Mapping

### Enterprise Customer Journey (90-180 Days)

#### Stage 1: Awareness (Days 0-14)

**Trigger Events**:
- Hired VP of Engineering (new priorities)
- Developer productivity crisis (missed deadlines)
- Copilot adoption (looking for more AI tools)
- Conference talk (NeurIPS, ICSE)
- Research paper citation

**Touchpoints**:
- LinkedIn post from peer VP Eng: "Just tested Miyabi - mind blown"
- TechCrunch article: "Miyabi raises $20M for autonomous development"
- YouTube video: "I replaced my junior devs with AI agents"
- Cold email from SDR: "How NTT Data reduced code review time by 70%"
- Google search: "autonomous code generation enterprise"

**Content**:
- Thought leadership: "The End of Code Review Bottlenecks" (whitepaper)
- Case study: "How [Fortune 500] deployed Miyabi in 90 days"
- Research paper: "Multi-Agent Orchestration for Software Engineering"
- ROI Calculator: "Calculate your savings with Miyabi"

**Goal**: Generate inbound lead or qualify outbound prospect

---

#### Stage 2: Consideration (Days 15-45)

**Touchpoints**:
- **Discovery Call** (45 min) with AE
  - Pain discovery: Current workflow, bottlenecks, costs
  - Demo: Live Issue → PR → Deploy workflow
  - Social proof: Name-drop 3 similar customers
  - Next steps: Schedule technical deep-dive

- **Technical Deep-Dive** (60 min) with AE + SE
  - Architecture walkthrough: 7 agents, security, scalability
  - Q&A: Security, compliance, integration
  - Hands-on: Connect to test GitHub repo, run 5 issues
  - Next steps: Propose PoC scope

- **PoC Scoping Call** (30 min) with SE + customer engineers
  - Define success metrics: 50% code review time reduction
  - Select pilot team: 10 developers, 1 repo
  - Timeline: 60 days (30 days setup, 30 days evaluation)
  - Next steps: Legal review, MSA negotiation

**Content**:
- **Sales Deck**: "Miyabi Enterprise Platform Overview" (30 slides)
- **Technical Whitepaper**: "Architecture & Security Deep-Dive" (40 pages)
- **ROI Analysis**: Custom spreadsheet with customer data
- **Reference Calls**: Connect with 2 existing customers

**Goal**: Secure commitment for PoC

---

#### Stage 3: Evaluation (Days 46-120) - PoC Phase

**PoC Setup (Week 1-2)**:
- Kickoff call: Align on goals, timeline, communication
- GitHub integration: Install Miyabi app, configure repos
- Agent configuration: Customize labels, workflows, approval gates
- Training: 2-hour workshop for 10 pilot developers

**Active PoC (Week 3-6)**:
- **Week 3**: Run 50 issues, measure baseline metrics
- **Week 4**: Optimize agent settings, address feedback
- **Week 5**: Run 100 issues, compare to pre-Miyabi baseline
- **Week 6**: Executive readout, present results

**Success Metrics (Measured Weekly)**:
- **Primary**: Code review time (baseline vs. Miyabi)
- **Secondary**: PR merge time, bug rate, developer satisfaction (NPS)
- **Tertiary**: Lines of code generated, test coverage

**Weekly Touchpoints**:
- **Monday**: Check-in call (15 min) with customer success manager
- **Wednesday**: Office hours (optional, 30 min) for Q&A
- **Friday**: Weekly report (automated email) with metrics

**Goal**: Prove ROI, secure purchase order

---

#### Stage 4: Purchase (Days 121-150)

**Stakeholder Alignment**:
- **Executive Sponsor** (VP Eng): Internal champion, secure budget
- **Procurement**: Negotiate contract terms, MSA, DPA
- **Legal**: IP assignment, liability, SLA terms
- **Finance**: Payment terms (annual upfront vs. quarterly)
- **CISO**: Security attestation, SOC 2 review

**Contract Negotiation**:
- **Standard Terms**: 1-year contract, quarterly payments
- **Enterprise Discounts**: 10% for annual prepay, 20% for 3-year commit
- **Pilot Pricing**: First 50 seats at 50% off (land-and-expand)
- **Expansion Rights**: Pre-negotiated pricing for seats 51-500

**Approval Process**:
1. VP Eng approval: Technical fit, ROI validation
2. Procurement review: Vendor risk, pricing benchmarking
3. Legal review: Contract terms, liability caps
4. CISO sign-off: Security attestation
5. CFO approval: Budget allocation (>$500K deals)
6. CEO/Board approval: Strategic vendor (>$1M deals)

**Goal**: Signed contract, purchase order

---

#### Stage 5: Onboarding (Days 151-180)

**Week 1: Kickoff & Setup**
- **Kickoff Call** (60 min): Introduce CSM, review timeline, set expectations
- **Technical Setup** (AE + SE): Production GitHub org integration
- **Admin Training** (CSM): Configure labels, workflows, approval policies
- **SSO Setup** (SE): SAML integration with Okta/Azure AD

**Week 2-3: Pilot Rollout**
- **Pilot Team** (50 developers): First production team onboarding
- **Training Workshop** (CSM): 2-hour session, best practices
- **Shadow Period** (Week 2): Miyabi runs alongside manual process
- **Full Adoption** (Week 3): Miyabi becomes primary workflow

**Week 4: Expansion Planning**
- **Success Review** (CSM): Pilot metrics, lessons learned
- **Expansion Roadmap** (AE + CSM): Rollout to 200+ developers
- **Upsell Discussion** (AE): Enterprise+ tier, custom agents
- **QBR Planning** (CSM): Schedule first quarterly business review

**Success Metrics**:
- 90% developer adoption (active users / pilot team size)
- 50% reduction in code review time (vs. pre-Miyabi)
- 80+ NPS from pilot team

**Goal**: Happy customer, ready for expansion

---

### SMB Customer Journey (7-30 Days)

#### Fast-Track Journey

**Day 1: Discovery**
- Inbound lead (website signup, free trial)
- Automated email: "Welcome to Miyabi - Get started in 5 minutes"
- Connect GitHub repo, run first issue

**Day 3-7: Activation**
- Email: "You've processed 5 issues - here's what's next"
- In-app prompt: "Upgrade to Team tier for unlimited issues"
- Live chat: "Need help? Our team is here"

**Day 8-14: Conversion**
- Hits free tier limit (50 issues/month)
- Email: "You're out of issues - upgrade to continue"
- Self-serve checkout: Credit card, instant activation

**Day 15-30: Onboarding**
- Automated onboarding emails (best practices, tips)
- Success milestone: "You've saved 40 hours this month!"
- NPS survey: "How likely are you to recommend Miyabi?"

---

### Individual Developer Journey (Self-Serve)

**Hour 1: Discovery**
- Google search: "autonomous code generation"
- YouTube video: "Miyabi demo - Issue to PR in 10 minutes"
- Sign up (OAuth with GitHub)

**Hour 2: Aha Moment**
- First issue processed: "This is magic!"
- Share on Twitter: "Just tried @MiyabiDev - game changer for solo devs"
- Join Discord community

**Week 1: Engagement**
- Process 10-20 issues
- Viral loop: "Powered by Miyabi" badge on PRs
- Referral: Share invite link with 3 friends

**Month 1: Conversion (or Advocacy)**
- **Path A**: Upgrade to Team tier (if working with team)
- **Path B**: Recommend to employer (enterprise referral bonus: $500)
- **Path C**: Stay on free tier, become community advocate

---

## Lead Generation Channels

### Inbound Channels (50% of pipeline)

#### 1. Content Marketing (SEO + Thought Leadership)

**Pillar Content**:
- **Ultimate Guide**: "Autonomous Development: Complete Guide for Engineering Leaders" (10K words, 100+ backlinks target)
- **Research Papers**: Publish on arXiv, submit to ICSE/FSE/NeurIPS
- **Whitepaper**: "The Economics of AI-Powered Development" (gated, lead capture)

**SEO Strategy**:
- **Primary Keywords**: "autonomous code generation", "AI development platform", "GitHub automation"
- **Secondary Keywords**: "code review automation", "AI pair programming", "developer productivity tools"
- **Long-Tail**: "how to automate pull request creation", "best AI coding assistant for enterprises"

**Content Calendar (Weekly)**:
- **Monday**: Blog post (1,500 words, technical deep-dive)
- **Wednesday**: Case study or customer story
- **Friday**: Weekly roundup (industry news, Miyabi updates)

**Goal**: 100K monthly organic visitors by Q4 2026

---

#### 2. Product-Led Growth (Free Tier)

**Freemium Model**:
- **Free Tier**: 50 issues/month, 1 concurrent agent
- **Conversion Funnel**:
  - Sign up → First issue → 5 issues (activation)
  - 20 issues (power user) → Hit limit → Upgrade
- **Viral Loop**:
  - "Powered by Miyabi" badge on AI-generated PRs
  - Referral program: Refer 5 friends → 100 bonus issues

**Conversion Metrics**:
- **Activation Rate**: 40% (sign up → 5 issues)
- **Free→Paid Conversion**: 2% (200 paid / 10K free)
- **Virality Coefficient**: 1.3 (each user refers 1.3 new users)

**Goal**: 10K free users by Q2 2026 → 200 Team tier customers

---

#### 3. Community & Events

**Discord Community**:
- Launch Q1 2026: Target 5K members by Q4 2026
- Weekly "Miyabi Office Hours" (live Q&A with founders)
- Community showcase: Share success stories, cool automations
- Bug bounty program: $500-$5K for security vulnerabilities

**Conferences & Events**:
- **Tier 1**: NeurIPS, ICSE, FSE (research credibility)
- **Tier 2**: GitHub Universe, AWS re:Invent, Google Cloud Next (buyer audience)
- **Tier 3**: Local meetups (SF, NYC, Tokyo) - sponsor, speak

**Webinars (Monthly)**:
- "Autonomous Development 101: Getting Started with Miyabi"
- "Case Study: How [Customer] Achieved 3x Developer Productivity"
- "Advanced Miyabi: Custom Agents & Workflow Automation"

**Goal**: 500 inbound leads/month from community

---

#### 4. Research & Credibility

**Academic Partnerships**:
- **MIT CSAIL**: Joint research on multi-agent systems
- **Stanford HAI**: AI safety and reliability research
- **University of Tokyo**: Japan market research, cultural fit

**Publications**:
- Target: 2 papers/year at ICSE, FSE, or NeurIPS
- Co-author with academics (credibility boost)
- Open-source benchmarks: "Miyabi Benchmark Suite" (like SWE-bench)

**Media Coverage**:
- TechCrunch: "Miyabi raises $20M for autonomous development"
- Wired: "The future of programming: AI agents that code themselves"
- Forbes: "How Miyabi is disrupting the $28B DevOps market"

**Goal**: 50K paper views, 500+ citations by Q4 2027

---

### Outbound Channels (50% of pipeline)

#### 1. SDR-Led Outreach (Enterprise)

**Target List**:
- 500 named accounts (top 50 enterprise + 450 SMB)
- Refreshed monthly (firmographic, technographic, intent data)

**Sequences (Automated + Personalized)**:

**Sequence A: VP Engineering (Enterprise)**
- **Day 1**: LinkedIn connection request (personalized note)
- **Day 3**: Email #1 - "How [Similar Company] reduced code review time by 70%"
- **Day 7**: Email #2 - "Quick question about [Company]'s GitHub automation"
- **Day 10**: LinkedIn message - Share case study
- **Day 14**: Email #3 - "Last attempt - worth 15 minutes?"
- **Day 21**: Phone call (if no response, mark as unresponsive)

**Email Template Example**:
```
Subject: How NTT Data reduced code review time by 70%

Hi [First Name],

I noticed [Company] recently [Trigger Event - e.g., "expanded your engineering team by 30%"].

We work with similar companies like [Customer 1] and [Customer 2] to automate their development workflows - specifically:

• Issue → PR in 15 minutes (vs. 2-3 days)
• 70% reduction in code review time
• 3x increase in developer throughput

Worth a 15-minute call to see if this applies to [Company]?

[CTA Button: Book a demo]

Best,
[SDR Name]
Miyabi
```

**Metrics**:
- **Cold Call**: 50 calls/day/SDR
- **Email**: 100 emails/day/SDR
- **LinkedIn**: 20 connections/day/SDR
- **Conversion**: 2% (cold → meeting booked)

**Goal**: 100 qualified meetings/month (10 SDRs × 10 meetings)

---

#### 2. Account-Based Marketing (ABM)

**Target Accounts**: Top 50 enterprise accounts

**Multi-Channel Approach**:
- **LinkedIn**: Personalized InMail from VP Sales + CEO
- **Direct Mail**: Send research paper + handwritten note to VP Eng
- **Advertising**: LinkedIn ads targeting specific companies
- **Events**: Invite to exclusive roundtable dinner (10 VP Engs)

**Example Campaign: "NTT Data ABM"**
- **Week 1**: CEO posts on LinkedIn: "Excited to partner with Japanese IT leaders"
- **Week 2**: VP Sales sends InMail to NTT Data VP Eng
- **Week 3**: Direct mail: Research paper + case study (similar telco)
- **Week 4**: Invite to Tokyo roundtable: "Future of AI in Enterprise Development"
- **Week 5**: Follow-up call from SDR: "Did you receive our package?"

**Budget**: $10K/account/year (top 50 = $500K)

**Goal**: 50% of top 50 accounts in active pipeline by Q4 2026

---

#### 3. Partner-Led (Channel Partners)

**Strategic Partnerships**:

**AWS Partnership**:
- AWS Marketplace listing (co-selling)
- Joint webinars (AWS + Miyabi)
- Co-marketing: AWS blog post, case study
- Revenue share: 20% to AWS for marketplace deals

**GitHub Partnership**:
- GitHub Enterprise integration (featured app)
- Co-marketing: GitHub Universe booth, sponsored talk
- Joint customers: Offer Miyabi to GitHub Enterprise customers
- Referral fee: $5K per enterprise deal

**KDDI/NTT Partnership (Japan)**:
- Reseller agreement: KDDI sells Miyabi to their enterprise customers
- Revenue share: 30% to KDDI
- Co-marketing: Joint press release, case studies
- Localization: Japanese UI, customer support

**Goal**: 30% of revenue from partnerships by Q4 2027

---

## Conversion Funnels

### Enterprise Funnel (90-Day Sales Cycle)

```
1,000 Target Accounts (Top 50 Enterprise + 950 SMB)
    ↓ (10% reach, via outbound + inbound)
100 Qualified Leads (discovery call booked)
    ↓ (50% qualify as good fit)
50 Opportunities (technical deep-dive scheduled)
    ↓ (60% agree to PoC)
30 PoCs Started (60-day evaluation)
    ↓ (50% convert to paid)
15 Closed-Won Deals (average $50K ACV)
    ↓
$750K in new ARR (per quarter)
```

**Metrics**:
- **Lead → Opportunity**: 50%
- **Opportunity → PoC**: 60%
- **PoC → Closed-Won**: 50%
- **Overall Win Rate**: 15% (15 wins / 100 leads)

---

### SMB Funnel (Self-Serve, 7-Day Cycle)

```
10,000 Free Tier Signups (per month)
    ↓ (40% activate: complete onboarding, run 5+ issues)
4,000 Activated Users
    ↓ (50% become power users: 20+ issues/month)
2,000 Power Users
    ↓ (10% hit free tier limit, see upgrade prompt)
200 Upgrade Prompts
    ↓ (20% convert to Team tier)
40 Paid Customers ($99/seat/month = $3,960 MRR)
```

**Metrics**:
- **Signup → Activation**: 40%
- **Activation → Power User**: 50%
- **Power User → Upgrade Prompt**: 10%
- **Upgrade Prompt → Paid**: 20%
- **Overall Conversion**: 0.4% (40 paid / 10K signups)

---

## Sales Process (Enterprise)

### Stage 0: Prospecting

**Goal**: Identify and qualify target accounts

**Activities**:
- Build target account list (firmographic, technographic filters)
- Enrich with intent data (website visits, content downloads)
- Assign to SDRs (50 accounts per SDR)

**Qualification Criteria (BANT)**:
- **Budget**: $100K+ annual dev tools budget
- **Authority**: VP Eng or higher involved
- **Need**: Developer productivity pain (measured: >30% time on toil)
- **Timeline**: Buying within 6 months

---

### Stage 1: Discovery (45-Min Call)

**Goal**: Understand pain, qualify fit, earn technical deep-dive

**Pre-Call Research** (15 min):
- Review LinkedIn: Recent hires, org structure
- Check GitHub: Public repos, activity level
- Google News: Recent announcements, funding
- Prepare 3 personalized insights: "I saw you recently [X]"

**Call Structure** (45 min):

**1. Rapport Building (5 min)**
- "How's your week going?"
- "I saw you [personalized insight] - congrats!"
- "Quick agenda: Learn about your workflow, show quick demo, see if we can help"

**2. Discovery Questions (20 min)**

**Current State**:
- "Walk me through your current development workflow: Issue → PR → Deploy"
- "How long does it typically take to go from Issue to merged PR?"
- "What percentage of developer time is spent on toil (PRs, reviews, testing)?"

**Pain Points**:
- "What's the biggest bottleneck in your workflow?"
- "If you could wave a magic wand and fix one thing, what would it be?"
- "How much is this costing you? (developer hours, missed deadlines)"

**Goals**:
- "If we could reduce code review time by 70%, what would that unlock for your team?"
- "What metrics would you use to measure success?"

**Budget & Timeline**:
- "What's your annual budget for dev tools?"
- "When are you looking to make a decision?"
- "Who else needs to be involved in this decision?"

**3. Demo (15 min)**
- **Setup** (2 min): "Let me show you how Miyabi works - this is a live demo with a real GitHub repo"
- **Walkthrough** (10 min):
  1. Create GitHub issue: "Add user authentication"
  2. Miyabi analyzes (CoordinatorAgent) → Decomposes into tasks
  3. CodeGenAgent generates code (live!)
  4. ReviewAgent performs security scan, quality check
  5. PR created with 80%+ test coverage
  6. Result: "15 minutes, production-ready code"
- **Objection Handling** (3 min): "I know what you're thinking - 'Is the code quality good enough?'"

**4. Next Steps (5 min)**
- "Does this look like it could solve [their pain]?"
- "Next step: Let's do a technical deep-dive with your team - 60 minutes"
- "I'll send calendar invite + agenda - when works for you?"

**Post-Call Actions**:
- Send meeting recap email (same day)
- Send calendar invite for technical deep-dive (within 24 hours)
- Update CRM: MEDDPICC notes (Metrics, Economic Buyer, Decision Criteria, Decision Process, Pain, Champion, Competition)

---

### Stage 2: Technical Deep-Dive (60-Min Call)

**Goal**: Prove technical fit, address objections, propose PoC

**Attendees**:
- **Miyabi**: AE + SE (Solutions Engineer)
- **Customer**: VP Eng + 2-3 engineers + CISO (if security-conscious)

**Pre-Call Prep** (SE):
- Review customer tech stack (GitHub, CI/CD, languages)
- Prepare custom demo (use their repo, language, framework)
- Pre-load security docs (SOC 2, penetration test results)

**Call Structure** (60 min):

**1. Recap & Agenda (5 min)**
- AE: "Quick recap of discovery call: [pain points]"
- AE: "Today's goal: Deep-dive into architecture, security, integration"

**2. Architecture Walkthrough (20 min)**
- SE: "Let me show you how Miyabi works under the hood"
- **7 Agents**: Coordinator → Issue → CodeGen → Review → PR → Deploy → Test
- **Git Worktree**: Parallel execution (72% faster)
- **LLM Stack**: Claude Sonnet 4, GPT-4o (fallback), Gemini (optional)
- **Security**: CodeQL, SBOM, SLSA, secret scanning

**3. Live Hands-On Demo (20 min)**
- SE: "Let's connect your GitHub repo and run 5 real issues"
- Customer: "Can we test with our codebase?"
- SE: "Absolutely - I'll share my screen, you drive"
- Customer creates issue → Miyabi processes → PR review
- SE: "As you can see, [outcome]"

**4. Q&A (10 min)**

**Common Questions**:
- "How do you handle security vulnerabilities in AI-generated code?"
  - Answer: ReviewAgent runs CodeQL + Gitleaks, 80%+ test coverage requirement
- "Can we customize the agents for our workflow?"
  - Answer: Yes - custom labels, approval gates, agent personalities
- "What's the ROI for a team of 100 developers?"
  - Answer: [Open ROI calculator] $500K savings, 6-month payback

**5. PoC Proposal (5 min)**
- AE: "Based on what we've discussed, I propose a 60-day PoC"
- **Scope**: 10 developers, 1 repo, 50 issues
- **Success Metrics**: 50% code review time reduction, 80+ NPS
- **Timeline**: 30 days setup + 30 days evaluation
- **Next Steps**: PoC scoping call (30 min) with your engineering team

**Post-Call Actions**:
- Send PoC proposal document (same day)
- Schedule PoC scoping call (within 48 hours)
- Send security docs (SOC 2, penetration test, whitepaper)

---

### Stage 3: PoC Scoping (30-Min Call)

**Goal**: Define PoC scope, success metrics, timeline

**Attendees**:
- **Miyabi**: SE + CSM (Customer Success Manager)
- **Customer**: 2-3 engineers who will use Miyabi

**Call Structure** (30 min):

**1. PoC Goals (10 min)**
- CSM: "What does success look like for you?"
- Customer: "Reduce code review time by 50%"
- CSM: "Great - how will we measure that?"
- Customer: "Average PR review time: 3 days → 1.5 days"

**2. PoC Logistics (10 min)**
- **Pilot Team**: 10 developers (which team?)
- **Pilot Repo**: 1 repo (which one?)
- **Timeline**: 60 days (start date?)
- **Communication**: Weekly check-ins (Monday 10am)
- **Training**: 2-hour workshop (schedule?)

**3. Next Steps (10 min)**
- SE: "I'll send PoC agreement for signature"
- SE: "Legal review: Should take 1-2 weeks"
- CSM: "Once signed, we'll schedule kickoff call"

**Post-Call Actions**:
- Send PoC agreement (same day)
- CC: Legal, Procurement for review
- Update CRM: PoC start date, success criteria

---

### Stage 4: PoC Execution (60 Days)

See [Enterprise Customer Journey > Stage 3: Evaluation](#stage-3-evaluation-days-46-120---poc-phase) for detailed PoC execution plan.

---

### Stage 5: Contract Negotiation (30 Days)

**Goal**: Close deal, sign contract, issue PO

**Key Activities**:
- Week 1: Executive readout (PoC results)
- Week 2: Pricing proposal (custom quote)
- Week 3: Contract negotiation (terms, MSA, DPA)
- Week 4: Legal approval, CFO sign-off, PO issued

**Pricing Negotiation**:
- **List Price**: $299/seat/month (Enterprise tier)
- **Volume Discount**: 10% for 100+ seats, 20% for 500+ seats
- **Prepay Discount**: 10% for annual prepay
- **Pilot Pricing**: First 50 seats at 50% off (Year 1 only)

**Contract Terms**:
- **Initial Term**: 1 year (auto-renews)
- **Payment Terms**: Quarterly (annual prepay optional)
- **SLA**: 99.9% uptime
- **Support**: Premium support (4-hour SLA)
- **Termination**: 90-day notice

**Post-Close Actions**:
- Celebrate! (ring the gong, announce to team)
- Handoff to CSM: Kickoff call within 1 week
- Update CRM: Closed-Won, ARR, contract terms
- Forecast: Add to quarterly revenue forecast

---

## Objection Handling

### Common Objections & Responses

#### "AI-generated code is buggy"

**Response**:
"I hear this concern often. Here's how we address it:
1. **ReviewAgent** runs CodeQL + Gitleaks on every PR (same tools you use manually)
2. **80%+ test coverage** requirement (enforced by CI)
3. **Human review** still required (Miyabi creates PR, you approve)
4. **Track record**: 95% PR acceptance rate at [Customer], 0 production incidents in 6 months"

**Demo**: Show ReviewAgent scanning a PR, catching security vulnerability.

---

#### "This will replace my developers"

**Response**:
"Miyabi doesn't replace developers - it eliminates toil. Think of it like this:
- **Before Miyabi**: Developers spend 40% time on toil (PRs, reviews, testing)
- **After Miyabi**: Developers spend 10% time on toil, 90% on creative work
- **Result**: Your team ships 3x more features, no layoffs needed

[Customer]: 'Miyabi gave me back my weekends - I finally have time to work on the hard problems'"

**Social Proof**: Share testimonial from VP Eng at similar company.

---

#### "Too expensive"

**Response**:
"Let's look at the ROI:
- **Your cost**: $299/seat/month × 100 devs = $29,900/month
- **Your savings**: 15 hours/week/dev × 100 devs = 1,500 hours/week
- **At $100/hour**: $150,000/week = $600,000/month savings
- **Payback period**: Less than 1 month

[Open ROI calculator] Let's plug in your numbers: What's your average developer hourly cost?"

**Upsell**: "We also offer pilot pricing: 50% off first 50 seats for Year 1"

---

#### "Security concerns" (CISO objection)

**Response**:
"Security is our #1 priority. Here's our security posture:
1. **SOC 2 Type II** certified (audit report attached)
2. **Penetration testing**: Annual by [Security Firm], report attached
3. **AI Code Security**:
   - CodeQL (GitHub Advanced Security) on every PR
   - Gitleaks secret scanning
   - SBOM generation (CycloneDX)
4. **Data Privacy**:
   - Your code never leaves your VPC (on-premise option)
   - Zero-retention: No code stored after PR creation
   - GDPR/CCPA compliant

Would you like to schedule a security deep-dive with our CISO?"

**Collateral**: Send security whitepaper, SOC 2 report, penetration test summary.

---

#### "We already use GitHub Copilot"

**Response**:
"Copilot is great for line-by-line suggestions, but Miyabi handles the entire workflow:

| Capability | Copilot | Miyabi |
|------------|---------|--------|
| Code completion | ✅ | ✅ |
| Generate entire files | ❌ | ✅ |
| Code review automation | ❌ | ✅ |
| PR creation | ❌ | ✅ |
| Testing & deployment | ❌ | ✅ |
| Multi-agent orchestration | ❌ | ✅ |

Many customers use both: Copilot for coding, Miyabi for workflows. [Customer] uses both - 4x productivity gain"

**Position**: Miyabi is complementary, not competitive.

---

## Metrics & KPIs

### Sales Metrics (Tracked Weekly)

**Pipeline Health**:
- **Pipeline Coverage**: 3x quota (target: maintain at all times)
- **Pipeline Velocity**: 90 days (Enterprise), 30 days (SMB)
- **Win Rate**: 40% (Enterprise), 20% (SMB), 2% (Free→Paid)

**Activity Metrics (Per SDR)**:
- **Calls**: 50/day
- **Emails**: 100/day
- **LinkedIn**: 20 connections/day
- **Meetings Booked**: 10/month (2% conversion)

**Activity Metrics (Per AE)**:
- **Discovery Calls**: 20/month
- **Technical Deep-Dives**: 10/month
- **PoCs Started**: 3/month
- **Closed-Won**: 1.5/month (avg $50K ACV)

### Conversion Metrics (Tracked Monthly)

**Enterprise Funnel**:
- **MQL → SAL** (Sales Accepted Lead): 70%
- **SAL → Discovery**: 60%
- **Discovery → Technical Deep-Dive**: 50%
- **Technical Deep-Dive → PoC**: 60%
- **PoC → Closed-Won**: 50%

**SMB Funnel**:
- **Signup → Activated**: 40%
- **Activated → Power User**: 50%
- **Power User → Upgrade Prompt**: 10%
- **Upgrade Prompt → Paid**: 20%

### Revenue Metrics (Tracked Monthly)

- **New ARR**: $750K/quarter (Enterprise), $150K/quarter (SMB)
- **Expansion ARR**: 20% (seat growth, tier upgrades)
- **Churn**: <5% (logos), <3% (revenue)
- **Net Revenue Retention**: 120%

---

## Success Criteria (12-Month)

By Q4 2026, Customer Acquisition will be considered successful if:

1. **Pipeline**: $30M in qualified pipeline (3x quota of $10M ARR)
2. **Win Rate**: 40% (Enterprise), 2% (Free→Paid)
3. **Customer Count**: 200 Team tier, 10 Enterprise tier
4. **Lead Volume**: 1,000 MQLs/month (50% inbound, 50% outbound)
5. **Sales Cycle**: 90 days (Enterprise), 7 days (SMB)

---

**Next Documents**:
- [03_SALES_STRATEGY.md](./03_SALES_STRATEGY.md) - Sales team structure, playbook, compensation
- [04_PARTNERSHIP_STRATEGY.md](./04_PARTNERSHIP_STRATEGY.md) - AWS, GitHub, KDDI partnerships
- [05_ENTERPRISE_POC_PROGRAM.md](./05_ENTERPRISE_POC_PROGRAM.md) - PoC framework, success criteria
