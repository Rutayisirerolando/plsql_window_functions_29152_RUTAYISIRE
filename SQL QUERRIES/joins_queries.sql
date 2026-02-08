-- ============================================================================
-- SQL JOINs Implementation
-- University Academic Management System
-- Part A: Demonstrating all 5 JOIN types
-- ============================================================================

-- ============================================================================
-- 1. INNER JOIN
-- Purpose: Retrieve all active enrollments with student and course information
-- Business Use: Track current course registrations across the university
-- ============================================================================

-- Get all enrollments with student and course details
SELECT 
    e.enrollment_id,
    s.student_name,
    s.department as student_department,
    s.gpa,
    c.course_name,
    c.course_code,
    c.credits,
    c.instructor_name,
    e.enrollment_date,
    e.grade,
    e.status
FROM Enrollments e
INNER JOIN Students s ON e.student_id = s.student_id
INNER JOIN Courses c ON e.course_id = c.course_id
WHERE e.status = 'Active'
ORDER BY e.enrollment_date DESC, s.student_name;

-- Business Interpretation:
-- This query shows all current course registrations with complete student and course details.
-- Academic advisors can use this to monitor student course loads, identify students taking
-- courses outside their department, and ensure proper enrollment distribution across sections.


-- ============================================================================
-- 2. LEFT JOIN (LEFT OUTER JOIN)
-- Purpose: Identify students who registered but never enrolled in any course
-- Business Use: Find inactive students for academic counseling and retention efforts
-- ============================================================================

-- Find students with no enrollments (never registered for courses)
SELECT 
    s.student_id,
    s.student_name,
    s.email,
    s.department,
    s.enrollment_year,
    s.gpa,
    COUNT(e.enrollment_id) as total_enrollments,
    COALESCE(SUM(CASE WHEN e.status = 'Completed' THEN 1 ELSE 0 END), 0) as completed_courses
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id, s.student_name, s.email, s.department, s.enrollment_year, s.gpa
HAVING COUNT(e.enrollment_id) = 0
ORDER BY s.enrollment_year DESC, s.student_name;

-- Business Interpretation:
-- Inactive students represent a retention risk and lost tuition revenue. Academic advisors
-- should reach out immediately to understand barriers to enrollment (financial, academic,
-- personal) and provide intervention services to prevent dropout and improve completion rates.


-- ============================================================================
-- 3. RIGHT JOIN (RIGHT OUTER JOIN)
-- Purpose: Detect courses with no student enrollments
-- Business Use: Identify underutilized courses for cancellation or promotion
-- ============================================================================

-- Find courses with no enrollments
SELECT 
    c.course_id,
    c.course_name,
    c.course_code,
    c.department,
    c.credits,
    c.semester,
    c.instructor_name,
    COUNT(e.enrollment_id) as total_enrollments,
    COALESCE(SUM(CASE WHEN e.status = 'Active' THEN 1 ELSE 0 END), 0) as active_enrollments
FROM Enrollments e
RIGHT JOIN Courses c ON e.course_id = c.course_id
GROUP BY c.course_id, c.course_name, c.course_code, c.department, c.credits, c.semester, c.instructor_name
HAVING COUNT(e.enrollment_id) = 0
ORDER BY c.semester, c.department, c.course_name;

-- Business Interpretation:
-- Courses with zero enrollments indicate poor scheduling, lack of student interest, or
-- insufficient marketing. The registrar should either cancel these courses to optimize
-- faculty resources or implement targeted promotion to boost enrollment before semester start.


-- ============================================================================
-- 4. FULL OUTER JOIN
-- Purpose: Complete overview of all students and courses including unmatched records
-- Business Use: Comprehensive analysis for enrollment planning and resource allocation
-- ============================================================================

-- Complete student-course relationship view
SELECT 
    s.student_id,
    s.student_name,
    s.department as student_dept,
    c.course_id,
    c.course_name,
    c.department as course_dept,
    e.enrollment_id,
    e.status,
    e.grade,
    CASE 
        WHEN e.enrollment_id IS NULL AND s.student_id IS NOT NULL THEN 'Student Not Enrolled'
        WHEN e.enrollment_id IS NULL AND c.course_id IS NOT NULL THEN 'Course Has No Students'
        WHEN e.status = 'Active' THEN 'Active Enrollment'
        WHEN e.status = 'Completed' THEN 'Completed'
        ELSE 'Dropped/Withdrawn'
    END AS record_status
