-- ============================================================================
-- SQL Window Functions Implementation
-- University Academic Management System
-- Part B: Advanced Analytics using Window Functions
-- ============================================================================


-- ============================================================================
-- CATEGORY 1: RANKING FUNCTIONS
-- Functions: ROW_NUMBER(), RANK(), DENSE_RANK(), PERCENT_RANK()
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 1A. ROW_NUMBER() - Assign unique sequential numbers
-- Use Case: Rank students by GPA for honors list and scholarships
-- ----------------------------------------------------------------------------
SELECT 
    student_id,
    student_name,
    department,
    enrollment_year,
    gpa,
    ROW_NUMBER() OVER (ORDER BY gpa DESC) as overall_rank,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY gpa DESC) as department_rank,
    ROW_NUMBER() OVER (PARTITION BY enrollment_year ORDER BY gpa DESC) as year_rank,
    CASE 
        WHEN ROW_NUMBER() OVER (ORDER BY gpa DESC) <= 5 THEN 'University Honors'
        WHEN ROW_NUMBER() OVER (PARTITION BY department ORDER BY gpa DESC) <= 3 THEN 'Department Honors'
        ELSE 'Good Standing'
    END as academic_status
FROM Students
ORDER BY gpa DESC;

-- Business Interpretation:
-- ROW_NUMBER provides unique rankings essential for scholarship allocation and honors
-- designation. Top 5 students university-wide receive presidential scholarships, while
-- top 3 per department receive department awards. This ensures fair recognition across
-- all academic programs regardless of department difficulty.


-- ----------------------------------------------------------------------------
-- 1B. RANK() - Ranking with gaps for ties
-- Use Case: Rank courses by enrollment numbers (ties get same rank with gaps)
-- ----------------------------------------------------------------------------
WITH course_enrollment_counts AS (
    SELECT 
        c.course_id,
        c.course_name,
        c.course_code,
        c.department,
        c.semester,
        c.instructor_name,
        COUNT(e.enrollment_id) as total_enrollments,
        COUNT(CASE WHEN e.status = 'Active' THEN 1 END) as active_enrollments
    FROM Courses c
    LEFT JOIN Enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_id, c.course_name, c.course_code, c.department, c.semester, c.instructor_name
)
SELECT 
    course_name,
    course_code,
    department,
    semester,
    instructor_name,
    total_enrollments,
    active_enrollments,
    RANK() OVER (ORDER BY total_enrollments DESC) as enrollment_rank,
    RANK() OVER (PARTITION BY department ORDER BY total_enrollments DESC) as dept_rank,
    RANK() OVER (PARTITION BY semester ORDER BY total_enrollments DESC) as semester_rank
FROM course_enrollment_counts
ORDER BY total_enrollments DESC;

-- Business Interpretation:
-- RANK identifies popular courses while properly handling ties. Courses with identical
-- enrollment get the same rank (e.g., both ranked #3), with the next course at #5.
-- High-demand courses may need additional sections, while low-ranked courses might be
-- cancelled or rescheduled to optimize resource allocation.


-- ----------------------------------------------------------------------------
-- 1C. DENSE_RANK() - Ranking without gaps
-- Use Case: Top 5 students per department (no gaps for scholarship tiers)
-- ----------------------------------------------------------------------------
WITH student_performance AS (
    SELECT 
        s.student_id,
        s.student_name,
        s.department,
        s.gpa,
        s.enrollment_year,
        COUNT(CASE WHEN e.status = 'Completed' THEN 1 END) as completed_courses,
        AVG(CASE 
            WHEN e.grade = 'A' THEN 4.0
            WHEN e.grade = 'A-' THEN 3.7
            WHEN e.grade = 'B+' THEN 3.3
            WHEN e.grade = 'B' THEN 3.0
            WHEN e.grade = 'B-' THEN 2.7
            WHEN e.grade = 'C+' THEN 2.3
            WHEN e.grade = 'C' THEN 2.0
            WHEN e.grade = 'C-' THEN 1.7
            WHEN e.grade = 'D' THEN 1.0
            WHEN e.grade = 'F' THEN 0.0
        END) as calculated_gpa
    FROM Students s
    LEFT JOIN Enrollments e ON s.student_id = e.student_id
    GROUP BY s.student_id, s.student_name, s.department, s.gpa, s.enrollment_year
)
SELECT 
    student_name,
    department,
    gpa,
    completed_courses,
    ROUND(calculated_gpa, 2) as semester_gpa,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY gpa DESC) as dept_rank,
    CASE 
        WHEN DENSE_RANK() OVER (PARTITION BY department ORDER BY gpa DESC) = 1 THEN 'Gold Medal'
        WHEN DENSE_RANK() OVER (PARTITION BY department ORDER BY gpa DESC) = 2 THEN 'Silver Medal'
        WHEN DENSE_RANK() OVER (PARTITION BY department ORDER BY gpa DESC) = 3 THEN 'Bronze Medal'
        WHEN DENSE_RANK() OVER (PARTITION BY department ORDER BY gpa DESC) <= 5 THEN 'Honorable Mention'
        ELSE 'Good Standing'
    END as recognition_tier
