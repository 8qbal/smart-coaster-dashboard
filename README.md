# Smart Coaster Dashboard

This project is a real-time web dashboard that displays sensor data from an ESP32-based Smart Coaster hydration reminder system. The dashboard is built using HTML, CSS, and JavaScript, with Firebase integration for real-time data updates.

## Features

- Real-time display of sensor data (temperature, humidity, distance, and bottle status)
- Countdown timer for hydration reminders
- Responsive design for various devices
- Chart visualizations for temperature and humidity trends

## Project Structure

```
smart-coaster-dashboard
├── src
│   ├── js
│   │   ├── app.js               # Main JavaScript file for Firebase connection and UI updates
│   │   ├── firebase-config.js    # Firebase configuration and initialization
│   │   ├── chart-manager.js      # Functions for managing charts with Chart.js
│   │   └── sensor-listener.js    # Logic for listening to Firebase Realtime Database changes
│   ├── css
│   │   ├── style.css             # General styles for the dashboard
│   │   └── dashboard.css          # Specific styles for dashboard components
│   └── index.html                 # Main HTML document for the dashboard
├── firebase.json                  # Firebase Hosting configuration
├── .firebaserc                    # Firebase project configuration
├── package.json                   # npm configuration file with dependencies
└── README.md                      # Project documentation
```

## Setup Instructions

1. Clone the repository:
   ```
   git clone <repository-url>
   ```

2. Navigate to the project directory:
   ```
   cd smart-coaster-dashboard
   ```

3. Install the required dependencies:
   ```
   npm install
   ```

4. Configure Firebase:
   - Create a Firebase project in the Firebase console.
   - Obtain your Firebase configuration object and update `src/js/firebase-config.js`.

5. Run the application:
   ```
   npm start
   ```

6. Open your browser and navigate to `http://localhost:3000` to view the dashboard.

## Usage Guidelines

- Ensure your ESP32 device is connected and sending data to the Firebase Realtime Database.
- The dashboard will automatically update with the latest sensor data.
- Use the countdown timer to remind yourself to hydrate regularly.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.