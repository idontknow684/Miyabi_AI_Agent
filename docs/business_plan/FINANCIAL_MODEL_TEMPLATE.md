# MIYABI - FINANCIAL MODEL TEMPLATE
## 3-Year Financial Projections (Spreadsheet Format)

**Version**: 1.0
**Date**: November 7, 2025
**Format**: Google Sheets / Excel
**Confidential**: For Investment Discussion Only

---

## SPREADSHEET STRUCTURE

This document describes the structure of the Miyabi financial model spreadsheet. The actual spreadsheet should be created in Google Sheets or Excel with the following tabs:

---

## TAB 1: ASSUMPTIONS

**Purpose**: Single source of truth for all model inputs

### Section A: Revenue Assumptions

**Customer Acquisition by Segment**:
| Month | Individual | Team | Enterprise | Total | Notes |
|-------|-----------|------|------------|-------|-------|
| 1 | 0 | 0 | 0 | 0 | Pre-launch |
| 2 | 0 | 0 | 0 | 0 | arXiv publication |
| 3 | 1 | 0 | 0 | 1 | First paying customer |
| 4 | 2 | 0 | 1 | 3 | Early adopters |
| 5 | 2 | 1 | 1 | 4 | |
| 6 | 3 | 2 | 5 | 10 | Seed funding close |
| 7-12 | ... | ... | ... | 25 | Year 1 target |

**Pricing (Annual Contract Value)**:
| Segment | Price/User/Month | Avg Users | ACV | % of Mix |
|---------|------------------|-----------|-----|----------|
| Individual | $99 | 1 | $1,188 | 5% |
| Team | $299 | 10 | $35,880 | 30% |
| Enterprise | $250 | 100 | $300,000 | 65% |

**Churn Rates**:
| Year | Gross Churn | Net Revenue Retention | Notes |
|------|-------------|----------------------|-------|
| 1 | 15% | 110% | Early-stage volatility |
| 2 | 10% | 120% | PMF achieved |
| 3 | 8% | 125% | Enterprise stickiness |

**Pricing Escalation**:
| Year | Increase | Rationale |
|------|----------|-----------|
| 1 | 0% | Base pricing |
| 2 | 5% | Value-based increase |
| 3 | 8% | Premium positioning |

### Section B: Cost Assumptions

**Cost of Goods Sold (COGS)**:
| Component | % of Revenue | Year 1 | Year 2 | Year 3 |
|-----------|--------------|--------|--------|--------|
| Claude API | 8% | $148K | $486K | $1.55M |
| AWS Infrastructure | 3% | $56K | $182K | $581K |
| **Total COGS** | **11%** | **$204K** | **$668K** | **$2.13M** |

**Operating Expenses - R&D**:
| Role | Count Y1 | Count Y2 | Count Y3 | Annual Cost |
|------|----------|----------|----------|-------------|
| CTO | 0.5 | 1 | 1 | $250K |
| Senior Rust Engineer | 1.5 | 3 | 5 | $180K |
| Senior ML Engineer | 0 | 1 | 2 | $190K |
| DevRel Engineer | 0.5 | 1 | 1 | $150K |
| **Total R&D** | 2.5 | 6 | 9 | |

**Operating Expenses - Sales & Marketing**:
| Role | Count Y1 | Count Y2 | Count Y3 | Annual Cost |
|------|----------|----------|----------|-------------|
| VP Sales | 0 | 0.5 | 1 | $300K (base+OTE) |
| Account Executive | 1 | 2 | 4 | $240K (base+OTE) |
| Sales Engineer | 0.5 | 1 | 2 | $200K (base+OTE) |
| SDR | 0.5 | 1 | 2 | $100K (base+OTE) |
| CSM | 0.5 | 2 | 3 | $100K |
| Marketing Manager | 0.5 | 1 | 1 | $130K |
| **Total S&M** | 3 | 7.5 | 13 | |

**Operating Expenses - G&A**:
| Role | Count Y1 | Count Y2 | Count Y3 | Annual Cost |
|------|----------|----------|----------|-------------|
| CEO (Founder) | 1 | 1 | 1 | $180K |
| VP Engineering | 0 | 0 | 0.5 | $200K |
| Finance/Admin | 0 | 0.5 | 1 | $120K |
| **Total G&A** | 1 | 1.5 | 2.5 | |