FROM Students s
FULL OUTER JOIN Enrollments e ON s.student_id = e.student_id
FULL OUTER JOIN Courses c ON e.course_id = c.course_id
ORDER BY record_status, s.student_name;

-- Business Interpretation:
-- This comprehensive view reveals enrollment gaps and utilization patterns simultaneously.
-- Administration can identify both at-risk students (no enrollments) and underutilized
-- courses (no students) to make strategic decisions about course offerings and student support.


-- ============================================================================
-- 5. SELF JOIN
-- Purpose: Compare students within the same department
-- Business Use: Identify study groups and peer mentoring opportunities
-- ============================================================================

-- Find student pairs in same department for study groups
SELECT 
    s1.student_id as student1_id,
    s1.student_name as student1_name,
    s1.gpa as student1_gpa,
    s1.enrollment_year as student1_year,
    s2.student_id as student2_id,
    s2.student_name as student2_name,
    s2.gpa as student2_gpa,
    s2.enrollment_year as student2_year,
    s1.department as shared_department,
    ABS(s1.gpa - s2.gpa) as gpa_difference
FROM Students s1
INNER JOIN Students s2 ON s1.department = s2.department 
    AND s1.student_id < s2.student_id
    AND ABS(s1.enrollment_year - s2.enrollment_year) <= 1
ORDER BY s1.department, gpa_difference, s1.student_name;

-- Alternative SELF JOIN: Find students enrolled in same courses
-- Useful for forming study groups and peer collaboration
SELECT 
    e1.enrollment_id as enrollment1_id,
    s1.student_name as student1_name,
    s1.department as student1_dept,
    e2.enrollment_id as enrollment2_id,
    s2.student_name as student2_name,
    s2.department as student2_dept,
    c.course_name,
    c.course_code,
    c.semester
FROM Enrollments e1
INNER JOIN Enrollments e2 ON e1.course_id = e2.course_id 
    AND e1.enrollment_id < e2.enrollment_id
    AND e1.status = 'Active' 
    AND e2.status = 'Active'
INNER JOIN Students s1 ON e1.student_id = s1.student_id
INNER JOIN Students s2 ON e2.student_id = s2.student_id
INNER JOIN Courses c ON e1.course_id = c.course_id
ORDER BY c.course_name, s1.student_name;

-- Business Interpretation:
-- The first query pairs students in the same department and year for peer study groups,
-- especially matching high and low GPA students for tutoring opportunities. The second
-- query identifies students in the same courses who could form collaborative study groups,
-- improving academic outcomes and student engagement.


-- ============================================================================
-- BONUS: Complex JOIN for comprehensive academic performance analysis
-- ============================================================================

-- Department performance summary with student and course metrics
SELECT 
    s.department,
    COUNT(DISTINCT s.student_id) as total_students,
    COUNT(DISTINCT c.course_id) as total_courses_offered,
    COUNT(e.enrollment_id) as total_enrollments,
    ROUND(AVG(s.gpa), 2) as avg_department_gpa,
    COUNT(CASE WHEN e.status = 'Completed' THEN 1 END) as completed_enrollments,
    COUNT(CASE WHEN e.status = 'Dropped' THEN 1 END) as dropped_enrollments,
    ROUND(
        COUNT(CASE WHEN e.status = 'Dropped' THEN 1 END)::DECIMAL / 
        NULLIF(COUNT(e.enrollment_id), 0) * 100, 
        2
    ) as dropout_rate_pct,
    COUNT(CASE WHEN e.grade IN ('A', 'A-') THEN 1 END) as excellent_grades,
    COUNT(CASE WHEN e.grade IN ('D', 'F') THEN 1 END) as failing_grades
FROM Students s
LEFT JOIN Enrollments e ON s.student_id = e.student_id
LEFT JOIN Courses c ON e.course_id = c.course_id AND c.department = s.department
GROUP BY s.department
ORDER BY avg_department_gpa DESC, total_students DESC;

-- Business Interpretation:
-- This analysis reveals departmental health metrics including enrollment patterns, dropout
-- rates, and academic performance. Departments with high dropout rates or low GPAs need
-- targeted interventions such as tutoring programs, course redesign, or faculty development.