FROM student_performance
WHERE DENSE_RANK() OVER (PARTITION BY department ORDER BY gpa DESC) <= 5
ORDER BY department, dept_rank;

-- Business Interpretation:
-- DENSE_RANK ensures no gaps in "Top N" recognition programs. Each department gets
-- exactly 5 students recognized without skipping ranks, making awards distribution
-- fair and predictable. This is critical for graduation honors and departmental awards.


-- ----------------------------------------------------------------------------
-- 1D. PERCENT_RANK() - Relative standing as percentile
-- Use Case: Calculate GPA percentiles for academic standing classification
-- ----------------------------------------------------------------------------
SELECT 
    student_name,
    department,
    enrollment_year,
    gpa,
    PERCENT_RANK() OVER (ORDER BY gpa) as gpa_percentile,
    ROUND(PERCENT_RANK() OVER (ORDER BY gpa) * 100, 2) as percentile_score,
    PERCENT_RANK() OVER (PARTITION BY department ORDER BY gpa) as dept_percentile,
    CASE 
        WHEN PERCENT_RANK() OVER (ORDER BY gpa) >= 0.90 THEN 'Summa Cum Laude (Top 10%)'
        WHEN PERCENT_RANK() OVER (ORDER BY gpa) >= 0.75 THEN 'Magna Cum Laude (Top 25%)'
        WHEN PERCENT_RANK() OVER (ORDER BY gpa) >= 0.50 THEN 'Cum Laude (Top 50%)'
        WHEN PERCENT_RANK() OVER (ORDER BY gpa) >= 0.25 THEN 'Good Standing'
        ELSE 'Academic Probation'
    END AS academic_standing
FROM Students
ORDER BY gpa DESC;

-- Business Interpretation:
-- PERCENT_RANK enables percentile-based honors classifications. Students in top 10%
-- receive Summa Cum Laude, top 25% get Magna Cum Laude, and top 50% earn Cum Laude.
-- Bottom 25% are flagged for academic probation and mandatory tutoring programs.


