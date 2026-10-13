-- =====================================================
-- Project: Healthcare AR & Revenue Cycle Analysis
-- File: 03_transactions_and_followups.sql
-- Database: healthcare_ar_analysis
--
-- Purpose:
-- Insert synthetic payment transactions, denial records,
-- and AR follow-up activity.
--
-- Tables populated:
-- 1. payments
-- 2. denials
-- 3. ar_followups
--
-- Expected records:
-- 41 payments
-- 22 denials
-- 105 follow-ups
--
-- Data is synthetic and for educational purposes only.
-- =====================================================

USE healthcare_ar_analysis;

INSERT INTO payments
(payment_id, claim_id, payment_date, payment_amount,
 adjustment_amount, patient_responsibility)
VALUES

-- Fully paid claims
(70001,50001,'2026-01-28',4200.00,480.00,520.00),
(70002,50002,'2026-02-02',2700.00,300.00,400.00),
(70003,50005,'2026-02-05',5850.00,650.00,700.00),
(70004,50008,'2026-02-10',1710.00,190.00,200.00),
(70005,50010,'2026-02-15',3645.00,405.00,450.00),

-- Partial payment
(70006,50006,'2026-02-18',2500.00,500.00,700.00),
(70007,50006,'2026-03-05',600.00,100.00,200.00),

(70008,50014,'2026-02-28',2300.00,500.00,600.00),

-- Paid
(70009,50016,'2026-03-01',2475.00,275.00,350.00),
(70010,50018,'2026-03-08',3780.00,420.00,500.00),

-- Partial
(70011,50021,'2026-03-15',3500.00,700.00,500.00),
(70012,50021,'2026-04-02',700.00,100.00,200.00),

-- Paid
(70013,50024,'2026-03-20',6120.00,680.00,800.00),
(70014,50026,'2026-03-25',2925.00,325.00,350.00),

-- Partial
(70015,50028,'2026-04-01',1900.00,400.00,650.00),

-- Paid
(70016,50030,'2026-04-10',3555.00,395.00,450.00),

-- Paid
(70017,50032,'2026-04-12',2115.00,235.00,250.00),

-- Paid
(70018,50034,'2026-04-18',4140.00,460.00,500.00),

-- Partial
(70019,50036,'2026-04-20',5000.00,600.00,850.00),
(70020,50036,'2026-05-03',900.00,150.00,300.00),

-- Paid
(70021,50037,'2026-04-25',4770.00,530.00,600.00),
(70022,50040,'2026-05-01',2835.00,315.00,350.00),

-- Partial
(70023,50042,'2026-05-06',3500.00,400.00,700.00),

-- Paid
(70024,50044,'2026-05-10',2340.00,260.00,300.00),

-- Partial
(70025,50045,'2026-05-15',4500.00,500.00,600.00),
(70026,50045,'2026-06-02',500.00,100.00,200.00),

-- Paid
(70027,50048,'2026-05-18',6390.00,710.00,800.00),

-- Paid
(70028,50050,'2026-05-22',3060.00,340.00,400.00),

-- April/May/June claims
(70029,50052,'2026-05-12',3375.00,375.00,450.00),
(70030,50056,'2026-05-20',2160.00,240.00,300.00),
(70031,50058,'2026-05-25',4455.00,495.00,550.00),
(70032,50061,'2026-05-30',5085.00,565.00,650.00),
(70033,50065,'2026-06-04',7605.00,845.00,950.00),
(70034,50068,'2026-06-08',2340.00,260.00,300.00),
(70035,50072,'2026-06-15',6930.00,770.00,900.00),
(70036,50074,'2026-06-18',3195.00,355.00,400.00),
(70037,50078,'2026-06-25',3690.00,410.00,500.00),
(70038,50080,'2026-06-28',2520.00,280.00,300.00),
(70039,50082,'2026-07-03',4770.00,530.00,600.00),
(70040,50086,'2026-07-12',3330.00,370.00,400.00),
(70041,50089,'2026-07-15',8190.00,910.00,1000.00);

INSERT INTO denials
(denial_id, claim_id, denial_date, denial_code,
 denial_reason, denial_amount, appeal_status)
VALUES

(80001,50003,'2026-01-20','CO-16',
 'Missing or invalid information','1800.00','Not Appealed'),

(80002,50007,'2026-01-25','CO-197',
 'Prior authorization required','9500.00','Appealed'),

(80003,50011,'2026-02-10','CO-4',
 'Incorrect procedure or modifier','1600.00','Resolved'),

(80004,50015,'2026-02-15','CO-29',
 'Timely filing limit exceeded','2300.00','Not Appealed'),

