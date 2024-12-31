const mysql = require('mysql');
const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: ''
});

connection.connect();

connection.query("ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY ''", function (error, results, fields) {
  if (error) throw error;
  console.log('User altered');
});

connection.query('FLUSH PRIVILEGES', function (error, results, fields) {
  if (error) throw error;
  console.log('Privileges flushed');
});

connection.end();
