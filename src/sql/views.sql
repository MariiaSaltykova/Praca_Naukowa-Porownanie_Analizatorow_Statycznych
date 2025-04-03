CREATE VIEW licenses_with_tools AS
SELECT l.uniqueID, l.name, l.description
FROM licenses l
         INNER JOIN tools t ON l.uniqueID = t.licenseID;


CREATE VIEW metric_values_with_connections AS
SELECT mv.uniqueID, mv.metricValue
FROM metricValues mv
         INNER JOIN toolsMetricsConnections tmc ON mv.toolMetricID = tmc.uniqueID;

CREATE VIEW projects_with_metrics AS
SELECT p.uniqueID, p.projectName, p.url
FROM projects p
         INNER JOIN metricValues mv ON p.uniqueID = mv.projectID;

CREATE VIEW used_metric_definitions AS
SELECT md.uniqueID, md.metricDefinition, md.url
FROM metricDefinitions md
         INNER JOIN toolsMetricsConnections tmc ON md.uniqueID = tmc.metricID;
