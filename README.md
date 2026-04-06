# 📊 Activation Funnel Optimization Analysis (Fintech SaaS)

*Improving onboarding-to-transaction conversion through data-driven funnel insights*

---

## 🚀 Executive Summary

User activation has plateaued at ~40% despite stable acquisition, indicating inefficiencies within the onboarding funnel. To identify root causes, I analyzed **1M+ event records across 12,000+ users** using SQL and built a Tableau dashboard to track progression from **Signup → First Transaction**.

The analysis revealed that the **largest revenue opportunity lies in improving post-KYC conversion**, where over **25% of verified users drop off before completing their first transaction**. Additional inefficiencies were identified in **iOS performance** and **low-quality paid acquisition channels**.

To improve conversion and revenue without increasing acquisition spend, the following optimizations are recommended:

- Enhancing post-KYC user experience with clearer guidance and nudges  
- Implementing reminder campaigns (email/push) for high-intent users  
- Reallocating spend toward high-converting referral channels  
- Optimizing iOS onboarding experience through UX improvements  

📈 These improvements are expected to increase overall conversion to **52–58%**, unlocking significant incremental revenue.

---

## 🧩 Business Problem

Despite stable user acquisition, only ~40% of users complete onboarding and perform their first transaction.

**Core Question:**  
Where are users dropping off in the onboarding funnel, and how can product and growth teams improve conversion at the highest-impact stages?

---

## 🔍 Methodology

- **SQL:** Extracted, cleaned, and transformed 1M+ event-level records using CTEs, joins, and window functions  
- **Tableau Dashboard:** Built interactive funnel visualizations to track stage-wise conversion and segmentation  
- **Funnel Analysis:** Evaluated drop-offs across onboarding stages segmented by **device type** and **acquisition channel**  
- **Data Validation:** Ensured 95%+ accuracy via deduplication, staging tables, and timestamp normalization  

---

## 🛠️ Skills Used

- **SQL:** CTEs, Joins, Window Functions, Data Cleaning, Aggregations  
- **Tableau:** Dashboard Design, KPI Tracking, Funnel Visualization, Filters  
- **Analytics:** Funnel Analysis, Segmentation, KPI Design, Business Insights  

---

## 📊 Results & Key Insights

### 🔑 Key Findings

- ~3,000 users lost post-KYC (**largest drop-off point**)  
- iOS conversion: **48% vs Android: 68%** → major performance gap  
- Paid channels: **44% conversion vs Referral: 72%** → low ROI acquisition  
- Dashboard reduced manual reporting by **~40% (~15 hours/week)** through self-serve analytics  

---

## 💡 Business Recommendations

Since the highest revenue impact comes from improving **post-KYC conversion and user quality**, the following actions are recommended:

### 1. Improve Post-KYC Experience
- Add clear next-step guidance after KYC approval  
- Introduce progress indicators and frictionless transaction flow  
- Reinforce value proposition before first transaction  

---

### 2. Re-engage High-Intent Users
- Trigger email and push notifications for KYC-approved inactive users  
- Use urgency-based messaging to drive activation  

---

### 3. Optimize iOS Experience
- Conduct UX audit to identify friction points  
- Run A/B tests on onboarding and transaction flows  

---

### 4. Rebalance Acquisition Strategy
- Shift budget from paid channels to referral programs  
- Incentivize high-quality user acquisition  

---

## 📈 Business Impact

- +8–12% uplift from post-KYC optimization  
- +3–5% uplift from iOS improvements  
- +5–8% uplift from acquisition mix optimization  

🎯 **Projected Outcome:**  
Increase overall funnel conversion from **40% → 52–58%** without increasing acquisition spend.

---

## 🔭 Next Steps

- A/B test onboarding and post-KYC improvements  
- Launch re-engagement campaigns for inactive verified users  
- Perform iOS-specific UX testing and debugging  
- Track campaign performance (CTR, open rate, conversion lift)  
- Extend analysis to a 90-day rolling window for trend validation  

---

## 🧾 Summary

This analysis demonstrates that **growth is constrained by conversion efficiency rather than acquisition volume**. By optimizing high-impact funnel stages, the business can unlock significant revenue gains with minimal incremental cost.

It also highlights how **funnel analytics + dashboarding + segmentation** can directly influence product strategy and decision-making at scale.
