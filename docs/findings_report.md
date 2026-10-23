# Healthcare AR & Revenue Cycle Analysis

## Findings and Business Interpretation

## 1. Purpose

This report documents the findings from the Healthcare AR & Revenue Cycle Analysis project, which uses MySQL to analyze a synthetic U.S. healthcare claims dataset.

The analysis examines claim statuses, payment transactions, calculated financial balances, payer performance, denials, follow-up activity, and claim prioritization.

The purpose is to translate SQL results into business-relevant observations while distinguishing recorded data from calculated metrics and conclusions that require further investigation.

**Dataset disclaimer:** All data is synthetic and intended for educational and portfolio purposes. The findings do not represent the actual performance of healthcare providers or insurance payers.

---

## 2. Dataset Overview

The database contains seven related tables:

| Table        | Expected records |
| ------------ | ---------------: |
| patients     |               50 |
| providers    |               12 |
| payers       |               10 |
| claims       |               90 |
| payments     |               41 |
| denials      |               22 |
| ar_followups |              105 |

These are the expected dataset counts. They should be confirmed using the validation queries before publication.

The `claims` table is the central table, linked to patients, providers, and payers. Payment transactions, denials, and follow-up activities are recorded in separate tables.

---

## 3. Financial Analysis and Reconciliation

### 3.1 Simplified remaining-balance calculation

The project calculates a simplified remaining allowed balance:

`Allowed Amount - Recorded Payments - Recorded Adjustments`

Payment transactions and adjustments are aggregated by claim before being joined to the claims table.

This approach helps prevent payment totals from being multiplied when claims have multiple transactions.

The result is a project-specific reconciliation measure. It is not an audited financial balance or a definitive measure of collectible accounts receivable.

### 3.2 Reconciliation summary

The validation analysis produced the following results:

| Reconciliation category  | Claims | Total allowed amount | Calculated balance |
| ------------------------ | -----: | -------------------: | -----------------: |
| No payment transactions  |     53 |             $268,950 |           $268,950 |
| Fully reconciled to zero |     31 |             $137,330 |                 $0 |
| Positive balance remains |      6 |              $29,500 |             $3,250 |
| **Total**                | **90** |         **$435,780** |       **$272,200** |

These figures describe the simplified reconciliation output.

The $272,200 total calculated balance must not be interpreted as confirmed collectible AR. The 53 claims without payment transactions include pending, denied, paid, and partially paid claims.

### 3.3 Claims with inconsistent recorded statuses

Eight claims were identified as having no recorded payment transactions despite being marked Paid or Partially Paid.

Two are marked Paid, and six are marked Partially Paid.

The combined allowed amount for these claims is $40,850.

This finding indicates a discrepancy between the recorded claim statuses and the available payment transaction history. It does not establish whether payments occurred outside the dataset or whether the claim statuses are incorrect.

These records should be treated as data-quality exceptions.

### 3.4 Additional reconciliation exceptions

Claim `50042` is marked Paid but has a calculated remaining balance of $200.

Claim `50006` is marked Partially Paid but has a calculated remaining balance of zero.

These cases illustrate why claim statuses and calculated balances should be checked separately. Neither condition, by itself, establishes the correct operational or accounting status.

---

## 4. Pending Claims and Payer Analysis

### 4.1 Pending claims without recorded payments

The validation analysis identified 23 pending claims without payment transactions.

Their combined allowed amount is $141,800.

The payer-level results were:

| Payer             | Pending claims | Total allowed amount | Average age at reporting date |
| ----------------- | -------------: | -------------------: | ----------------------------: |
| UnitedHealthcare  |              8 |              $47,250 |                    180.1 days |
| Medicare          |              5 |              $39,250 |                    197.6 days |
| Centene           |              2 |              $15,150 |                    214.5 days |
| Kaiser Permanente |              3 |              $14,500 |                    194.0 days |
| Cigna             |              3 |              $11,750 |                    180.0 days |
| Humana            |              1 |              $10,600 |                    152.0 days |
| Aetna             |              1 |               $3,300 |                    210.0 days |
| **Total**         |         **23** |         **$141,800** |                             — |

Claim age was calculated using a fixed reporting date of 16 October 2026.

### 4.2 Interpretation

UnitedHealthcare has the highest pending-claim count and total allowed amount in this subset.

Medicare has the second-highest total allowed amount. Centene has the highest average age among these payer groups, based on two claims.

These results help identify where an analyst might investigate the largest concentration of older pending claims.

They do not establish that any payer has poor real-world processing performance. The sample is synthetic, and the results depend on the records included in the dataset.

### 4.3 Recommended investigation

Claims should be prioritized using a combination of age, financial value, denial history, follow-up activity, and recorded status.

Claim age and allowed amount alone are not sufficient to establish collectibility or determine the appropriate next action.

---

## 5. Denial Analysis

### 5.1 Denial reasons and recorded denied amounts

The denial analysis produced the following results:

| Denial reason                   | Recorded denied amount | Claims represented |
| ------------------------------- | ---------------------: | -----------------: |
| Prior authorization required    |                $54,200 |                  5 |
| Incorrect procedure or modifier |                $19,500 |                  5 |
| Missing or invalid information  |                $10,300 |                  5 |
| Timely filing limit exceeded    |                 $6,650 |                  3 |
| Missing documentation           |                 $4,000 |                  2 |
| Duplicate claim                 |                 $3,950 |                  2 |
| **Total**                       |            **$98,600** |             **22** |

These amounts represent the sum of the recorded denial amounts in the dataset.

They do not establish the final financial loss, the amount still unpaid, or the amount ultimately recoverable.

### 5.2 Main finding: Prior authorization