(80005,50019,'2026-02-20','CO-197',
 'Prior authorization required','10200.00','Appealed'),

(80006,50023,'2026-03-01','CO-16',
 'Missing or invalid information','1900.00','Resolved'),

(80007,50027,'2026-03-10','CO-18',
 'Duplicate claim','2100.00','Not Appealed'),

(80008,50031,'2026-03-15','CO-4',
 'Incorrect procedure or modifier','9700.00','Appealed'),

(80009,50035,'2026-03-20','CO-16',
 'Missing documentation','1750.00','Resolved'),

(80010,50039,'2026-03-28','CO-29',
 'Timely filing limit exceeded','2250.00','Not Appealed'),

(80011,50043,'2026-04-05','CO-197',
 'Prior authorization required','10800.00','Appealed'),

(80012,50047,'2026-04-12','CO-16',
 'Missing or invalid information','1850.00','Resolved'),

(80013,50051,'2026-04-20','CO-4',
 'Incorrect procedure or modifier','1950.00','Appealed'),

(80014,50055,'2026-04-28','CO-197',
 'Prior authorization required','11200.00','Appealed'),

(80015,50059,'2026-05-08','CO-18',
 'Duplicate claim','1850.00','Not Appealed'),

(80016,50063,'2026-05-15','CO-16',
 'Missing or invalid information','2400.00','Resolved'),

(80017,50066,'2026-05-20','CO-4',
 'Incorrect procedure or modifier','4300.00','Appealed'),

(80018,50071,'2026-06-08','CO-29',
 'Timely filing limit exceeded','2100.00','Not Appealed'),

(80019,50075,'2026-06-18','CO-16',
 'Missing documentation','2250.00','Resolved'),

(80020,50079,'2026-06-25','CO-197',
 'Prior authorization required','12500.00','Appealed'),

(80021,50083,'2026-07-02','CO-4',
 'Incorrect procedure or modifier','1950.00','Appealed'),

(80022,50087,'2026-07-10','CO-16',
 'Missing or invalid information','2350.00','Resolved');
 
 INSERT INTO ar_followups
(followup_id, claim_id, followup_date,
 followup_type, followup_status,
 days_since_submission, notes)
VALUES

-- Claim 50003 - repeated follow-up
(90001,50003,'2026-01-15','Payer Call','Pending',7,
 'Claim status checked; denial under review'),

(90002,50003,'2026-01-25','Payer Call','Escalated',17,
 'Payer confirmed missing information'),

(90003,50003,'2026-02-05','Documentation Request','Completed',28,
 'Requested missing clinical documentation'),

(90004,50003,'2026-02-20','Resubmission','Submitted',43,
 'Corrected claim resubmitted'),

-- Claim 50004
(90005,50004,'2026-01-20','Portal Check','Pending',10,
 'Claim still under payer review'),

(90006,50004,'2026-02-10','Payer Call','Pending',31,
 'Payer requested additional processing time'),

(90007,50004,'2026-03-01','Payer Call','Escalated',50,
 'Claim escalated due to prolonged pending status'),

-- Claim 50007 denial
(90008,50007,'2026-01-20','Payer Call','Denied',4,
 'Payer confirmed authorization issue'),

(90009,50007,'2026-02-01','Appeal','Submitted',16,
 'Appeal submitted with supporting documentation'),

(90010,50007,'2026-02-20','Payer Call','Pending',35,
 'Appeal still under review'),

(90011,50007,'2026-03-10','Payer Call','Resolved',53,
 'Appeal approved; payment expected'),

-- Claim 50009
(90012,50009,'2026-01-25','Payer Call','Pending',5,
 'Claim received by payer'),

(90013,50009,'2026-02-15','Payer Call','Pending',26,
 'Processing delayed'),

(90014,50009,'2026-03-05','Payer Call','Escalated',44,
 'Escalated due to aging'),

-- Claim 50012
(90015,50012,'2026-02-01','Portal Check','Pending',6,
 'Claim received'),

(90016,50012,'2026-02-20','Payer Call','Pending',25,
 'Payer requested additional review'),

(90017,50012,'2026-03-20','Payer Call','Escalated',54,
 'Supervisor escalation initiated'),

-- Claim 50017
(90018,50017,'2026-02-10','Payer Call','Pending',4,
 'Claim in payer processing'),

(90019,50017,'2026-03-01','Payer Call','Pending',23,
 'No payment posted'),

(90020,50017,'2026-03-25','Payer Call','Escalated',47,
 'Aged claim escalated'),

