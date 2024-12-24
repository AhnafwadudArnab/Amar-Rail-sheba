import express from 'express';  // Import express
import db from './db.js';  // Import database connection

const route = express.Router();

// Route for registering users
route.route('/register').post((req, res) => {
    var name = req.body.name;
    var email = req.body.email;
    var phone = req.body.phone;
    var password = req.body.password;

    // Check if the email already exists
    var checkEmailQuery = "SELECT * FROM users WHERE email = ?";
    db.query(checkEmailQuery, [email], function(error, data) {
        if (error) {
            return res.status(500).json({ success: false, message: 'Error in querying the database', error });
        }
        if (data.length > 0) {
            return res.status(400).json({ success: false, message: 'Email already exists' });
        }

        // Insert user into the database without hashing the password
        var sqlQuery = "INSERT INTO users(name, email, phone, password) VALUES(?, ?, ?, ?)";
        db.query(sqlQuery, [name, email, phone, password], function(error, data) {
            if (error) {
                return res.status(500).json({ success: false, message: 'Error in inserting values', error });
            }
            res.status(200).json({ success: true, message: 'Registered successfully' });
        });
    });
});
// Route for logging in users
route.route('/login').post((req, res) => {
    var name = req.body.name;
    var email = req.body.email;
    var password = req.body.password;
    // Query to check if the user exists with the provided name, email, and password
    var sqlQuery = "SELECT * FROM users WHERE name = ? AND email = ? AND password = ?";
    db.query(sqlQuery, [name, email, password], function(error, data){
        if (error) {
            return res.status(500).json({ success: false, message: 'Error in querying the database', error });
        }
        if (data.length === 0) {
            return res.status(401).json({ success: false, message: 'Invalid email or password' });
        }
        res.status(200).json({ success: true, message: 'Logged in successfully' });
    });
});


// Route for forgetting password
route.route('/forget-password').post((req, res) => {
    var email = req.body.email;
    var password = req.body.password;
    // Query to check if the user exists with the provided email
    var sqlQuery = "SELECT * FROM users WHERE email = ?";

    db.query(sqlQuery, [email], function(error, data){
        if (error) {
            return res.status(500).json({ success: false, message: 'Error in querying the database', error });
        }
        if (data.length === 0) {
            return res.status(401).json({ success: false, message: 'Invalid email' });
        }
        // Update the user's password
        var updateQuery = "UPDATE users SET password = ? WHERE email = ?";
        db.query(updateQuery, [password, email], function(error){
            if (error) {
                return res.status(500).json({ success: false, message: 'Error in updating the password', error });
            }
            res.status(200).json({ success: true, message: 'Password updated successfully' });
        }
    );

});
}
);


export default route;