Prior authorization is the largest denial category, representing $54,200, or approximately 54.97% of the recorded denied amount.

All five associated claims are marked Appealed, and none is marked Resolved in the denial records.

This category warrants investigation into appeal progress and the supporting authorization information.

The dataset does not establish whether these appeals succeeded.

### 5.3 Timely filing and duplicate claims

Three claims totaling $6,650 are recorded under timely filing denials, and all three are marked Not Appealed.

Two claims totaling $3,950 are recorded as duplicate claims, and both are marked Not Appealed.

These categories warrant review, but the appropriate action may differ by denial reason. The availability of an appeal or other remedy depends on the circumstances and applicable rules.

### 5.4 Recorded appeal statuses

The denial analysis groups the recorded denied amounts by appeal status:

| Recorded appeal status | Denied amount |
| ---------------------- | ------------: |
| Not Appealed           |       $12,400 |
| Appealed               |       $72,100 |
| Resolved               |       $14,100 |
| **Total**              |   **$98,600** |

A status of Resolved does not prove that the denied amount was recovered.

The dataset does not explicitly link each denial event to a subsequent payment in a way that establishes verified recovery.

---

## 6. Denial Exposure by Payer

The payer-level denial analysis produced the following results:

| Payer                  | Denied claims | Recorded denied amount | Share of recorded denied amount |
| ---------------------- | ------------: | ---------------------: | ------------------------------: |
| Humana                 |             6 |                $63,900 |                          64.81% |
| Medicare               |             8 |                $17,400 |                          17.65% |
| Molina Healthcare      |             7 |                $13,000 |                          13.18% |
| Blue Cross Blue Shield |             1 |                 $4,300 |                           4.36% |
| **Total**              |        **22** |            **$98,600** |                     **100.00%** |

Humana accounts for the largest recorded denied amount in this synthetic dataset, while Medicare has the highest denied-claim count among the listed payer groups.

These are different measures: claim volume describes how many claims are affected, while denied amount describes their recorded financial exposure.

The results must not be interpreted as real-world payer denial rates. Calculating a denial rate would require an appropriate denominator, such as the number of claims submitted to each payer for the same reporting cohort.

---

## 7. Claim Prioritization

The consolidated claim-prioritization query combines claim details with aggregated payment, denial, and follow-up information.

It assigns illustrative review categories, including:

* Data quality review
* Financial reconciliation review
* Denial review
* High-priority pending review
* Aging pending review
* Outstanding balance review
* Paid status reconciliation
* Routine review

The report uses a fixed reporting date of 16 October 2026 to calculate claim age.

The category rules are intended to demonstrate SQL-based prioritization. They are not universal healthcare billing standards and do not replace payer-specific deadlines, contractual requirements, or organizational policies.

The results should be used to identify records for investigation, not to automatically determine whether a claim is collectible.

---

## 8. Data-Quality Findings

The validation work identified several limitations requiring attention:

1. Eight Paid or Partially Paid claims have no recorded payment transactions.
2. Some claims marked Paid have a positive calculated remaining balance.
3. Some claims marked Partially Paid have a zero calculated remaining balance.
4. Claims without payment transactions include several different operational statuses.
5. Some denied claims have no recorded follow-up activity.
6. Patient responsibility is stored on payment transaction records, so its aggregation requires careful interpretation.
7. Denial resolution status does not independently establish successful recovery.

These observations distinguish SQL execution from analytical validity: a query may run successfully while the underlying records still require investigation.

---

## 9. Business Recommendations

Based on the synthetic dataset, the following investigative priorities are appropriate:

### Priority 1: Reconcile inconsistent claim statuses

Review claims marked Paid or Partially Paid that have no recorded payment transactions.

Confirm whether the source data is incomplete or whether the recorded statuses need correction.

### Priority 2: Investigate older pending claims

Review older, higher-value pending claims, including their submission dates, payer responses, and follow-up histories.

Do not treat their full allowed amounts as confirmed collectible balances.

### Priority 3: Examine prior-authorization denials

Investigate the five prior-authorization denial records representing $54,200 in recorded denied amounts.

Review the recorded appeal statuses and supporting information before drawing conclusions about recovery.

### Priority 4: Review unappealed denial records

Investigate timely filing and duplicate-claim denials marked Not Appealed.

Determine whether further action is appropriate for each individual record.

### Priority 5: Improve transaction traceability

A future version of the database could link denial events and appeal outcomes to subsequent payment transactions.

This would make it easier to distinguish recorded denial resolution from verified financial recovery.

---

## 10. Limitations

This project uses a small synthetic dataset designed for SQL practice.

The database does not contain a complete production revenue-cycle ledger, detailed claim-status history, payer-specific deadlines, or an explicit event-level link between denial resolution and subsequent payments.

The simplified remaining-balance calculation is not an audited AR measure.

The analysis demonstrates how SQL can support investigation and reporting, but its findings must not be generalized to actual healthcare providers, patients, or insurance payers.

---

## 11. Conclusion

This project demonstrates how relational database design and SQL analysis can be used to investigate healthcare claims, payment transactions, denial patterns, payer-level financial exposure, and claim follow-up activity.

It also demonstrates the importance of validating calculations and examining data quality before translating query output into business conclusions.

The project combines practical SQL techniques with transparent metric definitions and explicit limitations, providing a foundation for further development in healthcare reporting, revenue-cycle analysis, and entry-level data analytics.

---

## 12. Validation Status

This report includes findings established during the documented validation work.

The remaining original analysis queries should be cross-checked against their actual SQL definitions and outputs before the report is considered final. Any additional findings should be added only when their calculations, assumptions, and interpretations have been verified.
