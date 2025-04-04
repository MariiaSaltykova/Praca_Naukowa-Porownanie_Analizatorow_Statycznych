UPDATE metricValues
SET metricValues.path = ''
WHERE metricValues.path IS NULL;

UPDATE metricValues
SET metricValues.metricValue = CONVERT(REPLACE(metricValues.metricValue, '%', '') / 100, CHAR)
WHERE metricValues.metricValue IS NOT NULL AND RIGHT (metricValues.metricValue, 1) = '%'

