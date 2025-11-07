# Miyabi - 3-Year Financial Model

**Version**: 1.0
**Scenario**: Base Case (Conservative)
**Currency**: USD
**Last Updated**: 2025-11-07

---

## Executive Summary

**Revenue Projection** (Years 1-3):
- Year 1: $500K (10 customers)
- Year 2: $5.0M (50 customers, 10× growth)
- Year 3: $20.0M (150 customers, 4× growth)

**Profitability Timeline**:
- Year 1: -$2.3M (EBITDA)
- Year 2: -$5.5M (EBITDA)
- Year 3: $1.5M (EBITDA, 7.5% margin)

**Capital Required**:
- Seed: $3.0M (18-month runway)
- Series A: $20.0M (24-month runway)
- Total: $23.0M to profitability

**Key Metrics** (Year 3):
- ARR: $20.0M
- Gross Margin: 85%
- CAC Payback: 3 months
- LTV:CAC: 33:1
- Net Dollar Retention: 120%

---

## 1. Revenue Model

### 1.1 Pricing Tiers

```
┌─────────────────────────────────────────────────────────┐
│ TEAM TIER                                               │
├─────────────────────────────────────────────────────────┤
│ Price:         $499/developer/month                     │
│ Annual:        $5,988/developer/year                    │
│ Min Seats:     2 developers                             │
│ Max Seats:     10 developers                            │
│ Avg Contract:  $30K/year (5 devs)                       │
│ Target:        SMBs, startups, small teams              │
│ % of Revenue:  10% (Year 1) → 20% (Year 3)              │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ ENTERPRISE TIER                                         │
├─────────────────────────────────────────────────────────┤
│ Price:         Custom ($500-2,000/dev/month)            │
│ Annual:        $50K-200K/year                           │
│ Avg Contract:  $100K/year (30 devs)                     │
│ Min Seats:     10 developers                            │
│ Max Seats:     100 developers                           │
│ Target:        Mid-market, Fortune 1000                 │
│ % of Revenue:  70% (Year 1) → 60% (Year 3)              │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│ ENTERPRISE PLUS TIER                                    │
├─────────────────────────────────────────────────────────┤
│ Price:         $200K-1M+/year                           │
│ Avg Contract:  $400K/year (150 devs)                    │
│ Min Seats:     100 developers                           │
│ Max Seats:     Unlimited                                │
│ Target:        Fortune 500, Global 2000                 │
│ % of Revenue:  20% (Year 1) → 20% (Year 3)              │
└─────────────────────────────────────────────────────────┘
```

### 1.2 Revenue Projections (Monthly)

**Year 1** (Months 1-12):
```
Month   New      Churn   Total    MRR        ARR       Notes
        Customers        Customers
────────────────────────────────────────────────────────────
1       0        0       0        $0         $0        Pre-launch
2       0        0       0        $0         $0        Product v1.0
3       1        0       1        $8.3K      $100K     First customer!
4       2        0       3        $25.0K     $300K     PoC conversions
5       1        0       4        $33.3K     $400K
6       1        0       5        $41.7K     $500K     Seed milestone
7       1        0       6        $50.0K     $600K
8       1        0       7        $58.3K     $700K
9       1        0       8        $66.7K     $800K
10      1        0       9        $75.0K     $900K
11      1        0       10       $83.3K     $1.0M
12      0        0       10       $83.3K     $1.0M

Total:  10 new, 0 churn → 10 customers, $1.0M ARR (exit)
Avg ACV: $100K
```

**Year 2** (Months 13-24):
```
Month   New      Churn   Total    MRR        ARR       Notes
        Customers        Customers
────────────────────────────────────────────────────────────
13      2        0       12       $100K      $1.2M
14      2        0       14       $117K      $1.4M
15      3        0       17       $142K      $1.7M     US expansion
16      3        0       20       $167K      $2.0M
17      3        1       22       $183K      $2.2M     First churn
18      4        0       26       $217K      $2.6M     Series A close
19      4        0       30       $250K      $3.0M
20      4        0       34       $283K      $3.4M
21      4        0       38       $317K      $3.8M
22      5        1       42       $350K      $4.2M
23      5        0       47       $392K      $4.7M
24      5        1       51       $425K      $5.1M

Total:  44 new, 3 churn → 51 customers, $5.1M ARR (exit)
Avg ACV: $100K
Net Churn: 6% annually
```

