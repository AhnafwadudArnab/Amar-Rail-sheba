import mysql from 'mysql';

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: '',
  database: 'bd_railways',
});

connection.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err);
    return;
  }
  console.log('Connected to the MySQL database.');
});

function getData(callback) {
  connection.query('SSELECT * FROM coaches', (err, results) => {
    if (err) {
      console.error('Error fetching data:', err);
      callback(err, null);
      return;
    }
    callback(null, results);
  });
}

export { getData };