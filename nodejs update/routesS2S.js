const express = require('express');

const router = express.Router();

// Import your controllers here
// const { loginController, registerController } = require('../controllers/authController');

// Define your routes here
router.post('/login', (req, res) => {
    // Call your login controller here
    // loginController(req, res);
    res.send('Login route');
});

router.post('/register', (req, res) => {
    // Call your register controller here
    // registerController(req, res);
    res.send('Register route');
});

module.exports = router;