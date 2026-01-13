import 'package:flutter/material.dart';

class NoteColors {
  // Predefined color palette for notes
  static const List<Color> palette = [
    Color(0xFFFFFFFF), // White (default)
    Color(0xFFFFF9C4), // Yellow (sticky note)
    Color(0xFFFFCCBC), // Peach
    Color(0xFFB2DFDB), // Cyan
    Color(0xFFC5CAE9), // Blue
    Color(0xFFF8BBD0), // Pink
    Color(0xFFD7CCC8), // Brown (kraft paper)
    Color(0xFFE0E0E0), // Gray
  ];

  static const List<String> colorNames = [
    'Default',
    'Yellow',
    'Peach',
    'Cyan',
    'Blue',
    'Pink',
    'Brown',
    'Gray',
  ];

  // Get color from index
  static Color getColor(int index) {
    if (index < 0 || index >= palette.length) {
      return palette[0]; // Default white
    }
    return palette[index];
  }

  // Get index from color
  static int getColorIndex(Color color) {
    final index = palette.indexOf(color);
    return index >= 0 ? index : 0;
  }

  // Get text color for contrast (black or white)
  static Color getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  // Get darker shade for borders/accents
  static Color getDarkerShade(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.1).clamp(0.0, 1.0)).toColor();
  }
}