-- Claim 50019
(90021,50019,'2026-02-15','Payer Call','Denied',5,
 'Authorization missing'),

(90022,50019,'2026-02-25','Appeal','Submitted',15,
 'Appeal submitted'),

(90023,50019,'2026-03-15','Payer Call','Pending',33,
 'Appeal pending'),

(90024,50019,'2026-04-05','Payer Call','Resolved',54,
 'Appeal approved'),

-- Claim 50022
(90025,50022,'2026-02-20','Portal Check','Pending',4,
 'Claim received'),

(90026,50022,'2026-03-15','Payer Call','Pending',27,
 'Still processing'),

-- Claim 50025
(90027,50025,'2026-02-28','Payer Call','Pending',6,
 'Claim received'),

(90028,50025,'2026-03-20','Payer Call','Escalated',26,
 'Aging beyond expected processing time'),

(90029,50025,'2026-04-15','Payer Call','Pending',52,
 'Payer requested additional time'),

-- Claim 50029
(90030,50029,'2026-03-10','Payer Call','Pending',8,
 'Claim received'),

(90031,50029,'2026-04-01','Payer Call','Pending',30,
 'Claim still processing'),

(90032,50029,'2026-04-25','Payer Call','Escalated',54,
 'Escalated due to aging'),

-- Claim 50031 denial
(90033,50031,'2026-03-15','Payer Call','Denied',9,
 'Incorrect modifier'),

(90034,50031,'2026-03-25','Appeal','Submitted',19,
 'Corrected documentation submitted'),

(90035,50031,'2026-04-15','Payer Call','Pending',40,
 'Appeal under review'),

(90036,50031,'2026-05-01','Payer Call','Resolved',56,
 'Appeal approved'),

-- Claim 50033
(90037,50033,'2026-03-15','Payer Call','Pending',5,
 'Claim received'),

(90038,50033,'2026-04-05','Payer Call','Pending',26,
 'No payment received'),

(90039,50033,'2026-04-30','Payer Call','Escalated',51,
 'Aged claim escalated'),

-- Claim 50038
(90040,50038,'2026-03-25','Portal Check','Pending',5,
 'Claim received'),

(90041,50038,'2026-04-15','Payer Call','Pending',26,
 'Still under review'),

-- Claim 50041
(90042,50041,'2026-04-01','Payer Call','Pending',6,
 'Claim received'),

(90043,50041,'2026-04-25','Payer Call','Pending',30,
 'Processing delayed'),

(90044,50041,'2026-05-20','Payer Call','Escalated',55,
 'Escalated due to aging'),

-- Claim 50043
(90045,50043,'2026-04-05','Payer Call','Denied',6,
 'Authorization required'),

(90046,50043,'2026-04-15','Appeal','Submitted',16,
 'Appeal submitted'),

(90047,50043,'2026-05-05','Payer Call','Pending',36,
 'Appeal still pending'),

(90048,50043,'2026-05-25','Payer Call','Resolved',56,
 'Appeal approved'),

-- Claim 50046
(90049,50046,'2026-04-10','Payer Call','Pending',5,
 'Claim received'),

(90050,50046,'2026-05-01','Payer Call','Pending',26,
 'No payment posted'),

(90051,50046,'2026-05-25','Payer Call','Escalated',50,
 'Escalated to payer supervisor'),

-- Claim 50047
(90052,50047,'2026-04-12','Payer Call','Denied',5,
 'Missing information'),

(90053,50047,'2026-04-20','Documentation Request','Submitted',13,
 'Requested missing documentation'),

(90054,50047,'2026-05-05','Resubmission','Submitted',28,
 'Corrected claim submitted'),

-- Claim 50049
(90055,50049,'2026-04-15','Payer Call','Pending',4,
 'Claim received'),

(90056,50049,'2026-05-10','Payer Call','Pending',29,
 'Processing delayed'),

(90057,50049,'2026-06-01','Payer Call','Escalated',51,
 'Escalated due to aging'),

-- Claim 50051
(90058,50051,'2026-04-20','Payer Call','Denied',5,
 'Incorrect procedure modifier'),

(90059,50051,'2026-04-28','Appeal','Submitted',13,
 'Appeal submitted'),

(90060,50051,'2026-05-15','Payer Call','Pending',30,
 'Appeal under review'),

-- Claim 50053
(90061,50053,'2026-04-22','Payer Call','Pending',4,
 'Claim received'),

(90062,50053,'2026-05-15','Payer Call','Pending',27,
 'Still processing'),

(90063,50053,'2026-06-10','Payer Call','Escalated',53,
 'Aged claim escalated'),

