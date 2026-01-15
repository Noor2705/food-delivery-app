const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");
const Order = require("../models/Order");

/**
 * ADMIN: GET ALL ORDERS
 * GET /admin/orders
 */
router.get(
  "/orders",
  authMiddleware,
  roleMiddleware("admin"),
  async (req, res) => {
    try {
      const orders = await Order.find().sort({ createdAt: -1 });

      res.status(200).json({
        success: true,
        orders,
      });
    } catch (error) {
      console.error("GET ADMIN ORDERS ERROR:", error);
      res.status(500).json({
        success: false,
        message: error.message,
      });
    }
  }
);

/**
 * ADMIN: UPDATE ORDER STATUS
 * PUT /admin/orders/:id/status
 */
router.put(
  "/orders/:id/status",
  authMiddleware,
  roleMiddleware("admin"),
  async (req, res) => {
    try {
      const { status } = req.body;

      const order = await Order.findByIdAndUpdate(
        req.params.id,
        { status },
        { new: true }
      );

      if (!order) {
        return res.status(404).json({
          message: "Order not found",
        });
      }

      res.status(200).json({
        success: true,
        message: "Order status updated",
        order,
      });
    } catch (error) {
      console.error("UPDATE ORDER STATUS ERROR:", error);
      res.status(500).json({
        success: false,
        message: error.message,
      });
    }
  }
);

module.exports = router;
