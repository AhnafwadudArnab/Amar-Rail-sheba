import mysql from 'mysql';  // Import mysql module


// Database connection setup
const connection = mysql.createConnection({
    host: 'localhost',  // XAMPP MySQL server is usually on localhost
    user: 'root',  // Default XAMPP MySQL user
    password: '',  // Your MySQL password
        database: 'bd_railways',
        port: 3308  // XAMPP MySQL port
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
