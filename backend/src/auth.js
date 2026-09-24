const jwt=require('jsonwebtoken');const crypto=require('crypto');
const secret=()=>process.env.JWT_SECRET||'staffsync-dev-secret-change-me';
const rsecret=()=>process.env.JWT_REFRESH_SECRET||'staffsync-refresh-secret-change-me';
exports.sign=(u)=>jwt.sign({sub:u.id,employeeId:u.employee_id,email:u.email,role:u.role_name},secret(),{expiresIn:'15m'});
exports.refresh=(u)=>jwt.sign({sub:u.id},rsecret(),{expiresIn:'7d'});
exports.hash=(t)=>crypto.createHash('sha256').update(t).digest('hex');
exports.verify=(t)=>jwt.verify(t,rsecret());