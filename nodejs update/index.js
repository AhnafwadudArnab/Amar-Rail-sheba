import express from 'express'; 
import userRoute from './user.js';  // Adjust this according to the correct path

const app = express();
import bodyParser from 'body-parser';

app.use(express.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/user', userRoute);


const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});