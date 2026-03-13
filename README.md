# User Onboarding Funnel Analysis 

> *Identifying conversion bottlenecks across a 6-stage onboarding journey to improve activation rates, reduce drop-off, and drive measurable business growth.*

---

## 1. Project Background

### Business Context

In SaaS and fintech products, the onboarding funnel is the single most critical driver of revenue. Every user who drops off before completing their first transaction represents lost lifetime value, wasted acquisition spend, and a missed activation opportunity.

This project simulates a real-world product analytics engagement — analyzing the full onboarding journey from **Signup → Email Verification → KYC Initiation → KYC Approval → First Transaction** across **12,000+ users** and **1M+ event records** over a **30-day activity window.**

### Problem Statement

The product team observed stagnating activation rates despite growing signup volumes. Month-over-month signup growth had slowed to **under 3%**, yet overall activation remained stuck at **~40%**. The core business question was:

> *"Where exactly are we losing users — and what should we prioritize fixing first?"*

### Objectives

- Map and quantify user progression across all 6 onboarding stages
- Identify the highest-impact drop-off points with supporting data
- Segment conversion performance by **device type** and **acquisition channel**
- Deliver prioritized, evidence-based recommendations for product and growth teams
- Build a self-serve Tableau dashboard for ongoing funnel monitoring

---

## 2. Executive Summary

| Metric | Value |
|--------|-------|
| Total Users Analyzed | 12,000+ |
| Event Records Processed | 1,000,000+ |
| Analysis Period | 30-Day Activity Window |
| Overall Funnel Conversion | ~40% |
| Primary Drop-off Stage | Post-KYC → First Transaction |
| Users Lost at Critical Stage | ~3,000 |
| Data Accuracy Achieved | 95%+ |
| Manual Reporting Reduced | 40% (~15 hrs/week) |
| KPIs Tracked | 10+ |

### The Core Finding

> **25%+ of KYC-approved users never completed their first transaction.**

This single bottleneck — post-KYC drop-off — accounts for the largest share of lost activation in the entire funnel. These are high-intent, identity-verified users being lost at the last mile before revenue conversion.

**Fixing this one stage delivers more ROI than increasing acquisition spend.**

---

```
╔══════════════════════════════════════════════════════════════════╗
║              ONBOARDING FUNNEL — FULL OVERVIEW                   ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  SIGNUP              ████████████████████████  12,000 users      ║
║                                                ↓ 85% converted   ║
║  EMAIL VERIFIED      ████████████████████      10,200 users      ║
║                                                ↓ 78% converted   ║
║  KYC INITIATED       ███████████████            7,956 users      ║
║                                                ↓ 82% converted   ║
║  KYC APPROVED        ████████████               6,524 users      ║
║                                                ↓ 54% ⚠️ LEAK     ║
║  FIRST TRANSACTION   ██████                     3,523 users      ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║  OVERALL CONVERSION: ~40%  |  CRITICAL LOSS: ~3,000 users        ║
║  POST-KYC IS WHERE REVENUE IS BEING LEFT ON THE TABLE            ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 3. Dataset & Methodology

### Data Sources

| Table | Description | Volume |
|-------|-------------|--------|
| `user_events` | Event-level activity logs | 1M+ records |
| `user_profiles` | Signup metadata, device, channel | 12K+ records |
| `funnel_stages` | Stage timestamps per user | 12K+ records |

### Key Fields

- Funnel timestamps — signup, email verification, KYC initiation, KYC approval, first transaction
- Device type — Android, iOS, Web
- Acquisition channel — Organic, Paid, Referral, Social
- App version, country, event type, system error flags

### Analytical Approach

```
RAW DATA
   ↓
STAGING TABLES (data integrity preserved)
   ↓
CLEANING & VALIDATION (SQL)
   ↓
EXPLORATORY DATA ANALYSIS (SQL)
   ↓
FUNNEL METRICS & SEGMENTATION
   ↓
INSIGHTS & BUSINESS NARRATIVE
   ↓
