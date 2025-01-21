import express from 'express';
import mysql from 'mysql2/promise';
import bodyParser from 'body-parser';

const app = express();
app.use(bodyParser.json());

const dbConfig = {
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'bd_railways',
};

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
        seat_numbers !== undefined ? JSON.stringify(seat_numbers) : null,
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

// Start the server
app.listen(3000, () => {
    console.log('Server is running on port 3000');
});