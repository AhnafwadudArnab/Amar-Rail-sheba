import express from 'express';
import bodyParser from 'body-parser';
import mysql from 'mysql2';

const app = express();
const PORT = 3000;

// Middleware
app.use(bodyParser.json());

// MySQL database connection
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '', // Replace with your password
    database: 'bd_railways', // Replace with your database name
port: 3306,
});

// Connect to MySQL
db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        process.exit(1);
    }
    console.log('Connected to MySQL database');
});

// Create ticket table if not exists
db.query(`
    CREATE TABLE IF NOT EXISTS tickets (
        id INT AUTO_INCREMENT PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        from_station VARCHAR(255) NOT NULL,
        to_station VARCHAR(255) NOT NULL,
        travel_class VARCHAR(255) NOT NULL,
        date DATE NOT NULL,
        depart_time TIME NOT NULL,
        seat VARCHAR(10) NOT NULL,
        total_amount DECIMAL(10, 2) NOT NULL,
        train_code VARCHAR(20) NOT NULL
    )
`);

// Endpoint to create a new ticket
app.post('/ticket', (req, res) => {
    const { name, from_station, to_station, travel_class, date, depart_time, seat, total_amount, train_code } = req.body;

    const query = `
        INSERT INTO tickets (name, from_station, to_station, travel_class, date, depart_time, seat, total_amount, train_code) 
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    `;
    
    db.query(query, [name, from_station, to_station, travel_class, date, depart_time, seat, total_amount, train_code], (err, result) => {
        if (err) {
            console.error('Error creating ticket:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.json({ message: 'Ticket created successfully', ticketId: result.insertId });
    });
});

// Endpoint to view all tickets
app.get('/tickets', (res) => {
    db.query('SELECT * FROM tickets', (err, results) => {
        if (err) {
            console.error('Error fetching tickets:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.json(results);
    });
});

// Endpoint to view a specific ticket by ID
app.get('/ticket/:id', (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM tickets WHERE id = ?', [id], (err, result) => {
        if (err) {
            console.error('Error fetching ticket:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        if (result.length === 0) {
            return res.status(404).json({ error: 'Ticket not found' });
        }
        res.json(result[0]);
    });
});

// Endpoint to update a ticket
app.put('/ticket/:id', (req, res) => {
    const { id } = req.params;
    const { name, from_station, to_station, travel_class, date, depart_time, seat, total_amount, train_code } = req.body;

    const query = `
        UPDATE tickets 
        SET name = ?, from_station = ?, to_station = ?, travel_class = ?, date = ?, depart_time = ?, seat = ?, total_amount = ?, train_code = ? 
        WHERE id = ?
    `;

    db.query(query, [name, from_station, to_station, travel_class, date, depart_time, seat, total_amount, train_code, id], (err, result) => {
        if (err) {
            console.error('Error updating ticket:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Ticket not found' });
        }
        res.json({ message: 'Ticket updated successfully' });
    });
});

// Endpoint to delete a ticket
app.delete('/ticket/:id', (req, res) => {
    const { id } = req.params;
    
    db.query('DELETE FROM tickets WHERE id = ?', [id], (err, result) => {
        if (err) {
            console.error('Error deleting ticket:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ error: 'Ticket not found' });
        }
        res.json({ message: 'Ticket deleted successfully' });
    });
});

// Start the server
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
