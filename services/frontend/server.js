const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;
const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:5000';

app.get('/', async (req, res) => {
    try {
        const response = await fetch(`${BACKEND_URL}/api/products`);
        const products = await response.json();
        res.send(`
            <h1>Cloud Native DevOps Platform - Store</h1>
            <ul>
                ${products.map(p => `<li><strong>${p.name}</strong> - $${p.price}</li>`).join('')}
            </ul>
        `);
    } catch (error) {
        res.status(500).send(`<h1>Error connecting to backend: ${error.message}</h1>`);
    }
});

app.listen(PORT, () => console.log(`Frontend running on port ${PORT}`));
