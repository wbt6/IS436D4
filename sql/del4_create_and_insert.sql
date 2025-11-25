CREATE TABLE departments (
	department_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL
);
CREATE TABLE users (
	user_id SERIAL PRIMARY KEY,
	name VARCHAR(100) NOT NULL,
	email VARCHAR(100) UNIQUE NOT NULL,
	role VARCHAR(20) CHECK (role IN ('student', 'staff', 'admin')) NOT NULL,
	department_id INT REFERENCES departments(department_id),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE staff_availability (
	availability_id SERIAL PRIMARY KEY,
	staff_id INT REFERENCES users(user_id),
	start_time TIMESTAMP NOT NULL,
	end_time TIMESTAMP NOT NULL,
	location VARCHAR(100),
	is_virtual BOOLEAN DEFAULT FALSE
);
CREATE TABLE appointments (
	appointment_id SERIAL PRIMARY KEY,
	student_id INT REFERENCES users(user_id),
	staff_id INT REFERENCES users(user_id),
	service_type VARCHAR(50),
	appointment_time TIMESTAMP NOT NULL,
	status VARCHAR(20) DEFAULT 'booked'
    	CHECK (status IN ('booked', 'canceled', 'completed')),
	notes TEXT
);
CREATE TABLE tickets (
	ticket_id SERIAL PRIMARY KEY,
	student_id INT REFERENCES users(user_id),
	category VARCHAR(50),
	description TEXT NOT NULL,
	status VARCHAR(20) DEFAULT 'open'
    	CHECK (status IN ('open', 'in progress', 'resolved')),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- insert statements

INSERT INTO users (name, email, role, department_id) VALUES
('Alice Student', 'alice@umbc.edu', 'student', NULL),
('Bob Student', 'bob@umbc.edu', 'student', NULL),
('Dr. Smith', 'smith@umbc.edu', 'staff', 1),
('Tutor Jane', 'jane@umbc.edu', 'staff', 2),
('Admin Sam', 'admin@umbc.edu', 'admin', 1);
 
INSERT INTO staff_availability (staff_id, start_time, end_time, location, is_virtual) VALUES
(3, '2025-11-05 10:00', '2025-11-05 11:00', 'ENG 102', FALSE),
(4, '2025-11-06 14:00', '2025-11-06 15:00', NULL, TRUE);
 
INSERT INTO appointments (student_id, staff_id, service_type, appointment_time, status) VALUES
(1, 3, 'Advising', '2025-11-05 10:00', 'booked'),
(2, 4, 'Tutoring', '2025-11-06 14:00', 'booked');
 
INSERT INTO tickets (student_id, category, description) VALUES
(1, 'Technical', 'Issue joining virtual tutoring session'),
(2, 'Advising', 'Advisor unavailable for scheduled appointment');
