import express from 'express';
import mysql from 'mysql';

const app = express();
app.use(express.json());

const connection = mysql.createConnection({
    host: 'localhost',
    user: 'root',
    password: '',
    database: 'systems_rail',
    port: '3306', // Ensure this matches your DB setup
});

connection.connect((err) => {
    if (err) {
        console.log(err);
    } else {
        console.log('DB connected !!');
    }
});

app.post('/firstpage', (req, res) => {
    const { user_from, user_to, user_class, user_date } = req.body;

    connection.query('INSERT INTO first_booking_page VALUES(?, ?, ?, ?)', [user_from, user_to, user_class, user_date], (err) => {
        if (err) {
            console.log(err);
            res.status(500).send('Error inserting values');
        } else {
            res.send('Values Inserted');
        }
    });
});
app.listen(3000, () => {
    console.log('Server is running on port 3000');
});