-- Claim 50055
(90064,50055,'2026-04-28','Payer Call','Denied',5,
 'Prior authorization missing'),

(90065,50055,'2026-05-05','Appeal','Submitted',12,
 'Appeal submitted'),

(90066,50055,'2026-05-30','Payer Call','Pending',37,
 'Appeal under review'),

(90067,50055,'2026-06-20','Payer Call','Resolved',58,
 'Appeal approved'),

-- Claim 50057
(90068,50057,'2026-05-01','Payer Call','Pending',4,
 'Claim received'),

(90069,50057,'2026-05-25','Payer Call','Pending',28,
 'Processing delayed'),

-- Claim 50059
(90070,50059,'2026-05-10','Payer Call','Denied',9,
 'Duplicate claim confirmed'),

(90071,50059,'2026-05-15','Payer Call','Closed',14,
 'Duplicate claim closed'),

-- Claim 50060
(90072,50060,'2026-05-05','Payer Call','Pending',2,
 'Claim received'),

(90073,50060,'2026-05-30','Payer Call','Pending',27,
 'No payment posted'),

-- Claim 50063
(90074,50063,'2026-05-15','Payer Call','Denied',6,
 'Missing information'),

(90075,50063,'2026-05-25','Documentation Request','Submitted',16,
 'Documentation requested'),

(90076,50063,'2026-06-15','Resubmission','Submitted',37,
 'Corrected claim resubmitted'),

-- Claim 50064
(90077,50064,'2026-05-15','Payer Call','Pending',4,
 'Claim received'),

(90078,50064,'2026-06-05','Payer Call','Pending',25,
 'Still processing'),

-- Claim 50067
(90079,50067,'2026-05-20','Payer Call','Pending',3,
 'Claim received'),

(90080,50067,'2026-06-10','Payer Call','Pending',24,
 'Processing delayed'),

(90081,50067,'2026-07-01','Payer Call','Escalated',45,
 'Escalated due to aging'),

-- Claim 50071
(90082,50071,'2026-06-10','Payer Call','Denied',8,
 'Timely filing denial'),

(90083,50071,'2026-06-15','Payer Call','Closed',13,
 'Appeal not permitted'),

-- Claim 50073
(90084,50073,'2026-06-10','Payer Call','Pending',4,
 'Claim received'),

(90085,50073,'2026-07-05','Payer Call','Pending',29,
 'Processing delayed'),

-- Claim 50075
(90086,50075,'2026-06-20','Payer Call','Denied',10,
 'Missing documentation'),

(90087,50075,'2026-06-28','Documentation Request','Submitted',18,
 'Documentation requested'),

(90088,50075,'2026-07-15','Resubmission','Submitted',35,
 'Corrected claim submitted'),

-- Claim 50077
(90089,50077,'2026-06-15','Payer Call','Pending',1,
 'Claim received'),

(90090,50077,'2026-07-10','Payer Call','Pending',26,
 'No payment posted'),

-- Claim 50079
(90091,50079,'2026-06-25','Payer Call','Denied',8,
 'Prior authorization required'),

(90092,50079,'2026-07-01','Appeal','Submitted',14,
 'Appeal submitted'),

(90093,50079,'2026-07-20','Payer Call','Pending',33,
 'Appeal under review'),

-- Claim 50081
(90094,50081,'2026-06-25','Payer Call','Pending',3,
 'Claim received'),

(90095,50081,'2026-07-20','Payer Call','Pending',28,
 'Still processing'),

-- Claim 50083
(90096,50083,'2026-07-02','Payer Call','Denied',6,
 'Incorrect modifier'),

(90097,50083,'2026-07-10','Appeal','Submitted',14,
 'Appeal submitted'),

-- Claim 50085
(90098,50085,'2026-07-01','Payer Call','Pending',1,
 'Claim received'),

(90099,50085,'2026-07-20','Payer Call','Pending',20,
 'Processing delayed'),

-- Claim 50087
(90100,50087,'2026-07-10','Payer Call','Denied',7,
 'Missing information'),

(90101,50087,'2026-07-18','Documentation Request','Submitted',15,
 'Documentation requested'),

-- Claim 50088
(90102,50088,'2026-07-10','Payer Call','Pending',5,
 'Claim received'),

(90103,50088,'2026-07-25','Payer Call','Pending',20,
 'No payment posted'),

-- Claim 50090
(90104,50090,'2026-07-12','Payer Call','Pending',3,
 'Claim received'),

(90105,50090,'2026-07-28','Payer Call','Pending',19,
 'Processing delayed');
