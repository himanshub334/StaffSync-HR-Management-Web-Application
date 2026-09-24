CREATE TABLE departments(
 id SERIAL PRIMARY KEY,name VARCHAR(100) UNIQUE NOT NULL,location VARCHAR(100),created_at TIMESTAMPTZ DEFAULT NOW());
CREATE TABLE roles(id SERIAL PRIMARY KEY,name VARCHAR(30) UNIQUE NOT NULL);
CREATE TABLE employees(
 id SERIAL PRIMARY KEY,employee_code VARCHAR(30) UNIQUE NOT NULL,first_name VARCHAR(80) NOT NULL,
 last_name VARCHAR(80) NOT NULL,email VARCHAR(160) UNIQUE NOT NULL,department_id INT REFERENCES departments(id),
 role_id INT REFERENCES roles(id),manager_id INT REFERENCES employees(id),salary NUMERIC(12,2) CHECK(salary>=0),
 joining_date DATE NOT NULL,annual_leave_balance INT DEFAULT 24 CHECK(annual_leave_balance>=0),
 active BOOLEAN DEFAULT TRUE,created_at TIMESTAMPTZ DEFAULT NOW(),updated_at TIMESTAMPTZ DEFAULT NOW());
CREATE TABLE users(
 id SERIAL PRIMARY KEY,employee_id INT UNIQUE REFERENCES employees(id) ON DELETE CASCADE,
 email VARCHAR(160) UNIQUE NOT NULL,password_hash TEXT NOT NULL,
 role_name VARCHAR(30) CHECK(role_name IN('ADMIN','HR','EMPLOYEE')),refresh_token_hash TEXT,created_at TIMESTAMPTZ DEFAULT NOW());
CREATE TABLE leave_requests(
 id SERIAL PRIMARY KEY,employee_id INT REFERENCES employees(id),leave_type VARCHAR(30) CHECK(leave_type IN('ANNUAL','SICK','PERSONAL')),
 start_date DATE NOT NULL,end_date DATE NOT NULL,days INT CHECK(days>0),reason TEXT,
 status VARCHAR(20) DEFAULT 'PENDING' CHECK(status IN('PENDING','APPROVED','REJECTED')),
 reviewed_by INT REFERENCES employees(id),reviewed_at TIMESTAMPTZ,created_at TIMESTAMPTZ DEFAULT NOW(),CHECK(end_date>=start_date));
CREATE TABLE audit_log(
 id BIGSERIAL PRIMARY KEY,actor_employee_id INT REFERENCES employees(id),entity_type VARCHAR(60) NOT NULL,
 entity_id INT,action VARCHAR(80) NOT NULL,details JSONB DEFAULT '{}'::jsonb,created_at TIMESTAMPTZ DEFAULT NOW());
CREATE INDEX idx_employee_department ON employees(department_id);
CREATE INDEX idx_leave_status ON leave_requests(status);
CREATE INDEX idx_leave_employee ON leave_requests(employee_id);
