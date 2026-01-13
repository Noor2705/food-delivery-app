const Restaurant = require("../models/Restaurant");
const Menu = require("../models/Menu");

// PUBLIC – GET RESTAURANTS
exports.getRestaurants = async (req, res) => {
  try {
    const restaurants = await Restaurant.find();
    res.status(200).json({
      success: true,
      restaurants,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// ADMIN – ADD RESTAURANT
exports.addRestaurant = async (req, res) => {
  try {
    const { name } = req.body;

    if (!name) {
      return res.status(400).json({ message: "Restaurant name is required" });
    }

    const restaurant = await Restaurant.create({ name });

    res.status(201).json({
      success: true,
      message: "Restaurant added successfully",
      restaurant,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// ADMIN – ADD MENU ITEM
exports.addMenuItem = async (req, res) => {
  try {
    const { restaurantId, itemName, price } = req.body;

    const menuItem = await Menu.create({
      restaurantId,
      itemName,
      price,
    });

    res.status(201).json({
      success: true,
      message: "Menu item added successfully",
      menuItem,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

// PUBLIC – GET MENU BY RESTAURANT
exports.getMenuByRestaurant = async (req, res) => {
  try {
    const { restaurantId } = req.params;
    const menu = await Menu.find({ restaurantId });

    res.status(200).json({
      success: true,
      menu,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};
