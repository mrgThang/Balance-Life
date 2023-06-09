import 'package:flutter/material.dart';

class APP_COLORS {
  static const int GREEN = 0xff91C788;
  static const int GRAY = 0xff999999;
  static const int PINK = 0xffff8473;
  static const int LIGHT_PINK = 0xfffff8ee;
  static const int GREEN_BUTTON = 0xff91C788;
  static const int RED_BUTTON = 0xffff8473;

  static const int BLUE_PROGRESS_BAR = 0xff1890ff;
  static const int GREEN_PROGRESS_BAR = 0xff52c41a;
  static const int RED_PROGRESS_BAR = 0xfff5222d;
  static const int BLUE_NUTRIENTS_NAME = 0xff5db1ff;

  static const int SEARCH_BAR_THEME = 0xfff4f4f4;
  static const int SEARCH_BAR_TEXT = 0xff999999;

  static const int GREEN_BOTTOM_BAR = 0xffeff7ee;

  static const int PROTEIN_PIE_CHART = 0xff009299;
  static const int FAT_PIE_CHART = 0xff7ed957;
  static const int CARBS_PIE_CHART = 0xff00b980;

}

class CustomColorScheme {
  Color icon = Colors.grey.shade400;
  Color primary = const Color(0xFF91C789);
  Color message_unseen = Colors.black;
  Color message_seen = Colors.black54;
  Color text_normal = Colors.black54;
  Color text_message = Colors.black87;
  Color chat_header = Colors.black;
  Color message_card_border = Color.fromARGB(255, 224, 255, 194);
  Color message_card = Colors.lightGreen;
  Color oppose_message_card_border = Color.fromARGB(255, 245, 245, 245);
  Color oppose_message_card = Colors.black26;
}

CustomColorScheme mColorScheme = CustomColorScheme();

const INGREDIENTS_DATA = [
  "apples",
  "apricot",
  "apricot dried",
  "avocado",
  "baked potatoes",
  "bananas",
  "basil",
  "beans",
  "beef",
  "beef liver",
  "beer",
  "beets",
  "blackberries",
  "blueberries",
  "broccoli",
  "butter",
  "cabbage",
  "carrot",
  "chicken",
  "chicken liver",
  "cinnamon",
  "coconut",
  "coconut water",
  "cod",
  "cod liver oil",
  "corn",
  "cow milk",
  "cucumber",
  "egg",
  "garlic",
  "ginger",
  "goat cheese",
  "grape",
  "grapefruit",
  "green beans",
  "green tea",
  "honey",
  "kiwi",
  "leek",
  "lemon",
  "lettuce",
  "mango",
  "melon",
  "mozzarella",
  "nectarines",
  "olive oil",
  "onion",
  "orange",
  "parsley",
  "parsley dried",
  "parsley freeze-dried",
  "pea",
  "peach",
  "peanut butter",
  "pear",
  "pepper",
  "pineapple",
  "pork",
  "potatoes",
  "quinoa",
  "raspberries",
  "rice brown",
  "salmon",
  "salt",
  "spinach",
  "squid",
  "strawberries",
  "sweet potato",
  "thyme",
  "tomatoes",
  "tuna",
  "watermelon",
  "wheat bread",
  "wine red",
  "yogurt",
];

const VITAMIN_NAMES = [
  'Vitamin A',
  'Vitamin B1',
  'Vitamin B2',
  'Vitamin B3',
  'Vitamin B5',
  'Vitamin B6',
  'Vitamin B7',
  'Vitamin B9',
  'Vitamin B12',
  'Vitamin C',
  'Vitamin E',
  'Vitamin K',
  'Choline',
];

const MINERAL_NAMES = [
  'Calcium',
  'Chloride',
  'Chromium',
  'Copper',
  'Iodine',
  'Iron',
  'Magnesium',
  'Manganese',
  'Molybdenum',
  'Phosphorus',
  'Potassium',
  'Selenium',
  'Sodium',
  'Zinc',
];

const AMINO_ACIDS_NAMES = [
  'Isoleucine',
  'Histidine',
  'Leucine',
  'Lysine',
  'Methionine',
  'Phenylalanine',
  'Tryptophan',
  'Threonine',
  'Valine',
];

const FATTY_ACIDS_NAMES = [
  'α-Linolenic acid',
  'Linoleic acid'
];
