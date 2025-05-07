  -- Athletes only with student aid
    SELECT DISTINCT a.student_id,
             b.gender_code,
             c.academic_year_code,
             b.ipeds_race_ethnicity,
             d.activity_desc,
             f.financial_aid_fund_id,
             f.amount_offered
      FROM export.student_term_level_version a
 LEFT JOIN export.term c
        ON a.term_id = c.term_id
 LEFT JOIN export.student_version b
        ON b.student_id = a.student_id
       AND b.version_snapshot_id = a.version_snapshot_id
      LEFT JOIN export.student_extracurricular_activity d
             ON a.student_id = d.student_id
      LEFT JOIN export.student_financial_aid_year_fund_term_detail f
             ON a.student_id = f.student_id
            AND a.term_id = a.term_id
     WHERE a.term_id = '202440'
       AND a.is_primary_level = TRUE
       AND a.is_enrolled = TRUE
       AND a.is_degree_seeking = TRUE
       AND a.level_id = 'UG'
       AND b.full_time_part_time_code = 'F'
       AND a.version_desc = 'Census'
       AND d.activity_type_desc = 'Sports'
       AND f.amount_offered > '0'
       AND primary_degree_id LIKE 'B%'