**Year 3** (Months 25-36):
```
Month   New      Churn   Total    MRR        ARR       Notes
        Customers        Customers
────────────────────────────────────────────────────────────
25      7        1       57       $475K      $5.7M
26      7        0       64       $533K      $6.4M
27      8        1       71       $592K      $7.1M
28      8        1       78       $650K      $7.8M
29      9        1       86       $717K      $8.6M     Global expansion
30      9        1       94       $783K      $9.4M
31      10       1       103      $858K      $10.3M
32      10       1       112      $933K      $11.2M
33      11       2       121      $1,008K    $12.1M
34      11       1       131      $1,092K    $13.1M
35      12       2       141      $1,175K    $14.1M
36      12       2       151      $1,258K    $15.1M    Exit ARR

Plus expansion revenue (upsells): +$4.9M
Total ARR Year 3 Exit: $20.0M

Total:  114 new, 14 churn → 151 customers (new), $20.0M ARR
Avg ACV: $132K (higher tier mix + expansions)
Net Churn: 8% annually, offset by 120% NDR
```

### 1.3 Customer Acquisition Assumptions

**Year 1**:
- **Sales Cycle**: 90-120 days (founder-led sales)
- **Win Rate**: 20% (of qualified opportunities)
- **Avg ACV**: $100K (mostly Enterprise tier)
- **New Logos**: 10
- **Churn**: 0% (first year, too early)

**Year 2**:
- **Sales Cycle**: 60-90 days (professional sales team)
- **Win Rate**: 25% (better product-market fit)
- **Avg ACV**: $100K (mixed tiers)
- **New Logos**: 44
- **Churn**: 6% annually (mostly Team tier)

**Year 3**:
- **Sales Cycle**: 45-60 days (repeatable sales motion)
- **Win Rate**: 30% (strong references)
- **Avg ACV**: $132K (more Enterprise Plus)
- **New Logos**: 114
- **Churn**: 8% annually (offset by expansions)

### 1.4 Revenue by Tier (Year 3)

```
Tier              Customers   Avg ACV    Revenue    % of Total
──────────────────────────────────────────────────────────────
Team              45          $30K       $1.4M      7%
Enterprise        85          $110K      $9.4M      47%
Enterprise Plus   21          $450K      $9.5M      47%
──────────────────────────────────────────────────────────────
Total (New)       151         $132K      $20.0M     100%

Expansion Revenue (upsells from Y1/Y2 customers): +$5M
Total ARR:                                         $25M
```

**Note**: Base model uses new customer ARR only ($20M). Expansion adds $5M.

---

## 2. Cost Structure

### 2.1 Cost of Goods Sold (COGS)

**Components**:
1. **Cloud Infrastructure** (AWS, GCP)
   - LLM API calls (OpenAI, Anthropic Claude)
   - Compute (EC2, Lambda)
   - Storage (S3, RDS)
   - Networking

2. **Support & Success**
   - Customer support engineers
   - Implementation/onboarding
   - Technical account managers (Enterprise Plus)

**COGS by Year**:
```
Year    Revenue     Cloud Infra   Support   Total COGS   Gross Margin
────────────────────────────────────────────────────────────────────
1       $1.0M       $100K (10%)   $50K (5%) $150K        85%
2       $5.1M       $510K (10%)   $255K (5%)$765K        85%
3       $20.0M      $2.0M (10%)   $1.0M (5%)$3.0M        85%
```

**Assumptions**:
- **Cloud cost per customer**: $10K/year (scales with usage)
- **Support cost**: 5% of revenue (1 support engineer per $1M ARR)
- **Gross margin**: 85% (target SaaS benchmark)

**Cost Optimization Paths**:
- Negotiate AWS/GCP credits ($100K in Year 1)
- Use reserved instances (30% savings)
- Model caching (reduce API calls by 40%)
- Self-host models (Year 3, reduce COGS to 7%)

