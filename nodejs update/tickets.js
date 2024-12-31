import express from 'express';  // Import express
import db from './db.js';  // Import database connection

const route = express.Router();
route.route('/tickets').post((req, res) => {
    const { ticket_id,user_from,user_to,user_class,date_of_journey,depart_time,arrival_time,seat_no,train_id,create_time} = req.body;

    // Insert payment details into the database
    const sqlQuery = "INSERT INTO ticket_page(ticket_id,user_from,user_to,user_class,date_of_journey,depart_time,arrival_time,seat_no,train_id,create_time) VALUES(?, ?, ?, ?, ?, ?)";
    db.query(sqlQuery, [ticket_id,user_from,user_to,user_class,date_of_journey,depart_time,arrival_time,seat_no,train_id,create_time], function(error) {
        if (error) {
            return res.status(500).json({ success: false, message: 'Error in inserting values', error });
        }
        res.status(200).json({ success: true, message: 'ticket data inserted' });
    });
});
