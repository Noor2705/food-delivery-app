const express = require("express");
const router = express.Router();
const Restaurant = require("../models/Restaurant");
const Menu = require("../models/Menu");

// GET ALL RESTAURANTS
router.get("/", async (req, res) => {
  const restaurants = await Restaurant.find();
  res.json({ success: true, restaurants });
});

// GET MENUS BY RESTAURANT
router.get("/:id/menus", async (req, res) => {
  const menus = await Menu.find({ restaurantId: req.params.id });
  res.json({ success: true, menus });
});

// GET ALL MENU ITEMS (FOR CUSTOMER BROWSE)
router.get("/menus/all", async (req, res) => {
  try {
    const menus = await Menu.find().populate("restaurantId", "name");

    res.status(200).json({
      success: true,
      menus,
    });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

module.exports = router;