### 2.2 Operating Expenses (OpEx)

#### 2.2.1 Research & Development

**Year 1** ($1.5M total):
```
Role                  Count   Salary    Total     Notes
────────────────────────────────────────────────────────
Founder/CEO           1       $150K     $150K
CTO                   1       $300K     $300K     Hired Month 3
Research Engineer     2       $200K     $400K     Hired Month 4-5
Product Manager       1       $150K     $150K     Hired Month 6
DevOps Engineer       1       $180K     $180K     Hired Month 8

Infrastructure        -       -         $100K     AWS, GitHub, tools
Contractors           -       -         $100K     Specialized work
Recruiting            -       -         $80K      Hires 1-5
────────────────────────────────────────────────────────
Total R&D:                              $1,460K
```

**Year 2** ($3.2M total):
```
Role                  Count   Salary    Total     Notes
────────────────────────────────────────────────────────
Executive Team        3       $220K     $660K     CEO, CTO, CRO
Engineering           8       $190K     $1,520K   4 engineers per half
Product/Design        2       $160K     $320K     PM + Designer
DevOps/Infra          2       $180K     $360K

Infrastructure        -       -         $200K     Scaled systems
Contractors           -       -         $150K
────────────────────────────────────────────────────────
Total R&D:                              $3,210K
```

**Year 3** ($6.5M total):
```
Role                  Count   Salary    Total     Notes
────────────────────────────────────────────────────────
Executive Team        4       $225K     $900K     +COO
Engineering           18      $195K     $3,510K   Scale team
Product/Design        4       $165K     $660K
DevOps/Infra          4       $185K     $740K
QA/Testing            2       $140K     $280K

Infrastructure        -       -         $400K     Global infra
Contractors           -       -         $200K
────────────────────────────────────────────────────────
Total R&D:                              $6,690K
```

#### 2.2.2 Sales & Marketing

**Year 1** ($800K total):
```
Role/Channel          Count   Cost      Total     Notes
────────────────────────────────────────────────────────
Head of Sales         1       $250K     $250K     Hired Month 6
Sales Development Rep 1       $80K      $80K      Hired Month 9

Marketing Manager     1       $120K     $120K     Hired Month 7
Content/Demand Gen    -       -         $100K     Contractors

Sales Tools           -       -         $50K      Salesforce, Outreach
Marketing Tools       -       -         $30K      HubSpot, ads
Events/Conferences    -       -         $100K     AAAI, trade shows
────────────────────────────────────────────────────────
Total S&M:                              $730K
```

**Year 2** ($2.8M total):
```
Role/Channel          Count   Cost      Total     Notes
────────────────────────────────────────────────────────
CRO                   1       $300K     $300K
Account Executives    3       $200K     $600K     $150K base + OTE
Sales Development     3       $90K      $270K
Sales Engineers       2       $180K     $360K

Marketing Team        3       $130K     $390K     Manager + 2
Demand Generation     -       -         $400K     Ads, ABM, content

Sales Tools           -       -         $120K
Marketing Tools       -       -         $100K
Events/Conferences    -       -         $200K
Channel Development   -       -         $150K     Partnerships
────────────────────────────────────────────────────────
Total S&M:                              $2,890K
```

**Year 3** ($6.0M total):
```
Role/Channel          Count   Cost      Total     Notes
────────────────────────────────────────────────────────
CRO + Sales Ops       2       $275K     $550K
Account Executives    10      $200K     $2,000K   Scale sales team
Sales Development     6       $95K      $570K     2:1 SDR:AE ratio
Sales Engineers       4       $185K     $740K

Marketing Team        6       $140K     $840K     Director + team
Demand Generation     -       -         $800K     Multi-channel

Sales Tools           -       -         $200K
Marketing Tools       -       -         $150K
Events/Conferences    -       -         $300K
Channel Development   -       -         $400K     Alliances, resellers
Brand/PR              -       -         $300K     Agency
────────────────────────────────────────────────────────
Total S&M:                              $6,850K
```

#### 2.2.3 General & Administrative

