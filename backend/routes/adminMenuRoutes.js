const express = require("express");
const router = express.Router();

const authMiddleware = require("../middleware/authMiddleware");
const roleMiddleware = require("../middleware/roleMiddleware");
const Menu = require("../models/Menu");

/* =========================
   ADD MENU ITEM (ADMIN)
   POST /admin/menus
========================= */
router.post(
  "/menus",
  authMiddleware,
  roleMiddleware("admin"),
  async (req, res) => {
    try {
      const { restaurantId, itemName, price } = req.body;

      if (!restaurantId || !itemName || !price) {
        return res.status(400).json({
          success: false,
          message: "All fields are required",
        });
      }

      const menu = await Menu.create({
        restaurantId,
        itemName,
        price,
      });

      res.status(201).json({
        success: true,
        message: "Menu item added successfully",
        menu,
      });
    } catch (error) {
      console.error("ADD MENU ERROR:", error);
      res.status(500).json({
        success: false,
        message: error.message,
      });
    }
  }
);

/* =========================
   DELETE MENU ITEM (ADMIN)
   DELETE /admin/menus/:id
========================= */
router.delete(
  "/menus/:id",
  authMiddleware,
  roleMiddleware("admin"),
  async (req, res) => {
    try {
      const menuId = req.params.id;

      const deletedMenu = await Menu.findByIdAndDelete(menuId);

      if (!deletedMenu) {
        return res.status(404).json({
          success: false,
          message: "Menu item not found",
        });
      }

      res.status(200).json({
        success: true,
        message: "Menu item deleted successfully",
      });
    } catch (error) {
      console.error("DELETE MENU ERROR:", error);
      res.status(500).json({
        success: false,
        message: error.message,
      });
    }
  }
);

module.exports = router;
