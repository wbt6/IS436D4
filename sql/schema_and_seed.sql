DROP DATABASE IF EXISTS smartcampus_db;
CREATE DATABASE smartcampus_db;
USE smartcampus_db;

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) UNIQUE,
  email VARCHAR(255) NOT NULL UNIQUE,
  first_name VARCHAR(100),
  last_name VARCHAR(100),
  role ENUM('student','staff','advisor','admin') NOT NULL DEFAULT 'student',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  student_number VARCHAR(50) UNIQUE,
  major VARCHAR(100),
  year VARCHAR(20),
  phone VARCHAR(30),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE departments (
  department_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(150) NOT NULL UNIQUE,
  description TEXT
) ENGINE=InnoDB;

CREATE TABLE services (
  service_id INT AUTO_INCREMENT PRIMARY KEY,
  department_id INT NOT NULL,
  name VARCHAR(150),
  description TEXT,
  service_type ENUM('advising','counseling','it','facility','other'),
  FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE staff (
  staff_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  department_id INT,
  title VARCHAR(100),
  work_phone VARCHAR(30),
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE service_requests (
  request_id INT AUTO_INCREMENT PRIMARY KEY,
  student_id INT NOT NULL,
  service_id INT NOT NULL,
  status ENUM('open','in_progress','closed','cancelled') NOT NULL DEFAULT 'open',
  priority ENUM('low','medium','high') DEFAULT 'medium',
  description TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME NULL,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE appointments (
  appointment_id INT AUTO_INCREMENT PRIMARY KEY,
  request_id INT NULL,
  student_id INT NOT NULL,
  staff_id INT,
  service_id INT NOT NULL,
  start_time DATETIME NOT NULL,
  end_time DATETIME NOT NULL,
  location VARCHAR(255),
  status ENUM('scheduled','completed','no_show','cancelled') DEFAULT 'scheduled',
  FOREIGN KEY (request_id) REFERENCES service_requests(request_id) ON DELETE SET NULL,
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (staff_id) REFERENCES staff(staff_id) ON DELETE SET NULL,
  FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE notifications (
  notification_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  message TEXT,
  is_read BOOLEAN DEFAULT FALSE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE assets (
  asset_id INT AUTO_INCREMENT PRIMARY KEY,
  filename VARCHAR(255),
  url VARCHAR(512),
  uploaded_by INT,
  uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (uploaded_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE audit_log (
  audit_id INT AUTO_INCREMENT PRIMARY KEY,
  entity VARCHAR(100),
  entity_id INT,
  action VARCHAR(50),
  performed_by INT,
  performed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  details TEXT,
  FOREIGN KEY (performed_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB;

CREATE TABLE service_assets (
  service_id INT NOT NULL,
  asset_id INT NOT NULL,
  PRIMARY KEY (service_id, asset_id),
  FOREIGN KEY (service_id) REFERENCES services(service_id) ON DELETE CASCADE,
  FOREIGN KEY (asset_id) REFERENCES assets(asset_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- Seed users
INSERT INTO users (username, email, first_name, last_name, role) VALUES
('mblackwell','michael.blackwell@example.edu','Michael','Blackwell','admin'),
('wbusch','william.busch@example.edu','William','Busch','advisor'),
('rayd','ray.daugherty@example.edu','Ray','Daugherty','student'),
('nfoos','natalie.foos@example.edu','Natalie','Foos','student'),
('cgorman','colin.gorman@example.edu','Colin','Gorman','staff'),
('wtaylor','willbrown.taylor@example.edu','Will-Brown','Taylor','staff');

INSERT INTO students (user_id, student_number, major, year, phone) VALUES
(3,'S2025001','Information Systems','Junior','410-555-0101'),
(4,'S2025002','Computer Science','Sophomore','410-555-0102');

INSERT INTO departments (name, description) VALUES
('Advising','Academic advising services'),
('Counseling','Student counseling services'),
('IT Services','Campus IT support');

INSERT INTO services (department_id, name, description, service_type) VALUES
(1,'General Advising','Academic advising for majors and course selection','advising'),
(2,'Counseling Appointment','Student well-being and counseling','counseling'),
(3,'IT Support Ticket','Helpdesk and technical support','it');

INSERT INTO staff (user_id, department_id, title, work_phone) VALUES
(2,1,'Academic Advisor','410-555-0201'),
(5,3,'IT Technician','410-555-0202'),
(6,3,'IT Specialist','410-555-0203');

INSERT INTO service_requests (student_id, service_id, status, priority, description) VALUES
(1,1,'open','medium','Need help selecting classes for next semester'),
(2,3,'open','high','Laptop not connecting to campus Wi-Fi');

INSERT INTO appointments (request_id, student_id, staff_id, service_id, start_time, end_time, location, status) VALUES
(1,1,1,1,'2025-11-18 14:00:00','2025-11-18 14:30:00','Advising Office 101','scheduled'),
(NULL,2,2,3,'2025-11-17 10:00:00','2025-11-17 10:30:00','IT Helpdesk','scheduled');

INSERT INTO assets (filename, url, uploaded_by) VALUES
('campus_map.png','/assets/images/campus_map.png',1);

INSERT INTO service_assets (service_id, asset_id) VALUES (1,1);

INSERT INTO notifications (user_id, message, is_read) VALUES
(3,'Your appointment is scheduled for 2025-11-18 14:00',FALSE),
(4,'IT technician scheduled your appointment for 2025-11-17 10:00',FALSE);

INSERT INTO audit_log (entity, entity_id, action, performed_by, details) VALUES
('appointments',1,'created',2,'Appointment created for advising');

