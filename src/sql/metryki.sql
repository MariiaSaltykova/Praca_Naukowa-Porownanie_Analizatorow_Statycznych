-- phpMyAdmin SQL Dump
-- version 4.9.5deb2
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Czas generowania: 31 Lip 2024, 20:34
-- Wersja serwera: 8.0.37-0ubuntu0.20.04.3
-- Wersja PHP: 7.4.3-4ubuntu2.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Baza danych: `metryki`
--

DELIMITER $$
--
-- Procedury
--
CREATE DEFINER=`osavchuk`@`localhost` PROCEDURE `InsertMetricValue2` (IN `p_languageName` VARCHAR(255), IN `p_toolName` VARCHAR(255), IN `p_metricName` VARCHAR(255), IN `p_definitionID` INT, IN `p_projectName` VARCHAR(255), IN `p_levelName` VARCHAR(255), IN `p_sourceID` INT, IN `p_metricValue` INT)  BEGIN
    DECLARE v_languageID INT;
    DECLARE v_toolID INT;
    DECLARE v_metricID INT;
    DECLARE v_toolMetricID INT;

    -- Get language ID
    SELECT `uniqueID` INTO v_languageID FROM `languages` WHERE `languageName` = p_languageName;

    -- Get tool ID
    SELECT `uniqueID` INTO v_toolID FROM `tools` WHERE `toolName` = p_toolName;

    -- Get metric ID
    SELECT `uniqueID` INTO v_metricID FROM `metricNames` WHERE `metricName` = p_metricName;

    -- Get or insert into toolsMetricsConnections
    SELECT `uniqueID` INTO v_toolMetricID
    FROM `toolsMetricsConnections`
    WHERE `languageID` = v_languageID
    AND `toolID` = v_toolID
    AND `metricID` = v_metricID
    AND `definitionID` = p_definitionID;

    IF v_toolMetricID IS NULL THEN
        INSERT INTO `toolsMetricsConnections` (`languageID`, `toolID`, `metricID`, `definitionID`)
        VALUES (v_languageID, v_toolID, v_metricID, p_definitionID);
        SET v_toolMetricID = LAST_INSERT_ID();
    END IF;

    -- Insert into metricValues
    INSERT INTO `metricValues` (`toolMetricID`, `projectID`, `levelID`, `sourceID`, `metricValue`)
    VALUES (
        v_toolMetricID,
        (SELECT `uniqueID` FROM `projects` WHERE `projectName` = p_projectName),
        (SELECT `uniqueID` FROM `analysisLevels` WHERE `levelName` = p_levelName),
        p_sourceID,
        p_metricValue
    );
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `analysisLevels`
--

