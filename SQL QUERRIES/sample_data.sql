-- ============================================================================
-- Sample Data for University Academic Management System
-- Realistic test data for Students, Courses, and Enrollments
-- ============================================================================

-- ============================================================================
-- INSERT STUDENTS (40 students across 5 departments)
-- ============================================================================
INSERT INTO Students (student_id, student_name, email, department, enrollment_year, gpa) VALUES
-- Computer Science Students
(1, 'Alice Mukamana', 'alice.mukamana@university.ac.rw', 'Computer Science', 2022, 3.85),
(2, 'Bob Niyonzima', 'bob.niyonzima@university.ac.rw', 'Computer Science', 2023, 3.45),
(3, 'Claire Uwase', 'claire.uwase@university.ac.rw', 'Computer Science', 2022, 3.92),
(4, 'David Habimana', 'david.habimana@university.ac.rw', 'Computer Science', 2024, 3.20),
(5, 'Emma Mutoni', 'emma.mutoni@university.ac.rw', 'Computer Science', 2021, 3.67),
(6, 'Felix Nsengimana', 'felix.nsengimana@university.ac.rw', 'Computer Science', 2023, 3.55),
(7, 'Grace Ingabire', 'grace.ingabire@university.ac.rw', 'Computer Science', 2024, 3.78),
(8, 'Henry Mugisha', 'henry.mugisha@university.ac.rw', 'Computer Science', 2022, 3.41),

-- Business Administration Students
(9, 'Irene Nyirahabimana', 'irene.nyirahabimana@university.ac.rw', 'Business Administration', 2022, 3.72),
(10, 'James Kamanzi', 'james.kamanzi@university.ac.rw', 'Business Administration', 2023, 3.58),
(11, 'Karen Uwamahoro', 'karen.uwamahoro@university.ac.rw', 'Business Administration', 2021, 3.88),
(12, 'Leo Bizimana', 'leo.bizimana@university.ac.rw', 'Business Administration', 2024, 3.15),
(13, 'Maria Mukandori', 'maria.mukandori@university.ac.rw', 'Business Administration', 2022, 3.64),
(14, 'Nathan Gasana', 'nathan.gasana@university.ac.rw', 'Business Administration', 2023, 3.77),
(15, 'Olivia Nyiransabimana', 'olivia.nyiransabimana@university.ac.rw', 'Business Administration', 2024, 3.33),
(16, 'Peter Ndayisaba', 'peter.ndayisaba@university.ac.rw', 'Business Administration', 2021, 3.91),

-- Engineering Students
(17, 'Queen Mukarwego', 'queen.mukarwego@university.ac.rw', 'Engineering', 2022, 3.56),
(18, 'Robert Nkuranga', 'robert.nkuranga@university.ac.rw', 'Engineering', 2023, 3.44),
(19, 'Sarah Uwera', 'sarah.uwera@university.ac.rw', 'Engineering', 2021, 3.82),
(20, 'Thomas Mutabazi', 'thomas.mutabazi@university.ac.rw', 'Engineering', 2024, 3.28),
(21, 'Uma Nyirabagenzi', 'uma.nyirabagenzi@university.ac.rw', 'Engineering', 2022, 3.69),
(22, 'Victor Hakizimana', 'victor.hakizimana@university.ac.rw', 'Engineering', 2023, 3.51),
(23, 'Wendy Mukashema', 'wendy.mukashema@university.ac.rw', 'Engineering', 2024, 3.74),
(24, 'Xavier Munyaneza', 'xavier.munyaneza@university.ac.rw', 'Engineering', 2021, 3.87),

-- Medicine Students
(25, 'Yvonne Mukantwari', 'yvonne.mukantwari@university.ac.rw', 'Medicine', 2022, 3.94),
(26, 'Zachary Nshimiyimana', 'zachary.nshimiyimana@university.ac.rw', 'Medicine', 2023, 3.61),
(27, 'Angela Uwimana', 'angela.uwimana@university.ac.rw', 'Medicine', 2021, 3.89),
(28, 'Brian Niyomugabo', 'brian.niyomugabo@university.ac.rw', 'Medicine', 2024, 3.37),
(29, 'Catherine Umutoni', 'catherine.umutoni@university.ac.rw', 'Medicine', 2022, 3.76),
(30, 'Daniel Habineza', 'daniel.habineza@university.ac.rw', 'Medicine', 2023, 3.68),
(31, 'Emily Nyiramana', 'emily.nyiramana@university.ac.rw', 'Medicine', 2024, 3.52),
(32, 'Frank Mugabo', 'frank.mugabo@university.ac.rw', 'Medicine', 2021, 3.95),

