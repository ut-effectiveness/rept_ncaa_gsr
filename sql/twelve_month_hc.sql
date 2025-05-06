SELECT b.academic_year_code,
       b.academic_year_desc,
       b.term_id,
       c.gender_code,
       a.level_id,
       a.full_time_part_time_code,
       a.is_degree_seeking,
       a.primary_degree_id,
       a.student_id
FROM export.student_term_level_version a
         LEFT JOIN export.term b
                   ON a.term_id = b.term_id
LEFT JOIN export.student_version c
ON a.version_snapshot_id = c.version_snapshot_id
AND a.student_id = c.student_id
WHERE a.is_enrolled = TRUE
  AND a.is_primary_level = TRUE