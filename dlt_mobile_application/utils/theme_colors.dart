import 'package:dlt_app/utils/app_libraries.dart';

class ThemeColors {
  ThemeColors._();

  static const Color primary = Color(0xFF7ac142);
  static const Color secondary = Color(0xFFFFE900);
  static const Color grey = Color(0xFF757575);

  static const LinearGradient gradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[
          ThemeColors.primary,
          ThemeColors.secondary,
        ]);
}
