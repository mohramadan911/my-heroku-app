// File: app.js
const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

// Serve static files from the public directory
app.use(express.static(path.join(__dirname, 'public')));

// Routes
app.get('/api/hello', (req, res) => {
  res.json({ message: 'Hello from the API!' });
});

app.get('/api/time', (req, res) => {
  res.json({ time: new Date().toISOString() });
});

// Catch-all route to serve the main index.html for client-side routing
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Start server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});