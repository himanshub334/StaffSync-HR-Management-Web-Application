CREATE OR REPLACE FUNCTION create_leave_request(p_employee_id INT,p_leave_type VARCHAR,p_start_date DATE,p_end_date DATE,p_reason TEXT) RETURNS INT LANGUAGE plpgsql AS $$
DECLARE v_days INT; v_id INT;
BEGIN
 IF p_end_date<p_start_date THEN RAISE EXCEPTION 'End date cannot be before start date'; END IF;
 v_days:=(p_end_date-p_start_date)+1;
 INSERT INTO leave_requests(employee_id,leave_type,start_date,end_date,days,reason)
 VALUES(p_employee_id,p_leave_type,p_start_date,p_end_date,v_days,p_reason) RETURNING id INTO v_id;
 INSERT INTO audit_log(actor_employee_id,entity_type,entity_id,action,details)
 VALUES(p_employee_id,'LEAVE_REQUEST',v_id,'CREATE',jsonb_build_object('days',v_days));
 RETURN v_id;
END $$;

CREATE OR REPLACE FUNCTION approve_leave_request(p_request_id INT,p_reviewer_id INT) RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE v_employee_id INT; v_days INT; v_status VARCHAR; v_balance INT;
BEGIN
 SELECT employee_id,days,status INTO v_employee_id,v_days,v_status FROM leave_requests WHERE id=p_request_id FOR UPDATE;
 IF NOT FOUND THEN RAISE EXCEPTION 'Leave request not found'; END IF;
 IF v_status<>'PENDING' THEN RAISE EXCEPTION 'Only pending requests can be approved'; END IF;
 SELECT annual_leave_balance INTO v_balance FROM employees WHERE id=v_employee_id FOR UPDATE;
 IF v_balance<v_days THEN RAISE EXCEPTION 'Insufficient leave balance'; END IF;
 UPDATE employees SET annual_leave_balance=annual_leave_balance-v_days,updated_at=NOW() WHERE id=v_employee_id;
 UPDATE leave_requests SET status='APPROVED',reviewed_by=p_reviewer_id,reviewed_at=NOW() WHERE id=p_request_id;
 INSERT INTO audit_log(actor_employee_id,entity_type,entity_id,action,details)
 VALUES(p_reviewer_id,'LEAVE_REQUEST',p_request_id,'APPROVE',jsonb_build_object('days',v_days));
END $$;

CREATE OR REPLACE FUNCTION reject_leave_request(p_request_id INT,p_reviewer_id INT,p_reason TEXT) RETURNS VOID LANGUAGE plpgsql AS $$
DECLARE v_status VARCHAR;
BEGIN
 SELECT status INTO v_status FROM leave_requests WHERE id=p_request_id FOR UPDATE;
 IF NOT FOUND THEN RAISE EXCEPTION 'Leave request not found'; END IF;
 IF v_status<>'PENDING' THEN RAISE EXCEPTION 'Only pending requests can be rejected'; END IF;
 UPDATE leave_requests SET status='REJECTED',reviewed_by=p_reviewer_id,reviewed_at=NOW() WHERE id=p_request_id;
 INSERT INTO audit_log(actor_employee_id,entity_type,entity_id,action,details)
 VALUES(p_reviewer_id,'LEAVE_REQUEST',p_request_id,'REJECT',jsonb_build_object('reason',COALESCE(p_reason,'')));
END $$;
