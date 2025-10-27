const mysql = require('mysql2/promise');

const pool = mysql.createPool({
  host: 'localhost',      // Update if needed
  user: 'root',           // Your MySQL username
  password: 'password',   // Your MySQL password
  database: 'multicloud', // Make sure this DB exists
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

pool.getConnection()
  .then(() => console.log('Connected to MySQL database'))
  .catch(err => console.error('MySQL connection error:', err));

module.exports = pool;
