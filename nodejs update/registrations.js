import express from 'express';
const app = express();
import db from './db.js';  // Import the database connection

app.use(express.json());  // Middleware to parse JSON body

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
    db.query('INSERT INTO users (name, email, phone, password) VALUES (?, ?, ?, ?)', [name, email, phone, password], (error, results) => {
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



const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
