const express = require('express');
const router = express.Router();
const terraformController = require('../controllers/terraformController');

router.post('/deploy', terraformController.deploy);
router.get('/history', terraformController.getHistory);
router.post('/destroy', terraformController.destroy);

module.exports = router;

