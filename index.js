/**
 * NepsenX - Main Entry Point
 * 
 * This is the main entry point for the NepsenX project.
 * It sets up the Express server and initializes the application.
 */

const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
require('dotenv').config();

// Initialize Express app
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(helmet()); // Security headers
app.use(cors()); // Enable CORS
app.use(express.json()); // Parse JSON bodies
app.use(express.urlencoded({ extended: true })); // Parse URL-encoded bodies

// Static files
app.use(express.static('public'));

// Routes
app.get('/', (req, res) => {
  res.send('Welcome to NepsenX - Your Digital Solutions Partner');
});

// API routes
app.use('/api', require('./routes/api'));

// Error handling middleware
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

// Start server
app.listen(PORT, () => {
  console.log(`NepsenX server running on port ${PORT}`);
});

module.exports = app;
