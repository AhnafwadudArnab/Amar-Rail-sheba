import express from 'express';
const app = express();
import db from './db.js';  // Import the database connection

app.use(express.json());  // Middleware to parse JSON body


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

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});