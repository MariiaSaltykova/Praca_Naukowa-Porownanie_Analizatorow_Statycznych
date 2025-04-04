CREATE VIEW measurementsPerMetricAndLanguage AS
SELECT mn.metricName, lang.languageName, COUNT(*) AS amount
FROM metricNames mn
JOIN toolsMetricsConnections tmc
ON tmc.metricID = mn.uniqueID
JOIN languages lang
ON tmc.languageID = lang.uniqueID
JOIN metricValues mv
ON mv.toolMetricID = tmc.uniqueID
WHERE mv.metricValue IS NOT NULL
GROUP BY mn.uniqueID, lang.uniqueID
HAVING amount > 1;

CREATE VIEW doubleMetricValues AS
SELECT mv.uniqueID, mv.toolMetricID, mv.projectID, mv.levelID, mv.sourceID, mv.path,
CAST(mv.metricValue AS DOUBLE) AS metricValue
FROM metricValues mv
WHERE mv.metricValue IS NOT NULL
AND mv.metricValue REGEXP '^[+-]?[0-9]*\\.?[0-9]+$';
