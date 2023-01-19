import 'utils/app_libraries.dart';

class NominationPage extends StatelessWidget {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final relationshipController = TextEditingController();
  final messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  NominationPage({super.key});

  void submitNomination(BuildContext context) {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      Meta firstNameMeta = Meta(key: 'First Name', value: firstNameController.text);
      Meta lastNameMeta = Meta(key: 'Last Name', value: lastNameController.text);
      Meta emailMeta = Meta(key: 'Email', value: emailController.text);
      Meta phoneMeta = Meta(key: 'Phone', value: phoneController.text);
      Meta relationshipMeta = Meta(key: 'Relationship', value: relationshipController.text);
      final newChat = Chats(
          timestamp: TemporalTimestamp(DateTime.now()),
          user_id: context.read<AuthService>().attributes['user_id'] ?? '',
          message: messageController.text,
          meta_data: [firstNameMeta, lastNameMeta, emailMeta, phoneMeta, relationshipMeta],
          read: false);
      addNewChat(roomName: "Nominate Someone", chat: newChat);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AnimatedSplashScreen(
            duration: 1500,
            splash: const Heading('Nomination Submitted!'),
            nextScreen: NominationPage(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.rightToLeft,
            backgroundColor: ThemeColors.primary,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrap(
      backgroundColor: ThemeColors.grey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Logo(),
          Form(
            key: _formKey,
            child: Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Heading(
                    "Nominee Information",
                    fontSize: 50,
                  ),
                  Input(
                    hintText: 'Nominee\'s First Name*',
                    controller: firstNameController,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Please enter nominee's first name.";
                      }
                      return null;
                    },
                  ),
                  Input(
                    hintText: 'Nominee\'s Last Name*',
                    controller: lastNameController,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Please enter nominee's last name.";
                      }
                      return null;
                    },
                  ),
                  Input(
                    hintText: 'Nominee\'s Phone Number*',
                    type: 'number',
                    controller: phoneController,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Please enter nominee's phone.";
                      }
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 10) {
                        return "Phone number must be 10 digits.";
                      }
                      return null;
                    },
                  ),
                  Input(
                    hintText: 'Nominee\'s Email Address*',
                    controller: emailController,
                    validator: (value) {
                      if (value != null && value.isEmpty) {
                        return "Please enter nominees email";
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
                    hintText: 'Nominee\'s Relationship to You',
                    controller: relationshipController,
                  ),
                  TextArea(
                      hintText: 'Message to your nominee',
                      controller: messageController),
                  TextButton(
                    onPressed: () {
                      submitNomination(context);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(ThemeColors.primary),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0)))),
                    child: const Text(
                      'Submit Nomination',
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
        ],
      ),
    );
  }
}
