const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

// Routes
const authRoutes = require("./routes/authRoutes");
const restaurantRoutes = require("./routes/restaurantRoutes");
const orderRoutes = require("./routes/orderRoutes");
const paymentRoutes = require("./routes/paymentRoutes");
const adminMenuRoutes = require("./routes/adminMenuRoutes");
const adminOrderRoutes = require("./routes/adminOrderRoutes");

const app = express();

/* =======================
   MIDDLEWARE
======================= */
app.use(cors());
app.use(express.json());

/* =======================
   DATABASE CONNECTION
======================= */
mongoose
  .connect("mongodb://127.0.0.1:27017/food_delivery_db")
  .then(() => console.log("MongoDB connected successfully"))
  .catch((err) => {
    console.error("MongoDB connection error:", err);
    process.exit(1);
  });

/* =======================
   ROUTES
======================= */
app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "Food Delivery Backend API is running",
    time: new Date(),
  });
});

// Public / customer routes
app.use("/auth", authRoutes);
app.use("/restaurants", restaurantRoutes);

// Customer protected
app.use("/orders", orderRoutes);
app.use("/payments", paymentRoutes);

// Admin routes (ONLY THESE)
app.use("/admin", adminMenuRoutes);
app.use("/admin", adminOrderRoutes);

/* =======================
   SERVER
======================= */
const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
