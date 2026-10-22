## 1. Purpose

This document defines the financial metrics, operational indicators, and calculation rules used in the Healthcare AR & Revenue Cycle Analysis project.

Its purpose is to ensure that SQL queries produce interpretable results, that financial calculations are applied consistently, and that business conclusions are supported by the underlying data.

The dataset is synthetic and intended for educational and portfolio purposes.

## 2. Dataset Scope

The project uses seven relational tables:

| Table | Purpose |
| --- | --- |
| patients | Patient reference information |
| providers | Healthcare provider information |
| payers | Insurance payer information |
| claims | Claim details, amounts, dates, and statuses |
| payments | Payment transactions and adjustments |
| denials | Claim denial records and appeal information |
| ar_followups | Claim follow-up activities and outcomes |

The analysis combines these tables to investigate outstanding balances, payment activity, claim denials, aging, and follow-up priorities.

## 3. Financial Metric Definitions

### 3.1 Billed Amount

**Definition:** The amount billed by the provider for a claim.

**Source:** `claims.billed_amount`

This represents the submitted charge in the synthetic dataset. It should not automatically be interpreted as the amount collectible from the insurance payer.

### 3.2 Allowed Amount

**Definition:** The allowed amount recorded for a claim.

**Source:** `claims.allowed_amount`

The allowed amount is used as the starting point for the project's simplified remaining-balance calculation.

### 3.3 Total Payments

**Definition:** The sum of recorded payment transactions associated with a claim.

**Calculation:** `SUM(payments.payment_amount)`

Payments are aggregated by `claim_id` before being joined to the claims table.

Claims without payment records are retained using a `LEFT JOIN` and treated as having zero recorded payments for this calculation.

### 3.4 Total Adjustments

**Definition:** The sum of recorded adjustment amounts associated with a claim.

**Calculation:** `SUM(payments.adjustment_amount)`

Adjustments are aggregated by `claim_id`.

The interpretation of individual adjustments depends on the underlying transaction data and accounting context.

### 3.5 Simplified Remaining Allowed Balance

**Definition:** The allowed amount minus recorded payments and recorded adjustments.

**Formula:**
Remaining Allowed Balance = Allowed Amount - Total Payments - Total Adjustments

**SQL expression:**

```sql
ROUND(
    c.allowed_amount
    - COALESCE(ps.total_paid, 0)
    - COALESCE(ps.total_adjustments, 0),
    2
)
```
This is a project-specific analytical measure. It is not a complete healthcare accounting formula and does not independently establish the amount that remains collectible.

Patient responsibility is not automatically subtracted again, because its relationship to individual payment transactions has not been established sufficiently for that calculation.

#### Interpretation

Result | Interpretation

Positive balance | The simplified calculation shows an amount remaining

Zero balance | Recorded payments and adjustments equal the allowed amount

Negative balance | Recorded payments and adjustments exceed the allowed amount; investigate

No payment transactions | No payment transaction is recorded; this does not establish whether the claim is collectible

A positive balance does not necessarily mean that the entire amount is collectible. Denials, contractual obligations, patient responsibility, and other accounting details may affect the interpretation.

### 3.6 Payment Transaction Count

*Definition:* The number of payment records associated with a claim.

*Calculation:* `COUNT(payment_id)`

This metric helps identify claims whose recorded status may be inconsistent with their transaction history.

A claim marked Paid or Partially Paid with zero recorded payment transactions should be investigated.

### 3.7 Denial Count

*Definition:* The number of denial records associated with a claim.

*Calculation:* `COUNT(denial_id)`

This counts denial records, not necessarily unique denial causes. Multiple denial records may relate to the same claim.

A denial amount should not automatically be added to the remaining allowed balance because this may double-count financial exposure.

### 3.8 Follow-up Count

*Definition:* The number of recorded follow-up activities associated with a claim.

*Calculation:* `COUNT(followup_id)`

This indicates recorded follow-up activity. A higher count does not, by itself, prove that a claim was handled effectively.

### 3.9 Latest Follow-up Date

*Definition:* The most recent recorded follow-up date for a claim.

*Calculation:* `MAX(followup_date)`

Claims without follow-up records have no recorded latest follow-up date.

### 3.10 Days Since Submission

*Definition:* The number of calendar days between the claim's submission date and the analysis's reference date.

*Calculation:* `DATEDIFF(reference_date, submission_date)`

For the current validation snapshot, the reference date is *2026-10-16*.

Using a fixed reference date makes the results reproducible. A query using `CURRENT_DATE` may produce different aging results when run on a later date.

### 3.11 Submission Age Categories

The project's aging categories are:

Category | Rule

0–30 days | 30 days or fewer

31–60 days | More than 30 and up to 60 days

61–90 days | More than 60 and up to 90 days

Over 90 days | More than 90 days

These categories measure elapsed time since submission. They do not independently establish payer liability or the remaining time available to appeal a denial.

## 4. Operational Review Categories

The analytical report assigns recommended review categories using claim status, transaction summaries, denial records, and submission age.

Review category | General rule

Data quality review | Paid or Partially Paid claim has no recorded payment transaction

Financial reconciliation review | Calculated remaining balance is negative

Denial review | Claim is Denied and has at least one denial record

High-priority pending review | Pending claim is more than 90 days old

Aging pending review | Pending claim is more than 60 days old but not more than 90 days old

Outstanding balance review | Partially Paid claim has a positive calculated remaining balance

Paid status reconciliation | Paid claim has a positive calculated remaining balance

Routine review | None of the preceding conditions applies


The SQL `CASE` statement determines which category is assigned when multiple conditions apply. Therefore, the order of its conditions is part of the report's logic.

These categories are recommendations for investigation, not proof that an error or recoverable balance exists.

## 5. Validation Principles

The following principles apply throughout the project:

1. Aggregate payment, denial, and follow-up records separately before joining them to claims when necessary.
2. Use `LEFT JOIN` when claims without related transaction records must remain visible.
3. Use `COALESCE` where missing aggregate results should be treated as zero for a particular calculation.
4. Investigate negative balances rather than silently changing the underlying data.
5. Compare claim statuses with transaction records to identify possible inconsistencies.
6. Do not treat a denial amount as an additional balance without checking whether doing so would double-count exposure.
7. Use a fixed reference date when validating aging results.
8. Distinguish confirmed data errors from records that merely require further investigation.
9. Base business conclusions on actual query output, not on assumptions about what the synthetic data should show.
10. Clearly disclose the limitations of the synthetic dataset.

## 6. Known Data Limitations

The following limitations have been identified during validation:

- Some claims marked Paid or Partially Paid have no recorded payment transactions.
- Some claims marked Paid have a positive simplified remaining allowed balance.
- Some claims marked Partially Paid have zero simplified remaining balance.
- Patient responsibility is stored on payment transaction records, so its aggregation and accounting interpretation require care.
- A claim with no payment record should not automatically be interpreted as a claim with no payment activity in the real world.
- The simplified remaining balance does not independently establish the collectible accounts receivable balance.

These issues should be documented and investigated before the results are presented as definitive financial conclusions.

## 7. Scope of This Document

This document defines the metrics and interpretation rules used in the analysis.

The separate findings report will document the actual SQL results, identified exceptions, business implications, and recommendations.

The validation SQL file remains the executable record of the checks performed against the database.
