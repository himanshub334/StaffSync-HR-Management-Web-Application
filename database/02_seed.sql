INSERT INTO departments(name,location) VALUES
('Engineering','Pune'),('Human Resources','Pune'),('Finance','Mumbai'),('Sales','Bengaluru')
ON CONFLICT(name) DO NOTHING;
INSERT INTO roles(name) VALUES('ADMIN'),('HR'),('EMPLOYEE') ON CONFLICT(name) DO NOTHING;
INSERT INTO employees(employee_code,first_name,last_name,email,department_id,role_id,salary,joining_date)
SELECT 'EMP001','Aarav','Sharma','admin@staffsync.local',d.id,r.id,1800000,'2024-01-15' FROM departments d,roles r WHERE d.name='Engineering' AND r.name='ADMIN' ON CONFLICT(employee_code) DO NOTHING;
INSERT INTO employees(employee_code,first_name,last_name,email,department_id,role_id,salary,joining_date)
SELECT 'EMP002','Priya','Mehta','hr@staffsync.local',d.id,r.id,1200000,'2024-03-01' FROM departments d,roles r WHERE d.name='Human Resources' AND r.name='HR' ON CONFLICT(employee_code) DO NOTHING;
INSERT INTO employees(employee_code,first_name,last_name,email,department_id,role_id,salary,joining_date)
SELECT 'EMP003','Rohan','Patil','employee@staffsync.local',d.id,r.id,900000,'2025-01-10' FROM departments d,roles r WHERE d.name='Engineering' AND r.name='EMPLOYEE' ON CONFLICT(employee_code) DO NOTHING;
INSERT INTO employees(employee_code,first_name,last_name,email,department_id,role_id,salary,joining_date)
SELECT 'EMP004','Neha','Kulkarni','neha@staffsync.local',d.id,r.id,1000000,'2025-05-20' FROM departments d,roles r WHERE d.name='Sales' AND r.name='EMPLOYEE' ON CONFLICT(employee_code) DO NOTHING;
-- bcrypt hash for demo password Admin@123 / shared demo account hash
INSERT INTO users(email,password_hash,role_name,employee_id)
SELECT 'admin@staffsync.local','$2b$10$7EqJtq98hPqEX7fNZaFWoOeB4z4s3G3b4d6q1J5x6a2Qk5K1oYx5W','ADMIN',id FROM employees WHERE email='admin@staffsync.local' ON CONFLICT(email) DO NOTHING;
INSERT INTO users(email,password_hash,role_name,employee_id)
SELECT 'hr@staffsync.local','$2b$10$7EqJtq98hPqEX7fNZaFWoOeB4z4s3G3b4d6q1J5x6a2Qk5K1oYx5W','HR',id FROM employees WHERE email='hr@staffsync.local' ON CONFLICT(email) DO NOTHING;
INSERT INTO users(email,password_hash,role_name,employee_id)
SELECT 'employee@staffsync.local','$2b$10$7EqJtq98hPqEX7fNZaFWoOeB4z4s3G3b4d6q1J5x6a2Qk5K1oYx5W','EMPLOYEE',id FROM employees WHERE email='employee@staffsync.local' ON CONFLICT(email) DO NOTHING;