-- ============================================================================
-- CATEGORY 2: AGGREGATE WINDOW FUNCTIONS
-- Functions: SUM(), AVG(), MIN(), MAX() with ROWS and RANGE frames
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 2A. SUM() OVER() - Running total with ROWS frame
-- Use Case: Calculate cumulative enrollment trends over time
-- ----------------------------------------------------------------------------
WITH daily_enrollments AS (
    SELECT 
        enrollment_date,
        COUNT(enrollment_id) as daily_count,
        COUNT(CASE WHEN status = 'Active' THEN 1 END) as active_count,
        COUNT(CASE WHEN status = 'Dropped' THEN 1 END) as dropped_count
    FROM Enrollments
    GROUP BY enrollment_date
)
SELECT 
    enrollment_date,
    daily_count,
    active_count,
    dropped_count,
    SUM(daily_count) OVER (
        ORDER BY enrollment_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as cumulative_enrollments,
    SUM(active_count) OVER (
        ORDER BY enrollment_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as cumulative_active,
    SUM(dropped_count) OVER (
        ORDER BY enrollment_date 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) as cumulative_dropped,
    ROUND(
        SUM(dropped_count) OVER (ORDER BY enrollment_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)::DECIMAL /
        NULLIF(SUM(daily_count) OVER (ORDER BY enrollment_date ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 0) * 100,
        2
    ) as cumulative_drop_rate_pct
FROM daily_enrollments
ORDER BY enrollment_date;

-- Business Interpretation:
-- Running totals track enrollment momentum during registration periods. If cumulative
-- enrollments are below target by registration deadlines, administration can extend
-- deadlines or launch promotional campaigns. Cumulative drop rate helps identify systemic
-- issues requiring intervention before they escalate.


-- ----------------------------------------------------------------------------
-- 2B. AVG() OVER() - Moving average with ROWS frame
-- Use Case: Calculate rolling average GPA by cohort
-- ----------------------------------------------------------------------------
WITH student_cohorts AS (
    SELECT 
        enrollment_year,
        department,
        COUNT(student_id) as cohort_size,
        AVG(gpa) as cohort_avg_gpa,
        MIN(gpa) as cohort_min_gpa,
        MAX(gpa) as cohort_max_gpa
    FROM Students
    GROUP BY enrollment_year, department
)
SELECT 
    enrollment_year,
    department,
    cohort_size,
    ROUND(cohort_avg_gpa, 2) as avg_gpa,
    ROUND(cohort_min_gpa, 2) as min_gpa,
    ROUND(cohort_max_gpa, 2) as max_gpa,
    ROUND(AVG(cohort_avg_gpa) OVER (
        PARTITION BY department
        ORDER BY enrollment_year
        ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
    ), 2) as two_year_rolling_avg,
    ROUND(AVG(cohort_avg_gpa) OVER (
        PARTITION BY department
        ORDER BY enrollment_year
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) as three_year_rolling_avg
FROM student_cohorts
ORDER BY department, enrollment_year;

-- Business Interpretation:
-- Rolling averages smooth year-to-year GPA fluctuations to reveal genuine trends in
-- academic quality. Declining rolling averages signal curriculum issues or admission
-- standard problems requiring immediate review. This metric guides strategic planning
-- for academic improvement initiatives.


-- ----------------------------------------------------------------------------
-- 2C. MIN() and MAX() OVER() with RANGE frame
-- Use Case: Compare individual student GPA to departmental benchmarks
-- ----------------------------------------------------------------------------
WITH student_metrics AS (
    SELECT 
        s.student_id,
        s.student_name,
        s.department,
        s.gpa,
        COUNT(e.enrollment_id) as total_enrollments,
        COUNT(CASE WHEN e.status = 'Completed' THEN 1 END) as completed_courses
    FROM Students s
    LEFT JOIN Enrollments e ON s.student_id = e.student_id
    GROUP BY s.student_id, s.student_name, s.department, s.gpa
)
SELECT 
    student_name,
    department,
    gpa,
    completed_courses,
    MIN(gpa) OVER (PARTITION BY department) as dept_min_gpa,
    MAX(gpa) OVER (PARTITION BY department) as dept_max_gpa,
    ROUND(AVG(gpa) OVER (PARTITION BY department), 2) as dept_avg_gpa,
    ROUND(gpa - AVG(gpa) OVER (PARTITION BY department), 2) as deviation_from_avg,
    ROUND(
        (gpa - AVG(gpa) OVER (PARTITION BY department)) / 
        NULLIF(STDDEV(gpa) OVER (PARTITION BY department), 0), 
        2
    ) as standard_deviations_from_mean,
    CASE 
        WHEN gpa >= MAX(gpa) OVER (PARTITION BY department) THEN 'Department Leader'
        WHEN gpa >= AVG(gpa) OVER (PARTITION BY department) THEN 'Above Average'
        WHEN gpa >= MIN(gpa) OVER (PARTITION BY department) THEN 'Below Average'
        ELSE 'At Risk'
    END AS performance_category
FROM student_metrics
ORDER BY department, gpa DESC;

-- Business Interpretation:
-- MIN/MAX comparisons identify outliers and reveal departmental GPA distributions.
-- Students significantly below departmental average need tutoring and academic support.
-- Wide gaps between min/max GPAs suggest inconsistent grading standards requiring
-- faculty calibration sessions to ensure fairness.


-- ============================================================================
-- CATEGORY 3: NAVIGATION FUNCTIONS
-- Functions: LAG(), LEAD()
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 3A. LAG() - Previous period comparison
-- Use Case: Semester-over-semester enrollment growth analysis
-- ----------------------------------------------------------------------------
WITH semester_metrics AS (
    SELECT 
        c.semester,
        c.department,
        COUNT(DISTINCT e.enrollment_id) as total_enrollments,
        COUNT(DISTINCT e.student_id) as unique_students,
        COUNT(DISTINCT c.course_id) as courses_offered
    FROM Courses c
    LEFT JOIN Enrollments e ON c.course_id = e.course_id
    GROUP BY c.semester, c.department
)
SELECT 
    semester,
    department,
    total_enrollments,
    unique_students,
    courses_offered,
    LAG(total_enrollments, 1) OVER (PARTITION BY department ORDER BY semester) as previous_semester_enrollments,
    total_enrollments - LAG(total_enrollments, 1) OVER (PARTITION BY department ORDER BY semester) as enrollment_change,
    ROUND(
        ((total_enrollments - LAG(total_enrollments, 1) OVER (PARTITION BY department ORDER BY semester))::DECIMAL / 
        NULLIF(LAG(total_enrollments, 1) OVER (PARTITION BY department ORDER BY semester), 0)) * 100, 
        2
    ) as semester_growth_pct,
    LAG(unique_students, 1) OVER (PARTITION BY department ORDER BY semester) as previous_semester_students,
    unique_students - LAG(unique_students, 1) OVER (PARTITION BY department ORDER BY semester) as student_growth
FROM semester_metrics
ORDER BY department, semester;

-- Business Interpretation:
-- LAG enables semester-over-semester tracking of enrollment trends. Declining enrollments
-- signal program unpopularity or competition issues requiring marketing interventions.
-- Growing enrollments validate program quality and may justify hiring additional faculty
-- or expanding course sections to meet demand.


-- ----------------------------------------------------------------------------
-- 3B. LEAD() - Future period preview
-- Use Case: Anticipate course demand for next semester planning
-- ----------------------------------------------------------------------------
WITH course_trends AS (
    SELECT 
        c.course_code,
        c.course_name,
        c.department,
        c.semester,
        COUNT(e.enrollment_id) as current_enrollment
    FROM Courses c
    LEFT JOIN Enrollments e ON c.course_id = e.course_id
    GROUP BY c.course_code, c.course_name, c.department, c.semester
)
SELECT 
    course_code,
    course_name,
    department,
    semester,
    current_enrollment,
    LEAD(current_enrollment, 1) OVER (PARTITION BY course_code ORDER BY semester) as next_semester_enrollment,
    LEAD(current_enrollment, 1) OVER (PARTITION BY course_code ORDER BY semester) - current_enrollment as projected_change,
    CASE 
        WHEN LEAD(current_enrollment, 1) OVER (PARTITION BY course_code ORDER BY semester) > current_enrollment 
        THEN 'Increasing Demand'
        WHEN LEAD(current_enrollment, 1) OVER (PARTITION BY course_code ORDER BY semester) < current_enrollment 
        THEN 'Decreasing Demand'
        ELSE 'Stable'
    END AS demand_trend
FROM course_trends
ORDER BY department, course_code, semester;

-- Business Interpretation:
-- LEAD supports proactive planning for future semesters. If next semester shows increasing
-- demand, administration can pre-emptively add course sections or hire adjunct faculty.
-- Decreasing trends allow early course cancellation to avoid under-enrolled sections and
-- optimize instructor assignments.


-- ============================================================================
-- CATEGORY 4: DISTRIBUTION FUNCTIONS
-- Functions: NTILE(), CUME_DIST()
-- ============================================================================

-- ----------------------------------------------------------------------------
-- 4A. NTILE(4) - Student quartile segmentation by GPA
-- Use Case: Segment students for differentiated support programs
-- ----------------------------------------------------------------------------
WITH student_performance AS (
    SELECT 
        s.student_id,
        s.student_name,
        s.email,
        s.department,
        s.enrollment_year,
        s.gpa,
        COUNT(e.enrollment_id) as total_enrollments,
        COUNT(CASE WHEN e.status = 'Completed' THEN 1 END) as completed_courses,
        COUNT(CASE WHEN e.status = 'Dropped' THEN 1 END) as dropped_courses
    FROM Students s
    LEFT JOIN Enrollments e ON s.student_id = e.student_id
    GROUP BY s.student_id, s.student_name, s.email, s.department, s.enrollment_year, s.gpa
)
SELECT 
    student_name,
    email,
    department,
    enrollment_year,
    gpa,
    completed_courses,
    dropped_courses,
    NTILE(4) OVER (ORDER BY gpa DESC) as gpa_quartile,
    NTILE(4) OVER (PARTITION BY department ORDER BY gpa DESC) as dept_quartile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 1 THEN 'Tier 1 - Honors Program'
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 2 THEN 'Tier 2 - Dean\'s List'
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 3 THEN 'Tier 3 - Good Standing'
        ELSE 'Tier 4 - Academic Support Program'
    END as support_tier,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 1 THEN 'Research opportunities, graduate school prep'
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 2 THEN 'Leadership programs, advanced seminars'
        WHEN NTILE(4) OVER (ORDER BY gpa DESC) = 3 THEN 'Standard advising, career counseling'
        ELSE 'Mandatory tutoring, academic coaching, early warning system'
    END as intervention_strategy
FROM student_performance
ORDER BY gpa DESC;

-- Business Interpretation:
-- NTILE(4) creates equal-sized student segments for resource allocation. Top quartile
-- receives enrichment (research, honors thesis). Bottom quartile gets intensive support
-- (tutoring, study skills workshops). This data-driven segmentation maximizes intervention
-- effectiveness and prevents academic failure.


-- ----------------------------------------------------------------------------
-- 4B. CUME_DIST() - Cumulative distribution for GPA thresholds
-- Use Case: Determine GPA cutoffs for honors designations
-- ----------------------------------------------------------------------------
SELECT 
    student_name,
    department,
    gpa,
    CUME_DIST() OVER (ORDER BY gpa) as cumulative_dist,
    ROUND(CUME_DIST() OVER (ORDER BY gpa) * 100, 2) as percentile,
    CUME_DIST() OVER (PARTITION BY department ORDER BY gpa) as dept_cumulative_dist,
    ROUND(CUME_DIST() OVER (PARTITION BY department ORDER BY gpa) * 100, 2) as dept_percentile,
    CASE 
        WHEN CUME_DIST() OVER (ORDER BY gpa) >= 0.95 THEN 'Presidential Honors (Top 5%)'
        WHEN CUME_DIST() OVER (ORDER BY gpa) >= 0.90 THEN 'Summa Cum Laude (Top 10%)'
        WHEN CUME_DIST() OVER (ORDER BY gpa) >= 0.75 THEN 'Magna Cum Laude (Top 25%)'
        WHEN CUME_DIST() OVER (ORDER BY gpa) >= 0.50 THEN 'Cum Laude (Top 50%)'
        ELSE 'Good Standing'
    END AS honors_designation
FROM Students
ORDER BY gpa DESC;

-- Business Interpretation:
-- CUME_DIST reveals what percentage of students fall below each GPA threshold. If 75th
-- percentile = 3.65 GPA, then Magna Cum Laude cutoff can be set there. This ensures
-- honors designations are competitive yet achievable, motivating students to improve
-- academic performance to reach next recognition tier.


-- ============================================================================
-- BONUS: Combined Window Functions Analysis
-- Use multiple window functions for comprehensive student success prediction
-- ============================================================================

WITH student_comprehensive_metrics AS (
    SELECT 
        s.student_id,
        s.student_name,
        s.department,
        s.enrollment_year,
        s.gpa,
        COUNT(e.enrollment_id) as total_enrollments,
        COUNT(CASE WHEN e.status = 'Completed' THEN 1 END) as completed_courses,
        COUNT(CASE WHEN e.status = 'Active' THEN 1 END) as active_courses,
        COUNT(CASE WHEN e.status = 'Dropped' THEN 1 END) as dropped_courses,
        ROUND(
            COUNT(CASE WHEN e.status = 'Dropped' THEN 1 END)::DECIMAL / 
            NULLIF(COUNT(e.enrollment_id), 0) * 100, 
            2
        ) as dropout_rate_pct
    FROM Students s
    LEFT JOIN Enrollments e ON s.student_id = e.student_id
    GROUP BY s.student_id, s.student_name, s.department, s.enrollment_year, s.gpa
)
SELECT 
    student_name,
    department,
    enrollment_year,
    gpa,
    completed_courses,
    active_courses,
    dropped_courses,
    dropout_rate_pct,
    -- Ranking metrics
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY gpa DESC) as dept_rank,
    RANK() OVER (ORDER BY gpa DESC) as overall_rank,
    -- Distribution metrics
    NTILE(4) OVER (ORDER BY gpa DESC) as gpa_quartile,
    ROUND(PERCENT_RANK() OVER (ORDER BY gpa) * 100, 2) as gpa_percentile,
    -- Comparison metrics
    ROUND(gpa - AVG(gpa) OVER (PARTITION BY department), 2) as gpa_vs_dept_avg,
    ROUND(
        dropout_rate_pct - AVG(dropout_rate_pct) OVER (PARTITION BY department), 
        2
    ) as dropout_vs_dept_avg,
    -- Risk assessment
    CASE 
        WHEN gpa < 2.0 THEN 'High Risk'
        WHEN gpa < 2.5 AND dropout_rate_pct > 20 THEN 'Medium-High Risk'
        WHEN dropout_rate_pct > 30 THEN 'Medium Risk'
        WHEN gpa >= 3.5 THEN 'Low Risk - Thriving'
        ELSE 'Low Risk'
    END as retention_risk_category
FROM student_comprehensive_metrics
ORDER BY retention_risk_category DESC, gpa DESC;

-- Business Interpretation:
-- This comprehensive student success scorecard combines multiple window functions to
-- create a holistic view of academic standing and retention risk. High-risk students
-- receive immediate intervention (advisor meetings, tutoring), while thriving students
-- are recruited for leadership programs and research opportunities.
