# Healthcare AR & Revenue Cycle Analysis (MySQL)

A SQL-only portfolio project analyzing synthetic U.S. healthcare claims data to explore accounts receivable (AR), payer performance, denials, payments, aging, and follow-up activity.

The project demonstrates relational database design and practical MySQL analysis relevant to healthcare revenue cycle management (RCM), AR follow-up, reporting, and entry-level data analyst roles.

> **Data disclaimer:** All records are synthetic and created for learning and portfolio demonstration. They do not represent real patients, providers, payers, claims, or actual business performance. Thresholds used to flag claims are illustrative project rules, not universal healthcare standards.

## Project goals

Use SQL to answer questions such as:

- How many claims are in the dataset, and what are their billed and allowed values?
- How are claims distributed across statuses and payers?
- Which claims have the largest calculated outstanding balances?
- How old are claims, and how are balances distributed across aging buckets?
- Which payers and providers have the largest outstanding balances?
- Which denial reasons account for the highest recorded denied amounts?
- Which denied claims are marked as not appealed?
- Which claims have repeated follow-ups?
- How do recorded denial amounts change month over month?
- Which positive-balance claims meet the project's rule-based AR priority criteria?

## Technology

- **Database:** MySQL
- **SQL concepts:** joins, aggregate functions, `CASE`, `COALESCE`, `DATEDIFF`, `DATE_FORMAT`, subqueries, CTEs, `HAVING`, `RANK()`, `DENSE_RANK()`, `ROW_NUMBER()`, and `LAG()`
- **SQL testing environment:** DB Fiddle
- **Version control / portfolio:** GitHub

This project intentionally uses SQL only. Python, Excel, and BI tools are not required to run the analysis.

## Database design

The database contains seven related tables:

| Table | Purpose |
|---|---|
| `patients` | Synthetic patient demographics and insurance identifiers |
| `providers` | Provider names, types, specialties, and states |
| `payers` | Insurance payer names and payer categories |
| `claims` | Central claim table containing dates, billed/allowed amounts, status, and foreign keys |
| `payments` | Payment transactions, adjustments, and patient-responsibility values associated with claims |
| `denials` | Recorded denial events, codes, reasons, amounts, and appeal statuses |
| `ar_followups` | Follow-up activity, dates, types, outcomes, and notes |

`claims` is the central table. It references `patients`, `providers`, and `payers`. The `payments`, `denials`, and `ar_followups` tables reference `claims`.

```text
patients ─────┐
providers ────┼──> claims ────> payments
payers ───────┘        ├──────> denials
                       └──────> ar_followups
```

## Dataset

The current synthetic dataset is expected to contain:

| Table | Expected row count |
|---|---:|
| `patients` | 50 |
| `providers` | 12 |
| `payers` | 10 |
| `claims` | 90 |
| `payments` | 41 |
| `denials` | 22 |
| `ar_followups` | 105 |

Use the validation queries below to verify these counts after importing the schema and seed data. If you change the data, these figures will change.

## Analysis coverage

The analysis is organized into 40 business questions.

| Query range | Focus | Examples |
|---|---|---|
| Q1–Q10 | Core RCM metrics | Claim counts, billed/allowed amounts, status distribution, payer denial rate, initial AR calculation |
| Q11–Q20 | AR and aging | Claim-level balances, age in days, aging buckets, AR by payer, collection-rate calculation, prioritization |
| Q21–Q30 | Denials and follow-ups | Denial reasons and dollars, payer denial analysis, appeal-status distribution, repeat follow-ups |
| Q31–Q35 | Advanced payer/provider analysis | CTEs, payer AR ranking, largest denial reason by payer, provider AR ranking, follow-up frequency |
| Q36–Q37 | Denial trends | Monthly denied amounts and month-over-month change using `LAG()` |
| Q38–Q40 | Advanced account analysis | Above-average balances, claims marked not appealed, consolidated rule-based AR risk report |

## How to run the project

Run the SQL in this order:

1. Create the database and tables using the schema script.
2. Insert reference and claim data for patients, providers, payers, and claims.
3. Insert transaction data for payments, denials, and AR follow-ups.
4. Run validation queries to check row counts and relationships.
5. Run analysis queries Q1–Q40 individually and review the output.

Use a MySQL-compatible environment such as DB Fiddle. MySQL 8.0 or later is recommended for CTEs and window functions.

### Initial validation queries

```sql
SELECT 'patients' AS table_name, COUNT(*) AS row_count FROM patients
UNION ALL
SELECT 'providers', COUNT(*) FROM providers
UNION ALL
SELECT 'payers', COUNT(*) FROM payers
UNION ALL
SELECT 'claims', COUNT(*) FROM claims
UNION ALL
SELECT 'payments', COUNT(*) FROM payments
UNION ALL
SELECT 'denials', COUNT(*) FROM denials
UNION ALL
SELECT 'ar_followups', COUNT(*) FROM ar_followups;
```

Check for orphaned foreign keys. Each query should return zero rows when referential integrity is intact.

```sql
SELECT c.claim_id
FROM claims c
LEFT JOIN patients p ON c.patient_id = p.patient_id
WHERE p.patient_id IS NULL;

SELECT c.claim_id
FROM claims c
LEFT JOIN providers pr ON c.provider_id = pr.provider_id
WHERE pr.provider_id IS NULL;

SELECT c.claim_id
FROM claims c
LEFT JOIN payers py ON c.payer_id = py.payer_id
WHERE py.payer_id IS NULL;

SELECT p.payment_id
FROM payments p
LEFT JOIN claims c ON p.claim_id = c.claim_id
WHERE c.claim_id IS NULL;

SELECT d.denial_id
FROM denials d
LEFT JOIN claims c ON d.claim_id = c.claim_id
WHERE c.claim_id IS NULL;

SELECT f.followup_id
FROM ar_followups f
LEFT JOIN claims c ON f.claim_id = c.claim_id
WHERE c.claim_id IS NULL;
```