**Year 1** ($400K):
```
Category              Cost      Notes
──────────────────────────────────────────────
Finance/Accounting    $60K      Outsourced CFO, bookkeeper
Legal                 $80K      Corp structure, contracts
HR/Recruiting         $80K      Recruiters, benefits admin
Office/Facilities     $50K      Co-working space
Insurance             $40K      D&O, liability, cyber
Software/Tools        $30K      G suite, Slack, etc.
Travel                $40K      Founder/exec travel
Misc                  $20K      Buffer
──────────────────────────────────────────────
Total G&A:            $400K
```

**Year 2** ($900K):
```
Category              Cost      Notes
──────────────────────────────────────────────
Finance/Accounting    $180K     Fractional CFO, 1 FTE
Legal                 $150K     More contracts, IP
HR/Recruiting         $200K     HR Manager + recruiters
Office/Facilities     $120K     SF + Tokyo offices
Insurance             $80K      More coverage
Software/Tools        $60K      Scaled systems
Travel                $80K      Team travel
Misc                  $30K      Buffer
──────────────────────────────────────────────
Total G&A:            $900K
```

**Year 3** ($1.8M):
```
Category              Cost      Notes
──────────────────────────────────────────────
Finance/Accounting    $400K     CFO + Controller + AP/AR
Legal                 $250K     General Counsel + support
HR/Recruiting         $400K     CHRO + team
Office/Facilities     $300K     SF, Tokyo, London offices
Insurance             $150K     Full coverage
Software/Tools        $120K     Enterprise systems
Travel                $150K     Global team
Misc                  $50K      Buffer
──────────────────────────────────────────────
Total G&A:            $1,820K
```

### 2.3 Total Operating Expenses Summary

```
Year    R&D       S&M       G&A       Total OpEx
────────────────────────────────────────────────
1       $1.5M     $0.8M     $0.4M     $2.7M
2       $3.2M     $2.9M     $0.9M     $7.0M
3       $6.7M     $6.9M     $1.8M     $15.4M
```

---

## 3. P&L Statements

### 3.1 Year 1 (Seed Stage)

```
Revenue
  New Bookings (10 customers × $100K)           $1,000K
  Total Revenue                                 $1,000K

Cost of Goods Sold
  Cloud Infrastructure (10%)                      -$100K
  Support (5%)                                     -$50K
  Total COGS                                      -$150K
────────────────────────────────────────────────────────
Gross Profit                                      $850K
Gross Margin                                        85%

Operating Expenses
  Research & Development                        -$1,460K
  Sales & Marketing                               -$730K
  General & Administrative                        -$400K
  Total OpEx                                    -$2,590K
────────────────────────────────────────────────────────
EBITDA                                          -$1,740K
EBITDA Margin                                      -174%

Depreciation & Amortization                        -$20K
────────────────────────────────────────────────────────
Operating Income (EBIT)                         -$1,760K

Interest Income (cash on balance sheet)            $30K
────────────────────────────────────────────────────────
Net Income                                      -$1,730K
Net Margin                                         -173%

────────────────────────────────────────────────────────
Headcount (Year-End)                              7 FTEs
Cash Burn (Monthly, Average)                      -$190K
Runway (with $3M seed)                          15.8 months
```

### 3.2 Year 2 (Post-Seed, Pre-Series A)

```
Revenue
  Beginning ARR                                 $1,000K
  New Bookings (44 customers × $100K)           $4,400K
  Expansion Revenue (upsells)                     $300K
  Churn (3 customers × $100K)                    -$300K
  Total Revenue                                 $5,400K

Cost of Goods Sold
  Cloud Infrastructure (10%)                      -$540K
  Support (5%)                                    -$270K
  Total COGS                                      -$810K
────────────────────────────────────────────────────────
Gross Profit                                    $4,590K
Gross Margin                                        85%

Operating Expenses
  Research & Development                        -$3,210K
  Sales & Marketing                             -$2,890K
  General & Administrative                        -$900K
  Total OpEx                                    -$7,000K
────────────────────────────────────────────────────────
EBITDA                                          -$2,410K
EBITDA Margin                                       -45%

Depreciation & Amortization                        -$50K
────────────────────────────────────────────────────────
Operating Income (EBIT)                         -$2,460K

Interest Income                                     $80K
────────────────────────────────────────────────────────
Net Income                                      -$2,380K
Net Margin                                          -44%

────────────────────────────────────────────────────────
Headcount (Year-End)                             22 FTEs
Cash Burn (Monthly, Average)                      -$230K
Funds Raised (Series A, Month 18)              $20,000K
Runway (Post-Series A)                         72+ months
```