-- Law Students
(33, 'Gloria Mukamana', 'gloria.mukamana@university.ac.rw', 'Law', 2022, 3.81),
(34, 'Hugo Niyonzima', 'hugo.niyonzima@university.ac.rw', 'Law', 2023, 3.49),
(35, 'Ivy Uwase', 'ivy.uwase@university.ac.rw', 'Law', 2021, 3.86),
(36, 'Jack Habimana', 'jack.habimana@university.ac.rw', 'Law', 2024, 3.22),
(37, 'Kelly Mutoni', 'kelly.mutoni@university.ac.rw', 'Law', 2022, 3.73),
(38, 'Louis Nsengimana', 'louis.nsengimana@university.ac.rw', 'Law', 2023, 3.59),
(39, 'Monica Ingabire', 'monica.ingabire@university.ac.rw', 'Law', 2024, 3.66),
(40, 'Noah Mugisha', 'noah.mugisha@university.ac.rw', 'Law', 2021, 3.90);

-- ============================================================================
-- INSERT COURSES (30 courses across 5 departments)
-- ============================================================================
INSERT INTO Courses (course_id, course_name, course_code, department, credits, semester, instructor_name) VALUES
-- Computer Science Courses
(1, 'Data Structures and Algorithms', 'CS201', 'Computer Science', 4, 'Fall 2024', 'Dr. Emmanuel Kayitare'),
(2, 'Database Management Systems', 'CS301', 'Computer Science', 3, 'Fall 2024', 'Dr. Sarah Mukamana'),
(3, 'Web Development', 'CS202', 'Computer Science', 3, 'Spring 2025', 'Prof. James Nkusi'),
(4, 'Machine Learning', 'CS401', 'Computer Science', 4, 'Spring 2025', 'Dr. Grace Uwera'),
(5, 'Software Engineering', 'CS302', 'Computer Science', 4, 'Fall 2025', 'Dr. Patrick Habimana'),
(6, 'Computer Networks', 'CS303', 'Computer Science', 3, 'Fall 2025', 'Prof. Alice Mutoni'),

-- Business Administration Courses
(7, 'Financial Accounting', 'BA201', 'Business Administration', 3, 'Fall 2024', 'Dr. Robert Gasana'),
(8, 'Marketing Management', 'BA202', 'Business Administration', 3, 'Fall 2024', 'Prof. Maria Uwamahoro'),
(9, 'Business Strategy', 'BA301', 'Business Administration', 4, 'Spring 2025', 'Dr. David Bizimana'),
(10, 'Organizational Behavior', 'BA203', 'Business Administration', 3, 'Spring 2025', 'Prof. Lisa Mukandori'),
(11, 'Operations Management', 'BA302', 'Business Administration', 3, 'Fall 2025', 'Dr. Peter Kamanzi'),
(12, 'Entrepreneurship', 'BA303', 'Business Administration', 3, 'Fall 2025', 'Prof. Claire Nyirahabimana'),

-- Engineering Courses
(13, 'Engineering Mathematics', 'ENG201', 'Engineering', 4, 'Fall 2024', 'Dr. Thomas Nkuranga'),
(14, 'Circuit Analysis', 'ENG202', 'Engineering', 4, 'Fall 2024', 'Prof. Sarah Mukarwego'),
(15, 'Thermodynamics', 'ENG301', 'Engineering', 3, 'Spring 2025', 'Dr. Victor Mutabazi'),
(16, 'Fluid Mechanics', 'ENG302', 'Engineering', 3, 'Spring 2025', 'Prof. Queen Uwera'),
(17, 'Control Systems', 'ENG303', 'Engineering', 4, 'Fall 2025', 'Dr. Xavier Hakizimana'),
(18, 'Structural Engineering', 'ENG304', 'Engineering', 4, 'Fall 2025', 'Prof. Wendy Nyirabagenzi'),

