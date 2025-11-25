--
-- Job Portal System Database Schema
-- Target Database: MySQL
--

-- 1. Admin Table
-- Stores the credentials for the system administrator.
CREATE TABLE admin (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL -- Store hashed password
);

-- Insert a default admin user (password: admin123)
INSERT INTO admin (username, password) VALUES ('admin', 'admin123'); -- In a real application, this should be a hashed password

-- 2. Employers Table
-- Stores information about companies/employers.
CREATE TABLE employers (
    employer_id INT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Store hashed password
    contact_person VARCHAR(100),
    phone_number VARCHAR(20),
    address TEXT,
    is_approved BOOLEAN DEFAULT FALSE, -- Admin approval status
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Users Table (Job Seekers)
-- Stores information about job seekers.
CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Store hashed password
    phone_number VARCHAR(20),
    current_location VARCHAR(100),
    skills TEXT,
    resume_path VARCHAR(255), -- Path to the uploaded resume file
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Jobs Table
-- Stores job postings made by employers.
CREATE TABLE jobs (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    employer_id INT NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    required_skills TEXT,
    salary_range VARCHAR(100),
    location VARCHAR(100) NOT NULL,
    posted_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT TRUE,
    FOREIGN KEY (employer_id) REFERENCES employers(employer_id) ON DELETE CASCADE
);

-- 5. Applications Table
-- Stores job applications submitted by users.
CREATE TABLE applications (
    application_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL,
    user_id INT NOT NULL,
    application_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Reviewed', 'Shortlisted', 'Rejected') DEFAULT 'Pending',
    FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    UNIQUE KEY unique_application (job_id, user_id) -- Prevent duplicate applications
);

-- Relationships:
-- 1. One-to-Many: employers (1) to jobs (M) -> jobs.employer_id references employers.employer_id
-- 2. Many-to-Many: users (M) to jobs (M) via applications table
--    -> applications.user_id references users.user_id
--    -> applications.job_id references jobs.job_id
-- 3. One-to-One: admin (1) to system (1) -> simple credentials table

-- Example Data (Optional)
-- INSERT INTO employers (company_name, email, password, contact_person) VALUES ('TechCorp', 'hr@techcorp.com', 'hashed_password_tech', 'Jane Doe');
-- INSERT INTO users (full_name, email, password) VALUES ('John Smith', 'john.smith@example.com', 'hashed_password_john');
-- INSERT INTO jobs (employer_id, title, description, location) VALUES (1, 'Software Engineer', 'Develop and maintain web applications.', 'Remote');
-- INSERT INTO applications (job_id, user_id) VALUES (1, 1);
