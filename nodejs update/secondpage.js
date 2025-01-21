import express from 'express';
import bodyParser from 'body-parser';
import mysql from 'mysql2';

const app = express();
const PORT = 3000;
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'bd_railways',
    port: 3306,
});

db.connect((err) => {
    if (err) {
        console.error('Error connecting to MySQL:', err);
        process.exit(1);
    }
    console.log('Connected to MySQL database');
});

///  new entry to the `secondpage` table
app.post('/secondPage', (req, res) => {
    const { Tprice, ticketType } = req.body;

    if (!Tprice || !ticketType) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    const sql = `
        INSERT INTO secondpage (Tprice, ticketType)
        VALUES (?, ?)
    `;
    db.query(sql, [Tprice, ticketType], (err, result) => {
        if (err) {
            console.error('Error inserting data:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.status(201).json({ message: 'Entry added successfully', id: result.insertId });
    });
});

/// Fetch all entries from the `secondpage` table
app.get('/secondPage', (_, res) => {
    const sql = `SELECT * FROM secondpage`;

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error fetching data:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.json(results);
    });
});

/// Fetch a specific entry by ID
app.get('/secondPage/:id', (req, res) => {
    const { id } = req.params;

    const sql = `SELECT * FROM secondpage WHERE ID = ?`;

    db.query(sql, [id], (err, result) => {
        if (err) {
            console.error('Error fetching data:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        if (result.length === 0) {
            return res.status(404).json({ message: 'Entry not found' });
        }
        res.json(result[0]);
    });
});

/// Update an entry in the `secondpage` table
app.put('/secondPage/:id', (req, res) => {
    const { id } = req.params;
    const { Tprice, ticketType } = req.body;

    if (!Tprice || !ticketType) {
        return res.status(400).json({ error: 'All fields are required' });
    }

    const sql = `
        UPDATE secondpage
        SET Tprice = ?, ticketType = ?
        WHERE ID = ?
    `;
    db.query(sql, [Tprice, ticketType, id], (err, result) => {
        if (err) {
            console.error('Error updating data:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Entry not found' });
        }
        res.json({ message: 'Entry updated successfully' });
    });
});
/// Delete an entry from the `secondpage` table
app.delete('/secondPage/:id', (req, res) => {
    const { id } = req.params;

    const sql = `DELETE FROM secondpage WHERE ID = ?`;

    db.query(sql, [id], (err, result) => {
        if (err) {
            console.error('Error deleting data:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        if (result.affectedRows === 0) {
            return res.status(404).json({ message: 'Entry not found' });
        }
        res.json({ message: 'Entry deleted successfully' });
    });
});

/// Start server
const server = app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
