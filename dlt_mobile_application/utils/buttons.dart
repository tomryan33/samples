import 'package:dlt_app/utils/app_libraries.dart';

class BasicButton extends StatelessWidget{
  BasicButton(String text, {super.key}){
    text_ = text;
  }

  String text_ = "";

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (){},
      style: ButtonStyle(
        backgroundColor:
        MaterialStateProperty.all(ThemeColors.primary),
      ),
      child: Text(
        text_,
        style: const TextStyle(
          color: Colors.white,
          fontStyle: FontStyle.italic,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

}