**Other Operating Costs**:
| Category | Year 1 | Year 2 | Year 3 |
|----------|--------|--------|--------|
| Software Tools | $30K | $65K | $110K |
| Office/Workspace | $0 | $0 | $50K (optional co-working) |
| Travel & Entertainment | $20K | $50K | $100K |
| Marketing & Advertising | $80K | $200K | $400K |
| Legal & Compliance | $50K | $80K | $120K |
| Insurance | $15K | $40K | $80K |
| Conferences & Events | $40K | $100K | $200K |
| **Total Other OpEx** | $235K | $535K | $1.06M |

### Section C: Capital Assumptions

**Funding Rounds**:
| Round | Amount | Date | Valuation (Post) | Dilution | Use of Funds |
|-------|--------|------|------------------|----------|--------------|
| Seed | $3M | Month 6 | $12M | 25% | Product 50%, GTM 30%, Team 20% |
| Series A | $9M | Month 18 | $45M | 20% | Scale team, US expansion |

**Capital Expenditure**:
| Item | Year 1 | Year 2 | Year 3 |
|------|--------|--------|--------|
| Laptops (avg $3K) | $15K | $30K | $60K |
| Servers (development) | $20K | $30K | $50K |
| Office Equipment | $10K | $20K | $70K |
| **Total CapEx** | $45K | $80K | $180K |

---

## TAB 2: REVENUE MODEL

**Purpose**: Bottom-up revenue buildup by customer cohort

### Monthly Revenue Table (Year 1)

| Month | Existing MRR | New Customers | New MRR | Churn MRR | Expansion MRR | Ending MRR | ARR |
|-------|--------------|---------------|---------|-----------|---------------|------------|-----|
| 1 | $0 | 0 | $0 | $0 | $0 | $0 | $0 |
| 2 | $0 | 0 | $0 | $0 | $0 | $0 | $0 |
| 3 | $0 | 1 | $10K | $0 | $0 | $10K | $120K |
| 4 | $10K | 2 | $25K | $0 | $0 | $35K | $420K |
| 5 | $35K | 2 | $20K | ($0) | $0 | $55K | $660K |
| 6 | $55K | 5 | $45K | ($0) | $0 | $100K | $1.2M |
| 7 | $100K | 3 | $30K | ($0) | $0 | $130K | $1.56M |
| 8 | $130K | 3 | $30K | ($0) | $0 | $160K | $1.92M |
| 9 | $160K | 4 | $40K | ($0) | $0 | $200K | $2.4M |
| 10 | $200K | 2 | $20K | ($0) | $0 | $220K | $2.64M |
| 11 | $220K | 2 | $20K | ($0) | $0 | $240K | $2.88M |
| 12 | $240K | 1 | $10K | ($0) | $0 | $250K | $3M |

**Formulas**:
- `Ending MRR = Existing MRR + New MRR - Churn MRR + Expansion MRR`
- `ARR = Ending MRR × 12`
- `Churn MRR = Existing MRR × Monthly Churn Rate`
- `Expansion MRR = Existing MRR × (NRR - 1) / 12`

### Quarterly Revenue Table (Year 2-3)

Similar structure, aggregated by quarter instead of month.

### Customer Cohort Analysis

Track retention and expansion by acquisition cohort:

| Cohort (Acq Month) | M0 | M3 | M6 | M12 | M18 | M24 | M36 |
|--------------------|----|----|----|----|-----|-----|-----|
| Q1 2026 | 100% | 95% | 92% | 88% | 85% | 83% | 80% |
| Q2 2026 | 100% | 96% | 93% | 90% | 87% | 85% | 82% |
| ... | | | | | | | |

**Revenue Expansion by Cohort**:
- Track ACV growth over time (seat expansion, tier upgrades)

---

## TAB 3: PROFIT & LOSS (P&L)

**Purpose**: Income statement with monthly/quarterly detail

### Year 1 P&L (Monthly)

