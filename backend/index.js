const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors");

// Routes
const authRoutes = require("./routes/authRoutes");
const orderRoutes = require("./routes/orderRoutes");
const restaurantRoutes = require("./routes/restaurantRoutes");

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

// Health check
app.get("/", (req, res) => {
  res.json({
    success: true,
    message: "Food Delivery Backend API is running",
    time: new Date(),
  });
});

// Auth routes
app.use("/auth", authRoutes);

// Order routes
app.use("/orders", orderRoutes);

// Restaurant routes
app.use("/restaurants", restaurantRoutes);

/* =======================
   SERVER
======================= */
const PORT = 5000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
