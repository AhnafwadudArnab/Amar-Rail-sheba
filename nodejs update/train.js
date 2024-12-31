import mysql from 'mysql';
import express from 'express';
const router = express.Router();

// Database connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'railway_systems',
    port: 3308, // Adjust the port if necessary
});

// Ensure database connection
db.connect((err) => {
    if (err) {
        console.error('Database connection failed: ', err.stack);
        return;
    }
    console.log('Connected to MySQL database on port 3308');
});

router.route('/train.js').post((req, res) => {
    const train_id = req.body.train_id; // Get train_id from the request body
    let sqlQuery;

    if (train_id) {
        // Query to fetch data for a specific train
        sqlQuery = "SELECT * FROM train_collections WHERE train_id = ?";
    } else {
        // Query to fetch all train data if no train_id is provided
        sqlQuery = "SELECT * FROM train_collections";
    }

    db.query(sqlQuery, train_id ? [train_id] : [], function(error, data) {
        if (error) {
            return res.status(500).json({ success: false, message: 'Error fetching train data', error });
        }

        if (data.length === 0) {
            return res.status(404).json({ success: false, message: 'No train data found' });
        }

        res.status(200).json({ success: true, data });
    });
});

export default router;