| Line Item | M1 | M2 | M3 | ... | M12 | Total Y1 |
|-----------|----|----|----|----|-----|----------|
| **Revenue** | | | | | | |
| Individual | $0 | $0 | $1K | ... | $15K | $60K |
| Team | $0 | $0 | $0 | ... | $75K | $300K |
| Enterprise | $0 | $0 | $9K | ... | $160K | $1.5M |
| **Total Revenue** | $0 | $0 | $10K | ... | $250K | $1.86M |
| | | | | | | |
| **COGS** | | | | | | |
| Claude API | $0 | $0 | $0.8K | ... | $20K | $148K |
| AWS | $0 | $0 | $0.3K | ... | $8K | $56K |
| **Total COGS** | $0 | $0 | $1.1K | ... | $28K | $204K |
| | | | | | | |
| **Gross Profit** | $0 | $0 | $8.9K | ... | $222K | $1.66M |
| **Gross Margin %** | N/A | N/A | 89% | ... | 89% | 89% |
| | | | | | | |
| **Operating Expenses** | | | | | | |
| R&D | $15K | $15K | $20K | ... | $80K | $520K |
| Sales & Marketing | $10K | $10K | $15K | ... | $90K | $540K |
| G&A | $5K | $5K | $5K | ... | $30K | $240K |
| **Total OpEx** | $30K | $30K | $40K | ... | $200K | $1.3M |
| | | | | | | |
| **EBITDA** | -$30K | -$30K | -$31K | ... | $22K | $360K |
| Depreciation | $0 | $0 | $1K | ... | $2K | $15K |
| **EBIT** | -$30K | -$30K | -$32K | ... | $20K | $345K |
| Interest | $0 | $0 | $0 | ... | $0 | $0 |
| **Net Income** | -$30K | -$30K | -$32K | ... | $20K | $345K |

### Year 2-3 P&L (Quarterly)

Similar structure, quarterly aggregation.

**Key Metrics to Track**:
- Gross Margin %
- Operating Margin %
- Net Margin %
- EBITDA Margin %
- Revenue Growth Rate (MoM, QoQ, YoY)

---

## TAB 4: CASH FLOW STATEMENT

**Purpose**: Track cash movements (operating, investing, financing)

### Year 1 Cash Flow (Monthly)

| Line Item | M1 | M2 | M3 | ... | M12 | Total Y1 |
|-----------|----|----|----|----|-----|----------|
| **Operating Activities** | | | | | | |
| Net Income | -$30K | -$30K | -$32K | ... | $20K | $345K |
| Add: Depreciation | $0 | $0 | $1K | ... | $2K | $15K |
| Changes in A/R | $0 | $0 | -$5K | ... | -$10K | -$80K |
| Changes in A/P | $0 | $0 | $2K | ... | $5K | $30K |
| **Net Operating CF** | -$30K | -$30K | -$34K | ... | $17K | $310K |
| | | | | | | |
| **Investing Activities** | | | | | | |
| CapEx | -$5K | -$5K | -$5K | ... | -$5K | -$45K |
| **Net Investing CF** | -$5K | -$5K | -$5K | ... | -$5K | -$45K |
| | | | | | | |
| **Financing Activities** | | | | | | |
| Seed Funding | $0 | $0 | $0 | $3M (M6) | $0 | $3M |
| **Net Financing CF** | $0 | $0 | $0 | $3M | $0 | $3M |
| | | | | | | |
| **Net Change in Cash** | -$35K | -$35K | -$39K | ... | $12K | $3.27M |
| **Ending Cash Balance** | $15K | -$20K | -$59K | ... | $2.97M | $2.97M |

**Runway Calculation**:
- `Runway (months) = Ending Cash / Avg Monthly Burn`
- `Avg Monthly Burn = (Total OpEx + COGS - Revenue) / 12`

### Year 2-3 Cash Flow (Quarterly)

Similar structure.

---

## TAB 5: BALANCE SHEET

**Purpose**: Snapshot of assets, liabilities, equity

### Year-End Balance Sheets

