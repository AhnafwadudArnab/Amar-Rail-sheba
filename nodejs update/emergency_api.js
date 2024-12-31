const express = require('express');

const app = express();
const port = 3000;

const emergencyData = [
    { emergency_id: 1, user_name: 'John Doe', seat_no: '12A', compartment_no: '3', type_of_emergency: 'Medical', pressed: true },
    { emergency_id: 2, user_name: 'Jane Smith', seat_no: '15B', compartment_no: '4', type_of_emergency: 'Fire', pressed: false },
    // Add more data as needed
];

app.get('/emergencies', (req, res) => {
    res.json(emergencyData);
});

app.listen(port, () => {
    console.log(`Emergency API listening at http://localhost:${port}`);
});