// Chart Manager Module
// Handles temperature and humidity trend charts

let trendChart = null;
const MAX_DATA_POINTS = 720; // 1 hour of data at 5-second intervals
const chartData = {
    labels: [],
    temperature: [],
    humidity: []
};

/**
 * Initialize the trend chart
 * @param {HTMLCanvasElement} canvas - The canvas element for the chart
 */
export function initializeChart(canvas) {
    const ctx = canvas.getContext('2d');
    
    // Get CSS variables for theming
    const isDark = document.documentElement.getAttribute('data-theme') === 'dark';
    const textColor = isDark ? '#e2e8f0' : '#4a5568';
    const gridColor = isDark ? '#4a5568' : '#e2e8f0';

    trendChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: chartData.labels,
            datasets: [
                {
                    label: 'Temperature (°C)',
                    data: chartData.temperature,
                    borderColor: '#f56565',
                    backgroundColor: 'rgba(245, 101, 101, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 0,
                    pointHoverRadius: 4
                },
                {
                    label: 'Humidity (%)',
                    data: chartData.humidity,
                    borderColor: '#4299e1',
                    backgroundColor: 'rgba(66, 153, 225, 0.1)',
                    borderWidth: 2,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 0,
                    pointHoverRadius: 4
                }
            ]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: {
                mode: 'index',
                intersect: false
            },
            plugins: {
                legend: {
                    position: 'top',
                    labels: {
                        color: textColor,
                        usePointStyle: true,
                        padding: 20
                    }
                },
                tooltip: {
                    backgroundColor: isDark ? '#2d3748' : '#ffffff',
                    titleColor: isDark ? '#f7fafc' : '#1a202c',
                    bodyColor: isDark ? '#e2e8f0' : '#4a5568',
                    borderColor: gridColor,
                    borderWidth: 1,
                    padding: 12,
                    displayColors: true,
                    callbacks: {
                        label: function(context) {
                            const label = context.dataset.label || '';
                            const value = context.parsed.y;
                            if (label.includes('Temperature')) {
                                return `${label}: ${value.toFixed(1)}°C`;
                            }
                            return `${label}: ${value.toFixed(1)}%`;
                        }
                    }
                }
            },
            scales: {
                x: {
                    display: true,
                    grid: {
                        color: gridColor,
                        drawBorder: false
                    },
                    ticks: {
                        color: textColor,
                        maxTicksLimit: 6,
                        maxRotation: 0
                    }
                },
                y: {
                    display: true,
                    grid: {
                        color: gridColor,
                        drawBorder: false
                    },
                    ticks: {
                        color: textColor
                    },
                    beginAtZero: false
                }
            }
        }
    });

    return trendChart;
}

/**
 * Add new data point to the chart
 * @param {number} temperature - Temperature value
 * @param {number} humidity - Humidity value
 * @param {number} timestamp - Data timestamp
 */
export function addDataPoint(temperature, humidity, timestamp) {
    const time = new Date(timestamp);
    const timeLabel = time.toLocaleTimeString('id-ID', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false
    });

    chartData.labels.push(timeLabel);
    chartData.temperature.push(temperature);
    chartData.humidity.push(humidity);

    // Keep only last hour of data
    if (chartData.labels.length > MAX_DATA_POINTS) {
        chartData.labels.shift();
        chartData.temperature.shift();
        chartData.humidity.shift();
    }

    if (trendChart) {
        trendChart.update('none'); // 'none' for no animation on frequent updates
    }
}

/**
 * Update chart theme colors
 * @param {boolean} isDark - Whether dark theme is active
 */
export function updateChartTheme(isDark) {
    if (!trendChart) return;

    const textColor = isDark ? '#e2e8f0' : '#4a5568';
    const gridColor = isDark ? '#4a5568' : '#e2e8f0';

    trendChart.options.plugins.legend.labels.color = textColor;
    trendChart.options.plugins.tooltip.backgroundColor = isDark ? '#2d3748' : '#ffffff';
    trendChart.options.plugins.tooltip.titleColor = isDark ? '#f7fafc' : '#1a202c';
    trendChart.options.plugins.tooltip.bodyColor = isDark ? '#e2e8f0' : '#4a5568';
    trendChart.options.plugins.tooltip.borderColor = gridColor;
    trendChart.options.scales.x.grid.color = gridColor;
    trendChart.options.scales.x.ticks.color = textColor;
    trendChart.options.scales.y.grid.color = gridColor;
    trendChart.options.scales.y.ticks.color = textColor;

    trendChart.update();
}

/**
 * Clear all chart data
 */
export function clearChart() {
    chartData.labels = [];
    chartData.temperature = [];
    chartData.humidity = [];
    
    if (trendChart) {
        trendChart.update();
    }
}

/**
 * Get current chart data
 * @returns {Object} Chart data object
 */
export function getChartData() {
    return { ...chartData };
}
