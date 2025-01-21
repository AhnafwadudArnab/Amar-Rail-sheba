const express = require('express');
const mysql = require('mysql2');
const app = express();
const port = 3000;

// Middleware to parse JSON requests
app.use(express.json());

// MySQL Database Configuration
const db = mysql.createConnection({
    host: 'localhost', // Change this to your DB host
    user: 'root',      // Your DB user
    password: '',      // Your DB password
    database: 'train_db' // Your database name
});

// Connect to MySQL
db.connect((err) => {
    if (err) {
        console.error('Error connecting to the database:', err);
        return;
    }
    console.log('Connected to MySQL database');
});

// Endpoint to fetch all trains
app.get('/trains', (req, res) => {
    const query = 'SELECT * FROM trains'; // Replace with your table name
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching train data:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        res.status(200).json(results);
    });
});

// Endpoint to fetch a train by ID
app.get('/train/:id', (req, res) => {
    const trainId = req.params.id;
    const query = 'SELECT * FROM trains WHERE id = ?'; // Replace with your table name
    db.query(query, [trainId], (err, results) => {
        if (err) {
            console.error('Error fetching train by ID:', err);
            return res.status(500).json({ error: 'Database query failed' });
        }
        if (results.length === 0) {
            return res.status(404).json({ error: 'Train not found' });
        }
        res.status(200).json(results[0]);
    });
});

// Start the server
app.listen(port, () => {
    console.log(`Server running on http://localhost:${port}`);
});