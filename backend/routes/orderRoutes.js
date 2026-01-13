const express = require("express");
const {
  placeOrder,
  getOrderHistory,
} = require("../controllers/orderController");

const authMiddleware = require("../middleware/authMiddleware");

const router = express.Router();

router.post("/", authMiddleware, placeOrder);
router.get("/history", authMiddleware, getOrderHistory);

module.exports = router;
