import 'package:dlt_app/utils/app_libraries.dart';

class Heading extends StatelessWidget {
  const Heading(String this.text,
      {this.textAlign,
      this.fontStyle,
      this.fontSize = 30,
      this.padding = const EdgeInsets.only(bottom: 10),
      this.color = Colors.white,
      super.key});

  final String? text;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final Color color;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text!,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontStyle: fontStyle ?? FontStyle.normal,
          letterSpacing: 0.5,
        ),
        textAlign: textAlign ?? TextAlign.left,
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body(String this.text,
      {this.textAlign,
      this.fontStyle,
      this.fontSize = 20,
      this.padding = const EdgeInsets.only(bottom: 10),
      this.color = Colors.white,
      super.key});

  final String? text;
  final TextAlign? textAlign;
  final FontStyle? fontStyle;
  final Color color;
  final double fontSize;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Text(
        text!,
        style: TextStyle(
            fontFamily: 'Raleway',
            color: color,
            fontSize: fontSize,
            fontStyle: fontStyle ?? FontStyle.normal,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w200),
        textAlign: textAlign ?? TextAlign.left,
      ),
    );
  }
}
