-- ============================================================================
-- University Academic Management System - Database Schema
-- Database Development with PL/SQL (INSY 8311)
-- Author: [Your Name]
-- Date: February 2026
-- ============================================================================

-- Drop tables if they exist (for clean re-creation)
DROP TABLE IF EXISTS Enrollments CASCADE;
DROP TABLE IF EXISTS Courses CASCADE;
DROP TABLE IF EXISTS Students CASCADE;

-- ============================================================================
-- TABLE 1: Students
-- Stores student information including department and enrollment details
-- ============================================================================
CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    department VARCHAR(50) NOT NULL,
    enrollment_year INT NOT NULL,
    gpa DECIMAL(3,2) DEFAULT 0.00,
    CONSTRAINT chk_department CHECK (department IN ('Computer Science', 'Business Administration', 'Engineering', 'Medicine', 'Law')),
    CONSTRAINT chk_enrollment_year CHECK (enrollment_year >= 2020 AND enrollment_year <= 2026),
    CONSTRAINT chk_gpa CHECK (gpa >= 0.00 AND gpa <= 4.00)
);

-- ============================================================================
-- TABLE 2: Courses
-- Stores course catalog with credits and department assignment
-- ============================================================================
CREATE TABLE Courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100) NOT NULL,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    department VARCHAR(50) NOT NULL,
    credits INT NOT NULL,
    semester VARCHAR(20) NOT NULL,
    instructor_name VARCHAR(100) NOT NULL,
    CONSTRAINT chk_course_department CHECK (department IN ('Computer Science', 'Business Administration', 'Engineering', 'Medicine', 'Law')),
    CONSTRAINT chk_credits CHECK (credits >= 1 AND credits <= 6),
    CONSTRAINT chk_semester CHECK (semester IN ('Fall 2024', 'Spring 2025', 'Fall 2025', 'Spring 2026'))
);

-- ============================================================================
-- TABLE 3: Enrollments
-- Stores student course registrations and grades
-- ============================================================================
CREATE TABLE Enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    grade VARCHAR(2),
    status VARCHAR(20) NOT NULL DEFAULT 'Active',
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES Students(student_id),
    CONSTRAINT fk_course FOREIGN KEY (course_id) REFERENCES Courses(course_id),
    CONSTRAINT chk_grade CHECK (grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D', 'F', NULL)),
    CONSTRAINT chk_status CHECK (status IN ('Active', 'Completed', 'Dropped', 'Withdrawn')),
    CONSTRAINT unique_enrollment UNIQUE (student_id, course_id)
);

-- ============================================================================
-- Create Indexes for Performance Optimization
-- ============================================================================
CREATE INDEX idx_enrollments_student ON Enrollments(student_id);
CREATE INDEX idx_enrollments_course ON Enrollments(course_id);
CREATE INDEX idx_enrollments_date ON Enrollments(enrollment_date);
CREATE INDEX idx_students_department ON Students(department);
CREATE INDEX idx_courses_department ON Courses(department);
CREATE INDEX idx_courses_semester ON Courses(semester);
CREATE INDEX idx_students_gpa ON Students(gpa);

-- ============================================================================
-- Verify Schema Creation
-- ============================================================================
-- SELECT 'University schema created successfully!' AS status;
