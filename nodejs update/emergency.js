import express from 'express';
import bodyParser from 'body-parser';
import mysql from 'mysql';

const app = express();

// Middleware
app.use(bodyParser.json());

const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'bd_railways',
    port: 3306
});

db.connect(err => {
    if (err) {
        console.error('Database connection failed:', err.stack);
        return;
    }
    console.log('Connected to database.');
});

// Emergency alert endpoint
app.post('/emergencyAlert', (req, res) => {
    const { userId, seatNumber, emergencyType, coachNo } = req.body;

    if (!userId || !seatNumber || !emergencyType || !coachNo) {
        return res.status(400).send('All fields are required.');
    }

    const userQuery = 'SELECT name FROM users WHERE id = ?';
    db.query(userQuery, [userId], (err, userResult) => {
        if (err) {
            return res.status(500).send('Error fetching user data.');
        }

        if (userResult.length === 0) {
            return res.status(404).send('User not found.');
        }

        const userName = userResult[0].name;

        const alertQuery = 'INSERT INTO emergency_alerts (EG_id, name, seatNumber, emergencyType, coachNo) VALUES (?, ?, ?, ?, ?)';
        db.query(alertQuery, [userId, userName, seatNumber, emergencyType, coachNo], (err) => {
            if (err) {
                return res.status(500).send('Error saving emergency alert.');
            }

            res.status(200).send('Emergency alert saved successfully.');
            db.end();
        });
    });
});

app.post('/getDetails', (req, res) => {
    const { userId, ticketId } = req.body;

    if (!userId || !ticketId) {
        return res.status(400).send('User ID and Ticket ID are required.');
    }

    const userQuery = 'SELECT name FROM users WHERE id = ?';
    const seatQuery = 'SELECT seat_no FROM seats WHERE order_id = ?';
    const compartmentQuery = 'SELECT compartment FROM tickets WHERE id = ?';

    db.query(userQuery, [userId], (err, userResult) => {
        if (err) {
            return res.status(500).send('Error fetching user data.');
        }

        if (userResult.length === 0) {
            return res.status(404).send('User not found.');
        }

        const userName = userResult[0].name;

        db.query(seatQuery, [ticketId], (err, seatResult) => {
            if (err) {
                return res.status(500).send('Error fetching seat data.');
            }

            if (seatResult.length === 0) {
                return res.status(404).send('Seat not found.');
            }

            const seatNumber = seatResult[0].seat_no;

            db.query(compartmentQuery, [ticketId], (err, compartmentResult) => {
                if (err) {
                    return res.status(500).send('Error fetching compartment data.');
                }

                if (compartmentResult.length === 0) {
                    return res.status(404).send('Compartment not found.');
                }

                const compartment = compartmentResult[0].compartment;

                res.status(200).json({
                    userName,
                    seatNumber
                });
                db.end();
            });
        });
    });
});



// Start server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});



