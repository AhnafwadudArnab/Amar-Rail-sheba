import express from 'express';  // Import express
import db from './db.js';  // Import database connection

const route = express.Router();
route.route('/payments').post((req, res) => {
    const { ticket_id: Ticket_ID, payment_id: Payment_ID, payment_date: Payment_date, payment_status: Payment_status, total_amount: Payment_amount, payment_type: Payment_method } = req.body;

    // Insert payment details into the database
    const sqlQuery = "INSERT INTO payments(Ticket_ID,Payment_ID,Payment_status,Payment_date, Payment_method, Payment_amount) VALUES(?, ?, ?, ?, ?, ?)";
    db.query(sqlQuery, [Ticket_ID, Payment_ID, Payment_status, Payment_date, Payment_method, Payment_amount], function(error) {
        if (error) {
            return res.status(500).json({ success: false, message: 'Error in inserting values', error });
        }
        res.status(200).json({ success: true, message: 'Payment Done' });
    });
});

export default route;