## Business logic and metric definitions

Metric definitions matter as much as syntactically correct SQL. Interpret the calculations using these assumptions.

### 1. Claim age

Claim age is calculated as the number of days between `submission_date` and a fixed analysis date:

```sql
DATEDIFF('2026-09-21', submission_date)
```

The fixed date makes results reproducible. Update the date consistently in all queries if you want to analyze the data as of a different date. Negative ages should be investigated as potential data-quality issues.

### 2. Calculated outstanding balance

The analysis uses this project-specific formula:

```text
Calculated balance =
    allowed amount
    - recorded payment amounts
    - recorded adjustment amounts
    - recorded patient-responsibility amounts
```

**Interpretation warning:** This formula is valid only if the payment, adjustment, and patient-responsibility fields are populated consistently and are not duplicated across transaction rows. In a real revenue-cycle ledger, payer AR and patient AR should be modeled separately. Patient responsibility is often part of the remaining patient balance rather than an amount that should automatically be subtracted when calculating total AR. Confirm the meaning and grain of each field and reconcile balances to the source ledger before using such a metric for real decisions.

The queries call the result `outstanding_ar` for consistency, but it is a simplified calculated balance—not an audited financial balance.

### 3. Denial amounts and denial counts

- `denial_count` counts denial records unless a query explicitly counts distinct claim IDs.
- `denial_amount` is the amount recorded on denial records.
- Summing denial amounts measures **recorded denied-dollar exposure**. It does not establish the amount still unpaid, the amount recovered, or the final financial loss.
- If a claim can have multiple denial events, summing event amounts may count the same claim's exposure more than once. A production analysis should define whether it measures denial events, unique denied claims, or unrecovered denial balances.

### 4. Appeal resolution versus recovery

A denial marked `Resolved` is not automatically a successful appeal or a recovered payment. The dataset does not, by itself, establish that a specific payment was caused by a specific appeal. Resolution-rate queries therefore describe recorded statuses, not a verified cash recovery rate.

A future version could add denial-event history, appeal dates and outcomes, payer adjudication events, and a traceable link between denial resolution and subsequent payment transactions.

### 5. Collection rate

The project demonstrates a simplified ratio:

```text
Recorded payment amount / allowed amount × 100
```

This is a learning metric, not a universally standardized collection-rate definition. Real organizations may distinguish gross collections, net collections, contractual adjustments, patient collections, and performance for a defined claim cohort or time period. The numerator and denominator should match the business question.

### 6. Priority categories

The risk report uses illustrative thresholds based on claim age and calculated balance. They demonstrate `CASE` expressions and worklist prioritization. They do not replace payer-specific timely-filing rules, appeal deadlines, contractual terms, or an organization's operational policy.

## Key SQL practices demonstrated

- **Pre-aggregation before joins:** Payment, denial, and follow-up tables can each contain multiple rows per claim. Aggregate them to claim level before joining them together to avoid multiplying amounts and counts.
- **`LEFT JOIN`:** Preserve claims that have no recorded payment or follow-up transaction.
- **`COALESCE`:** Treat missing aggregate values as zero where appropriate.
- **`COUNT(DISTINCT ...)`:** Count unique claims when multiple related records may exist.
- **CTEs:** Separate complex logic into readable steps.
- **Window functions:** Rank payers/providers and compare monthly values with `LAG()`.
- **Transparent assumptions:** Distinguish recorded data, calculated metrics, and business interpretations.

## Limitations and next improvements

This is a portfolio-learning dataset, not a production healthcare billing system. It has a small synthetic sample, simplified claim statuses, and limited event history. Results should not be generalized to real payers or providers.

Potential improvements:

1. Model payer AR and patient AR separately instead of using one simplified balance formula.
2. Add a claim-status history table to reconstruct status changes over time.
3. Link denial events, appeals, and subsequent payments to measure verified denial recovery.
4. Add payer-specific filing and appeal deadlines.
5. Add a calendar table so monthly reports include months with zero events.
6. Add automated reconciliation checks and documented expected outcomes for selected test cases.
7. Record the exact MySQL version and keep schema, seed data, validation, and analysis scripts in separate files.

## Suggested repository structure

```text
healthcare-ar-revenue-cycle-analysis/
├── README.md
├── sql/
│   ├── 01_schema.sql
│   ├── 02_reference_and_claim_data.sql
│   ├── 03_transactions_and_followups.sql
│   ├── 04_validation_checks.sql
│   └── 05_analysis_queries.sql
└── docs/
    └── metric_definitions.md
```

Adjust filenames to match the files actually uploaded. Do not include a script in the run order until it exists in the repository.

## Portfolio summary

**Healthcare AR & Revenue Cycle Analysis | MySQL**

Designed a relational database with seven connected tables and analyzed synthetic claims, payment transactions, denials, and AR follow-ups. Developed 40 SQL analyses covering claim metrics, calculated outstanding balances, aging buckets, payer/provider comparisons, denial patterns, follow-up activity, monthly trends, and rule-based AR prioritization. Applied joins, aggregations, subqueries, CTEs, and window functions while documenting metric assumptions and data-quality limitations.

---

**Disclaimer:** This project is for educational and portfolio purposes only. It is not medical, billing, reimbursement, legal, or financial advice, and it contains no real patient information.
