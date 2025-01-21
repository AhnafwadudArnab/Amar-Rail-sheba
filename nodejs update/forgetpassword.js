import express from 'express';
import bodyParser from 'body-parser';
import mysql from 'mysql2';
const app = express();
const PORT = 3000;

// Middleware to parse JSON request bodies
app.use(bodyParser.json());

// MySQL database connection
const db = mysql.createConnection({
    host: 'localhost', // Replace with your MySQL host
    user: 'root',      // Replace with your MySQL username
    password: '', // Replace with your MySQL password
    database: 'bd_railways', 
    port:3306// Replace with your database name
});

// Connect to MySQL database
db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        process.exit(1);
    }
    console.log('Connected to MySQL database');
});

// Route for forgetting password
app.put('/forgetPassword', (req, res) => {
    const { email, newPassword } = req.body;

    // Validate input
    if (!email || !newPassword) {
        return res.status(400).json({ error: 'Email and new password are required' });
    }

    // Update password in the database
    const sql = `UPDATE users SET password = ? WHERE email = ?`;
    db.query(sql, [newPassword, email], (err, result) => {
        if (err) {
            console.error('Error updating password:', err);
            return res.status(500).json({ error: 'Database error' });
        }

        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Email not found' });
        }

        res.status(200).json({ message: 'Password updated successfully' });
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
