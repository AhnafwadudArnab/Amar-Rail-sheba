import express from 'express';
import bodyParser from 'body-parser';
import mysql from 'mysql2';
const app = express();
const PORT = 3000;

// Middleware to parse JSON request bodies
app.use(bodyParser.json());

// MySQL database connection
const db = mysql.createConnection({
    host: 'localhost', 
    user: 'root',      
    password: '', 
    database: 'bd_railways',
    port: 3308 
});

// Connect to MySQL database
db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        process.exit(1);
    }
    console.log('Connected to MySQL database');
});

// Route to add a booking to the `firstPage` table
app.post('/firstPage', (req, res) => {
    const { user_id, user_from, user_to, user_class, journey_date } = req.body;

    if (!user_id || !user_from || !user_to || !user_class || !journey_date) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    const sql = `
        INSERT INTO firstPage (user_id, user_from, user_to, user_class, journey_date)
        VALUES (?, ?, ?, ?, ?)
    `;

    db.query(sql, [user_id, user_from, user_to, user_class, journey_date], (err, result) => {
        if (err) {
            console.error('Error inserting data:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.status(201).json({ message: 'Booking added successfully', bookingId: result.insertId });
    });
});

// Route to get all bookings
app.get('/firstPage', (req, res) => {
    const sql = `SELECT * FROM firstPage`;

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error retrieving data:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.json(results);
    });
});

// Route to get a specific booking by user_id
app.get('/firstPage/:user_id', (req, res) => {
    const { user_id } = req.params;

    const sql = `SELECT * FROM firstPage WHERE user_id = ?`;

    db.query(sql, [user_id], (err, results) => {
        if (err) {
            console.error('Error retrieving data:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        if (results.length === 0) {
            return res.status(404).json({ error: 'Booking not found' });
        }
        res.json(results[0]);
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
