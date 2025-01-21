import mysql from 'mysql';
import bodyParser from 'body-parser';
import express from 'express';

const app = express();
const port = 3000;

// Middleware
app.use(bodyParser.json());

// Database Connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    port: 3306,
    password: process.env.DB_PASSWORD || '', // Use environment variables for sensitive data
    database: 'bd_railways',
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        process.exit(1); // Stop the server if database connection fails
    }
    console.log('Connected to MySQL.!!');
});

// Update Seat Status
app.put('/update-seat-status', (req, res) => {
    const { coach_ID, seatNumber, status } = req.body;

    // Input Validation
    const validStatuses = ['available', 'booked', 'reserved'];
    if (!coach_ID || typeof seatNumber !== 'number' || !validStatuses.includes(status)) {
        return res.status(400).send({ error: 'Invalid input data.' });
    }

    db.query(
        'UPDATE seats SET status = ? WHERE coach_ID = ? AND seat_number = ?',
        [status, coach_ID, seatNumber],
        (err, results) => {
            if (err) {
                return res.status(500).send({ error: 'Error updating seat status' });
            }
            if (results.affectedRows === 0) {
                return res.status(404).send({ error: 'Seat not found.' });
            }
            res.send({ message: 'Seat status updated successfully.' });
        }
    );
});

// Get Seat Status
app.get('/get-seat-status/:coach_ID', (req, res) => {
    const { coach_ID } = req.params;

    db.query(
        'SELECT seat_number, status, compartment FROM seats WHERE coach_ID = ?',
        [coach_ID],
        (err, results) => {
            if (err) {
                return res.status(500).send({ error: 'Error fetching seat status' });
            }
            res.send({ data: results });
        }
    );
});

// Book Seats
app.post('/book-seats', (req, res) => {
    const { coach_ID, seats } = req.body;

    // Input Validation
    if (!coach_ID || !Array.isArray(seats) || seats.some((seat) => typeof seat !== 'number')) {
        return res.status(400).send({ error: 'Invalid input data.' });
    }

    db.query(
        'UPDATE seats SET status = "booked" WHERE coach_ID = ? AND seat_number IN (?)',
        [coach_ID, seats],
        (err, results) => {
            if (err) {
                return res.status(500).send({ error: 'Error booking seats' });
            }
            if (results.affectedRows === 0) {
                return res
                    .status(400)
                    .send({ error: 'No seats were booked. Please check the seat numbers and try again.' });
            }
            res.send({ message: `Seats ${seats} booked successfully.` });
        }
    );
});

// Catch-All Error Handler
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send({ error: 'Something went wrong!' });
});

// Start the Server
app.listen(port, () => {
    console.log(`Server is running on http://localhost:${port}`);
});
