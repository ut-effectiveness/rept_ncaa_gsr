WITH cte_sports AS (
    SELECT DISTINCT
        CASE
             WHEN activity_id IN ('BBL', 'MBK', 'XCM', 'FTB') THEN activity_desc
             WHEN activity_id IN ('WBK') THEN activity_desc
             WHEN activity_id IN ('XCW', 'TRK', 'WTI') THEN 'Womens CC/Track'
             WHEN activity_id IN ('GLF', 'MSO', 'MTE') THEN 'Mens Other'
             WHEN activity_id IN ('GLFW', 'SFB', 'SOC', 'SWI', 'TEN', 'VLB') THEN 'Womens Other'
             WHEN b.gender_code = 'M' THEN 'Mens Other'
            WHEN b.gender_code = 'F' THEN 'Womens Other'
    END AS ncaa_sport_desc,
        a.student_id,
        a.term_id,
        a.student_id || term_id AS term_test
    FROM export.student_extracurricular_activity a
    INNER JOIN export.student b ON b.student_id = a.student_id
    WHERE activity_type_desc = 'Sports'
)

        SELECT DISTINCT
                 a.student_id,
                 a.sis_system_id,
                 b.is_athlete,
                  i.ncaa_sport_desc,
                 b.is_veteran,
                 a.cohort_start_term_id,
                 a.cohort_code,
                 a.cohort_code_desc,
                 CASE
                     WHEN b.is_athlete THEN 'BA' -- if athlete, change degree level to BA
                     ELSE a.cohort_degree_level_code
                 END AS cohort_degree_level_code,
                  CASE
                     WHEN b.is_athlete THEN 'Bachelor' -- if athlete, change degree level to Bachelor
                     ELSE a.cohort_degree_level_desc
                  END AS cohort_degree_level_desc,
                 a.cohort_desc,
                 a.full_time_part_time_code,
                 c.is_graduated,
                 a.is_exclusion,
                 b.gender_code,
                 b.death_date,
                 b.ipeds_race_ethnicity,
                 d.ipeds_award_level_code,
                 c.graduation_date,
                 e.term_start_date,
                 CASE
                     WHEN c.graduation_date - e.term_start_date < 0 THEN NULL
                 ELSE c.graduation_date - e.term_start_date END AS days_to_graduate,
                 f.is_pell_awarded,
                 CASE
                     WHEN f.is_pell_awarded THEN FALSE
                     ELSE f.is_subsidized_loan_awarded
                 END AS is_subsidized_loan_awarded,
                 COALESCE(g.is_enrolled, FALSE) AS is_enrolled,
                 COALESCE(h.is_transfer_out, FALSE) AS is_transfer_out
          FROM export.student_term_cohort a
       LEFT JOIN export.student b ON b.student_id = a.student_id
       LEFT JOIN export.degrees_awarded c
              ON c.student_id = a.student_id
             AND c.is_highest_undergraduate_degree_awarded
             AND c.degree_status_code = 'AW'
       LEFT JOIN export.academic_programs d ON d.program_id = c.primary_program_id
       LEFT JOIN export.term e
              ON e.term_id = a.cohort_start_term_id
       LEFT JOIN export.student_term_level f ON f.student_id = a.student_id
             AND f.term_id = a.cohort_start_term_id
       /* Still enrolled */
       LEFT JOIN export.student_term_level g
              ON g.student_id = a.student_id
             AND g.term_id = (SELECT term_id FROM export.term WHERE is_previous_term)
             AND g.is_primary_level
       /* Transferred Out */
       LEFT JOIN (SELECT DISTINCT sis_system_id,
                                  CASE
                                     WHEN ( SUBSTR(college_code, 1, 6) != '003671' OR college_code IS NULL ) THEN TRUE
                                     ELSE FALSE
                                  END AS is_transfer_out
                             FROM quad.nsc_supplemental_enrollment
                            WHERE substr(college_code, 1, 6) != '003671') h
              ON h.sis_system_id = a.sis_system_id
       /* Atheletes */
       LEFT JOIN cte_sports i ON i.student_id = a.student_id AND i.term_id = a.cohort_start_term_id
         WHERE a.cohort_start_term_id >= '201440'
           AND cohort_desc IN ('First-Time Freshman', 'Transfer')