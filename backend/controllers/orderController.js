const Order = require("../models/Order");

/**
 * PLACE ORDER (Customer)
 * POST /orders
 * JWT required
 */
exports.placeOrder = async (req, res) => {
  try {
    // JWT middleware must attach user
    if (!req.user || !req.user.id) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized user",
      });
    }

    const { items, total } = req.body;

    // Basic validation
    if (!items || items.length === 0 || !total) {
      return res.status(400).json({
        success: false,
        message: "Items and total are required",
      });
    }

    const order = await Order.create({
      userId: req.user.id,
      items,
      total,
      status: "PLACED",
    });

    return res.status(201).json({
      success: true,
      message: "Order placed successfully",
      order,
    });
  } catch (error) {
    console.error("Place order error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to place order",
    });
  }
};

/**
 * ORDER HISTORY (Customer)
 * GET /orders/history
 * JWT required
 */
exports.getOrderHistory = async (req, res) => {
  try {
    if (!req.user || !req.user.id) {
      return res.status(401).json({
        success: false,
        message: "Unauthorized user",
      });
    }

    const orders = await Order.find({ userId: req.user.id }).sort({
      createdAt: -1,
    });

    return res.status(200).json({
      success: true,
      orders,
    });
  } catch (error) {
    console.error("Order history error:", error);
    return res.status(500).json({
      success: false,
      message: "Failed to fetch order history",
    });
  }
};
