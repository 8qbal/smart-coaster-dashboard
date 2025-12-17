// Sensor Listener Module
// Handles real-time data subscription from Firebase

import { database, ref, onValue, off, SMART_COASTER_PATH } from './firebase-config.js';

let statusRef = null;
let dataCallback = null;

/**
 * Start listening to sensor data from Firebase
 * @param {Function} callback - Function to call when data updates
 */
export function startListening(callback) {
    if (statusRef) {
        stopListening();
    }

    dataCallback = callback;
    statusRef = ref(database, SMART_COASTER_PATH);

    onValue(statusRef, (snapshot) => {
        const data = snapshot.val();
        if (data && dataCallback) {
            dataCallback(data);
        }
    }, (error) => {
        console.error('Firebase listener error:', error);
        if (dataCallback) {
            dataCallback(null, error);
        }
    });

    console.log('Started listening to:', SMART_COASTER_PATH);
}

/**
 * Stop listening to sensor data
 */
export function stopListening() {
    if (statusRef) {
        off(statusRef);
        statusRef = null;
        dataCallback = null;
        console.log('Stopped listening to Firebase');
    }
}

/**
 * Check if currently listening
 * @returns {boolean}
 */
export function isListening() {
    return statusRef !== null;
}