### 3.3 Year 3 (Post-Series A, Scale Mode)

```
Revenue
  Beginning ARR                                 $5,400K
  New Bookings (114 customers × $132K)         $15,048K
  Expansion Revenue (upsells from Y1/Y2)        $4,900K
  Churn (14 customers × $100K avg)             -$1,400K
  Total Revenue                                $23,948K
  (Conservative: $20,000K for model purposes)

Cost of Goods Sold
  Cloud Infrastructure (10%)                    -$2,000K
  Support (5%)                                  -$1,000K
  Total COGS                                    -$3,000K
────────────────────────────────────────────────────────
Gross Profit                                   $17,000K
Gross Margin                                        85%

Operating Expenses
  Research & Development                        -$6,690K
  Sales & Marketing                             -$6,850K
  General & Administrative                      -$1,820K
  Total OpEx                                   -$15,360K
────────────────────────────────────────────────────────
EBITDA                                          $1,640K
EBITDA Margin                                        8%

Depreciation & Amortization                       -$100K
────────────────────────────────────────────────────────
Operating Income (EBIT)                         $1,540K

Interest Income                                    $200K
────────────────────────────────────────────────────────
Net Income                                      $1,740K
Net Margin                                           9%

────────────────────────────────────────────────────────
Headcount (Year-End)                             52 FTEs
Monthly Net Income (Q4)                           $350K
Path to Profitability                           ACHIEVED
```

---

## 4. Unit Economics

### 4.1 Customer Acquisition Cost (CAC)

**Calculation**: Total S&M Spend ÷ New Customers Acquired

```
Year    S&M Spend    New Customers   CAC       Notes
──────────────────────────────────────────────────────
1       $730K        10              $73K      High (founder-led)
2       $2,890K      44              $66K      Improving efficiency
3       $6,850K      114             $60K      Scaled, repeatable
```

**CAC by Channel**:
```
Channel               CAC       % of New Customers
────────────────────────────────────────────────────
Direct Sales          $80K      60% (Enterprise Plus)
Partnerships          $50K      25% (Enterprise)
Product-Led Growth    $20K      15% (Team tier)
```

**CAC Payback Period** (Months to recover CAC from gross profit):
```
Tier              ACV     Gross Profit   CAC     Payback
────────────────────────────────────────────────────────
Team              $30K    $25.5K         $20K    9 months
Enterprise        $100K   $85K           $50K    7 months
Enterprise Plus   $400K   $340K          $80K    3 months

Blended Avg:      $132K   $112K          $60K    6 months
```

**Target**: <6 months payback (achieved by Year 3)

### 4.2 Lifetime Value (LTV)

**Calculation**: (Avg Annual Revenue × Gross Margin × Avg Customer Lifetime)

**Assumptions**:
- **Avg Annual Revenue**: $132K (Year 3 blended)
- **Gross Margin**: 85%
- **Churn Rate**: 8% annually (Year 3)
- **Avg Customer Lifetime**: 1 ÷ 0.08 = 12.5 years
- **Discount Factor**: 10% (conservative)

```
LTV = $132K × 0.85 × 12.5 = $1,402K (undiscounted)
LTV (discounted) = $850K (using 10% discount rate)
```

**Conservative LTV**: $500K (using 5-year lifetime)

### 4.3 LTV:CAC Ratio

```
Year    LTV       CAC     LTV:CAC   Benchmark   Status
──────────────────────────────────────────────────────────
1       $500K     $73K    6.8:1     >3:1        ✅ Excellent
2       $500K     $66K    7.6:1     >3:1        ✅ Excellent
3       $500K     $60K    8.3:1     >3:1        ✅ World-class
```

