import 'package:dlt_app/utils/app_libraries.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final String? labelText;
  final String? type;
  final FormFieldValidator<String>? validator;

  const Input({
    super.key,
    this.hintText = '',
    this.labelText = '',
    required this.controller,
    this.type = "text",
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    bool password = false;
    var keyboardType = TextInputType.text;
    var inputFormatters;
    if (type == "password") {
      password = true;
    }
    if (type == "number") {
      keyboardType = TextInputType.number;
      inputFormatters = <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10)
      ];
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        style: const TextStyle(
          color: Colors.white,
          fontFamily: 'Raleway',
          height: 0,
        ),
        obscureText: password,
        enableSuggestions: !password,
        autocorrect: !password,
        textCapitalization: TextCapitalization.none,
        validator: (value) {
          if (validator != null) return validator!(value);
        },
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        controller: controller,
        decoration: InputDecoration(
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.white.withOpacity(0.4),
            hintText: hintText!,
            hintStyle: const TextStyle(
              fontStyle: FontStyle.italic,
              color: Colors.white,
              fontFamily: 'Raleway',
              height: 0,
            ),
            errorStyle: const TextStyle(
              color: ThemeColors.secondary,
              fontFamily: 'Raleway',
              fontSize: 15,
              letterSpacing: 1,
              fontStyle: FontStyle.italic,
            )),
      ),
    );
  }
}

class TextArea extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final minLines;
  final maxLines;

  const TextArea({
    super.key,
    required String this.hintText,
    required this.controller,
    this.validator,
    this.minLines = 5,
    this.maxLines = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        style: const TextStyle(color: Colors.white, fontFamily: 'Raleway'),
        validator: (value) {
          if (validator != null) return validator!(value);
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        minLines: minLines,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.white.withOpacity(0.4),
          hintText: hintText!,
          hintStyle: const TextStyle(
            fontStyle: FontStyle.italic,
            color: Colors.white,
            fontFamily: 'Raleway',
            height: 0,
          ),
        ),
      ),
    );
  }
}
