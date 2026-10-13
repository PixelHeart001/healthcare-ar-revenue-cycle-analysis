CREATE TABLE patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10),
    state VARCHAR(50),
    insurance_id VARCHAR(50)
);

CREATE TABLE providers (
    provider_id INT PRIMARY KEY,
    provider_name VARCHAR(100) NOT NULL,
    provider_type VARCHAR(50),
    specialty VARCHAR(100),
    state VARCHAR(50)
);

CREATE TABLE payers (
    payer_id INT PRIMARY KEY,
    payer_name VARCHAR(100) NOT NULL,
    payer_type VARCHAR(50)
);

CREATE TABLE claims (
    claim_id INT PRIMARY KEY,
    patient_id INT NOT NULL,
    provider_id INT NOT NULL,
    payer_id INT NOT NULL,
    claim_date DATE NOT NULL,
    service_date DATE NOT NULL,
    submission_date DATE NOT NULL,
    billed_amount DECIMAL(12,2) NOT NULL,
    allowed_amount DECIMAL(12,2),
    claim_status VARCHAR(30) NOT NULL,

    FOREIGN KEY (patient_id)
        REFERENCES patients(patient_id),

    FOREIGN KEY (provider_id)
        REFERENCES providers(provider_id),

    FOREIGN KEY (payer_id)
        REFERENCES payers(payer_id)
  );
  
CREATE TABLE payments (
    payment_id INT PRIMARY KEY,
    claim_id INT NOT NULL,
    payment_date DATE,
    payment_amount DECIMAL(12,2) DEFAULT 0,
    adjustment_amount DECIMAL(12,2) DEFAULT 0,
    patient_responsibility DECIMAL(12,2) DEFAULT 0,

    FOREIGN KEY (claim_id)
        REFERENCES claims(claim_id)
);

CREATE TABLE denials (
    denial_id INT PRIMARY KEY,
    claim_id INT NOT NULL,
    denial_date DATE,
    denial_code VARCHAR(20),
    denial_reason VARCHAR(255),
    denial_amount DECIMAL(12,2),
    appeal_status VARCHAR(30),

    FOREIGN KEY (claim_id)
        REFERENCES claims(claim_id)
);

CREATE TABLE ar_followups (
    followup_id INT PRIMARY KEY,
    claim_id INT NOT NULL,
    followup_date DATE NOT NULL,
    followup_type VARCHAR(50),
    followup_status VARCHAR(50),
    days_since_submission INT,
    notes VARCHAR(500),

    FOREIGN KEY (claim_id)
        REFERENCES claims(claim_id)
);
