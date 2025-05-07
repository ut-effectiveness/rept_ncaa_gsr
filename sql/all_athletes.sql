/* ALL Athletes at Census regardless of ft pt status */

    SELECT a.term_id,
             a.student_id,
             b.gender_code,
             b.ipeds_race_ethnicity,
             a.is_athlete
      FROM export.student_term_level_version a
 LEFT JOIN export.term c
        ON a.term_id = c.term_id
 LEFT JOIN export.student_version b
        ON b.student_id = a.student_id
       AND b.version_snapshot_id = a.version_snapshot_id
     WHERE a.term_id = '202440'
       AND a.is_primary_level = TRUE
       AND a.is_enrolled = TRUE
      -- AND a.is_degree_seeking = TRUE
       AND a.version_desc = 'Census'
       AND a.is_athlete = TRUE