CREATE TABLE `analysisLevels` (
  `uniqueID` int NOT NULL,
  `levelName` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `analysisLevels`
--

INSERT INTO `analysisLevels` (`uniqueID`, `levelName`) VALUES
(1, 'file'),
(2, 'Directory');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `languages`
--

CREATE TABLE `languages` (
  `uniqueID` int NOT NULL,
  `languageName` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `languages`
--

INSERT INTO `languages` (`uniqueID`, `languageName`) VALUES
(1, 'typescript'),
(3, 'Python'),
(4, 'Java'),
(5, 'C++');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `licenses`
--

CREATE TABLE `licenses` (
  `uniqueID` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `description` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `licenses`
--

INSERT INTO `licenses` (`uniqueID`, `name`, `description`) VALUES
(1, 'paid (limited free access)', 'Proprietary software which might provide free license for specific types of projects'),
(2, 'paid', 'Proprietary software which does not provide any kind of free license'),
(3, 'paid (limited free access)', 'Proprietary software which might provide free license for specific types of projects'),
(4, 'paid', 'Proprietary software which does not provide any kind of free license'),
(5, 'LGPL-3.0 license', 'GNU LESSER GENERAL PUBLIC LICENSE\r\n'),
(6, 'EPL-1.0', 'The Eclipse Public License (EPL) is a free and open source software license most notably used for the Eclipse IDE and other projects by the Eclipse Foundation. It replaces the Common Public License (CPL) and removes certain terms relating to litigations related to patents.'),
(7, 'MIT', 'THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND,\r\nEXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\r\nMERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND\r\nNONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE\r\nLIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION\r\nOF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION\r\nWITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.'),
(8, 'BSD-3-Clause license ', 'Redistribution and use in source and binary forms, with or without\r\nmodification, are permitted provided that the following conditions are met:\r\n\r\n* Redistributions of source code must retain the above copyright notice, this\r\n  list of conditions and the following disclaimer.\r\n* Redistributions in binary form must reproduce the above copyright notice,\r\n  this list of conditions and the following disclaimer in the documentation\r\n  and/or other materials provided with the distribution.\r\n* Neither the name of the author nor the names of its contributors may be used\r\n  to endorse or promote products derived from this software without specific\r\n  prior written permission.\r\n\r\nTHIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\"\r\nAND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE\r\nIMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE\r\nDISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE\r\nFOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL\r\nDAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR\r\nSERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER\r\nCAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,\r\nOR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE\r\nOF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.'),
(9, 'GPL-3.0', 'The licenses for most software and other practical works are designed\r\nto take away your freedom to share and change the works.  By contrast,\r\nthe GNU General Public License is intended to guarantee your freedom to\r\nshare and change all versions of a program--to make sure it remains free\r\nsoftware for all its users.  We, the Free Software Foundation, use the\r\nGNU General Public License for most of our software; it applies also to\r\nany other work released this way by its authors.  You can apply it to\r\nyour programs, too.'),
(10, 'Apache License 2.0', 'The Apache License is a permissive free software license written by the Apache Software Foundation (ASF). It allows users to use the software for any purpose, to distribute it, to modify it, and to distribute modified versions of the software under the terms of the license, without concern for royalties. The ASF and its projects release their software products under the Apache License. The license is also used by many non-ASF projects.'),
(11, 'EPL 2.0', 'The JaCoCo Java Code Coverage Library and all included documentation is made available by Mountainminds GmbH & Co. KG, Munich. Except indicated below, the Content is provided to you under the terms and conditions of the Eclipse Public License Version 2.0 (\"EPL\"). A copy of the EPL is provided with this Content and is also available at https://www.eclipse.org/legal/epl-2.0/'),
(12, 'LGPL-2.1', 'GNU LESSER GENERAL PUBLIC LICENSE\r\nVersion 2.1, February 1999\r\n\r\n Copyright (C) 1991, 1999 Free Software Foundation, Inc.\r\n 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA\r\n Everyone is permitted to copy and distribute verbatim copies\r\n of this license document, but changing it is not allowed.');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `metricDefinitions`
--

CREATE TABLE `metricDefinitions` (
  `uniqueID` int NOT NULL,
  `metricDefinition` longtext,
  `url` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `metricDefinitions`
--

INSERT INTO `metricDefinitions` (`uniqueID`, `metricDefinition`, `url`) VALUES
(1, 'Cyclomatic complexity is a measure of the complexity of a program’s code flow based on the number of independent paths through the source code. E.g. function with no conditional statements has cyclomatic complexity of 1.', 'https://blog.jetbrains.com/qodana/2023/10/top-6-code-quality-metrics-to-empower-your-team/'),
(2, 'Complexity refers to Cyclomatic complexity, a quantitative metric used to calculate the number of paths through the code. Whenever the control flow of a function splits, the complexity counter gets incremented by one. Each function has a minimum complexity of 1. This calculation varies slightly by language because keywords and functionalities do.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/'),
(3, 'The code duplication percentage helps you identify how much of the same or similar code appears in multiple places in the codebase.', 'https://blog.jetbrains.com/qodana/2023/10/top-6-code-quality-metrics-to-empower-your-team/#code-duplication-percentage'),
(4, 'There should be at least 100 successive and duplicated tokens. Those tokens should be spread at least on 10 lines of code', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#duplications'),
(5, 'The number of files involved in duplications', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#duplications'),
(6, 'The number of lines involved in duplications', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#duplications'),
(7, 'The number of classes (including nested classes, interfaces, enums, and annotations).', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(8, 'The number of lines containing either comment or commented-out code. Non-significant comment lines (empty comment lines, comment lines containing only special characters, etc.) do not increase the number of comment lines. The following piece of code contains 9 comment lines:\r\n/**                                            +0 => empty comment line\r\n *                                             +0 => empty comment line\r\n * This is my documentation                    +1 => significant comment\r\n * although I don\'t                            +1 => significant comment\r\n * have much                                   +1 => significant comment\r\n * to say                                      +1 => significant comment\r\n *                                             +0 => empty comment line\r\n ***************************                   +0 => non-significant comment\r\n *                                             +0 => empty comment line\r\n * blabla...                                   +1 => significant comment\r\n */                                            +0 => empty comment line\r\n\r\n/**                                            +0 => empty comment line\r\n * public String foo() {                       +1 => commented-out code\r\n *   System.out.println(message);              +1 => commented-out code\r\n *   return message;                           +1 => commented-out code\r\n * }                                           +1 => commented-out code\r\n */                                            +0 => empty comment line', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(9, 'The number of directories', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(10, 'The number of files.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(11, 'The number of physical lines (number of carriage returns)', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(12, 'The number of physical lines that contain at least one character which is neither a whitespace nor a tabulation nor part of a comment', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(13, 'The number of functions. Depending on the language, a function is defined as either a function, a method, or a paragraph.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(14, 'The number of projects in a Portfolio', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(15, 'The number of statements.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(16, 'The number of functions. Depending on the language, a function is defined as either a function, a method, or a paragraph. Methods in anonymous classes are ignored.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(17, 'The number of lines containing either comment or commented-out code. Non-significant comment lines (empty comment lines, comment lines containing only special characters, etc.) do not increase the number of comment lines. The following piece of code contains 9 comment lines:\r\n/**                                            +0 => empty comment line\r\n *                                             +0 => empty comment line\r\n * This is my documentation                    +1 => significant comment\r\n * although I don\'t                            +1 => significant comment\r\n * have much                                   +1 => significant comment\r\n * to say                                      +1 => significant comment\r\n *                                             +0 => empty comment line\r\n ***************************                   +0 => non-significant comment\r\n *                                             +0 => empty comment line\r\n * blabla...                                   +1 => significant comment\r\n */                                            +0 => empty comment line\r\n\r\n/**                                            +0 => empty comment line\r\n * public String foo() {                       +1 => commented-out code\r\n *   System.out.println(message);              +1 => commented-out code\r\n *   return message;                           +1 => commented-out code\r\n * }                                           +1 => commented-out code\r\n */                                            +0 => empty comment line\r\n\r\n\"File headers are not counted as comment lines (because they usually define the license).\"', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(18, 'On each line of code containing some boolean expressions, the condition coverage answers the following question: \'Has each boolean expression been evaluated both to true and to false?\'. This is the density of possible conditions in flow control structures that have been followed during unit tests execution.\r\nCondition coverage = (CT + CF) / (2*B) where:\r\nCT = conditions that have been evaluated to \'true\' at least once\r\nCF = conditions that have been evaluated to \'false\' at least once\r\nB = total number of conditions\r\nCondition coverage on new code (new_branch_coverage): This definition is identical to Condition coverage but is restricted to new/updated source code.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#tests'),
(19, 'The number of conditions by line.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#tests'),
(20, 'A mix of Line coverage and Condition coverage. It\'s goal is to provide an even more accurate answer the question \'How much of the source code has been covered by the unit tests?\'.\r\nCoverage = (CT + CF + LC)/(2*B + EL)\r\nwhere:\r\n\r\nCT = conditions that have been evaluated to \'true\' at least once\r\nCF = conditions that have been evaluated to \'false\' at least once\r\nLC = covered lines = linestocover - uncovered_lines\r\nB = total number of conditions\r\nEL = total number of executable lines (lines_to_cover)', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#tests'),
(21, 'On a given line of code, Line coverage simply answers the question \'Has this line of code been executed during the execution of the unit tests?\'. It is the density of covered lines by unit tests:\r\nLine coverage = LC / EL\r\nwhere:\r\n\r\nLC = covered lines (lines_to_cover - uncovered_lines)\r\nEL = total number of executable lines (lines_to_cover)', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#tests'),
(22, 'Coverable lines. The number of lines of code that could be covered by unit tests (for example, blank lines or full comments lines are not considered as lines to cover). Note that this metric is about what is possible, not what is left to do (that\'s uncovered_lines).', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#tests'),
(23, 'The number of unit tests.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#tests'),
(24, 'Code coverage percentage = (the number of lines of code tested by the algorithm / the total number of lines of code in a system component) * 100\r\n', 'https://blog.jetbrains.com/qodana/2023/10/top-6-code-quality-metrics-to-empower-your-team/#3.-code-test-coverage'),
(25, 'Measuring code smells, such as deprecated API usage, is important for maintaining the health of a software codebase. Though deprecated API usage can be assessed manually, allowing reviewers to identify and suggest alternatives to deprecated APIs, the most common approach is to employ static code analysis tools like Qodana.', 'https://blog.jetbrains.com/qodana/2023/10/top-6-code-quality-metrics-to-empower-your-team/#code-smells'),
(26, 'Vulnerabilities in code refer to security weaknesses or issues that could lead to security breaches, data leaks, or other security-related problems. ', 'https://blog.jetbrains.com/qodana/2023/10/top-6-code-quality-metrics-to-empower-your-team/#number-of-vulnerabilities'),
(27, 'Complexity refers to Cyclomatic complexity, a quantitative metric used to calculate the number of paths through the code. Whenever the control flow of a function splits, the complexity counter gets incremented by one. Each function has a minimum complexity of 1. This calculation varies slightly by language because keywords and functionalities do.\r\n\r\n\"Keywords incrementing the complexity: if, for, while, case, &&, ||, ?, ->.\"', 'Same as for python plus \"Keywords incrementing the complexity: if, for, while, case, &&, ||, ?, ->.\"'),
(28, 'Number of places in code where bugs can occur.\r\n\r\nWe obviously want to keep the number of bugs in our code as close to zero as possible, and code analysis is capable of flagging all sorts of them. One example is NullPointerExceptions, which are raised when we’re trying to perform an operation where an object is required. This is often the result of using a method on an object instance that is null at runtime or trying to access variables of that instance.\r\n\r\nIt’s important to catch these problems early to avoid releasing a buggy version of your product, especially since you might not immediately notice them in your code or even during the peer review process. Qodana can easily gate problems related to incorrect resource handling, such as database connections not being closed safely after use.', 'https://blog.jetbrains.com/qodana/2023/10/top-6-code-quality-metrics-to-empower-your-team/#number-of-possible-bugs'),
(29, 'Cognitive complexity is a measure of how difficult it is for humans to read and understand a method.', 'https://pmd.github.io/pmd/pmd_rules_java_design.html'),
(30, 'Branch coverage calculates coverage for all if and switch statements. This metric counts the total number of such branches in a method and determines the number of executed or missed branches.', 'https://www.eclemma.org/jacoco/trunk/doc/counters.html'),
(31, 'Class Fan Out Complexity checks the number of other types a given class/record/interface/enum/annotation relies on.', 'https://checkstyle.sourceforge.io/checks/metrics/classfanoutcomplexity.html'),
(32, 'NCSS (Non-commenting source statements) metric is calculated by counting the source lines which are not comments.', 'https://checkstyle.sourceforge.io/checks/metrics/javancss.html'),
(33, 'NPath Complexity metric computes the number of possible execution paths through a function(method). It takes into account the nesting of conditional statements and multipart boolean expressions (A && B, C || D, E ? F :G and their combinations).', 'https://checkstyle.sourceforge.io/checks/metrics/npathcomplexity.html'),
(35, 'Cyclomatic complexity was introduced by Thomas McCabe. It is determined based on the number of decision points in a method.', 'https://docs.oclint.org/en/stable/internals/metrics.html'),
(37, 'Defined for application, projects, namespaces, types. The number of methods. A method can be an abstract, virtual or non-virtual method, a method declared in an interface, a constructor, a class constructor, a finalizer, a property/indexer getter or setter, an event adder or remover.', 'https://www.cppdepend.com/documentation/code-metrics#NbMethods'),
(38, 'Defined for types, methods. Cyclomatic complexity is a popular procedural software metric equal to the number of decisions that can be taken in a procedure. Concretely, in C++ the CC of a method is 1 + {the number of following expressions found in the body of the method}:\r\n\r\nif | while | for | case | default | continue | goto | && | || | catch | ternary operator ?: | ??\r\n\r\nFollowing expressions are not counted for CC computation:\r\n\r\nelse | do | switch | try | using | throw | finally | return | object creation | method call | field access\r\n\r\nAdapted to the OO world, this metric is defined both on methods and classes/structures (as the sum of its methods CC). Notice that the CC of an anonymous method is not counted when computing the CC of its outer method. ', 'https://www.cppdepend.com/documentation/code-metrics#CC'),
(39, 'The number of parameters of a method. Ref and Out are also counted. The this reference passed to instance methods in IL is not counted as a parameter. ', 'https://www.cppdepend.com/documentation/code-metrics#NbParameters'),
(40, 'The number of duplicated blocks of lines.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#duplications'),
(41, 'The number of unique operators.', 'https://ftaproject.dev/docs/scoring'),
(42, 'The number of unique operands.', 'https://ftaproject.dev/docs/scoring'),
(43, 'The total number of operators.', 'https://ftaproject.dev/docs/scoring'),
(44, 'The total number of operands.', 'https://ftaproject.dev/docs/scoring'),
(45, 'The total count of operators and operands. (N)', 'https://ftaproject.dev/docs/scoring'),
(46, 'The total count of unique operators and operands. (n)', 'https://ftaproject.dev/docs/scoring'),
(47, 'A measure of the size of the program. V = N * log2(n).', 'https://ftaproject.dev/docs/scoring'),
(48, 'Quantifies how difficult a program is to write or understand. D = (n1/2) * (N2/n2).', 'https://ftaproject.dev/docs/scoring'),
(49, 'An estimation of the amount of work required to write a program. E = D * V.', 'https://ftaproject.dev/docs/scoring'),
(50, 'An estimation of the time required to write the program. T = E / 18 (seconds).', 'https://ftaproject.dev/docs/scoring'),
(51, 'An estimation of the number of bugs in the program. B = V / 3000.', 'https://ftaproject.dev/docs/scoring'),
(52, 'A normalized aggregate of the other metrics that provides an overall indication of maintainability.', 'https://ftaproject.dev/docs/scoring'),
(53, 'TLDR assessment for files based on FTA score. > 60 - Needs Improvement, Difficult to maintain. 50-60 - Could be better, Reasonably maintainable. < 50 - OK, Considered maintainable', 'https://ftaproject.dev/docs/scoring'),
(54, 'The number of physical lines that contain at least one character which is neither a whitespace nor a tabulation nor part of a comment.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/#size'),
(55, 'Number of functions', NULL),
(56, 'Notice that the LOC for a type is the sum of its methods’ LOC, the LOC for a namespace is the sum of its types’ LOC, the LOC for an project is the sum of its namespaces’ LOC and the LOC for an application is the sum of its projects LOC. ', 'https://www.cppdepend.com/documentation/code-metrics#NbLinesOfCode'),
(57, 'lines of code without comments', 'https://github.com/terryyin/lizard'),
(58, 'Non commenting source statements (NCSS) counts the number of all statements excluding comments, empty statements, empty blocks, closing brackets or semicolons after closing brackets.', 'https://docs.oclint.org/en/stable/internals/metrics.html'),
(59, 'The analyzer detected code that could be refactored. This diagnostic looks for three or more identical code blocks. Such repeated code is unlikely to be incorrect, but it is better to factor it out in a separate function.', 'https://pvs-studio.com/en/docs/warnings/v761/'),
(60, 'Cyclomatic complexity. Cyclomatic complexity of a program is a structural (or topological) measure of programs\' complexity for measuring software quality. Cyclomatic complexity measuring allows you to evaluate the quality of the program code and detect high-complexity procedures. High-complexity procedures are subject to errors and detecting them is highly required to perform code review. Program cyclomatic complexity was the first topological complexity measure which was used in practice and became basis for many modifications. Measuring of cyclomatic complexity relates to static code analysis methods.', 'https://pvs-studio.com/en/blog/terms/0010/'),
(61, 'Test coverage defines what percentage of application code is tested and whether the test cases cover all the code.', 'https://www.browserstack.com/guide/test-coverage-techniques#:~:text=Test%20coverage%20defines%20what%20percentage,%2C%20the%20coverage%20is%2050%25.'),
(62, 'Lines of code (ncloc): The number of physical lines that contain at least one character which is neither a whitespace nor a tabulation nor part of a comment.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/'),
(63, 'Bugs (bugs): The total number of bug issues.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/'),
(64, 'Functions (functions): The number of functions. Depending on the language, a function is defined as either a function, a method, or a paragraph.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/'),
(65, 'token count of functions', 'https://github.com/terryyin/lizard'),
(66, 'CCN (cyclomatic complexity number)', 'https://github.com/terryyin/lizard'),
(67, 'parameter count of functions', 'https://github.com/terryyin/lizard'),
(68, 'Cognitive Complexity (cognitive_complexity): How hard it is to understand the code\'s control flow. See the Cognitive Complexity white paper for a complete description of the mathematical model applied to compute this measure.', 'https://docs.sonarsource.com/sonarqube/latest/user-guide/metric-definitions/'),
(69, 'The complexity of methods directly affects maintenance costs and readability. Concentrating too much decisional logic in a single method makes its behaviour hard to read and change.\r\n\r\nCyclomatic complexity assesses the complexity of a method by counting the number of decision points in a method, plus one for the method entry. Decision points are places where the control flow jumps to another place in the program. As such, they include all control flow statements, such as if, while, for, and case. For more details on the calculation, see the documentation CYCLO.', 'https://pmd.github.io/pmd/pmd_rules_java_design.html'),
(70, 'Copy-paste detector finds duplicated blocks of code.', 'https://pmd.github.io/pmd/pmd_userdocs_cpd'),
(71, 'This rule uses the NCSS (Non-Commenting Source Statements) metric to determine the number of lines of code in a class, method or constructor. NCSS ignores comments, blank lines, and only counts actual statements. For more details on the calculation, see the documentation NCSS', 'https://pmd.github.io/pmd/pmd_rules_java_design.html?#ncsscount'),
(72, 'The NPath complexity of a method is the number of acyclic execution paths through that method. While cyclomatic complexity counts the number of decision points in a method, NPath counts the number of full paths from the beginning to the end of the block of the method. That metric grows exponentially, as it multiplies the complexity of statements in the same block.', 'https://pmd.github.io/pmd/pmd_rules_java_design.html?#npathcomplexity'),
(73, 'Checks cyclomatic complexity against a specified limit. It is a measure of the minimum number of possible paths through the source and therefore the number of required tests, it is not about quality of code! It is only applied to methods, c-tors, static initializers and instance initializers.\r\n\r\nThe complexity is equal to the number of decision points + 1. Decision points: if, while , do, for, ?:, catch , switch, case statements and operators && and || in the body of target.', 'https://checkstyle.sourceforge.io/checks/metrics/cyclomaticcomplexity.html'),
(74, 'JaCoCo also calculates cyclomatic complexity for each non-abstract method and summarizes complexity for classes, packages and groups. According to its definition by McCabe1996 cyclomatic complexity is the minimum number of paths that can, in (linear) combination, generate all possible paths through a method. Thus the complexity value can serve as an indication for the number of unit test cases to fully cover a certain piece of software. Complexity figures can always be calculated, even in absence of debug information in the class files', 'https://www.eclemma.org/jacoco/trunk/doc/counters.html'),
(75, 'For all class files that have been compiled with debug information, coverage information for individual lines can be calculated. A source line is considered executed when at least one instruction that is assigned to this line has been executed.\r\n', 'https://www.eclemma.org/jacoco/trunk/doc/counters.html'),
(76, 'This counts the number of other classes a given class or operation relies on. Classes from the package java.lang are ignored by default (can be changed via options). Also primitives are not included into the count.', 'https://docs.pmd-code.org/pmd-doc-6.30.0/pmd_java_metrics_index.html#class-fan-out-complexity-class_fan_out'),
(79, 'Accessing a protected member of a class or a module', 'https://www.jetbrains.com/qodana/'),
(80, 'An instance attribute is defined outside `__init__`', 'https://www.jetbrains.com/qodana/'),
(81, 'Assigning function calls that don\'t return anything', 'https://www.jetbrains.com/qodana/'),
(82, 'Assignments to \'for\' loop or \'with\' statement parameter', 'https://www.jetbrains.com/qodana/'),
(83, 'Attempt to call a non-callable object', 'https://www.jetbrains.com/qodana/'),
(84, 'Begin or end anchor in unexpected position', 'https://www.jetbrains.com/qodana/'),
(85, 'Class must implement all abstract methods', 'https://www.jetbrains.com/qodana/'),
(86, 'Class-specific decorator is used outside the class', 'https://www.jetbrains.com/qodana/'),
(87, 'Consecutive spaces', 'https://www.jetbrains.com/qodana/'),
(88, 'Deprecated function, class, or module', 'https://www.jetbrains.com/qodana/'),
(89, 'Dictionary contains duplicate keys', 'https://www.jetbrains.com/qodana/'),
(90, 'Dictionary creation can be rewritten by dictionary literal', 'https://www.jetbrains.com/qodana/'),
(91, 'Duplicate character in character class', 'https://www.jetbrains.com/qodana/'),
(92, 'Errors in string formatting operations', 'https://www.jetbrains.com/qodana/'),
(93, 'First argument of the method is reassigned', 'https://www.jetbrains.com/qodana/'),
(94, 'Fixture is not requested by test functions', 'https://www.jetbrains.com/qodana/'),
(95, 'Function call can be replaced with set literal', 'https://www.jetbrains.com/qodana/'),
(96, 'Global variable is not defined at the module level', 'https://www.jetbrains.com/qodana/'),
(97, 'Improper first parameter', 'https://www.jetbrains.com/qodana/'),
(98, 'Improper position of from __future__ import', 'https://www.jetbrains.com/qodana/'),
(99, 'Inappropriate access to properties', 'https://www.jetbrains.com/qodana/'),
(100, 'Incorrect arguments in @pytest.mark.parametrize', 'https://www.jetbrains.com/qodana/'),
(101, 'Incorrect call arguments', 'https://www.jetbrains.com/qodana/'),
(102, 'Incorrect docstring', 'https://www.jetbrains.com/qodana/'),
(103, 'Incorrect property definition', 'https://www.jetbrains.com/qodana/'),
(104, 'Incorrect type', 'https://www.jetbrains.com/qodana/'),
(105, 'Invalid TypedDict definition and usages', 'https://www.jetbrains.com/qodana/'),
(106, 'Invalid definition and usage of Data Classes', 'https://www.jetbrains.com/qodana/'),
(107, 'Invalid protocol definitions and usages', 'https://www.jetbrains.com/qodana/'),
(108, 'Invalid type hints definitions and usages', 'https://www.jetbrains.com/qodana/'),
(109, 'Invalid usage of ClassVar variables', 'https://www.jetbrains.com/qodana/'),
(110, 'Invalid usages of classes with \'__slots__\' definitions', 'https://www.jetbrains.com/qodana/'),
(111, 'Method is not declared static', 'https://www.jetbrains.com/qodana/'),
(112, 'Method signature does not match signature of overridden method', 'https://www.jetbrains.com/qodana/'),
(113, 'Missed call to \'__init__\' of the super class', 'https://www.jetbrains.com/qodana/'),
(114, 'Non-optimal list declaration', 'https://www.jetbrains.com/qodana/'),
(115, 'PEP 8 coding style violation', 'https://www.jetbrains.com/qodana/'),
(116, 'PEP 8 naming convention violation', 'https://www.jetbrains.com/qodana/'),
(117, 'Problematic nesting of decorators', 'https://www.jetbrains.com/qodana/'),
(118, 'Prohibited trailing semicolon in a statement', 'https://www.jetbrains.com/qodana/'),
(119, 'Redeclared names without usages', 'https://www.jetbrains.com/qodana/'),
(120, 'Redundant boolean variable check', 'https://www.jetbrains.com/qodana/'),
(121, 'Redundant parentheses', 'https://www.jetbrains.com/qodana/'),
(122, 'Shadowing built-in names', 'https://www.jetbrains.com/qodana/'),
(123, 'Shadowing names from outer scopes', 'https://www.jetbrains.com/qodana/'),
(124, 'Single character alternation', 'https://www.jetbrains.com/qodana/'),
(125, 'Single quoted docstring', 'https://www.jetbrains.com/qodana/'),
(126, 'Statement has no effect', 'https://www.jetbrains.com/qodana/'),
(127, 'Suspicious relative imports', 'https://www.jetbrains.com/qodana/'),
(128, 'The default argument is mutable', 'https://www.jetbrains.com/qodana/'),
(129, 'Too complex chained comparisons', 'https://www.jetbrains.com/qodana/'),
(130, 'Tuple assignment balance is incorrect', 'https://www.jetbrains.com/qodana/'),
(131, 'Tuple item assignment is prohibited', 'https://www.jetbrains.com/qodana/'),
(132, 'Unbound local variables', 'https://www.jetbrains.com/qodana/'),
(133, 'Unclear exception clauses', 'https://www.jetbrains.com/qodana/'),
(134, 'Unnecessary backslash', 'https://www.jetbrains.com/qodana/'),
(135, 'Unnecessary non-capturing group', 'https://www.jetbrains.com/qodana/'),
(136, 'Unreachable code', 'https://www.jetbrains.com/qodana/'),
(137, 'Unsatisfied package requirements', 'https://www.jetbrains.com/qodana/'),
(138, 'Unused local symbols', 'https://www.jetbrains.com/qodana/'),
(139, 'Using equality operators to compare with None', 'https://www.jetbrains.com/qodana/'),
(140, '__init__ method that returns a value', 'https://www.jetbrains.com/qodana/'),
(141, 'No definition', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `metricDiscrepancies`
--

CREATE TABLE `metricDiscrepancies` (
  `uniqueID` int NOT NULL,
  `firstToolMetricID` int DEFAULT NULL,
  `secondToolMetricID` int DEFAULT NULL,
  `description` mediumtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `metricDiscrepancies`
--

INSERT INTO `metricDiscrepancies` (`uniqueID`, `firstToolMetricID`, `secondToolMetricID`, `description`) VALUES
(1, 1, 2, 'błąd'),
(3, 121, 122, 'różnica: 448. Biorąc pod uwagę, że oryginalny plik ma 2106 linii, wynik z narzędzia cppdepend jest bardzo mały.'),
(4, 121, 123, 'różnica: 680. Duża różnica wynika głównie z bardzo niskiego pomiaru otrzymanego z narzędzia cppdepend dla linii kodu. Pomiar dla narzędzia OCLint otrzymany przy pomocy własnego skryptu i flagi -rc=LONG_METHOD=0'),
(5, 122, 123, 'różnica: 232. Lizard liczy sumę linii kodu nie zawierających komentarzy. Wynik otrzymany przez OCLint jest sumą linii kodu wszystkich metod. Plik zawierał linie kodu będące komentarzami i linie kodu zawierające komentarze. Stąd wynik otrzymany przez OCLint jest wyższy. Pomiar dla narzędzia OCLint otrzymany przy pomocy własnego skryptu i flagi -rc=LONG_METHOD=0'),
(6, 224, 223, 'różnica: 0.04. Z obserwacji wynika, że lizard zwraca wyniki z dokładnością do jednego miejsca po przecinku. Gdyby zaokrąglić wynik pomiaru 2.66 do 2.7, różnica wynosiłaby 0.'),
(7, 224, 222, 'różnica: 0.37. Wynik otrzymany przez OCLint był obliczany przy pomocy własnego skryptu i flagi -rc=CYCLOMATIC_COMPLEXITY=0. Wynik w ten sposób otrzymany odbiega od wyników zmierzonych przy użyciu pozostałych narzędzi.'),
(8, 223, 222, 'różnica: 0.41. Wynik otrzymany przez OCLint był obliczany przy pomocy własnego skryptu i flagi -rc=CYCLOMATIC_COMPLEXITY=0. Wynik w ten sposób otrzymany odbiega od wyników zmierzonych przy użyciu pozostałych narzędzi.'),
(9, 74, 67, 'różnica: 4. Wynik byłby identyczny, gdyby wziąć pod uwagę wynik z Dashbordu narzędzia cppdepend. Wybrany został jednak wynik otrzymany z kwerendy, aby zachować spójność pomiarów - przy pomocy kwerendy otrzymana została wartość dla liczby parametrów.\r\nkwerenda do obliczenia liczby metod w cppdepend: (from m in Methods orderby m.NbLinesOfCode descending\r\nselect new { m, m.NbParameters ,m.IsThirdParty}).Where(x => x.IsThirdParty == false).Count()'),
(10, 74, 221, 'różnica: 25. Wynik otrzymany przez OCLint był obliczany przy pomocy własnego skryptu i flagi -rc=LONG_METHOD=0 - zliczane były wszystkie metody o długości powyżej 0. Wynik w ten sposób otrzymany odbiega od wyników zmierzonych przy użyciu pozostałych narzędzi.\r\nkwerenda do obliczenia liczby metod w cppdepend: (from m in Methods orderby m.NbLinesOfCode descending\r\nselect new { m, m.NbParameters ,m.IsThirdParty}).Where(x => x.IsThirdParty == false).Count()'),
(11, 67, 221, 'różnica: 21. Wynik otrzymany przez OCLint był obliczany przy pomocy własnego skryptu i flagi -rc=LONG_METHOD=0 - zliczane były wszystkie metody o długości powyżej 0. Wynik w ten sposób otrzymany odbiega od wyników zmierzonych przy użyciu pozostałych narzędzi.'),
(12, 76, 77, 'różnica: 7. W przypadku metryki mierzącej liczbę funkcji wynik w przypadku lizarda był wyższy. Stąd prawdopodobnie różnica również w liczbie parametrów. Dodatkowo wartość tej metryki dla lizarda była liczona przez własny skrypt na podstawie zwróconego raportu przez narzędzie.\r\nkwerenda do obliczenia liczby parametrów w cppdepend: (from m in Methods orderby m.NbLinesOfCode descending\r\nselect new { m, m.NbParameters ,m.IsThirdParty}).Where(x => x.IsThirdParty == false).Sum(x => x.NbParameters)'),
(13, 76, 220, 'różnica: 100. Wynik otrzymany przez OCLint był obliczany przy pomocy własnego skryptu i flagi -rc=TOO_MANY_PARAMETERS=0 - zliczane były liczby parametrów metod o liczbie parametrów powyżej 0. Wynik w ten sposób otrzymany odbiega od wyników zmierzonych przy użyciu pozostałych narzędzi.\r\nkwerenda do obliczenia liczby parametrów w cppdepend: (from m in Methods orderby m.NbLinesOfCode descending\r\nselect new { m, m.NbParameters ,m.IsThirdParty}).Where(x => x.IsThirdParty == false).Sum(x => x.NbParameters)'),
(14, 77, 220, 'różnica: 93. Wynik otrzymany przez OCLint był obliczany przy pomocy własnego skryptu i flagi -rc=TOO_MANY_PARAMETERS=0 - zliczane były liczby parametrów metod o liczbie parametrów powyżej 0. Wynik w ten sposób otrzymany odbiega od wyników zmierzonych przy użyciu pozostałych narzędzi. Dodatkowo wartość tej metryki dla lizarda była liczona przez własny skrypt na podstawie zwróconego raportu przez narzędzie.'),
(15, 2, 109, 'Bardzo duża różnica wartości. Kilku do kilkunastokrotne powiększenie, widać pewne podobieństwo między skalą powiększenia pomiędzy plikami'),
(16, 2, 111, 'Lizard daje dużo mniejsze wartości, około 10 razy mniejsze.'),
(17, 2, 78, 'Podobne wyniki. Dla np source 5 wyniki takie same. Jeśli są różnice to niedużej skali, w okolicach 2x'),
(18, 112, 131, 'SonarQube zwykle daje większe wartości, od 2x do 4x, ale nie ma stałej zależności. W source 4 pełna zgodność wartości, a w source 2 SonarQube dał mniejszy wynik.\r\n'),
(19, 114, 129, 'Identyczne wartości dla każdego source'),
(20, 148, 152, 'PMD(NCSS) - Keywords incrementing the number of lines: if, else, while, do, for, switch, break, continue, return, throw, synchronized, catch, finally. Number of lines is also incremented by: variable declaration, and statement expression. \r\n\r\nCheckstyle(JavaNCSS) - NCSS counter is incremented by each: package declaration, import declaration, class declaration, interface declaration, field declaration, method declaration, constructor declaration, constructor invocation, statement(expression, if, else, while, do, for, switch, break, continue, return, throw, synchronized, catch, finally), label(normal, case, default). '),
(21, 149, 153, 'PMD(NPATH) - Empty block has a complexity of 1. Number of switch cases + the complexity of each case block. In ?: its sum of 3 expressions. It\'s counting try-catch statement. Return is the complexity of the statement or 1 if there is none. Sequences of binary expressions count as 1. \r\n\r\nCheckstyle(NPathComplexity) - S(i=1:i=n)NP(case-range[i]) + NP(default-range) + NP(expr). In ?: its sum of 3 expressions + 2. It\'s not counting try-catch statement. Return is always 1. Sequences of binary expressions count as sum. '),
(22, 155, 142, 'Jacoco: Exception handling is not considered as branches in the context of this counter definition\r\n\r\nSonar: There is no information if exception handling is considered as branches in the context of this counter definition\r\n');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `metricNames`
--

CREATE TABLE `metricNames` (
  `uniqueID` int NOT NULL,
  `metricName` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `metricNames`
--

INSERT INTO `metricNames` (`uniqueID`, `metricName`) VALUES
(1, 'Cyclomatic complexity'),
(2, 'Code duplication percentage'),
(3, 'Duplicated blocks'),
(4, 'Duplicated files'),
(5, 'Duplicated lines'),
(6, 'Classes'),
(7, 'Comment lines'),
(8, 'Directories'),
(9, 'Files'),
(10, 'Lines'),
(11, 'Lines of code'),
(12, 'Functions'),
(13, 'Projects'),
(14, 'Statements'),
(15, 'Condition coverage'),
(16, 'Conditions by line'),
(17, 'Coverage'),
(18, 'Line coverage'),
(19, 'Lines to cover'),
(20, 'Unit tests'),
(21, 'Code smells'),
(22, 'Number of vulnerabilities'),
(23, 'Number of possible bugs'),
(24, 'Cognitive complexity'),
(25, 'Branch coverage'),
(26, 'Class Fan Out Complexity'),
(27, 'NCSS'),
(28, 'NPath Complexity'),
(29, 'Unused variables'),
(30, 'Unused imports'),
(31, 'Duplicated signatures'),
(32, 'Number of parameters'),
(33, 'Unique operators'),
(34, 'Unique operands'),
(35, 'Operators'),
(36, 'Operands'),
(37, 'Length'),
(38, 'Vocabulary size'),
(39, 'Program volume'),
(40, 'Difficulty to write'),
(41, 'Effort to write'),
(42, 'Time to write'),
(43, 'FTA score'),
(44, 'Assessment'),
(68, 'Token count'),
(69, 'Average function parameter count'),
(71, 'Average function name length'),
(72, 'Test coverage'),
(73, 'Unused variables'),
(74, 'Unused imports'),
(75, 'Bugs'),
(79, '__init__ method that returns a value'),
(80, 'Using equality operators to compare with None'),
(81, 'Unused local symbols'),
(82, 'Unsatisfied package requirements'),
(83, 'Unreachable code'),
(84, 'Unnecessary non-capturing group'),
(85, 'Unnecessary backslash'),
(86, 'Unclear exception clauses'),
(87, 'Unbound local variables'),
(88, 'Tuple item assignment is prohibited'),
(89, 'Tuple assignment balance is incorrect'),
(90, 'Too complex chained comparisons'),
(91, 'The default argument is mutable'),
(92, 'Suspicious relative imports'),
(93, 'Statement has no effect'),
(94, 'Single quoted docstring'),
(95, 'Single character alternation'),
(96, 'Shadowing names from outer scopes'),
(97, 'Shadowing built-in names'),
(98, 'Redundant parentheses'),
(99, 'Redundant boolean variable check'),
(100, 'Redeclared names without usages'),
(101, 'Prohibited trailing semicolon in a statement'),
(102, 'Problematic nesting of decorators'),
(103, 'PEP 8 naming convention violation'),
(104, 'PEP 8 coding style violation'),
(105, 'Non-optimal list declaration'),
(106, 'Missed call to \'__init__\' of the super class'),
(107, 'Method signature does not match signature of overridden method'),
(108, 'Method is not declared static'),
(109, 'Invalid usages of classes with \'__slots__\' definitions'),
(110, 'Invalid usage of ClassVar variables'),
(111, 'Invalid type hints definitions and usages'),
(112, 'Invalid protocol definitions and usages'),
(113, 'Invalid definition and usage of Data Classes'),
(114, 'Invalid TypedDict definition and usages'),
(115, 'Incorrect type'),
(116, 'Incorrect property definition'),
(117, 'Incorrect docstring'),
(118, 'Incorrect call arguments'),
(119, 'Incorrect arguments in @pytest.mark.parametrize'),
(120, 'Inappropriate access to properties'),
(121, 'Improper position of from __future__ import'),
(122, 'Improper first parameter'),
(123, 'Global variable is not defined at the module level'),
(124, 'Function call can be replaced with set literal'),
(125, 'Fixture is not requested by test functions'),
(126, 'First argument of the method is reassigned'),
(127, 'Errors in string formatting operations'),
(128, 'Duplicate character in character class'),
(129, 'Dictionary creation can be rewritten by dictionary literal'),
(130, 'Dictionary contains duplicate keys'),
(131, 'Deprecated function, class, or module'),
(132, 'Consecutive spaces'),
(133, 'Class-specific decorator is used outside the class'),
(134, 'Class must implement all abstract methods'),
(135, 'Begin or end anchor in unexpected position'),
(136, 'Attempt to call a non-callable object'),
(137, 'Assignments to \'for\' loop or \'with\' statement parameter'),
(138, 'Assigning function calls that don\'t return anything'),
(139, 'An instance attribute is defined outside __init__'),
(140, 'Accessing a protected member of a class or a module'),
(141, 'Avg Cyclomatic Complexity');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `metricValues`
--

CREATE TABLE `metricValues` (
  `uniqueID` int NOT NULL,
  `toolMetricID` int DEFAULT NULL,
  `projectID` int DEFAULT NULL,
  `levelID` int DEFAULT NULL,
  `sourceID` int DEFAULT NULL,
  `metricValue` varchar(255) DEFAULT NULL,
  `path` longtext
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `metricValues`
--

INSERT INTO `metricValues` (`uniqueID`, `toolMetricID`, `projectID`, `levelID`, `sourceID`, `metricValue`, `path`) VALUES
(7, 1, 1, 1, 3, NULL, NULL),
(8, 1, 1, 1, 2, NULL, NULL),
(9, 1, 1, 1, 1, NULL, NULL),
(10, 2, 1, 1, 3, '25', NULL),
(11, 2, 1, 1, 2, '59', NULL),
(12, 2, 1, 1, 1, '24', NULL),
(13, 3, 1, 1, 3, NULL, NULL),
(14, 3, 1, 1, 2, NULL, NULL),
(15, 3, 1, 1, 1, NULL, NULL),
(16, 4, 1, 1, 3, NULL, NULL),
(17, 4, 1, 1, 2, NULL, NULL),
(18, 4, 1, 1, 1, NULL, NULL),
(19, 43, 1, 1, 3, NULL, NULL),
(20, 43, 1, 1, 2, NULL, NULL),
(21, 43, 1, 1, 1, NULL, NULL),
(22, 44, 1, 1, 3, NULL, NULL),
(23, 44, 1, 1, 2, NULL, NULL),
(24, 44, 1, 1, 1, NULL, NULL),
(25, 65, 1, 1, 3, NULL, NULL),
(26, 65, 1, 1, 2, NULL, NULL),
(27, 65, 1, 1, 1, NULL, NULL),
(28, 78, 1, 1, 3, '16', NULL),
(29, 78, 1, 1, 2, '41', NULL),
(30, 78, 1, 1, 1, '10', NULL),
(31, 79, 1, 1, 3, '25', NULL),
(32, 79, 1, 1, 2, '29', NULL),
(33, 79, 1, 1, 1, '22', NULL),
(34, 80, 1, 1, 3, '149', NULL),
(35, 80, 1, 1, 2, '137', NULL),
(36, 80, 1, 1, 1, '105', NULL),
(37, 81, 1, 1, 3, '419', NULL),
(38, 81, 1, 1, 2, '403', NULL),
(39, 81, 1, 1, 1, '186', NULL),
(40, 82, 1, 1, 3, '514', NULL),
(41, 82, 1, 1, 2, '598', NULL),
(42, 82, 1, 1, 1, '276', NULL),
(43, 83, 1, 1, 3, '933', NULL),
(44, 83, 1, 1, 2, '1001', NULL),
(45, 83, 1, 1, 1, '462', NULL),
(46, 84, 1, 1, 3, '174', NULL),
(47, 84, 1, 1, 2, '166', NULL),
(48, 84, 1, 1, 1, '127', NULL),
(49, 85, 1, 1, 3, '6944.266281626863', NULL),
(50, 85, 1, 1, 2, '7382.414470778272', NULL),
(51, 85, 1, 1, 1, '3228.7723252887404', NULL),
(52, 86, 1, 1, 3, '41.395973154362416', NULL),
(53, 86, 1, 1, 2, '61.10948905109489', NULL),
(54, 86, 1, 1, 1, '28.914285714285715', NULL),
(55, 87, 1, 1, 3, '287464.66057096975', NULL),
(56, 87, 1, 1, 2, '451135.57627266925', NULL),
(57, 87, 1, 1, 1, '93357.64551977729', NULL),
(58, 88, 1, 1, 3, '15970.25892060943', NULL),
(59, 88, 1, 1, 2, '25063.087570703847', NULL),
(60, 88, 1, 1, 1, '5186.535862209849', NULL),
(61, 89, 1, 1, 3, '2.3147554272089543', NULL),
(62, 89, 1, 1, 2, '2.460804823592757', NULL),
(63, 89, 1, 1, 1, '1.0762574417629134', NULL),
(64, 90, 1, 1, 3, '303', NULL),
(65, 90, 1, 1, 2, '394', NULL),
(66, 90, 1, 1, 1, '203', NULL),
(67, 91, 1, 1, 3, '62.30941501078834', NULL),
(68, 91, 1, 1, 2, '65.24848808728797', NULL),
(69, 91, 1, 1, 1, '58.51016613862266', NULL),
(70, 92, 1, 1, 3, 'Needs improvement', NULL),
(71, 92, 1, 1, 2, 'Needs improvement', NULL),
(72, 92, 1, 1, 1, 'Could be better', NULL),
(73, 109, 1, 1, 3, '123', NULL),
(74, 109, 1, 1, 2, '202', NULL),
(75, 109, 1, 1, 1, '126', NULL),
(76, 111, 1, 1, 3, '2.2', NULL),
(77, 111, 1, 1, 2, '1.4', NULL),
(78, 111, 1, 1, 1, '1.7', NULL),
(79, 112, 1, 1, 3, '6', NULL),
(80, 112, 1, 1, 2, '28', NULL),
(81, 112, 1, 1, 1, '7', NULL),
(82, 113, 1, 1, 3, '61.3', NULL),
(83, 113, 1, 1, 2, '16.4', NULL),
(84, 113, 1, 1, 1, '38.1', NULL),
(85, 114, 1, 1, 3, '303', NULL),
(86, 114, 1, 1, 2, '394', NULL),
(87, 114, 1, 1, 1, '203', NULL),
(88, 115, 1, 1, 3, '2.2', NULL),
(89, 115, 1, 1, 2, '1.4', NULL),
(90, 115, 1, 1, 1, '1.7', NULL),
(91, 116, 1, 1, 3, '6', NULL),
(92, 116, 1, 1, 2, '28', NULL),
(93, 116, 1, 1, 1, '7', NULL),
(94, 117, 1, 1, 3, '61.3', NULL),
(95, 117, 1, 1, 2, '16.4', NULL),
(96, 117, 1, 1, 1, '38.1', NULL),
(97, 118, 1, 1, 3, '303', NULL),
(98, 118, 1, 1, 2, '349', NULL),
(99, 118, 1, 1, 1, '203', NULL),
(100, 119, 1, 1, 3, NULL, NULL),
(101, 119, 1, 1, 2, NULL, NULL),
(102, 119, 1, 1, 1, NULL, NULL),
(134, 1, 2, 1, 6, NULL, NULL),
(135, 1, 2, 1, 5, NULL, NULL),
(136, 1, 2, 1, 4, NULL, NULL),
(137, 2, 2, 1, 6, '17', NULL),
(138, 2, 2, 1, 5, '16', NULL),
(139, 2, 2, 1, 4, '77', NULL),
(140, 3, 2, 1, 6, NULL, NULL),
(141, 3, 2, 1, 5, NULL, NULL),
(142, 3, 2, 1, 4, NULL, NULL),
(143, 4, 2, 1, 6, NULL, NULL),
(144, 4, 2, 1, 5, NULL, NULL),
(145, 4, 2, 1, 4, NULL, NULL),
(146, 43, 2, 1, 6, NULL, NULL),
(147, 43, 2, 1, 5, NULL, NULL),
(148, 43, 2, 1, 4, NULL, NULL),
(149, 44, 2, 1, 6, NULL, NULL),
(150, 44, 2, 1, 5, NULL, NULL),
(151, 44, 2, 1, 4, NULL, NULL),
(152, 65, 2, 1, 6, NULL, NULL),
(153, 65, 2, 1, 5, NULL, NULL),
(154, 65, 2, 1, 4, NULL, NULL),
(155, 78, 2, 1, 6, '14', NULL),
(156, 78, 2, 1, 5, '16', NULL),
(157, 78, 2, 1, 4, '71', NULL),
(158, 79, 2, 1, 6, '22', NULL),
(159, 79, 2, 1, 5, '24', NULL),
(160, 79, 2, 1, 4, '26', NULL),
(161, 80, 2, 1, 6, '82', NULL),
(162, 80, 2, 1, 5, '66', NULL),
(163, 80, 2, 1, 4, '177', NULL),
(164, 81, 2, 1, 6, '154', NULL),
(165, 81, 2, 1, 5, '136', NULL),
(166, 81, 2, 1, 4, '584', NULL),
(167, 82, 2, 1, 6, '187', NULL),
(168, 82, 2, 1, 5, '145', NULL),
(169, 82, 2, 1, 4, '721', NULL),
(170, 83, 2, 1, 6, '341', NULL),
(171, 83, 2, 1, 5, '281', NULL),
(172, 83, 2, 1, 4, '1305', NULL),
(173, 84, 2, 1, 6, '104', NULL),
(174, 84, 2, 1, 5, '90', NULL),
(175, 84, 2, 1, 4, '203', NULL),
(176, 85, 2, 1, 6, '2284.849943886112', NULL),
(177, 85, 2, 1, 5, '1824.2107200686387', NULL),
(178, 85, 2, 1, 4, '10003.263371926656', NULL),
(179, 86, 2, 1, 6, '25.085365853658537', NULL),
(180, 86, 2, 1, 5, '26.363636363636363', NULL),
(181, 86, 2, 1, 4, '52.954802259887', NULL),
(182, 87, 2, 1, 6, '57316.2967630943', NULL),
(183, 87, 2, 1, 5, '48092.82807453684', NULL),
(184, 87, 2, 1, 4, '529720.8338139466', NULL),
(185, 88, 2, 1, 6, '3184.2387090607945', NULL),
(186, 88, 2, 1, 5, '2671.8237819187134', NULL),
(187, 88, 2, 1, 4, '29428.93521188592', NULL),
(188, 89, 2, 1, 6, '0.7616166479620374', NULL),
(189, 89, 2, 1, 5, '0.6080702400228796', NULL),
(190, 89, 2, 1, 4, '3.334421123975552', NULL),
(191, 90, 2, 1, 6, '127', NULL),
(192, 90, 2, 1, 5, '88', NULL),
(193, 90, 2, 1, 4, '528', NULL),
(194, 91, 2, 1, 6, '52.7051641049538', NULL),
(195, 91, 2, 1, 5, '48.59146628277488', NULL),
(196, 91, 2, 1, 4, '71.36238749295335', NULL),
(197, 92, 2, 1, 6, 'Could be better', NULL),
(198, 92, 2, 1, 5, 'OK', NULL),
(199, 92, 2, 1, 4, 'Needs improvement', NULL),
(200, 109, 2, 1, 6, '103', NULL),
(201, 109, 2, 1, 5, '102', NULL),
(202, 109, 2, 1, 4, '210', NULL),
(203, 111, 2, 1, 6, '1.0', NULL),
(204, 111, 2, 1, 5, '2.5', NULL),
(205, 111, 2, 1, 4, '4.2', NULL),
(206, 112, 2, 1, 6, '1', NULL),
(207, 112, 2, 1, 5, '2', NULL),
(208, 112, 2, 1, 4, '9', NULL),
(209, 113, 2, 1, 6, '37.0', NULL),
(210, 113, 2, 1, 5, '31.5', NULL),
(211, 113, 2, 1, 4, '69.3', NULL),
(212, 114, 2, 1, 6, '127', NULL),
(213, 114, 2, 1, 5, '88', NULL),
(214, 114, 2, 1, 4, '528', NULL),
(215, 115, 2, 1, 6, '1.0', NULL),
(216, 115, 2, 1, 5, '2.5', NULL),
(217, 115, 2, 1, 4, '4.2', NULL),
(218, 116, 2, 1, 6, '1', NULL),
(219, 116, 2, 1, 5, '2', NULL),
(220, 116, 2, 1, 4, '9', NULL),
(221, 117, 2, 1, 6, '37.0', NULL),
(222, 117, 2, 1, 5, '31.5', NULL),
(223, 117, 2, 1, 4, '69.3', NULL),
(224, 118, 2, 1, 6, '127', NULL),
(225, 118, 2, 1, 5, '88', NULL),
(226, 118, 2, 1, 4, '528', NULL),
(227, 119, 2, 1, 6, NULL, NULL),
(228, 119, 2, 1, 5, NULL, NULL),
(229, 119, 2, 1, 4, NULL, NULL),
(261, 131, 1, 1, 1, '14', NULL),
(262, 130, 1, 1, 1, '0', NULL),
(263, 129, 1, 1, 1, '203', NULL),
(264, 131, 1, 1, 2, '19', NULL),
(265, 130, 1, 1, 2, '0', NULL),
(266, 129, 1, 1, 2, '394', NULL),
(267, 131, 1, 1, 3, '9', NULL),
(268, 130, 1, 1, 3, '0', NULL),
(269, 129, 1, 1, 3, '303', NULL),
(291, 33, 4, 2, 22, '42489', '/manim'),
(292, 32, 4, 2, 22, '77789', '/manim'),
(293, 34, 4, 2, 22, '3570', '/manim'),
(294, 31, 4, 2, 22, '316', '/manim'),
(295, 36, 4, 2, 22, '28933', '/manim'),
(296, 28, 4, 2, 22, '421', '/manim'),
(297, 29, 4, 2, 22, '26198', '/manim'),
(298, 24, 4, 2, 22, '6679', '/manim'),
(299, 27, 4, 2, 22, '2387', '/manim'),
(300, 25, 4, 2, 22, '90', '/manim'),
(301, 26, 4, 2, 22, '37', '/manim'),
(302, 41, 4, 2, 22, '27230', '/manim'),
(303, 40, 4, 2, 22, '0.0%', '/manim'),
(304, 39, 4, 2, 22, '0.0%', '/manim'),
(305, 151, 5, 1, 7, '0', NULL),
(306, 152, 5, 1, 7, '239', NULL),
(307, 148, 5, 1, 7, '239', NULL),
(308, 151, 6, 1, 8, '20', NULL),
(309, 152, 6, 1, 8, '116', NULL),
(310, 153, 6, 1, 8, '102', NULL),
(311, 154, 6, 1, 8, '38', NULL),
(312, 148, 6, 1, 8, '117', NULL),
(313, 149, 6, 1, 8, '103', NULL),
(314, 144, 6, 1, 8, '37', NULL),
(315, 145, 6, 1, 8, '77', NULL),
(316, 151, 5, 1, 9, '33', NULL),
(317, 152, 5, 1, 9, '330', NULL),
(318, 153, 5, 1, 9, '168', NULL),
(319, 154, 5, 1, 9, '120', NULL),
(320, 148, 5, 1, 9, '330', NULL),
(321, 149, 5, 1, 9, '172', NULL),
(322, 144, 5, 1, 9, '132', NULL),
(323, 145, 5, 1, 9, '80', NULL),
(324, 151, 5, 1, 10, '18', NULL),
(325, 152, 5, 1, 10, '368', NULL),
(326, 153, 5, 1, 10, '162', NULL),
(327, 154, 5, 1, 10, '93', NULL),
(328, 148, 5, 1, 10, '347', NULL),
(329, 149, 5, 1, 10, '139', NULL),
(330, 144, 5, 1, 10, '98', NULL),
(331, 145, 5, 1, 10, '74', NULL),
(332, 151, 5, 1, 11, '23', NULL),
(333, 152, 5, 1, 11, '135', NULL),
(334, 153, 5, 1, 11, '125', NULL),
(335, 154, 5, 1, 11, '42', NULL),
(336, 148, 5, 1, 11, '136', NULL),
(337, 149, 5, 1, 11, '122', NULL),
(338, 144, 5, 1, 11, '46', NULL),
(339, 145, 5, 1, 11, '42', NULL),
(340, 151, 5, 1, 12, '11', NULL),
(341, 152, 5, 1, 12, '189', NULL),
(342, 153, 5, 1, 12, '225', NULL),
(343, 154, 5, 1, 12, '60', NULL),
(344, 148, 5, 1, 12, '194', NULL),
(345, 149, 5, 1, 12, '226', NULL),
(346, 144, 5, 1, 12, '69', NULL),
(347, 145, 5, 1, 12, '75', NULL),
(348, 151, 5, 1, 13, '10', NULL),
(349, 152, 5, 1, 13, '68', NULL),
(350, 153, 5, 1, 13, '37', NULL),
(351, 154, 5, 1, 13, '29', NULL),
(352, 148, 5, 1, 13, '68', NULL),
(353, 149, 5, 1, 13, '39', NULL),
(354, 144, 5, 1, 13, '33', NULL),
(355, 145, 5, 1, 13, '21', NULL),
(356, 151, 5, 1, 14, '11', NULL),
(357, 152, 5, 1, 14, '130', NULL),
(358, 153, 5, 1, 14, '462', NULL),
(359, 154, 5, 1, 14, '34', NULL),
(360, 148, 5, 1, 14, '131', NULL),
(361, 149, 5, 1, 14, '462', NULL),
(362, 144, 5, 1, 14, '46', NULL),
(363, 145, 5, 1, 14, '62', NULL),
(364, 151, 12, 1, 26, '4', NULL),
(365, 152, 12, 1, 26, '118', NULL),
(366, 153, 12, 1, 26, '45', NULL),
(367, 154, 12, 1, 26, '41', NULL),
(368, 148, 12, 1, 26, '120', NULL),
(369, 149, 12, 1, 26, '52', NULL),
(370, 144, 12, 1, 26, '41', NULL),
(371, 145, 12, 1, 26, '40', NULL),
(372, 151, 12, 1, 27, '4', NULL),
(373, 152, 12, 1, 27, '78', NULL),
(374, 153, 12, 1, 27, '33', NULL),
(375, 154, 12, 1, 27, '31', NULL),
(376, 148, 12, 1, 27, '83', NULL),
(377, 149, 12, 1, 27, '33', NULL),
(378, 144, 12, 1, 27, '30', NULL),
(379, 145, 12, 1, 27, '31', NULL),
(380, 151, 12, 1, 28, '6', NULL),
(381, 152, 12, 1, 28, '105', NULL),
(382, 153, 12, 1, 28, '813', NULL),
(383, 154, 12, 1, 28, '43', NULL),
(384, 148, 12, 1, 28, '110', NULL),
(385, 149, 12, 1, 28, '240', NULL),
(386, 144, 12, 1, 28, '43', NULL),
(387, 145, 12, 1, 28, '46', NULL),
(388, 151, 12, 1, 29, '1', NULL),
(389, 152, 12, 1, 29, '85', NULL),
(390, 153, 12, 1, 29, '676', NULL),
(391, 154, 12, 1, 29, '33', NULL),
(392, 148, 12, 1, 29, '86', NULL),
(393, 149, 12, 1, 29, '491', NULL),
(394, 144, 12, 1, 29, '33', NULL),
(395, 145, 12, 1, 29, '42', NULL),
(396, 138, 12, 1, 26, '41', NULL),
(397, 139, 12, 1, 26, '40', NULL),
(398, 142, 12, 1, 26, '100%', NULL),
(399, 143, 12, 1, 26, '100%', NULL),
(400, 138, 12, 1, 27, '30', NULL),
(401, 139, 12, 1, 27, '31', NULL),
(402, 142, 12, 1, 27, '100%', NULL),
(403, 143, 12, 1, 27, '100%', NULL),
(404, 138, 12, 1, 28, '43', NULL),
(405, 139, 12, 1, 28, '39', NULL),
(406, 142, 12, 1, 28, '0%', NULL),
(407, 143, 12, 1, 28, '0%', NULL),
(408, 138, 12, 1, 29, '33', NULL),
(409, 139, 12, 1, 29, '42', NULL),
(410, 142, 12, 1, 29, '29.2%', NULL),
(411, 143, 12, 1, 29, '51.5%', NULL),
(412, 155, 12, 1, 26, '100%', NULL),
(413, 156, 12, 1, 26, '100%', NULL),
(414, 156, 12, 1, 27, '100%', NULL),
(415, 155, 12, 1, 27, 'n/a', NULL),
(416, 155, 12, 1, 28, 'n/a', NULL),
(417, 156, 12, 1, 28, '0%', NULL),
(418, 155, 12, 1, 29, '29%', NULL),
(419, 156, 12, 1, 29, '43%', NULL),
(420, 155, 12, 2, 30, '22%', NULL),
(421, 156, 12, 2, 30, '15%', NULL),
(422, 142, 12, 2, 30, '23.1%', NULL),
(423, 143, 12, 2, 30, '19.5%', NULL),
(424, 155, 12, 2, 31, '63%', NULL),
(425, 156, 12, 2, 31, '46%', NULL),
(426, 142, 12, 2, 31, '63.9%', NULL),
(427, 143, 12, 2, 31, '52.6%', NULL),
(428, 155, 12, 2, 32, '40%', NULL),
(429, 156, 12, 2, 32, '38%', NULL),
(430, 142, 12, 2, 32, '40.8%', NULL),
(431, 143, 12, 2, 32, '39%', NULL),
(432, 131, 2, 1, 4, '9', NULL),
(433, 131, 2, 1, 5, '2', NULL),
(434, 131, 2, 1, 6, '4', NULL),
(435, 130, 2, 1, 4, '0', NULL),
(436, 130, 2, 1, 5, '0', NULL),
(437, 130, 2, 1, 6, '0', NULL),
(438, 129, 2, 1, 4, '528', NULL),
(439, 129, 2, 1, 5, '88', NULL),
(440, 129, 2, 1, 6, '127', NULL),
(441, 218, 10, 2, 33, '19134', NULL),
(442, 217, 10, 2, 33, '569', NULL),
(443, 216, 10, 2, 33, '114', NULL),
(444, 215, 10, 2, 33, '34', NULL),
(445, 214, 10, 2, 33, '3577', NULL),
(446, 213, 10, 2, 33, '1', NULL),
(447, 212, 10, 2, 33, '55', NULL),
(448, 211, 10, 2, 33, '5', NULL),
(449, 210, 10, 2, 33, '3', NULL),
(450, 209, 10, 2, 33, '44', NULL),
(451, 208, 10, 2, 33, '16', NULL),
(452, 207, 10, 2, 33, '58', NULL),
(453, 206, 10, 2, 33, '2', NULL),
(454, 205, 10, 2, 33, '12', NULL),
(455, 204, 10, 2, 33, '28', NULL),
(456, 203, 10, 2, 33, '254', NULL),
(457, 202, 10, 2, 33, '33', NULL),
(458, 201, 10, 2, 33, '40', NULL),
(459, 200, 10, 2, 33, '242', NULL),
(460, 199, 10, 2, 33, '2', NULL),
(461, 198, 10, 2, 33, '3', NULL),
(462, 197, 10, 2, 33, '1', NULL),
(463, 196, 10, 2, 33, '1270', NULL),
(464, 195, 10, 2, 33, '591', NULL),
(465, 194, 10, 2, 33, '7', NULL),
(466, 193, 10, 2, 33, '5257', NULL),
(467, 192, 10, 2, 33, '10', NULL),
(468, 191, 10, 2, 33, '5', NULL),
(469, 190, 10, 2, 33, '1', NULL),
(470, 189, 10, 2, 33, '65', NULL),
(471, 188, 10, 2, 33, '1', NULL),
(472, 187, 10, 2, 33, '1', NULL),
(473, 186, 10, 2, 33, '3565', NULL),
(474, 185, 10, 2, 33, '499', NULL),
(475, 184, 10, 2, 33, '105', NULL),
(476, 183, 10, 2, 33, '90', NULL),
(477, 182, 10, 2, 33, '10163', NULL),
(478, 181, 10, 2, 33, '13223', NULL),
(479, 180, 10, 2, 33, '7', NULL),
(480, 179, 10, 2, 33, '4', NULL),
(481, 178, 10, 2, 33, '85', NULL),
(482, 177, 10, 2, 33, '3', NULL),
(483, 176, 10, 2, 33, '1471', NULL),
(484, 175, 10, 2, 33, '5587', NULL),
(485, 174, 10, 2, 33, '18728', NULL),
(486, 173, 10, 2, 33, '5', NULL),
(487, 172, 10, 2, 33, '601', NULL),
(488, 171, 10, 2, 33, '194', NULL),
(489, 170, 10, 2, 33, '23', NULL),
(490, 169, 10, 2, 33, '45', NULL),
(491, 168, 10, 2, 33, '113', NULL),
(492, 167, 10, 2, 33, '10', NULL),
(493, 166, 10, 2, 33, '1', NULL),
(494, 165, 10, 2, 33, '838', NULL),
(495, 164, 10, 2, 33, '226', NULL),
(496, 163, 10, 2, 33, '4', NULL),
(497, 162, 10, 2, 33, '6', NULL),
(498, 161, 10, 2, 33, '1198', NULL),
(499, 160, 10, 2, 33, '5055', NULL),
(500, 159, 10, 2, 33, '10863', NULL),
(501, 158, 10, 2, 33, '1', NULL),
(502, 157, 10, 2, 33, '1', NULL),
(503, 24, 4, 1, 23, '441', 'ManimCommunity/manim/blob/main/manim/mobject/opengl/opengl_mobject.py'),
(504, 24, 4, 1, 24, '80', 'ManimCommunity/manim/blob/main/manim/utils/rate_functions.py'),
(505, 24, 4, 1, 25, '201', 'https://github.com/ManimCommunity/manim/blob/main/manim/scene/scene.py'),
(506, 219, 11, 2, 34, '142076', 'root'),
(507, 33, 4, 2, 33, '1103159', '/ bez plików *.java'),
(508, 32, 4, 2, 33, '1512284', '/ bez plików *.java'),
(509, 34, 4, 2, 33, '84368', '/ bez plików *.java'),
(510, 31, 4, 2, 33, '3487', '/ bez plików *.java'),
(511, 36, 4, 2, 33, '654752', '/ bez plików *.java'),
(512, 28, 4, 2, 33, '12920', '/ bez plików *.java'),
(513, 29, 4, 2, 33, '209767', '/ bez plików *.java'),
(514, 24, 4, 2, 33, '171890', '/ bez plików *.java'),
(515, 27, 4, 2, 33, '56716', '/ bez plików *.java'),
(516, 25, 4, 2, 33, '3208', '/ bez plików *.java'),
(517, 26, 4, 2, 33, '453', '/ bez plików *.java'),
(518, 41, 4, 2, 33, '643287', '/ bez plików *.java'),
(519, 40, 4, 2, 33, '0.0%', '/ bez plików *.java'),
(520, 39, 4, 2, 33, '0.0%', '/ bez plików *.java'),
(522, 121, 13, 1, NULL, '1397', NULL),
(523, 224, 13, 1, NULL, '2.66', NULL),
(524, 74, 13, 1, NULL, '191', NULL),
(525, 76, 13, 1, NULL, '318', NULL),
(526, 122, 13, 1, NULL, '1845', NULL),
(527, 223, 13, 1, NULL, '2.7', NULL),
(528, 67, 13, 1, NULL, '187', NULL),
(529, 77, 13, 1, NULL, '325', NULL),
(530, 123, 13, 1, NULL, '2077', NULL),
(531, 222, 13, 1, NULL, '2.29', NULL),
(532, 221, 13, 1, NULL, '166', NULL),
(533, 220, 13, 1, NULL, '418', NULL),
(534, 225, 10, 2, 33, '178583', NULL),
(535, 225, 11, 2, 34, '1333', NULL),
(536, 225, 11, 2, 34, '1333', NULL),
(537, NULL, 11, 2, 34, '1333', NULL),
(538, 225, 11, 2, 34, '65464566', NULL),
(539, 226, 11, 2, 34, '1333', NULL),
(540, 227, 11, 2, 34, '1333', NULL),
(541, 227, 11, 2, 34, '9999999', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `projects`
--

CREATE TABLE `projects` (
  `uniqueID` int NOT NULL,
  `projectName` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `projects`
--

INSERT INTO `projects` (`uniqueID`, `projectName`, `url`) VALUES
(1, 'vercel/ai', 'https://github.com/vercel/ai'),
(2, 'dubinc/dub', 'https://github.com/dubinc/dub'),
(3, 'azure-sdk-for-python', 'https://github.com/Azure/azure-sdk-for-python'),
(4, 'Manim', 'https://github.com/ManimCommunity/manim'),
(5, 'java-tron', 'https://github.com/tronprotocol/java-tron'),
(6, 'dolphinscheduler', 'https://github.com/apache/dolphinscheduler'),
(7, 'rampack', 'https://github.com/PKua007/rampack'),
(8, 'litecoin', 'https://github.com/litecoin-project/litecoin'),
(9, 'godot', 'https://github.com/godotengine/godot'),
(10, 'PyTorch', 'https://github.com/pytorch/pytorch'),
(11, 'MeloTTS', 'https://github.com/myshell-ai/MeloTTS/archive/abf885a.zip'),
(12, 'The Algorithms', 'https://github.com/TheAlgorithms/Java'),
(13, 'baca-like file', NULL);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `sources`
--

CREATE TABLE `sources` (
  `uniqueID` int NOT NULL,
  `source` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `sources`
--

INSERT INTO `sources` (`uniqueID`, `source`) VALUES
(1, 'packages/core/core/generate-text/stream-text.ts'),
(2, 'packages/core/react/use-chat.ts'),
(3, 'packages/core/mistral/mistral-chat-language-model.ts'),
(4, 'apps/web/lib/auth/index.ts'),
(5, 'apps/web/app/api/analytics/edge/[endpoint]/route.ts'),
(6, 'apps/web/lib/api/links/edit-link.ts'),
(7, 'https://github.com/tronprotocol/java-tron/blob/40d7f2695c754ce6ae8c1191dfcbc0027c90bc34/common/src/main/java/org/tron/core/Constant.java'),
(8, 'https://github.com/apache/dolphinscheduler/blob/dev/dolphinscheduler-api/src/main/java/org/apache/dolphinscheduler/api/service/impl/WorkFlowLineageServiceImpl.java'),
(9, 'https://github.com/tronprotocol/java-tron/blob/40d7f2695c754ce6ae8c1191dfcbc0027c90bc34/crypto/src/main/java/org/tron/common/crypto/ECKey.java'),
(10, 'https://github.com/tronprotocol/java-tron/blob/40d7f2695c754ce6ae8c1191dfcbc0027c90bc34/plugins/src/main/java/org/tron/plugins/DbLite.java'),
(11, 'https://github.com/tronprotocol/java-tron/blob/40d7f2695c754ce6ae8c1191dfcbc0027c90bc34/actuator/src/main/java/org/tron/core/utils/TransactionUtil.java'),
(12, 'https://github.com/tronprotocol/java-tron/blob/40d7f2695c754ce6ae8c1191dfcbc0027c90bc34/chainbase/src/main/java/org/tron/common/zksnark/IncrementalMerkleTreeContainer.java'),
(13, 'https://github.com/tronprotocol/java-tron/blob/40d7f2695c754ce6ae8c1191dfcbc0027c90bc34/chainbase/src/main/java/org/tron/common/utils/Commons.java'),
(14, 'https://github.com/tronprotocol/java-tron/blob/40d7f2695c754ce6ae8c1191dfcbc0027c90bc34/actuator/src/main/java/org/tron/core/vm/nativecontract/UnfreezeBalanceProcessor.java'),
(15, 'https://github.com/apache/dolphinscheduler/tree/dev/dolphinscheduler-api/src'),
(16, 'https://github.com/PKua007/rampack/blob/main/src/core/Simulation.cpp'),
(17, 'https://github.com/litecoin-project/litecoin/blob/master/src/crypto/scrypt.cpp'),
(18, 'https://github.com/godotengine/godot/blob/master/thirdparty/vulkan/include/vulkan/vulkan_funcs.hpp'),
(19, 'https://github.com/godotengine/godot/blob/master/thirdparty/vulkan/include/vulkan/vulkan_structs.hpp'),
(20, 'https://github.com/godotengine/godot/blob/master/thirdparty/vulkan/include/vulkan/vulkan_raii.hpp'),
(21, 'https://github.com/PKua007/rampack/blob/main/src/pyon/MatcherAlternative.cpp'),
(22, 'https://github.com/ManimCommunity/manim/'),
(23, 'https://github.com/ManimCommunity/manim/blob/main/manim/mobject/opengl/opengl_mobject.py'),
(24, 'https://github.com/ManimCommunity/manim/blob/main/manim/utils/rate_functions.py'),
(25, 'https://github.com/ManimCommunity/manim/blob/main/manim/scene/scene.py'),
(26, 'https://github.com/TheAlgorithms/Java/blob/master/src/main/java/com/thealgorithms/strings/AhoCorasick.java'),
(27, 'https://github.com/TheAlgorithms/Java/blob/master/src/main/java/com/thealgorithms/others/MemoryManagementAlgorithms.java'),
(28, 'https://github.com/TheAlgorithms/Java/blob/master/src/main/java/com/thealgorithms/others/Dijkstra.java'),
(29, 'https://github.com/TheAlgorithms/Java/blob/master/src/main/java/com/thealgorithms/others/CRCAlgorithm.java'),
(30, 'https://github.com/TheAlgorithms/Java/tree/master/src/main/java/com/thealgorithms/others'),
(31, 'https://github.com/TheAlgorithms/Java/tree/master/src/main/java/com/thealgorithms/sorts'),
(32, 'https://github.com/TheAlgorithms/Java/tree/master/src/main/java/com/thealgorithms'),
(33, 'https://github.com/pytorch/pytorch'),
(34, 'https://github.com/myshell-ai/MeloTTS/archive/abf885a.zip');

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `tools`
--

CREATE TABLE `tools` (
  `uniqueID` int NOT NULL,
  `toolName` varchar(255) DEFAULT NULL,
  `description` longtext,
  `version` varchar(255) DEFAULT NULL,
  `url` varchar(255) DEFAULT NULL,
  `licenseID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `tools`
--

INSERT INTO `tools` (`uniqueID`, `toolName`, `description`, `version`, `url`, `licenseID`) VALUES
(1, 'Qodana', 'Qodana is a smart code quality platform by JetBrains best suited for working in teams. It can analyze code written in 60+ languages including Java, JavaScript, TypeScript, PHP, Kotlin, Python, Go, and C#.', '2023.3', 'https://www.jetbrains.com/qodana/', 1),
(2, 'SonarQube', 'SonarQube includes a powerful secrets detection tool, one of the most comprehensive solutions for detecting and removing secrets in code.', '10.4.1.88267', 'https://github.com/SonarSource/sonarqube', 5),
(3, 'PMD', 'PMD is a source code analyzer. It finds common programming flaws like unused variables, empty catch blocks, unnecessary object creation, and so forth. It supports Java, JavaScript, Salesforce.com Apex and Visualforce, PLSQL, Apache Velocity, XML, XSL.', '7.0.0-rc4 ', 'https://pmd.github.io/', 10),
(4, 'JaCoCo', 'JaCoCo is a free code coverage library for Java, which has been created by the EclEmma team based on the lessons learned from using and integration existing libraries for many years.', '0.8.11', 'https://www.eclemma.org/jacoco/', 11),
(5, 'Checkstyle', 'Checkstyle is a development tool to help programmers write Java code that adheres to a coding standard. It automates the process of checking Java code to spare humans of this boring (but important) task. This makes it ideal for projects that want to enforce a coding standard.\r\n\r\nCheckstyle is highly configurable and can be made to support almost any coding standard. An example configuration files are supplied supporting the Sun Code Conventions, Google Java Style.', '10.14.0', 'https://checkstyle.sourceforge.io/', 12),
(6, 'PyDev', 'PyDev is a Python IDE for Eclipse, which may be used in Python, Jython and IronPython development.', '12.0.0', 'https://www.pydev.org/index.html', 6),
(7, 'lizard', 'Lizard is an extensible Cyclomatic Complexity Analyzer for many programming languages including C/C++ (doesn\'t require all the header files or Java imports). It also does copy-paste detection (code clone detection/code duplicate detection) and many other forms of static code analysis.', '1.17.10', 'https://github.com/terryyin/lizard', 7),
(8, 'cppdepend', 'The Ultimate C/C++ Code Quality Analysis Tool for Professionals.', '2024.1', 'https://www.cppdepend.com', 1),
(9, 'OCLint', 'OCLint is a static code analysis tool for improving quality and reducing defects by inspecting C, C++ and Objective-C code and looking for potential problems', '21.10', 'https://oclint.org', 8),
(10, 'PVS-Studio', 'PVS‑Studio detects various errors – typos, dead code, and potential vulnerabilities (Static Application Security Testing, SAST).\r\n\r\nThe analyzer matches warnings to the Common Weakness Enumeration, SEI CERT Coding Standards, and supports the MISRA standard.', '7.29', 'https://pvs-studio.com/en/pvs-studio', 1),
(11, 'FTA', 'FTA (Fast TypeScript Analyzer) is a super-fast TypeScript static analysis tool written in Rust. It captures static information about TypeScript code and generates easy-to-understand analytics that tell you about complexity and maintainability issues that you may want to address.', ' v2.0.0', 'https://ftaproject.dev/', 7),
(12, 'cyclomatic-complexity', 'Detect cyclomatic complexity of your JavaScript and TypeScript code', 'v1.2.3', 'https://github.com/pilotpirxie/cyclomatic-complexity', 7),
(13, 'FREGE', 'FREGE is an open-source application dedicated to analyzing other open-source repositories available on Github, Gitlab ect. for various metrics like average number of lines of code, average cyclomatic complexity, token count or number of devs per project.', NULL, 'https://github.com/Software-Engineering-Jagiellonian/django-celery-frege', 9),
(14, 'PyCharm', 'PyCharm is an integrated development environment (IDE) used for programming in Python. It provides code analysis, a graphical debugger, an integrated unit tester, integration with version control systems, and supports web development with Django. PyCharm is developed by the Czech company JetBrains.', '2023.3', 'https://www.jetbrains.com/pycharm/', 10),
(15, 'Pylint', 'Pylint is a static code analyser for Python 2 or 3. The latest version supports Python 3.8.0 and above.\r\n\r\nPylint analyses your code without actually running it. It checks for errors, enforces a coding standard, looks for code smells, and can make suggestions about how the code could be refactored.', '3.1.0', 'https://pypi.org/project/pylint/', 9);

-- --------------------------------------------------------

--
-- Struktura tabeli dla tabeli `toolsMetricsConnections`
--

CREATE TABLE `toolsMetricsConnections` (
  `uniqueID` int NOT NULL,
  `languageID` int DEFAULT NULL,
  `toolID` int DEFAULT NULL,
  `metricID` int DEFAULT NULL,
  `definitionID` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Zrzut danych tabeli `toolsMetricsConnections`
--

INSERT INTO `toolsMetricsConnections` (`uniqueID`, `languageID`, `toolID`, `metricID`, `definitionID`) VALUES
(1, 1, 1, 1, 1),
(2, 1, 2, 1, 2),
(3, 1, 1, 2, 3),
(4, 1, 1, 17, 24),
(24, 3, 2, 1, 2),
(25, 3, 2, 3, 4),
(26, 3, 2, 4, 5),
(27, 3, 2, 5, 6),
(28, 3, 2, 6, 7),
(29, 3, 2, 7, 8),
(30, 3, 2, 8, 9),
(31, 3, 2, 9, 10),
(32, 3, 2, 10, 11),
(33, 3, 2, 11, 12),
(34, 3, 2, 12, 13),
(35, 3, 2, 13, 14),
(36, 3, 2, 14, 15),
(37, 3, 2, 15, 18),
(38, 3, 2, 16, 19),
(39, 3, 2, 17, 20),
(40, 3, 2, 18, 21),
(41, 3, 2, 19, 22),
(42, 3, 2, 20, 23),
(43, 1, 1, 21, 25),
(44, 1, 1, 22, 26),
(46, 4, 3, 3, 4),
(54, 4, 3, 11, 12),
(60, 4, 3, 17, 20),
(61, 4, 3, 18, 21),
(62, 4, 3, 19, 22),
(64, 4, 3, 1, 27),
(65, 1, 1, 23, 28),
(67, 5, 7, 12, 65),
(68, 5, 7, 1, 66),
(69, 5, 9, 1, 141),
(70, 5, 2, 10, 11),
(71, 5, 2, 12, 13),
(72, 5, 2, 1, 2),
(74, 5, 8, 12, 37),
(75, 5, 8, 1, 38),
(76, 5, 8, 32, 39),
(77, 5, 7, 32, 67),
(78, 1, 11, 1, 1),
(79, 1, 11, 33, 41),
(80, 1, 11, 34, 42),
(81, 1, 11, 35, 43),
(82, 1, 11, 36, 44),
(83, 1, 11, 37, 45),
(84, 1, 11, 38, 46),
(85, 1, 11, 39, 47),
(86, 1, 11, 40, 48),
(87, 1, 11, 41, 49),
(88, 1, 11, 42, 50),
(89, 1, 11, 23, 51),
(90, 1, 11, 10, 11),
(91, 1, 11, 43, 52),
(92, 1, 11, 44, 53),
(108, 5, 2, 3, 40),
(109, 1, 12, 1, 141),
(111, 1, 7, 1, 141),
(112, 1, 7, 12, 55),
(113, 1, 7, 68, 141),
(114, 1, 7, 11, 141),
(115, 1, 13, 1, 141),
(116, 1, 13, 12, 55),
(117, 1, 13, 68, 141),
(118, 1, 13, 11, 141),
(119, 1, 13, 71, 141),
(120, 5, 2, 11, 54),
(121, 5, 8, 11, 56),
(122, 5, 7, 11, 57),
(123, 5, 9, 11, 58),
(127, 5, 10, 3, 59),
(128, 5, 10, 1, 60),
(129, 1, 2, 11, 62),
(130, 1, 2, 75, 63),
(131, 1, 2, 12, 64),
(132, 3, 1, 1, 1),
(133, 3, 1, 2, 3),
(134, 3, 1, 72, 61),
(135, 3, 1, 23, 51),
(136, 3, 1, 21, 25),
(137, 3, 1, 22, 26),
(138, 4, 2, 1, 2),
(139, 4, 2, 24, 68),
(140, 4, 2, 11, 12),
(141, 4, 2, 3, 4),
(142, 4, 2, 15, 18),
(143, 4, 2, 18, 21),
(144, 4, 3, 1, 69),
(145, 4, 3, 24, 29),
(146, 4, 3, 3, 70),
(147, 4, 3, 26, 76),
(148, 4, 3, 27, 71),
(149, 4, 3, 28, 72),
(150, 4, 5, 1, 73),
(151, 4, 5, 26, 31),
(152, 4, 5, 27, 32),
(153, 4, 5, 28, 33),
(154, 4, 4, 1, 74),
(155, 4, 4, 25, 30),
(156, 4, 4, 18, 75),
(157, 3, 1, 79, 140),
(158, 3, 1, 80, 139),
(159, 3, 1, 81, 138),
(160, 3, 1, 82, 137),
(161, 3, 1, 83, 136),
(162, 3, 1, 84, 135),
(163, 3, 1, 85, 134),
(164, 3, 1, 86, 133),
(165, 3, 1, 87, 132),
(166, 3, 1, 88, 131),
(167, 3, 1, 89, 130),
(168, 3, 1, 90, 129),
(169, 3, 1, 91, 128),
(170, 3, 1, 92, 127),
(171, 3, 1, 93, 126),
(172, 3, 1, 94, 125),
(173, 3, 1, 95, 124),
(174, 3, 1, 96, 123),
(175, 3, 1, 97, 122),
(176, 3, 1, 98, 121),
(177, 3, 1, 99, 120),
(178, 3, 1, 100, 119),
(179, 3, 1, 101, 118),
(180, 3, 1, 102, 117),
(181, 3, 1, 103, 116),
(182, 3, 1, 104, 115),
(183, 3, 1, 105, 114),
(184, 3, 1, 106, 113),
(185, 3, 1, 107, 112),
(186, 3, 1, 108, 111),
(187, 3, 1, 109, 110),
(188, 3, 1, 110, 109),
(189, 3, 1, 111, 108),
(190, 3, 1, 112, 107),
(191, 3, 1, 113, 106),
(192, 3, 1, 114, 105),
(193, 3, 1, 115, 104),
(194, 3, 1, 116, 103),
(195, 3, 1, 117, 102),
(196, 3, 1, 118, 101),
(197, 3, 1, 119, 100),
(198, 3, 1, 120, 99),
(199, 3, 1, 121, 98),
(200, 3, 1, 122, 97),
(201, 3, 1, 123, 96),
(202, 3, 1, 124, 95),
(203, 3, 1, 125, 94),
(204, 3, 1, 126, 93),
(205, 3, 1, 127, 92),
(206, 3, 1, 128, 91),
(207, 3, 1, 129, 90),
(208, 3, 1, 130, 89),
(209, 3, 1, 131, 88),
(210, 3, 1, 132, 87),
(211, 3, 1, 133, 86),
(212, 3, 1, 134, 85),
(213, 3, 1, 135, 84),
(214, 3, 1, 136, 83),
(215, 3, 1, 137, 82),
(216, 3, 1, 138, 81),
(217, 3, 1, 139, 80),
(218, 3, 1, 140, 79),
(219, 3, 14, 11, NULL),
(220, 5, 9, 32, 141),
(221, 5, 9, 12, 141),
(222, 5, 9, 141, 141),
(223, 5, 7, 141, 141),
(224, 5, 8, 141, 141),
(225, 3, 15, 21, 25),
(226, 4, 15, 21, 25),
(227, 4, 6, 21, 25);

--
-- Indeksy dla zrzutów tabel
--

--
-- Indeksy dla tabeli `analysisLevels`
--
ALTER TABLE `analysisLevels`
  ADD PRIMARY KEY (`uniqueID`);

--
-- Indeksy dla tabeli `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`uniqueID`);

--
-- Indeksy dla tabeli `licenses`
--
ALTER TABLE `licenses`
  ADD PRIMARY KEY (`uniqueID`);

--
-- Indeksy dla tabeli `metricDefinitions`
--
ALTER TABLE `metricDefinitions`
  ADD PRIMARY KEY (`uniqueID`);

--
-- Indeksy dla tabeli `metricDiscrepancies`
--
ALTER TABLE `metricDiscrepancies`
  ADD PRIMARY KEY (`uniqueID`);

--
-- Indeksy dla tabeli `metricNames`
--
ALTER TABLE `metricNames`
  ADD PRIMARY KEY (`uniqueID`);

--
-- Indeksy dla tabeli `metricValues`
--
ALTER TABLE `metricValues`
  ADD PRIMARY KEY (`uniqueID`);

--
-- Indeksy dla tabeli `projects`
--
ALTER TABLE `projects`
  ADD PRIMARY KEY (`uniqueID`);

--
-- Indeksy dla tabeli `sources`
--
ALTER TABLE `sources`
  ADD PRIMARY KEY (`uniqueID`);

--
-- Indeksy dla tabeli `tools`
--
ALTER TABLE `tools`
  ADD PRIMARY KEY (`uniqueID`);

--
-- Indeksy dla tabeli `toolsMetricsConnections`
--
ALTER TABLE `toolsMetricsConnections`
  ADD PRIMARY KEY (`uniqueID`);

--
-- AUTO_INCREMENT dla tabel zrzutów
--

--
-- AUTO_INCREMENT dla tabeli `analysisLevels`
--
ALTER TABLE `analysisLevels`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT dla tabeli `languages`
--
ALTER TABLE `languages`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT dla tabeli `licenses`
--
ALTER TABLE `licenses`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT dla tabeli `metricDefinitions`
--
ALTER TABLE `metricDefinitions`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=142;

--
-- AUTO_INCREMENT dla tabeli `metricDiscrepancies`
--
ALTER TABLE `metricDiscrepancies`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT dla tabeli `metricNames`
--
ALTER TABLE `metricNames`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=142;

--
-- AUTO_INCREMENT dla tabeli `metricValues`
--
ALTER TABLE `metricValues`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=542;

--
-- AUTO_INCREMENT dla tabeli `projects`
--
ALTER TABLE `projects`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT dla tabeli `sources`
--
ALTER TABLE `sources`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT dla tabeli `tools`
--
ALTER TABLE `tools`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT dla tabeli `toolsMetricsConnections`
--
ALTER TABLE `toolsMetricsConnections`
  MODIFY `uniqueID` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=228;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
