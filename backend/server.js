const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const terraformRoutes = require('./routes/terraformRoutes');

const app = express();
const PORT = process.env.PORT || 5000;

app.use(cors());
app.use(bodyParser.json());
app.use('/api/terraform', terraformRoutes);

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
