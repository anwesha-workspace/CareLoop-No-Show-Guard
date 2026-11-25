-- ==========================================
-- CARELOOP CLINICS - PART 2 SQL QUERIES
-- ==========================================

-- Task 2.2: Clinic no-show rates
-- Only clinics with at least 95 appointments

SELECT
    c.clinic_name,
    c.city,
    COUNT(*) AS total_appointments,
    SUM(a.no_show) AS total_no_shows,
    ROUND(100.0 * SUM(a.no_show) / COUNT(*), 1)
        AS no_show_percentage
FROM appointments_fixed a
JOIN clinics c
    ON a.clinic_id = c.clinic_id
GROUP BY c.clinic_id, c.clinic_name, c.city
HAVING COUNT(*) >= 95
ORDER BY no_show_percentage DESC;


-- Task 2.2: All clinics without HAVING filter

SELECT
    c.clinic_name,
    c.city,
    COUNT(*) AS total_appointments,
    SUM(a.no_show) AS total_no_shows,
    ROUND(100.0 * SUM(a.no_show) / COUNT(*), 1)
        AS no_show_percentage
FROM appointments_fixed a
JOIN clinics c
    ON a.clinic_id = c.clinic_id
GROUP BY c.clinic_id, c.clinic_name, c.city
ORDER BY no_show_percentage DESC;

-- ==========================================
-- Task 2.3: No-show rates by lead-time band
-- ==========================================

SELECT
    CASE
        WHEN lead_days BETWEEN 1 AND 7 THEN '1-7'
        WHEN lead_days BETWEEN 8 AND 14 THEN '8-14'
        WHEN lead_days BETWEEN 15 AND 30 THEN '15-30'
        ELSE '31+'
    END AS lead_time_band,
    COUNT(*) AS total_appointments,
    SUM(no_show) AS total_no_shows,
    ROUND(100.0 * SUM(no_show) / COUNT(*), 1)
        AS no_show_percentage
FROM appointments_fixed
GROUP BY
    CASE
        WHEN lead_days BETWEEN 1 AND 7 THEN '1-7'
        WHEN lead_days BETWEEN 8 AND 14 THEN '8-14'
        WHEN lead_days BETWEEN 15 AND 30 THEN '15-30'
        ELSE '31+'
    END
ORDER BY MIN(lead_days);

-- ==========================================
-- Task 2.4: Monthly no-show rates
-- ==========================================

WITH monthly_rates AS (
    SELECT
        strftime('%Y-%m', appt_date) AS appointment_month,
        COUNT(*) AS total_appointments,
        ROUND(
            100.0 * SUM(no_show) / COUNT(*), 1
        ) AS no_show_percentage
    FROM appointments_fixed
    GROUP BY strftime('%Y-%m', appt_date)
)
SELECT
    appointment_month,
    total_appointments,
    no_show_percentage,
    ROUND(
        no_show_percentage - LAG(no_show_percentage)
        OVER (ORDER BY appointment_month), 1
    ) AS change_from_previous_month
FROM monthly_rates
ORDER BY appointment_month;

-- ==========================================
-- Task 2.5: Rank clinics within each city
-- and compare with the overall no-show rate
-- ==========================================

WITH clinic_rates AS (
    SELECT
        c.clinic_name,
        c.city,
        ROUND(
            100.0 * SUM(a.no_show) / COUNT(*), 1
        ) AS no_show_pct
    FROM appointments_fixed a
    JOIN clinics c
        ON a.clinic_id = c.clinic_id
    GROUP BY c.clinic_id, c.clinic_name, c.city
)
SELECT
    clinic_name,
    city,
    no_show_pct,
    RANK() OVER (
        PARTITION BY city
        ORDER BY no_show_pct DESC
    ) AS rank_in_city,
    CASE
        WHEN no_show_pct > (
            SELECT 100.0 * SUM(no_show) / COUNT(*)
            FROM appointments_fixed
        ) THEN 'above'
        WHEN no_show_pct < (
            SELECT 100.0 * SUM(no_show) / COUNT(*)
            FROM appointments_fixed
        ) THEN 'below'
        ELSE 'equal'
    END AS vs_overall
FROM clinic_rates
ORDER BY city, rank_in_city;

-- Finding:
-- Overall no-show rate: 22.02%.
-- Clinics above overall: Malviya Nagar, Gomti Nagar,
-- Hadapsar and Kothrud.
-- Gomti Nagar Care Point has the highest clinic-level
-- no-show rate at 33.3%.

-- ==========================================
-- Task 2.1: Primary key duplicate test
-- ==========================================

-- Tested inserting appointment_id 'A0001'
-- into appointments_fixed.
-- Expected result: insertion rejected.
-- Actual result:
-- SQLITE_CONSTRAINT_PRIMARYKEY
-- UNIQUE constraint failed:
-- appointments_fixed.appointment_id
--
-- This confirms appointment_id is protected
-- by a PRIMARY KEY constraint.