**Note**: Even with conservative $500K LTV, we exceed 3:1 benchmark significantly.

### 4.4 Magic Number

**Definition**: Net New ARR ÷ Prior Quarter S&M Spend

**Calculation** (Year 2, Q4 example):
```
Q4 S&M Spend (Q3):           $750K
Net New ARR (Q4):            $1,200K
Magic Number:                1.6

Benchmark:
  - <0.5: Poor efficiency
  - 0.5-0.75: Acceptable
  - 0.75-1.0: Good
  - >1.0: Excellent
```

**Miyabi Magic Number by Year**:
```
Year    Magic Number    Interpretation
─────────────────────────────────────────
1       0.5             Acceptable (early stage)
2       1.2             Excellent (improving)
3       2.0             World-class (scaled)
```

### 4.5 Net Dollar Retention (NDR)

**Definition**: (Starting ARR + Expansions - Downgrades - Churn) ÷ Starting ARR

**Year 2 Cohort Analysis**:
```
Starting ARR (10 customers from Y1):   $1,000K
Expansions (seat growth, upsells):       $250K
Downgrades:                               -$20K
Churn (1 customer):                      -$100K
─────────────────────────────────────────────────
Ending ARR:                             $1,130K

NDR = $1,130K ÷ $1,000K = 113%
```

**Year 3 Target**: 120% NDR (best-in-class SaaS)

**Drivers of Expansion**:
1. Seat expansion (teams grow 20%/year)
2. Tier upgrades (Team → Enterprise)
3. Feature upsells (on-premise, custom models)
4. Geographic expansion (one country → multiple)

---

## 5. Cash Flow Statement

### 5.1 Year 1 Cash Flow

```
Operating Activities
  Net Income                                    -$1,730K
  Add: Depreciation & Amortization                 $20K
  Changes in Working Capital:
    Increase in Accounts Receivable              -$100K
    Increase in Deferred Revenue                  $250K
    Increase in Accounts Payable                   $50K
  ───────────────────────────────────────────────────────
  Net Cash from Operations                      -$1,510K

Investing Activities
  CapEx (computers, equipment)                    -$100K
  ───────────────────────────────────────────────────────
  Net Cash from Investing                         -$100K

Financing Activities
  Seed Fundraising (Month 3)                    $3,000K
  ───────────────────────────────────────────────────────
  Net Cash from Financing                       $3,000K

───────────────────────────────────────────────────────
Net Increase in Cash                            $1,390K
Beginning Cash                                       $0
Ending Cash                                     $1,390K
```

**Runway Check**: $1,390K ÷ $190K/month = 7.3 months remaining

### 5.2 Year 2 Cash Flow

```
Operating Activities
  Net Income                                    -$2,380K
  Add: Depreciation & Amortization                 $50K
  Changes in Working Capital:
    Increase in Accounts Receivable              -$450K
    Increase in Deferred Revenue                $1,200K
    Increase in Accounts Payable                 $100K
  ───────────────────────────────────────────────────────
  Net Cash from Operations                      -$1,480K

Investing Activities
  CapEx                                           -$200K
  ───────────────────────────────────────────────────────
  Net Cash from Investing                         -$200K

Financing Activities
  Series A Fundraising (Month 18)              $20,000K
  ───────────────────────────────────────────────────────
  Net Cash from Financing                      $20,000K

───────────────────────────────────────────────────────
Net Increase in Cash                           $18,320K
Beginning Cash                                  $1,390K
Ending Cash                                    $19,710K
```

**Runway Check**: $19,710K ÷ $1,500K/month = 13+ months runway

### 5.3 Year 3 Cash Flow

```
Operating Activities
  Net Income                                    $1,740K
  Add: Depreciation & Amortization                $100K
  Changes in Working Capital:
    Increase in Accounts Receivable            -$1,200K
    Increase in Deferred Revenue                $4,000K
    Increase in Accounts Payable                 $200K
  ───────────────────────────────────────────────────────
  Net Cash from Operations                      $4,840K

Investing Activities
  CapEx                                           -$400K
  ───────────────────────────────────────────────────────
  Net Cash from Investing                         -$400K

Financing Activities
  None                                                $0
  ───────────────────────────────────────────────────────
  Net Cash from Financing                            $0

───────────────────────────────────────────────────────
Net Increase in Cash                            $4,440K
Beginning Cash                                 $19,710K
Ending Cash (Projected)                        $24,150K
```

