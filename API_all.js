import express from 'express';
const app = express();
import db from './db.js';  
import mysql from 'mysql2/promise';

const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'bd_railways',
    PORT : 3306
};

app.use(express.json());  
   //Signup route
app.post('/user/register', (req, res) => {
    const { name, email, phone, password } = req.body;


    // Check if the email already exists
    db.query('SELECT * FROM users WHERE email = ?', [email], (error, results) => {
        if (error) {
            console.error('Error checking email:', error);
            return res.status(500).send('Server error');
        }

        if (results.length > 0) {
            return res.status(400).send('Email already exists'); 
        }

        // Insert the new user
        db.query('INSERT INTO users (name, email, phone, password) VALUES (?, ?, ?, ?)', [name, email, phone, password], (error) => {
            if (error) {
                console.error('Error inserting user:', error);
                return res.status(500).send('Server error');
            }

            // Log the request data
            console.log('Name:', name);
            console.log('Email:', email);
            console.log('Phone:', phone);
            console.log('Password:', password);

            res.status(200).send('Registration successful');
        });
    });

});


//Login route
app.post('/user/login', (req, res) => {
    const { name, email, password } = req.body;

    // Check if the email exists
    db.query('SELECT * FROM users WHERE email = ?', [email], (error, results) => {
        if (error) {
            console.error('Error checking email:', error);
            return res.status(500).send('Server error');
        }

        if (results.length === 0) {
            return res.status(400).send('Invalid email or password');
        }

        const user = results[0];
        // Compare the provided password with the plain password in the database
        if (password !== user.password) {
            return res.status(400).send('Invalid email or password');
        }

        // Compare the provided name with the name in the database
        if (name !== user.name) {
            return res.status(400).send('Invalid name');
        }

        // Successful login
        res.status(200).send(`Login successful. Welcome, ${user.name}!`);
    });
});



// Fetch all coaches data
app.get('/coaches', (_req, res) => {
    const query = 'SELECT name, seats, type FROM coaches';

    db.query(query, (err, results) => {
        if (err) {
            res.status(500).send({ error: 'Error fetching coaches data' });
            return;
        }
        if (results.length === 0) {
            res.status(404).send({ error: 'No coaches found' });
            return;
        }
        res.send(results);
    });
});


// Route to add a booking to the `firstPage` table
app.post('/firstPage', (req, res) => {
    const { user_from, user_to, user_class, journey_date } = req.body;

    if (!user_from || !user_to || !user_class || !journey_date) {
        return res.status(200).json({ error: 'All fields are required' });
    }

    // Insert booking into firstPage table
    const insertSql = `
        INSERT INTO firstPage (user_from, user_to, user_class, journey_date)
        VALUES (?, ?, ?, ?)
    `;
    db.query(insertSql, [user_from, user_to, user_class, journey_date], (err, result) => {
        if (err) {
            console.error('Error inserting data:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.status(201).json({ message: 'Searching trains now...', bookingId: result.insertId });
    });
});

// Route to get all bookings
app.get('/firstPage', (_req, res) => {
    const sql = `SELECT * FROM firstPage`;

    db.query(sql, (err, results) => {
        if (err) {
            console.error('Error retrieving data:', err);
            return res.status(500).json({ error: 'Database error' });
        }
        res.json(results);
    });
});

// Route to get a specific booking by booking ID
app.get('/firstPage/:bookingId', (req, res) => {
    const { bookingId } = req.params;

    const sql = `SELECT * FROM firstPage WHERE id = ?`;

    db.query(sql, [bookingId], (err, results) => {
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

 // seccond page // 

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


// Route for bookings // 
app.post('/insert-user-data', async (req, res) => {
    const { user_id, seat_numbers, coachname, seat_status } = req.body;

    // Validate required fields
    if (user_id === undefined) {
        return res.status(400).send('Error: user_id is required');
    }

    // Prepare the SQL query
    const query = 'INSERT INTO bookings (user_id, seat_numbers, coachname, seat_status) VALUES (?, ?, ?, ?)';
    const values = [
        user_id,
        Array.isArray(seat_numbers) ? JSON.stringify(seat_numbers) : null,
        coachname !== undefined ? coachname : null,
        seat_status !== undefined ? seat_status : null
    ];

    try {
        // Create a connection to the database
        const connection = await mysql.createConnection(dbConfig);
        // Execute the query
        await connection.execute(query, values);
        // Close the connection
        await connection.end();
        // Send success response
        res.status(200).send('User  data inserted successfully');
    } catch (error) {
        console.error('Error inserting user data:', error.message); // Log the error message
        res.status(500).send('Error inserting user data: ' + error.message); // Send error message
    }
});
// payment route //

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
// 	ticket_id 	payment_id 	payment_date 	payment_status 	total_amount 	payment_type 	
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


const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
