// Smart Coaster Dashboard - Main Application
// Real-time hydration reminder system dashboard

import { startListening, stopListening } from './sensor-listener.js';
import { initializeChart, addDataPoint, updateChartTheme } from './chart-manager.js';

// Constants
const OFFLINE_THRESHOLD = 60000; // 60 seconds in milliseconds
const BOTTLE_DETECTION_DISTANCE = 5; // cm

// State
let lastTimestamp = null;
let onlineCheckInterval = null;

// DOM Elements
const elements = {
    tempValue: document.getElementById('temp-value'),
    humidityValue: document.getElementById('humidity-value'),
    distanceValue: document.getElementById('distance-value'),
    bottleValue: document.getElementById('bottle-value'),
    bottleIcon: document.getElementById('bottle-icon'),
    lastUpdated: document.getElementById('last-updated'),
    connectionStatus: document.getElementById('connection-status'),
    themeToggle: document.getElementById('theme-toggle'),
    trendChart: document.getElementById('trendChart')
};

/**
 * Initialize the dashboard
 */
function init() {
    console.log('🚀 Smart Coaster Dashboard initializing...');
    
    // Initialize theme
    initTheme();
    
    // Initialize chart
    initializeChart(elements.trendChart);
    
    // Start listening to Firebase
    startListening(handleDataUpdate);
    
    // Start online status checker
    startOnlineChecker();
    
    // Setup event listeners
    setupEventListeners();
    
    console.log('✅ Dashboard initialized');
}

/**
 * Handle data updates from Firebase
 * @param {Object} data - Sensor data from Firebase
 * @param {Error} error - Error if any
 */
function handleDataUpdate(data, error) {
    if (error) {
        console.error('Data update error:', error);
        setOfflineStatus();
        return;
    }

    if (!data) {
        console.warn('No data received');
        return;
    }

    console.log('📊 Data received:', data);

    // Update last timestamp
    lastTimestamp = data.timestamp || Date.now();

    // Update connection status
    setOnlineStatus();

    // Update sensor cards
    updateSensorCards(data);

    // Update chart
    addDataPoint(data.temp, data.humidity, lastTimestamp);

    // Update last updated time
    updateLastUpdated();
}

/**
 * Update sensor display cards
 * @param {Object} data - Sensor data
 */
function updateSensorCards(data) {
    // Temperature
    const temp = parseFloat(data.temp).toFixed(1);
    elements.tempValue.textContent = temp;
    elements.tempValue.className = 'card-value ' + getTemperatureClass(data.temp);

    // Humidity
    const humidity = parseFloat(data.humidity).toFixed(1);
    elements.humidityValue.textContent = humidity;
    elements.humidityValue.className = 'card-value ' + getHumidityClass(data.humidity);

    // Distance
    const distance = parseFloat(data.distance).toFixed(1);
    elements.distanceValue.textContent = distance;

    // Bottle status
    const bottlePresent = data.bottle_present || data.distance < BOTTLE_DETECTION_DISTANCE;
    elements.bottleValue.textContent = bottlePresent ? 'Present' : 'Absent';
    elements.bottleIcon.textContent = bottlePresent ? '🍶' : '❌';
    
    const bottleCard = elements.bottleValue.closest('.card');
    bottleCard.classList.toggle('present', bottlePresent);
    bottleCard.classList.toggle('absent', !bottlePresent);
}

/**
 * Get temperature CSS class based on value
 * @param {number} temp - Temperature value
 * @returns {string} CSS class name
 */
function getTemperatureClass(temp) {
    if (temp >= 35) return 'hot';
    if (temp >= 30) return 'warm';
    if (temp >= 20) return 'normal';
    return 'cool';
}

/**
 * Get humidity CSS class based on value
 * @param {number} humidity - Humidity value
 * @returns {string} CSS class name
 */
function getHumidityClass(humidity) {
    if (humidity >= 70) return 'high';
    if (humidity >= 40) return 'normal';
    return 'low';
}

/**
 * Update last updated timestamp
 */
function updateLastUpdated() {
    if (!lastTimestamp) {
        elements.lastUpdated.textContent = 'Never';
        return;
    }

    const updateTime = () => {
        const now = Date.now();
        const diff = now - lastTimestamp;
        
        if (diff < 5000) {
            elements.lastUpdated.textContent = 'Just now';
        } else if (diff < 60000) {
            const seconds = Math.floor(diff / 1000);
            elements.lastUpdated.textContent = `${seconds} seconds ago`;
        } else if (diff < 3600000) {
            const minutes = Math.floor(diff / 60000);
            elements.lastUpdated.textContent = `${minutes} minute${minutes > 1 ? 's' : ''} ago`;
        } else {
            const date = new Date(lastTimestamp);
            elements.lastUpdated.textContent = date.toLocaleTimeString('id-ID');
        }
    };

    updateTime();
}

/**
 * Set online status indicator
 */
function setOnlineStatus() {
    const statusDot = elements.connectionStatus.querySelector('.status-dot');
    const statusText = elements.connectionStatus.querySelector('.status-text');
    
    statusDot.classList.add('online');
    statusDot.classList.remove('offline');
    statusText.textContent = 'Online';
}

/**
 * Set offline status indicator
 */
function setOfflineStatus() {
    const statusDot = elements.connectionStatus.querySelector('.status-dot');
    const statusText = elements.connectionStatus.querySelector('.status-text');
    
    statusDot.classList.add('offline');
    statusDot.classList.remove('online');
    statusText.textContent = 'Offline';
}

/**
 * Start checking online status periodically
 */
function startOnlineChecker() {
    onlineCheckInterval = setInterval(() => {
        if (!lastTimestamp) return;

        const now = Date.now();
        const diff = now - lastTimestamp;

        if (diff > OFFLINE_THRESHOLD) {
            setOfflineStatus();
        }

        updateLastUpdated();
    }, 5000);
}

/**
 * Initialize theme from localStorage
 */
function initTheme() {
    const savedTheme = localStorage.getItem('theme') || 'light';
    document.documentElement.setAttribute('data-theme', savedTheme);
    updateThemeButton(savedTheme);
}

/**
 * Toggle between light and dark theme
 */
function toggleTheme() {
    const currentTheme = document.documentElement.getAttribute('data-theme');
    const newTheme = currentTheme === 'dark' ? 'light' : 'dark';
    
    document.documentElement.setAttribute('data-theme', newTheme);
    localStorage.setItem('theme', newTheme);
    
    updateThemeButton(newTheme);
    updateChartTheme(newTheme === 'dark');
}

/**
 * Update theme toggle button icon
 * @param {string} theme - Current theme name
 */
function updateThemeButton(theme) {
    elements.themeToggle.textContent = theme === 'dark' ? '☀️' : '🌙';
}

/**
 * Setup event listeners
 */
function setupEventListeners() {
    // Theme toggle
    elements.themeToggle.addEventListener('click', toggleTheme);
    
    // Keyboard shortcut for theme (T key)
    document.addEventListener('keydown', (e) => {
        if (e.key === 't' || e.key === 'T') {
            if (e.target.tagName !== 'INPUT' && e.target.tagName !== 'TEXTAREA') {
                toggleTheme();
            }
        }
    });
    
    // Cleanup on page unload
    window.addEventListener('beforeunload', () => {
        stopListening();
        if (onlineCheckInterval) {
            clearInterval(onlineCheckInterval);
        }
    });
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', init);