**Cash Flow Positive**: Month 25 (Q1 Year 3)

---

## 6. Balance Sheet (Year-End Snapshots)

### 6.1 Year 1

```
ASSETS
Current Assets
  Cash & Cash Equivalents                       $1,390K
  Accounts Receivable                             $100K
  Prepaid Expenses                                 $50K
  ───────────────────────────────────────────────────────
  Total Current Assets                          $1,540K

Fixed Assets
  Equipment & Computers                           $100K
  Less: Accumulated Depreciation                  -$20K
  ───────────────────────────────────────────────────────
  Net Fixed Assets                                 $80K

Total Assets                                    $1,620K

LIABILITIES
Current Liabilities
  Accounts Payable                                 $50K
  Accrued Expenses                                 $80K
  Deferred Revenue                                $250K
  ───────────────────────────────────────────────────────
  Total Current Liabilities                       $380K

Total Liabilities                                 $380K

EQUITY
  Common Stock                                      $10K
  Preferred Stock (Seed)                        $3,000K
  Retained Earnings                            -$1,770K
  ───────────────────────────────────────────────────────
  Total Equity                                  $1,240K

Total Liabilities & Equity                      $1,620K
```

### 6.2 Year 3 (Projected)

```
ASSETS
Current Assets
  Cash & Cash Equivalents                      $24,150K
  Accounts Receivable                           $2,000K
  Prepaid Expenses                                $200K
  ───────────────────────────────────────────────────────
  Total Current Assets                         $26,350K

Fixed Assets
  Equipment & Computers                           $700K
  Less: Accumulated Depreciation                 -$170K
  ───────────────────────────────────────────────────────
  Net Fixed Assets                                $530K

Total Assets                                   $26,880K

LIABILITIES
Current Liabilities
  Accounts Payable                                $350K
  Accrued Expenses                                $500K
  Deferred Revenue                              $5,450K
  ───────────────────────────────────────────────────────
  Total Current Liabilities                     $6,300K

Total Liabilities                               $6,300K

EQUITY
  Common Stock                                     $10K
  Preferred Stock (Seed + Series A)            $23,000K
  Retained Earnings                            -$2,430K
  ───────────────────────────────────────────────────────
  Total Equity                                 $20,580K

Total Liabilities & Equity                     $26,880K
```

---

## 7. Key Metrics Dashboard

### 7.1 Summary Table

```
Metric                      Year 1    Year 2    Year 3    Target
─────────────────────────────────────────────────────────────────
ARR                         $1.0M     $5.4M     $20.0M
YoY Growth                  N/A       440%      270%      >100%
New Customers               10        44        114
Total Customers             10        51        151
Avg ACV                     $100K     $106K     $132K     >$100K
Churn Rate (Annual)         0%        6%        8%        <10%
Net Dollar Retention        N/A       113%      120%      >110%

Gross Margin                85%       85%       85%       >80%
CAC                         $73K      $66K      $60K      <$70K
LTV                         $500K     $500K     $500K
LTV:CAC                     6.8:1     7.6:1     8.3:1     >3:1
CAC Payback (Months)        10        8         6         <12
Magic Number                0.5       1.2       2.0       >0.75

EBITDA                      -$1.7M    -$2.4M    +$1.6M
EBITDA Margin               -174%     -45%      +8%
Cash Burn (Monthly Avg)     $190K     $230K     -$370K
Ending Cash                 $1.4M     $19.7M    $24.2M
Months of Runway            7.3       85        N/A       >12

Headcount                   7         22        52
Revenue per Employee        $143K     $245K     $385K     >$200K
```

### 7.2 SaaS Benchmarks Comparison

