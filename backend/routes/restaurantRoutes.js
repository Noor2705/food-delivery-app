const express = require("express");
const {
  getRestaurants,
  addRestaurant,
  addMenuItem,
  getMenuByRestaurant,
} = require("../controllers/restaurantController");

const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");

const router = express.Router();

// PUBLIC
router.get("/", getRestaurants);
router.get("/:restaurantId/menu", getMenuByRestaurant);

// ADMIN
router.post("/", authMiddleware, roleMiddleware("admin"), addRestaurant);
router.post("/menu", authMiddleware, roleMiddleware("admin"), addMenuItem);

module.exports = router;
