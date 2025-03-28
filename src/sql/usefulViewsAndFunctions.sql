CREATE VIEW measurementsPerMetricAndLanguage AS
SELECT mn.metricName, lang.languageName, COUNT(*) AS amount 
FROM metricnames mn
JOIN toolsmetricsconnections tmc
ON tmc.metricID = mn.uniqueID
JOIN languages lang
ON tmc.languageID = lang.uniqueID
JOIN metricvalues mv
ON mv.toolMetricID = tmc.uniqueID
WHERE mv.metricValue IS NOT NULL
GROUP BY mn.uniqueID, lang.uniqueID
HAVING amount > 1;