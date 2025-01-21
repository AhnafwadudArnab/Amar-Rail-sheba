import express from 'express';
import bodyParser from 'body-parser';
import mysql from 'mysql';
const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

// MySQL Database Connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'bd_railways',
    port: 3306,
});

db.connect((err) => {
    if (err) {
        console.error('Database connection failed:', err);
        process.exit(1);
    }
    console.log('Connected to MySQL database');
});

// API Endpoints

// Save Payment Details
app.post('/payments', (req, res) => {
    const {
        ticket_id,
        payment_id,
        payment_date,
        payment_status,
        total_amount,
        payment_type,
    } = req.body;

    if (
        !ticket_id ||
        !payment_id ||
        !payment_date ||
        !payment_status ||
        !total_amount ||
        !payment_type
    ) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    const query = `
        INSERT INTO payments (ticket_id, payment_id, payment_date, payment_status, total_amount, payment_type)
        VALUES (?, ?, ?, ?, ?, ?)
    `;
    const values = [
        ticket_id,
        payment_id,
        payment_date,
        payment_status,
        total_amount,
        payment_type,
    ];

    db.query(query, values, (err, result) => {
        if (err) {
            console.error('Error inserting payment:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.status(200).json({ message: 'Payment saved successfully', result });
    });
});

// Fetch Orders (Optional)
app.get('/orders', (_, res) => {
    const query = 'SELECT * FROM orders';
    db.query(query, (err, results) => {
        if (err) {
            console.error('Error fetching orders:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.status(200).json(results);
    });
});

// Start the Server
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});