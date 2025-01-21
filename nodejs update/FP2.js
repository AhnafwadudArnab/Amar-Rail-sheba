import express from 'express';
import mysql from 'mysql';
const app = express();
const port = 3000;
app.use(express.json());
const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'bd_railways' // Replace with your actual database name
});

connection.connect((err) => {
    if (err) throw err;
    console.log('Connected to the database.');
});

app.get('/trains', (req, res) => {
    const { from_station, to_station } = req.query;

    // Checking if from_station and to_station are provided
    if (!from_station || !to_station) {
        return res.status(400).json({ error: 'Both from_station and to_station are required' });
    }

    // Query to get train details based on from_station and to_station
    const selectQuery = `
        SELECT * FROM all_train_details
        WHERE from_station = ? AND to_station = ?
    `;

    connection.query(selectQuery, [from_station, to_station], (err, results) => {
        if (err) {
            return res.status(500).json({ error: err.message });
        }
        res.json(results);
    });
});

// Start the server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