-- Medicine Courses
(19, 'Human Anatomy', 'MED201', 'Medicine', 5, 'Fall 2024', 'Dr. Frank Mugabo'),
(20, 'Physiology', 'MED202', 'Medicine', 5, 'Fall 2024', 'Prof. Angela Uwimana'),
(21, 'Pathology', 'MED301', 'Medicine', 4, 'Spring 2025', 'Dr. Zachary Nshimiyimana'),
(22, 'Pharmacology', 'MED302', 'Medicine', 4, 'Spring 2025', 'Prof. Yvonne Mukantwari'),
(23, 'Clinical Medicine', 'MED401', 'Medicine', 6, 'Fall 2025', 'Dr. Daniel Habineza'),
(24, 'Medical Ethics', 'MED303', 'Medicine', 2, 'Fall 2025', 'Prof. Catherine Umutoni'),

-- Law Courses
(25, 'Constitutional Law', 'LAW201', 'Law', 3, 'Fall 2024', 'Dr. Noah Mugisha'),
(26, 'Contract Law', 'LAW202', 'Law', 3, 'Fall 2024', 'Prof. Gloria Mukamana'),
(27, 'Criminal Law', 'LAW301', 'Law', 4, 'Spring 2025', 'Dr. Hugo Niyonzima'),
(28, 'International Law', 'LAW302', 'Law', 3, 'Spring 2025', 'Prof. Ivy Uwase'),
(29, 'Corporate Law', 'LAW303', 'Law', 3, 'Fall 2025', 'Dr. Louis Nsengimana'),
(30, 'Human Rights Law', 'LAW304', 'Law', 3, 'Fall 2025', 'Prof. Kelly Mutoni');

-- ============================================================================
-- INSERT ENROLLMENTS (150+ enrollments with various statuses and grades)
-- ============================================================================

-- Fall 2024 Enrollments (Completed with grades)
INSERT INTO Enrollments (enrollment_id, student_id, course_id, enrollment_date, grade, status) VALUES
-- Computer Science students - Fall 2024
(1, 1, 1, '2024-08-20', 'A', 'Completed'),
(2, 1, 2, '2024-08-20', 'A-', 'Completed'),
(3, 2, 1, '2024-08-21', 'B+', 'Completed'),
(4, 2, 2, '2024-08-21', 'B', 'Completed'),
(5, 3, 1, '2024-08-20', 'A', 'Completed'),
(6, 3, 2, '2024-08-20', 'A', 'Completed'),
(7, 4, 1, '2024-08-22', 'C+', 'Completed'),
(8, 5, 1, '2024-08-20', 'B+', 'Completed'),
(9, 5, 2, '2024-08-20', 'A-', 'Completed'),
(10, 6, 1, '2024-08-21', 'B', 'Completed'),
(11, 7, 1, '2024-08-22', 'A-', 'Completed'),
(12, 8, 2, '2024-08-21', 'B-', 'Completed'),

-- Business Administration students - Fall 2024
(13, 9, 7, '2024-08-20', 'A-', 'Completed'),
(14, 9, 8, '2024-08-20', 'B+', 'Completed'),
(15, 10, 7, '2024-08-21', 'B', 'Completed'),
(16, 10, 8, '2024-08-21', 'B+', 'Completed'),
(17, 11, 7, '2024-08-20', 'A', 'Completed'),
(18, 11, 8, '2024-08-20', 'A', 'Completed'),
(19, 12, 7, '2024-08-22', 'C', 'Completed'),
(20, 13, 7, '2024-08-20', 'B+', 'Completed'),
(21, 14, 7, '2024-08-21', 'A-', 'Completed'),
(22, 14, 8, '2024-08-21', 'A-', 'Completed'),
(23, 15, 8, '2024-08-22', 'C+', 'Completed'),
(24, 16, 7, '2024-08-20', 'A', 'Completed'),

-- Engineering students - Fall 2024
(25, 17, 13, '2024-08-20', 'B+', 'Completed'),
(26, 17, 14, '2024-08-20', 'B', 'Completed'),
(27, 18, 13, '2024-08-21', 'B', 'Completed'),
(28, 18, 14, '2024-08-21', 'B-', 'Completed'),
(29, 19, 13, '2024-08-20', 'A', 'Completed'),
(30, 19, 14, '2024-08-20', 'A-', 'Completed'),
(31, 20, 13, '2024-08-22', 'C+', 'Completed'),
(32, 21, 13, '2024-08-20', 'B+', 'Completed'),
(33, 22, 13, '2024-08-21', 'B', 'Completed'),
(34, 22, 14, '2024-08-21', 'B+', 'Completed'),
(35, 23, 14, '2024-08-22', 'A-', 'Completed'),
(36, 24, 13, '2024-08-20', 'A', 'Completed'),

