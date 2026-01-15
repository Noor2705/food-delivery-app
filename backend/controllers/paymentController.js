const Payment = require("../models/Payment");

// MOCK PAYMENT SAVE
exports.createPayment = async (req, res) => {
  try {
    const { orderId, transactionId } = req.body;

    if (!orderId || !transactionId) {
      return res.status(400).json({
        message: "orderId and transactionId required",
      });
    }

    const payment = await Payment.create({
      orderId,
      transactionId,
    });

    res.status(201).json({
      success: true,
      message: "Payment recorded successfully",
      payment,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
