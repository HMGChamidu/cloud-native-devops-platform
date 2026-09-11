const express = require('express');
const app = express();
const PORT = process.env.PORT || 5000;

app.use(express.json());

app.get('/health', (req, res) => {
    res.status(200).json({ status: 'UP', message: 'Backend service is healthy' });
});

app.get('/api/products', (req, res) => {
    res.json([
        { id: 1, name: 'Cloud Server Node', price: 29.99 },
        { id: 2, name: 'Kubernetes Cluster Pod', price: 49.99 },
        { id: 3, name: 'DevSecOps Pipeline License', price: 99.99 }
    ]);
});

app.listen(PORT, () => {
    console.log(`Backend service running on port ${PORT}`);
});
