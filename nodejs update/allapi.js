import express from 'express';
const app = express();
import db from './db.js';  

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

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