```
Metric                    Miyabi (Y3)   Top Quartile   Median
───────────────────────────────────────────────────────────────
Gross Margin              85%           >80%           70-75%
LTV:CAC                   8.3:1         >3:1           <3:1
CAC Payback               6 mo          <12 mo         18-24 mo
Magic Number              2.0           >1.0           0.5-0.75
NDR                       120%          >110%          90-100%
Churn (Annual)            8%            <10%           15-20%
YoY Growth                270%          >100%          50-80%
Rev/Employee              $385K         >$200K         $150K
───────────────────────────────────────────────────────────────

✅ Miyabi exceeds top quartile in ALL metrics
```

---

## 8. Sensitivity Analysis

### 8.1 Revenue Scenarios

```
Scenario              Year 3 ARR   Customers   Avg ACV   Probability
────────────────────────────────────────────────────────────────────
Bear Case             $12.0M       100         $120K     20%
  (50% of plan)       (-40%)       (-34%)      (-9%)

Base Case             $20.0M       151         $132K     60%
  (Plan)

Bull Case             $30.0M       210         $143K     20%
  (+50% of plan)      (+50%)       (+39%)      (+8%)
```

**Bear Case Drivers**:
- Slower sales cycles (90 days → 120 days)
- Lower win rates (30% → 20%)
- Higher churn (8% → 12%)

**Bull Case Drivers**:
- Faster sales cycles (60 days → 45 days)
- Higher win rates (30% → 40%)
- Strong PLG motion (Team tier grows faster)

### 8.2 Profitability by Scenario

```
Scenario          Year 3 EBITDA   EBITDA Margin   Cash Flow Positive
──────────────────────────────────────────────────────────────────────
Bear Case         -$2.0M          -17%            Month 36+
Base Case         +$1.6M          +8%             Month 25
Bull Case         +$6.0M          +20%            Month 20
```

**Risk Mitigation**:
- If Bear Case, cut S&M by 20% (focus on best channels)
- Extend runway by reducing R&D hiring (18 → 15 engineers)
- Still achieve profitability by end of Year 3

### 8.3 Funding Scenarios

```
Scenario              Seed      Series A    Total     Outcome
───────────────────────────────────────────────────────────────
Minimum               $1.5M     $10M        $11.5M    Tight, risky
Base Case             $3.0M     $20M        $23.0M    Comfortable
Maximum               $5.0M     $30M        $35.0M    Accelerated growth
```

**Recommendation**: Raise $3M Seed + $20M Series A (Base Case)
- Provides 18-month runway to Series A
- Allows aggressive hiring + GTM
- Buffer for Bear Case scenario

---

## 9. Key Assumptions Summary

### 9.1 Revenue Assumptions
- Avg ACV: $100K (Y1) → $132K (Y3)
- Sales Cycle: 90 days (Y1) → 60 days (Y3)
- Win Rate: 20% (Y1) → 30% (Y3)
- Churn: 0% (Y1) → 8% (Y3)
- NDR: N/A (Y1) → 120% (Y3)

### 9.2 Cost Assumptions
- Gross Margin: 85% (consistent)
- Cloud COGS: 10% of revenue
- Support COGS: 5% of revenue
- Avg Salary: $150-200K (engineering), $200-250K (sales)
- S&M % of Revenue: 73% (Y1) → 34% (Y3)
- R&D % of Revenue: 146% (Y1) → 33% (Y3)

### 9.3 Market Assumptions
- TAM: $180B (global software development)
- SAM: $18B (AI dev tools, 2025)
- Market Growth: 42% CAGR
- Competition: GitHub Copilot ($1B ARR), Devin ($2B valuation)

---

## 10. Next Steps

1. **Validate with advisors**: Share model with CFO advisors, VCs
2. **Build detailed quarterly model**: Break down to Q1-Q12 for Years 1-3
3. **Scenario planning**: Build Bull/Bear case tabs in Excel
4. **Link to pitch deck**: Ensure numbers match exactly
5. **Prepare for due diligence**: VCs will scrutinize every assumption

---

**Files to Create**:
- `financial_model.xlsx` (full Excel model with multiple tabs)
- `unit_economics_calculator.xlsx` (standalone calculator for customers)
- `sensitivity_dashboard.xlsx` (interactive scenario planning)

**Next Document**: 04_FUNDRAISING_TIMELINE.md
