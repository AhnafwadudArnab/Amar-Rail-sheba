import mysql from 'mysql';  // Import mysql module

// Database connection setup
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'railway_systems',
    port: '3308', // Ensure this matches your DB setup
});

connection.connect((err) => {
    if (err) {
        console.error('Error connecting to the database:', err.message);
        process.exit(1); // Stop app if connection fails
    } else {
        console.log('DB connected successfully!');
    }
});

export default connection;  // Export connection for use in other files