TABLEAU DASHBOARD (stakeholder delivery)
```

---

## 4. Data Cleaning & Preparation

**SQL Script:** `/sql/data_cleaning.sql`

All preparation was performed in SQL using a **production-style staging workflow** to preserve raw data integrity throughout.

### Cleaning Steps

| Step | Action | Business Outcome |
|------|--------|-----------------|
| Staging tables | Preserved raw data before transformation | Zero data loss, full auditability |
| Deduplication | Window functions to remove duplicate events | Clean, unique user-event records |
| Categorical standardization | Normalized device, country, channel fields | Consistent, reliable segmentation |
| App version normalization | Resolved inconsistent version formatting | Accurate platform analysis |
| Timestamp conversion | Converted all fields to `DATETIME` | Precise time-to-conversion measurement |
| Null handling | Flagged and resolved missing stage timestamps | No gaps in funnel progression |
| Outlier removal | Removed time-to-conversion > 720 hours | Eliminated statistical skew |

---

## 5. Funnel Performance Analysis

**SQL Script:** `/sql/eda.sql`

### Stage-by-Stage Conversion

```
╔══════════════════════════════════════════════════════════════════╗
║                  STAGE-BY-STAGE BREAKDOWN                        ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Signup → Email Verified        85%  ████████████████  ✅ Strong ║
║  Email Verified → KYC Started   78%  ████████████      ✅ Solid  ║
║  KYC Started → KYC Approved     82%  █████████████     ✅ Good   ║
║  KYC Approved → 1st Transaction 54%  ███████           ⚠️ LEAK   ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║  The first 3 stages perform well. The leak is post-KYC.          ║
╚══════════════════════════════════════════════════════════════════╝
```

---

### Conversion by Device Type

```
╔══════════════════════════════════════════════════════════════════╗
║                    DEVICE PERFORMANCE                            ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Android   68%   ████████████████████  ✅ Best performer         ║
║  Web       65%   ███████████████████   ✅ Strong                 ║
║  iOS       48%   █████████████         ⚠️ 20pts below Android    ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║  iOS users represent a significant untapped conversion pool      ║
╚══════════════════════════════════════════════════════════════════╝
```

---

### Conversion by Acquisition Channel

```
╔══════════════════════════════════════════════════════════════════╗
║                   CHANNEL PERFORMANCE                            ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Referral  72%   ████████████████████  ✅ Highest quality        ║
║  Organic   61%   ██████████████████    ✅ Reliable               ║
║  Paid      44%   ████████████          ⚠️ High cost, low return  ║
║  Social    38%   ██████████            ❌ Lowest quality          ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║  Paid drives volume. Referral drives activated, retained users.  ║
╚══════════════════════════════════════════════════════════════════╝
```

---

### Signup Trend (30-Day Window)

```
╔══════════════════════════════════════════════════════════════════╗
║                  WEEKLY SIGNUP TREND                             ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Week 1   ████████████████████████   3,200 signups               ║
║  Week 2   ██████████████████████     3,050 signups               ║
║  Week 3   ████████████████████       2,900 signups  ↘ declining  ║
║  Week 4   ███████████████████        2,850 signups  ↘ declining  ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║  MoM growth: <3%  |  Acquisition has plateaued                   ║
║  Growth must now come from conversion efficiency, not volume     ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 6. Key Insights

### Insight 1 — Post-KYC Is the Revenue Leak 🔴

> **~3,000 users completed KYC but never made a first transaction — a 54% stage conversion rate.**

KYC-approved users are the highest-intent, highest-value segment in the entire funnel. They have cleared identity verification and demonstrated commitment. Losing them at the last step before revenue conversion is the most expensive failure in the product.

**Business implication:** Recovering even 20% of these users (~600 activations) at an average LTV of $200 represents **$120,000 in recoverable revenue** — without spending a dollar on new acquisition.

---

### Insight 2 — Acquisition Volume Does Not Equal Activation Quality 🟠

> **Paid channels drive high signup volume but convert at only 44% — 28 points below referral users.**

The data exposes a fundamental misalignment between acquisition investment and activation outcomes. Referral users convert at 72% and likely carry higher retention and LTV. Paid channel users are expensive to acquire and expensive to lose.

**Business implication:** Reallocating 20% of paid acquisition budget into a referral incentive program could materially improve both conversion rate and customer quality simultaneously.

---

### Insight 3 — iOS Is an Underperforming Platform 🟠

> **iOS users convert at 48% — 20 percentage points below Android (68%).**

This gap is too large to be explained by user quality alone. It signals a product experience issue specific to the iOS app — likely friction during the KYC flow, transaction initiation, or a platform-specific bug suppressing completion rates.

