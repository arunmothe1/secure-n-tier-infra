const express = require('express');
const path = require('path');
const app = express();

// ... Your API Routes go here ...
// app.use('/api', apiRoutes);

// 1. Serve React static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

// 2. Catch-All Route for React Router (serves index.html for non-API routes)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));