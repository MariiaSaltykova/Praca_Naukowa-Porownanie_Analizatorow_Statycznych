-- Script to clear all tables and views from the database
SET FOREIGN_KEY_CHECKS = 0;

-- Drop procedures
DROP PROCEDURE IF EXISTS InsertMetricValue2;

-- Drop views
DROP VIEW IF EXISTS licenses_with_tools;
DROP VIEW IF EXISTS metric_values_with_connections;
DROP VIEW IF EXISTS projects_with_metrics;
DROP VIEW IF EXISTS used_metric_definitions;
DROP VIEW IF EXISTS measurementsPerMetricAndLanguage;
DROP VIEW IF EXISTS doubleMetricValues;

-- Drop tables
DROP TABLE IF EXISTS analysisLevels;
DROP TABLE IF EXISTS languages;
DROP TABLE IF EXISTS licenses;
DROP TABLE IF EXISTS metricDefinitions;
DROP TABLE IF EXISTS metricDiscrepancies;
DROP TABLE IF EXISTS metricNames;
DROP TABLE IF EXISTS metricValues;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS projectsLanguagesConnections;
DROP TABLE IF EXISTS projectsLevelsConnections;
DROP TABLE IF EXISTS sources;
DROP TABLE IF EXISTS tools;
DROP TABLE IF EXISTS toolsLanguagesConnections;
DROP TABLE IF EXISTS toolsMetricsConnections;

SET FOREIGN_KEY_CHECKS = 1;

-- Confirm cleared database
SELECT 'Database cleared successfully' AS Status;