-- Medicine students - Fall 2024
(37, 25, 19, '2024-08-20', 'A', 'Completed'),
(38, 25, 20, '2024-08-20', 'A', 'Completed'),
(39, 26, 19, '2024-08-21', 'B+', 'Completed'),
(40, 26, 20, '2024-08-21', 'B', 'Completed'),
(41, 27, 19, '2024-08-20', 'A', 'Completed'),
(42, 27, 20, '2024-08-20', 'A-', 'Completed'),
(43, 28, 19, '2024-08-22', 'C+', 'Completed'),
(44, 29, 19, '2024-08-20', 'A-', 'Completed'),
(45, 29, 20, '2024-08-20', 'B+', 'Completed'),
(46, 30, 19, '2024-08-21', 'B+', 'Completed'),
(47, 31, 20, '2024-08-22', 'B', 'Completed'),
(48, 32, 19, '2024-08-20', 'A', 'Completed'),

-- Law students - Fall 2024
(49, 33, 25, '2024-08-20', 'A-', 'Completed'),
(50, 33, 26, '2024-08-20', 'A', 'Completed'),
(51, 34, 25, '2024-08-21', 'B', 'Completed'),
(52, 34, 26, '2024-08-21', 'B+', 'Completed'),
(53, 35, 25, '2024-08-20', 'A', 'Completed'),
(54, 35, 26, '2024-08-20', 'A-', 'Completed'),
(55, 36, 25, '2024-08-22', 'C', 'Completed'),
(56, 37, 25, '2024-08-20', 'A-', 'Completed'),
(57, 38, 26, '2024-08-21', 'B+', 'Completed'),
(58, 39, 25, '2024-08-22', 'B+', 'Completed'),
(59, 40, 25, '2024-08-20', 'A', 'Completed'),
(60, 40, 26, '2024-08-20', 'A', 'Completed'),

-- Spring 2025 Enrollments (Currently Active)
-- Computer Science students - Spring 2025
(61, 1, 3, '2025-01-15', NULL, 'Active'),
(62, 1, 4, '2025-01-15', NULL, 'Active'),
(63, 2, 3, '2025-01-16', NULL, 'Active'),
(64, 3, 3, '2025-01-15', NULL, 'Active'),
(65, 3, 4, '2025-01-15', NULL, 'Active'),
(66, 4, 3, '2025-01-17', 'B', 'Completed'),
(67, 5, 3, '2025-01-15', NULL, 'Active'),
(68, 6, 3, '2025-01-16', NULL, 'Active'),
(69, 6, 4, '2025-01-16', NULL, 'Active'),
(70, 7, 4, '2025-01-17', NULL, 'Active'),
(71, 8, 3, '2025-01-16', NULL, 'Dropped'),

-- Business Administration students - Spring 2025
(72, 9, 9, '2025-01-15', NULL, 'Active'),
(73, 9, 10, '2025-01-15', NULL, 'Active'),
(74, 10, 9, '2025-01-16', NULL, 'Active'),
(75, 11, 9, '2025-01-15', NULL, 'Active'),
(76, 11, 10, '2025-01-15', NULL, 'Active'),
(77, 12, 9, '2025-01-17', NULL, 'Active'),
(78, 13, 9, '2025-01-15', NULL, 'Active'),
(79, 14, 9, '2025-01-16', NULL, 'Active'),
(80, 14, 10, '2025-01-16', NULL, 'Active'),
(81, 15, 10, '2025-01-17', NULL, 'Dropped'),
(82, 16, 9, '2025-01-15', NULL, 'Active'),