| Line Item | End Year 0 | End Year 1 | End Year 2 | End Year 3 |
|-----------|------------|------------|------------|------------|
| **Assets** | | | | |
| Cash & Equivalents | $50K | $2.97M | $12.96M | $20.38M |
| Accounts Receivable | $0 | $80K | $400K | $1.2M |
| Prepaid Expenses | $0 | $20K | $50K | $100K |
| **Current Assets** | $50K | $3.07M | $13.41M | $21.68M |
| | | | | |
| PP&E (Gross) | $0 | $45K | $125K | $305K |
| Accumulated Depreciation | $0 | ($15K) | ($51K) | ($121K) |
| **PP&E (Net)** | $0 | $30K | $74K | $184K |
| | | | | |
| **Total Assets** | $50K | $3.1M | $13.48M | $21.86M |
| | | | | |
| **Liabilities** | | | | |
| Accounts Payable | $0 | $30K | $80K | $200K |
| Accrued Expenses | $0 | $20K | $60K | $150K |
| Deferred Revenue | $0 | $50K | $200K | $600K |
| **Current Liabilities** | $0 | $100K | $340K | $950K |
| | | | | |
| Long-term Debt | $0 | $0 | $0 | $0 |
| **Total Liabilities** | $0 | $100K | $340K | $950K |
| | | | | |
| **Equity** | | | | |
| Common Stock | $50K | $50K | $50K | $50K |
| Preferred Stock | $0 | $3M | $12M | $12M |
| Retained Earnings | $0 | ($355K) | $1.09M | $9.14M |
| **Total Equity** | $50K | $2.7M | $13.14M | $21.19M |
| | | | | |
| **Total Liab + Equity** | $50K | $2.8M | $13.48M | $22.09M |

**Key Ratios**:
- Current Ratio = Current Assets / Current Liabilities
- Quick Ratio = (Cash + A/R) / Current Liabilities
- Debt-to-Equity = Total Debt / Total Equity

---

## TAB 6: HIRING PLAN

**Purpose**: Detailed headcount planning by role and month

### Headcount Table

| Role | M1 | M2 | M3 | M4 | M5 | M6 | ... | M12 | M18 | M24 | M36 |
|------|----|----|----|----|----|----|-----|-----|-----|-----|-----|
| **Engineering** | | | | | | | | | | | |
| CTO | 0 | 0 | 0 | 0 | 0 | 1 | | 1 | 1 | 1 | 1 |
| Sr Rust Eng | 0 | 0 | 0 | 0 | 0 | 1 | | 2 | 3 | 4 | 5 |
| Sr ML Eng | 0 | 0 | 0 | 0 | 0 | 0 | | 0 | 1 | 1 | 2 |
| DevRel | 0 | 0 | 0 | 0 | 0 | 0 | | 1 | 1 | 1 | 1 |
| **Sales & Marketing** | | | | | | | | | | | |
| VP Sales | 0 | 0 | 0 | 0 | 0 | 0 | | 0 | 1 | 1 | 1 |
| AE | 0 | 0 | 0 | 0 | 0 | 1 | | 1 | 2 | 2 | 4 |
| SE | 0 | 0 | 0 | 0 | 0 | 0 | | 1 | 1 | 1 | 2 |
| SDR | 0 | 0 | 0 | 0 | 0 | 0 | | 1 | 1 | 1 | 2 |
| CSM | 0 | 0 | 0 | 0 | 0 | 1 | | 1 | 2 | 2 | 3 |
| Marketing | 0 | 0 | 0 | 0 | 0 | 0 | | 1 | 1 | 1 | 1 |
| **G&A** | | | | | | | | | | | |
| CEO (Founder) | 1 | 1 | 1 | 1 | 1 | 1 | | 1 | 1 | 1 | 1 |
| VP Eng | 0 | 0 | 0 | 0 | 0 | 0 | | 0 | 0 | 0 | 1 |
| Finance/Admin | 0 | 0 | 0 | 0 | 0 | 0 | | 0 | 0 | 1 | 1 |
| **Total** | 1 | 1 | 1 | 1 | 1 | 5 | | 11 | 15 | 17 | 25 |

### Salary Table

