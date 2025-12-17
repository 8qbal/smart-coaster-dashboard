// Firebase Configuration for Smart Coaster Dashboard
// Using Firebase SDK v10 (modular)

import { initializeApp } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-app.js";
import { getDatabase, ref, onValue, off } from "https://www.gstatic.com/firebasejs/10.7.1/firebase-database.js";

// Your web app's Firebase configuration
const firebaseConfig = {
    apiKey: "AIzaSyBeEe2ZAH7w18_81X3EAe7WsK858ZZObB0",
    authDomain: "smart-coaster-c4cb1.firebaseapp.com",
    databaseURL: "https://smart-coaster-c4cb1-default-rtdb.asia-southeast1.firebasedatabase.app",
    projectId: "smart-coaster-c4cb1",
    storageBucket: "smart-coaster-c4cb1.firebasestorage.app",
    messagingSenderId: "981786199110",
    appId: "1:981786199110:web:5fe6e7504976d6678ef647"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);

// Initialize Realtime Database
const database = getDatabase(app);

// Database path for Smart Coaster status
const SMART_COASTER_PATH = 'SmartCoaster/status';

// Export Firebase services and utilities
export { database, ref, onValue, off, SMART_COASTER_PATH };
