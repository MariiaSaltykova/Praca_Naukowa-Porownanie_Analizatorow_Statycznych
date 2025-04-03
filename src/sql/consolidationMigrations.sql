UPDATE metricvalues
SET metricvalues.path = ''
WHERE metricvalues.path IS NULL;

UPDATE metricvalues
SET metricvalues.metricValue = CAST((CAST(REPLACE(metricvalues.metricValue, '%', '') AS DOUBLE) / 100) AS VARCHAR(255))
WHERE metricvalues.metricValue IS NOT NULL AND RIGHT(metricvalues.metricValue, 1) = '%'

