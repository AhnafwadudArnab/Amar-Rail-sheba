import express from 'express';
import http from 'http';
import { Server } from 'socket.io';
const app = express();
const server = http.createServer(app);
const io = new Server(server);

app.use(express.json());

let users = {};

io.on('connection', (socket) => {
    console.log('New client connected');

    socket.on('join', (userId) => {
        users[userId] = socket.id;
        console.log(`User ${userId} connected`);
    });

    socket.on('locationUpdate', (data) => {
        const { userId, location } = data;
        console.log(`Location update from user ${userId}: ${location}`);
        // Broadcast location to all connected clients
        io.emit('locationUpdate', data);
    });

    socket.on('disconnect', () => {
        console.log('Client disconnected');
        for (let userId in users) {
            if (users[userId] === socket.id) {
                delete users[userId];
                console.log(`User ${userId} disconnected`);
                break;
            }
        }
    });
});

app.get('/', (_, res) => {
    res.send('Live Location Server is running');
});

const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});


