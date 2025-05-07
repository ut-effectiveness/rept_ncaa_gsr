SELECT a.term_desc,
       a.student_id,
       b.gender_code,
       a.is_athlete,
       a.primary_degree_id,
       b.ipeds_race_ethnicity,
       c.activity_desc,
       c.activity_type_desc
FROM export.student_term_level_version a
LEFT JOIN export.student_version b
ON a.student_id = b.student_id
AND a.version_snapshot_id = b.version_snapshot_id
LEFT JOIN export.student_extracurricular_activity c
ON a.student_id = c.student_id
WHERE a.is_enrolled IS TRUE
  AND a.is_primary_level IS TRUE
  AND a.term_id = '202440'
  AND a.version_desc = 'Census';