**Business implication:** A targeted iOS UX audit and A/B test could close this gap and unlock significant conversion uplift from an already-acquired user base at near-zero marginal cost.

---

### Insight 4 — Growth Is a Conversion Problem, Not an Acquisition Problem 🟡

> **Signup volume has plateaued at <3% MoM growth. The constraint is funnel efficiency, not top-of-funnel volume.**

Adding more users to a leaking funnel accelerates losses, not gains. The data makes a clear case: the highest-ROI investment right now is fixing the post-KYC experience — not increasing acquisition spend.

**Business implication:** A 10-point improvement in post-KYC conversion recovers ~650 additional activations per month — without a single dollar of additional acquisition spend.

---

## 7. Business Recommendations

### Priority Matrix

| Priority | Recommendation | Effort | Impact |
|----------|---------------|--------|--------|
| 🔴 P1 | Fix post-KYC activation experience | Medium | Very High |
| 🟠 P2 | Audit and fix iOS product experience | Medium | High |
| 🟠 P3 | Reallocate acquisition spend to referral | Low | High |
| 🟡 P4 | Re-engage KYC-approved inactive users | Low | Medium |
| 🟡 P5 | Build ongoing funnel monitoring | Low | Medium |

---

### Expected Cumulative Impact

```
╔══════════════════════════════════════════════════════════════════╗
║               PROJECTED IMPACT SUMMARY                           ║
╠══════════════════════════════════════════════════════════════════╣
║                                                                  ║
║  Fix post-KYC experience      +8–12% overall conversion          ║
║  iOS UX improvements          +3–5%  iOS conversion              ║
║  Acquisition reallocation     +5–8%  channel quality             ║
║  Re-engagement campaign       +2–4%  recovered activations       ║
║                                                                  ║
╠══════════════════════════════════════════════════════════════════╣
║  Combined potential: 40% → 52–58% overall funnel conversion      ║
║  WITHOUT increasing acquisition spend                            ║
╚══════════════════════════════════════════════════════════════════╝
```

---

## 8. Dashboard

An interactive **Tableau dashboard** was built to enable stakeholder exploration and self-serve analysis — reducing manual reporting by **40% (~15 hrs/week).**

**Dashboard Features:**
- Full funnel drop-off visualization with stage-by-stage breakdown
- Conversion segmentation by device type and acquisition channel
- Signup trend analysis over the 30-day window
- Parameter-driven filters for dynamic, on-demand analysis
- KPI summary cards for executive reporting

🔗 **[View Interactive Tableau Dashboard](#)** *(Screenshot.png)*

---

## 9. Limitations & Assumptions

> Acknowledging analytical boundaries is a hallmark of rigorous, trustworthy analysis.

| Limitation | Potential Impact | Mitigation Applied |
|------------|-----------------|-------------------|
| Simulated dataset | Distributions may differ from live production data | Methodology mirrors real-world DA workflows |
| 30-day analysis window | Seasonal or cyclical patterns may not be captured | Recommend expanding to 90-day rolling window |
| Expected impact estimates | Directional, not guaranteed outcomes | Based on funnel modeling and industry benchmarks |
| iOS root cause unconfirmed | UX vs. user quality requires further research | A/B testing recommended before acting |
| Last-touch attribution only | Multi-touch channels may be undervalued | Multi-touch attribution recommended for full picture |
| No LTV data available | Revenue impact estimates are approximated | LTV integration recommended for future iteration |

---

## 10. Tools & Technologies

| Tool | Purpose |
|------|---------|
| **SQL (MySQL)** | Data cleaning, EDA, funnel metrics, window functions, CTEs |
| **Tableau** | Interactive dashboard, funnel visualization, stakeholder reporting |
| **Git & GitHub** | Version control and portfolio publishing |

---

## Author

**Dipanshi Dhiman**
Data Analyst | Toronto, Ontario, Canada

Focused on product analytics, funnel optimization, and translating complex data into business decisions that drive measurable growth.

📧 dhimandipanshi713@gmail.com
💼 [LinkedIn](https://www.linkedin.com/in/dipanshidhiman)
🐙 [GitHub](https://github.com/dhimandipanshi)

---

*Portfolio Project — Simulating real-world fintech/SaaS product analytics | Jan 2026*
