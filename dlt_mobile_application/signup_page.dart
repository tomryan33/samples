import 'package:dlt_app/utils/app_libraries.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<StatefulWidget> createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  String _pageTitle = "Create Account";
  bool _isLoggedIn = false;
  bool isSignUpComplete = false;
  bool isConfirmComplete = false;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final verificationCodeController = TextEditingController();
  ImagePicker picker = ImagePicker();
  XFile? _image;
  final _formKey = GlobalKey<FormState>();
  String _imageButtonText = 'Add Profile Image';

  Future<void> signUpUser() async {
    if (!_isLoggedIn) {
      if (_formKey.currentState != null && _formKey.currentState!.validate()) {
        try {
          emailController.text = emailController.text.toLowerCase();
          final result = await Amplify.Auth.signUp(
            username: emailController.text,
            password: passwordController.text,
          );

          List<Phone> phone = [];
          if (phoneController.text != "") {
            phone = [
              Phone(
                type: "Personal",
                number: phoneController.text,
              )
            ];
          }

          List<Meta> metaData = [];
          if(_image != null){
            metaData = [Meta(key: 'imageHold', value: _image!.path)];
          }

          final userInfo = Users(
            email: emailController.text,
            user_detail: UserDetails(
                first_name: firstNameController.text,
                last_name: lastNameController.text,
                phone: phone),
            user_meta: UserMeta(
                account_type: 1,
                meta_data: metaData,
            ),
          );
          await Amplify.DataStore.save(userInfo);

          setState(() {
            //isSignUpComplete = result.isSignUpComplete;
            isSignUpComplete = true;
          });
        } on AuthException catch (e) {
          safePrint(e.message);
        }
      }
    } else {
      safePrint("logged in");
    }
  }

  Future<void> confirmUser() async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
          username: emailController.text,
          confirmationCode: verificationCodeController.text);

      setState(() {
        //isConfirmComplete = result.isSignUpComplete;
        isConfirmComplete = true;
      });
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> checkLoggedIn(BuildContext context) async {
    if (!_isLoggedIn) {
      if (await context.read<AuthService>().isLoggedIn()) {
        setState(() {
          _isLoggedIn = true;
          _pageTitle = "Edit Profile";
          var user = context.read<AuthService>().attributes;
          firstNameController.text = user["first_name"] ?? "";
          lastNameController.text = user["last_name"] ?? "";
          emailController.text = user["email"] ?? "";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkLoggedIn(context);
    if (isConfirmComplete) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ThoughtOfTheDayPage()));
    }

    CircleAvatar image = const CircleAvatar(
      radius: 54,
      backgroundImage: AssetImage('assets/images/avatar.png'),
    );
    if (_image != null) {
      image = CircleAvatar(
        radius: 54,
        backgroundImage: FileImage(File(_image!.path)),
      );
    }

    if (!isSignUpComplete) {
      return PageWrap(
        hideNav: true,
        hideMessageIcon: true,
        hideAppBar: false,
        title: _pageTitle,
        padding: EdgeInsets.only(top: 15, right: 15, bottom: 100, left: 15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: CircleAvatar(
                        radius: 60,
                        backgroundColor: ThemeColors.primary,
                        child: image,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        XFile? image =
                            await picker.pickImage(source: ImageSource.gallery);
                        setState(() {
                          _image = image;
                          _imageButtonText = _image != null
                              ? 'Change Profile Image'
                              : 'Add Profile Image';
                        });
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Colors.white),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          _imageButtonText,
                          style: const TextStyle(
                              color: ThemeColors.grey, fontFamily: 'Raleway'),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Input(
                  hintText: "First Name*",
                  controller: firstNameController,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter your first name.";
                    }
                    return null;
                  },
                ),
                Input(
                  hintText: "Last Name*",
                  controller: lastNameController,
                  validator: (value) {
                    if (value != null && value.isEmpty) {
                      return "Please enter your last name";
                    }
                    return null;
                  },
                ),
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
                Input(
                  hintText: "Phone Number",
                  controller: phoneController,
                  type: "number",
                  validator: (value) {
                    // Check to see if not empty
                    if (value != null &&
                        value.isNotEmpty &&
                        value.length < 10) {
                      return "Phone number must be 10 digits.";
                    }
                    return null;
                  },
                ),
                Input(
                  hintText: "Password*",
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
                  hintText: "Confirm Password*",
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
                    signUpUser();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(ThemeColors.primary),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)))),
                  child: const Text(
                    'Next',
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
              Input(
                  hintText: "Verification Code",
                  controller: verificationCodeController),
              TextButton(
                onPressed: () {
                  confirmUser();
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ThemeColors.primary),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)))),
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ));
    }
  }
}