-- Engineering students - Spring 2025
(83, 17, 15, '2025-01-15', NULL, 'Active'),
(84, 17, 16, '2025-01-15', NULL, 'Active'),
(85, 18, 15, '2025-01-16', NULL, 'Active'),
(86, 19, 15, '2025-01-15', NULL, 'Active'),
(87, 19, 16, '2025-01-15', NULL, 'Active'),
(88, 20, 15, '2025-01-17', NULL, 'Active'),
(89, 21, 15, '2025-01-15', NULL, 'Active'),
(90, 22, 15, '2025-01-16', NULL, 'Active'),
(91, 22, 16, '2025-01-16', NULL, 'Active'),
(92, 23, 16, '2025-01-17', NULL, 'Active'),
(93, 24, 15, '2025-01-15', NULL, 'Active'),

-- Medicine students - Spring 2025
(94, 25, 21, '2025-01-15', NULL, 'Active'),
(95, 25, 22, '2025-01-15', NULL, 'Active'),
(96, 26, 21, '2025-01-16', NULL, 'Active'),
(97, 27, 21, '2025-01-15', NULL, 'Active'),
(98, 27, 22, '2025-01-15', NULL, 'Active'),
(99, 28, 21, '2025-01-17', NULL, 'Active'),
(100, 29, 21, '2025-01-15', NULL, 'Active'),
(101, 29, 22, '2025-01-15', NULL, 'Active'),
(102, 30, 21, '2025-01-16', NULL, 'Active'),
(103, 31, 22, '2025-01-17', NULL, 'Active'),
(104, 32, 21, '2025-01-15', NULL, 'Active'),
(105, 32, 22, '2025-01-15', NULL, 'Active'),

-- Law students - Spring 2025
(106, 33, 27, '2025-01-15', NULL, 'Active'),
(107, 33, 28, '2025-01-15', NULL, 'Active'),
(108, 34, 27, '2025-01-16', NULL, 'Active'),
(109, 35, 27, '2025-01-15', NULL, 'Active'),
(110, 35, 28, '2025-01-15', NULL, 'Active'),
(111, 36, 27, '2025-01-17', NULL, 'Active'),
(112, 37, 27, '2025-01-15', NULL, 'Active'),
(113, 38, 28, '2025-01-16', NULL, 'Active'),
(114, 39, 27, '2025-01-17', NULL, 'Active'),
(115, 40, 27, '2025-01-15', NULL, 'Active'),
(116, 40, 28, '2025-01-15', NULL, 'Active'),

-- Additional enrollments for comprehensive analysis
(117, 1, 7, '2024-08-20', 'B+', 'Completed'),
(118, 3, 13, '2024-08-20', 'A-', 'Completed'),
(119, 5, 19, '2024-08-20', 'B', 'Completed'),
(120, 11, 1, '2024-08-20', 'A', 'Completed'),
(121, 16, 13, '2024-08-20', 'A-', 'Completed'),
(122, 19, 7, '2024-08-20', 'B+', 'Completed'),
(123, 25, 1, '2024-08-20', 'A', 'Completed'),
(124, 27, 13, '2024-08-20', 'A-', 'Completed'),
(125, 32, 7, '2024-08-20', 'A', 'Completed'),
(126, 35, 13, '2024-08-20', 'A', 'Completed'),
(127, 40, 1, '2024-08-20', 'A-', 'Completed');

-- ============================================================================
-- Verification Queries
-- ============================================================================

-- Count records in each table
SELECT 'Students' AS table_name, COUNT(*) AS record_count FROM Students
UNION ALL
SELECT 'Courses', COUNT(*) FROM Courses
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM Enrollments;

-- Show sample data
SELECT 'Sample Students:' AS info;
SELECT * FROM Students LIMIT 5;

SELECT 'Sample Courses:' AS info;
SELECT * FROM Courses LIMIT 5;

SELECT 'Sample Enrollments:' AS info;
SELECT * FROM Enrollments LIMIT 5;

-- ============================================================================
-- Data Summary Statistics
-- ============================================================================
SELECT 
    'Total Students' AS metric,
    COUNT(*) AS value
FROM Students
UNION ALL
SELECT 
    'Total Courses',
    COUNT(*)
FROM Courses
UNION ALL
SELECT 
    'Total Enrollments',
    COUNT(*)
FROM Enrollments
UNION ALL
SELECT 
    'Average GPA',
    ROUND(AVG(gpa), 2)
FROM Students
UNION ALL
SELECT 
    'Completed Enrollments',
    COUNT(*)
FROM Enrollments
WHERE status = 'Completed';