| Role | Base Salary | Equity (%) | OTE (if sales) | Annual Fully-Loaded |
|------|-------------|------------|----------------|---------------------|
| CEO (Founder) | $150K | 80% | N/A | $180K |
| CTO | $200K | 3-5% | N/A | $250K |
| VP Sales | $150K | 1% | $300K | $300K |
| VP Eng | $180K | 1.5% | N/A | $200K |
| Sr Rust Eng | $160K | 0.5% | N/A | $180K |
| Sr ML Eng | $170K | 0.5% | N/A | $190K |
| AE | $120K | 0.3% | $240K | $240K |
| SE | $130K | 0.3% | $200K | $200K |
| SDR | $60K | 0.1% | $100K | $100K |
| CSM | $90K | 0.2% | N/A | $100K |
| Marketing Mgr | $120K | 0.4% | N/A | $130K |
| DevRel | $140K | 0.4% | N/A | $150K |
| Finance/Admin | $110K | 0.2% | N/A | $120K |

**Fully-Loaded Cost** = Base + Benefits (15%) + Equity Amortization (5%)

---

## TAB 7: CAP TABLE

**Purpose**: Equity ownership over time

### Capitalization Table

| Shareholder | Shares (Pre-Seed) | % | Seed Round | Shares (Post-Seed) | % | Series A | Shares (Post-A) | % |
|-------------|-------------------|---|------------|---------------------|---|----------|------------------|---|
| **Founder** | | | | | | | | |
| Shunsuke Hayashi | 8,000,000 | 80% | - | 8,000,000 | 60% | - | 8,000,000 | 48% |
| | | | | | | | | |
| **Employees** | | | | | | | | |
| Option Pool (unallocated) | 2,000,000 | 20% | +500,000 | 2,500,000 | 18.75% | +1,000,000 | 3,500,000 | 21% |
| | | | | | | | | |
| **Seed Investors** | | | | | | | | |
| Lead VC | - | - | 1,666,667 | 1,666,667 | 12.5% | - | 1,666,667 | 10% |
| Strategic (KDDI) | - | - | 416,667 | 416,667 | 3.1% | - | 416,667 | 2.5% |
| Angels (5 × $100K) | - | - | 416,666 | 416,666 | 3.1% | - | 416,666 | 2.5% |
| | | | | | | | | |
| **Series A Investors** | | | | | | | | |
| Lead VC | - | - | - | - | - | 2,000,000 | 2,000,000 | 12% |
| Existing (Pro-Rata) | - | - | - | - | - | 666,667 | 666,667 | 4% |
| | | | | | | | | |
| **Total Shares** | 10,000,000 | 100% | +3,000,000 | 13,333,333 | 100% | +3,666,667 | 16,666,667 | 100% |

**Valuation Summary**:
| Round | Pre-Money | Investment | Post-Money | Price/Share | Dilution |
|-------|-----------|------------|------------|-------------|----------|
| Seed | $9M | $3M | $12M | $0.90 | 25% |
| Series A | $36M | $9M | $45M | $2.70 | 20% |

---

## TAB 8: SCENARIO ANALYSIS

**Purpose**: Model best/base/worst cases

### Scenario Comparison (Year 3)

| Metric | Bear Case | Base Case | Bull Case |
|--------|-----------|-----------|-----------|
| **Assumptions** | | | |
| Customer Acq (vs. base) | -40% | 0% | +30% |
| ACV (vs. base) | -15% | 0% | +20% |
| Churn (vs. base) | +50% | 0% | -30% |
| | | | |
| **Outputs** | | | |
| Total Customers | 210 | 350 | 455 |
| ARR | $14.5M | $28.5M | $44.5M |
| Revenue (Y3) | $11.6M | $19.4M | $35.6M |
| Gross Profit | $10.2M | $17.1M | $31.4M |
| Net Income | $1.2M | $8.05M | $15.2M |
| Ending Cash | $10.5M | $20.38M | $32.1M |
| | | | |
| **Key Metrics** | | | |
| Gross Margin | 88% | 88% | 88% |
| Net Margin | 10% | 41% | 43% |
| CAC Payback (mo) | 3.5 | 2.1 | 1.5 |
| LTV/CAC | 12x | 24x | 38x |

**Sensitivity Table**: ARR by Customer Count × ACV

