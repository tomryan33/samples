import 'package:dlt_app/utils/app_libraries.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ResetPasswordPage();
}

class _ResetPasswordPage extends State<ResetPasswordPage> {
  bool isPasswordReset = false;
  bool isConfirmComplete = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final verificationCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> resetPassword() async {
    try {
      final result = await Amplify.Auth.resetPassword(
        username: emailController.text,
      );
      setState(() {
        isPasswordReset = true;
      });
    } on AmplifyException catch (e) {
      safePrint(e);
    }
  }

  Future<void> confirmResetPassword() async {
    try {
      await Amplify.Auth.confirmResetPassword(
          username: emailController.text,
          newPassword: passwordController.text,
          confirmationCode: verificationCodeController.text
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    } on AmplifyException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if(isConfirmComplete){
      Navigator.pushReplacementNamed(context, '/totd');
    }
    if(!isPasswordReset) {
      return PageWrap(
        hideNav: true,
        hideMessageIcon: true,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Heading("Reset Password"),
                Input(
                  hintText: "Email*",
                  controller: emailController,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter your email";
                    }

                    RegExp emailCheck = RegExp(
                        r'^(([^<>()[\]\.,;:\s@\"]+(\.[^<>()[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$');
                    if (!emailCheck.hasMatch(value!)) {
                      return "Please enter a valid email address.";
                    }

                    return null;
                  },
                ),
                TextButton(
                  onPressed: () async {
                    await resetPassword();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all(ThemeColors.primary),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)))),
                  child: const Text(
                    'Send Code',
                    style: TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return PageWrap(
          hideMessageIcon: true,
          hideNav: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Heading("Check your email for a verification code"),
              Input(hintText: "Verification Code", controller: verificationCodeController),
              Input(
                hintText: "New Password*",
                type: 'password',
                controller: passwordController,
                validator: (value) {
                  // Check to see if not empty
                  if (value != null && value.isEmpty) {
                    return "Please enter a password";
                  }

                  // Check to see if password is more than 8 characters
                  if (value!.length < 8) {
                    return "Password must be 8 or more characters.";
                  }

                  // Check to see if password contains a special character
                  RegExp specialChar = RegExp(r"[#&^*%@$!]");
                  if (!specialChar.hasMatch(value)) {
                    return "Password must include at least one special character (#&^*%@\$!).";
                  }

                  // Check to see if password contains an uppercase character
                  RegExp uppercaseChar = RegExp(r"[A-Z]");
                  if (!uppercaseChar.hasMatch(value)) {
                    return "Password must contain an uppercase letter (A-Z).";
                  }

                  // Check to see if password contains a lowercase character
                  RegExp lowercaseChar = RegExp(r"[a-z]");
                  if (!lowercaseChar.hasMatch(value)) {
                    return "Password must contain a lowercase letter (a-z).";
                  }

                  // Check to see if password contains a number
                  RegExp numberChar = RegExp(r"[0-9]");
                  if (!numberChar.hasMatch(value)) {
                    return "Password must contain a number (0-9)";
                  }

                  return null;
                },
              ),
              Input(
                hintText: "Confirm New Password*",
                type: 'password',
                controller: confirmPasswordController,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return "Please confirm your password";
                  }

                  if (value != passwordController.text) {
                    return "Passwords do not match.";
                  }

                  return null;
                },
              ),
              TextButton(
                onPressed: () {
                  confirmResetPassword();
                },
                style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all(ThemeColors.primary),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)))),
                child: const Text(
                  'Reset Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          )
      );
    }
  }
}
