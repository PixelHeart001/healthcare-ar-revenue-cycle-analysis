-- =====================================================
-- Project: Healthcare AR & Revenue Cycle Analysis
-- File: 04_validation_checks.sql
-- Database: healthcare_ar_analysis
--
-- Purpose:
-- Validate row counts, foreign-key relationships,
-- and basic data quality.
-- =====================================================

USE healthcare_ar_analysis;


-- =====================================================
-- CHECK 1: TABLE ROW COUNTS
-- Expected counts for the original dataset:
-- patients: 50
-- providers: 12
-- payers: 10
-- claims: 90
-- payments: 41
-- denials: 22
-- ar_followups: 105
-- =====================================================

SELECT 'patients' AS table_name,
       COUNT(*) AS row_count
FROM patients

UNION ALL

SELECT 'providers', COUNT(*)
FROM providers

UNION ALL

SELECT 'payers', COUNT(*)
FROM payers

UNION ALL

SELECT 'claims', COUNT(*)
FROM claims

UNION ALL

SELECT 'payments', COUNT(*)
FROM payments

UNION ALL

SELECT 'denials', COUNT(*)
FROM denials

UNION ALL

SELECT 'ar_followups', COUNT(*)
FROM ar_followups;


-- =====================================================
-- CHECK 2: CLAIMS WITHOUT VALID PATIENTS
-- Expected result: zero rows
-- =====================================================

SELECT c.claim_id, c.patient_id
FROM claims c
LEFT JOIN patients p
    ON c.patient_id = p.patient_id
WHERE p.patient_id IS NULL;


-- =====================================================
-- CHECK 3: CLAIMS WITHOUT VALID PROVIDERS
-- Expected result: zero rows
-- =====================================================

SELECT c.claim_id, c.provider_id
FROM claims c
LEFT JOIN providers pr
    ON c.provider_id = pr.provider_id
WHERE pr.provider_id IS NULL;


-- =====================================================
-- CHECK 4: CLAIMS WITHOUT VALID PAYERS
-- Expected result: zero rows
-- =====================================================

SELECT c.claim_id, c.payer_id
FROM claims c
LEFT JOIN payers py
    ON c.payer_id = py.payer_id
WHERE py.payer_id IS NULL;


-- =====================================================
-- CHECK 5: PAYMENTS WITHOUT VALID CLAIMS
-- Expected result: zero rows
-- =====================================================

SELECT p.payment_id, p.claim_id
FROM payments p
LEFT JOIN claims c
    ON p.claim_id = c.claim_id
WHERE c.claim_id IS NULL;


-- =====================================================
-- CHECK 6: DENIALS WITHOUT VALID CLAIMS
-- Expected result: zero rows
-- =====================================================

SELECT d.denial_id, d.claim_id
FROM denials d
LEFT JOIN claims c
    ON d.claim_id = c.claim_id
WHERE c.claim_id IS NULL;


-- =====================================================
-- CHECK 7: FOLLOW-UPS WITHOUT VALID CLAIMS
-- Expected result: zero rows
-- =====================================================

SELECT f.followup_id, f.claim_id
FROM ar_followups f
LEFT JOIN claims c
    ON f.claim_id = c.claim_id
WHERE c.claim_id IS NULL;


-- =====================================================
-- CHECK 8: CLAIM STATUS DISTRIBUTION
-- Inspect the distribution of claim statuses.
-- =====================================================

SELECT
    claim_status,
    COUNT(*) AS claim_count
FROM claims
GROUP BY claim_status
ORDER BY claim_count DESC;


-- =====================================================
-- CHECK 9: PAYMENT TOTALS
-- Inspect payment, adjustment, and patient-responsibility
-- amounts separately.
-- =====================================================

SELECT
    COUNT(*) AS payment_transactions,

    ROUND(
        COALESCE(SUM(payment_amount), 0),
        2
    ) AS total_payments,

    ROUND(
        COALESCE(SUM(adjustment_amount), 0),
        2
    ) AS total_adjustments,

    ROUND(
        COALESCE(SUM(patient_responsibility), 0),
        2
    ) AS total_patient_responsibility

FROM payments;


-- =====================================================
-- CHECK 10: CLAIM DATE QUALITY
-- Identify claims whose dates appear out of sequence.
-- Review these records rather than assuming they are valid.
-- =====================================================

SELECT
    claim_id,
    service_date,
    claim_date,
    submission_date

FROM claims

WHERE service_date > claim_date
   OR claim_date > submission_date

ORDER BY claim_id;


-- =====================================================
-- END OF VALIDATION SCRIPT
-- =====================================================