| | ACV: -20% | ACV: -10% | ACV: Base | ACV: +10% | ACV: +20% |
|---|-----------|-----------|-----------|-----------|-----------|
| **Customers: -40%** | $11.6M | $13.1M | $14.5M | $16M | $17.4M |
| **Customers: -20%** | $18.2M | $20.5M | $22.8M | $25.1M | $27.4M |
| **Customers: Base** | $22.8M | $25.7M | $28.5M | $31.4M | $34.2M |
| **Customers: +20%** | $27.4M | $30.8M | $34.2M | $37.6M | $41M |
| **Customers: +40%** | $32M | $36M | $40M | $44M | $48M |

---

## TAB 9: DASHBOARDS

**Purpose**: Visual charts and KPI tracking

### Dashboard 1: Revenue Growth

**Charts**:
1. MRR Growth (line chart, monthly)
2. ARR (bar chart, quarterly)
3. Revenue by Segment (stacked area chart)
4. Customer Count (bar chart, by tier)

### Dashboard 2: Unit Economics

**Charts**:
1. CAC by Channel (bar chart)
2. LTV/CAC Ratio (line chart, by cohort)
3. CAC Payback Period (bar chart, by segment)
4. Gross Retention by Cohort (heatmap)

### Dashboard 3: Profitability

**Charts**:
1. Gross Margin % (line chart, monthly)
2. Operating Margin % (line chart, quarterly)
3. EBITDA (waterfall chart)
4. Net Income (bar chart, quarterly)

### Dashboard 4: Cash Management

**Charts**:
1. Cash Balance (line chart, monthly)
2. Burn Rate (bar chart, monthly)
3. Runway (gauge chart)
4. Cash Flow by Category (waterfall chart)

### Dashboard 5: Team

**Charts**:
1. Headcount by Department (stacked bar)
2. Revenue per Employee (line chart)
3. Hiring Plan vs. Actual (comparison chart)

---

## USAGE INSTRUCTIONS

### For Internal Planning:
1. Update **Assumptions** tab monthly with actuals
2. Review **Dashboards** tab weekly for KPI tracking
3. Compare **Scenario Analysis** quarterly to adjust strategy
4. Update **Hiring Plan** before each interview cycle

### For Investor Presentations:
1. Export **P&L** and **Cash Flow** to PDF
2. Share **Dashboards** tab screenshots in deck
3. Provide **Cap Table** in data room
4. Walk through **Scenario Analysis** in diligence calls

### For Board Meetings:
1. Send **Dashboards** tab as monthly report
2. Present **P&L** summary (quarterly)
3. Discuss variances from **Assumptions**
4. Review **Hiring Plan** progress

---

## FORMULAS REFERENCE

**Key Excel/Sheets Formulas**:

1. **MRR Growth**: `=Previous_MRR + New_MRR - Churn_MRR + Expansion_MRR`
2. **ARR**: `=MRR * 12`
3. **Gross Margin %**: `=(Revenue - COGS) / Revenue`
4. **Runway (months)**: `=Cash_Balance / Avg_Monthly_Burn`
5. **CAC**: `=Total_S&M_Spend / New_Customers_Acquired`
6. **LTV**: `=ACV * Avg_Customer_Lifetime_Years / (1 + Discount_Rate)^Year`
7. **NRR**: `=(Starting_ARR + Expansion - Contraction - Churn) / Starting_ARR`

**Conditional Formatting**:
- Green: Above target
- Yellow: 80-100% of target
- Red: <80% of target

---

## VERSION CONTROL

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 0.1 | 2025-11-01 | Initial draft | Shunsuke |
| 0.5 | 2025-11-05 | Added scenario analysis | Shunsuke |
| 1.0 | 2025-11-07 | Final for Seed raise | Shunsuke |

---

## NOTES

**Assumptions Subject to Change**:
- Customer acquisition rates (dependent on GTM execution)
- Pricing (market feedback may require adjustments)
- Churn rates (early estimates, will stabilize post-PMF)
- Headcount plan (flexible based on funding timeline)

**Model Limitations**:
- Does not include potential M&A scenarios
- Assumes linear customer growth (reality is lumpy)
- Does not model seasonality (enterprise budgets Q4-heavy)
- Strategic partnerships not quantified (upside optionality)

**For Questions**:
Contact: shunsuke@miyabi.dev

---

**END OF FINANCIAL MODEL TEMPLATE**

**Next Step**: Create actual Google Sheets with formulas and link here.
