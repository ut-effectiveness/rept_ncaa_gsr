--24-25 Academic Year

SELECT a.term_desc,
       a.student_id,
       b.gender_code,
       a.is_athlete,
       b.ipeds_race_ethnicity,
       a.primary_degree_id,
       a.full_time_part_time_code
FROM export.student_term_level_version a
LEFT JOIN export.student_version b
ON a.student_id = b.student_id
AND a.version_snapshot_id = b.version_snapshot_id
WHERE a.is_enrolled IS TRUE
  AND a.is_primary_level IS TRUE
  AND a.term_id = '202440'
  AND a.version_desc = 'Census';