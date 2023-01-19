import 'utils/app_libraries.dart';

const List<String> subject = [
  'I have a question',
  'Schedule an interview',
  'Request Information',
  'Enroll me',
  'Sign up for Game Changer Program'
];

Future<void> saveComment(BuildContext context, String userId, String subject, String comment) async {
  final newChat = Chats(
      timestamp: TemporalTimestamp(DateTime.now()),
      user_id: userId,
      message: "Subject: $subject\n$comment",
      read: false);
  addNewChat(roomName: "Contact Us", chat: newChat);
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => AnimatedSplashScreen(
        duration: 1500,
        splash: const Heading('Message Submitted!'),
        nextScreen: ContactUsPage(),
        splashTransition: SplashTransition.fadeTransition,
        pageTransitionType: PageTransitionType.rightToLeft,
        backgroundColor: ThemeColors.primary,
      ),
    ),
  );
}

class ContactUsPage extends StatelessWidget {
  final subjectDropdown = CustomDropdownButton(list: subject);
  final commentController = TextEditingController();

  ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    safePrint(context.read<AuthService>().attributes);
    return PageWrap(
      backgroundColor: ThemeColors.grey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Logo(),
          Center(
            child: Column(
              children: [
                const Heading(
                  "Contact Us",
                  fontSize: 50,
                ),
                GestureDetector(
                  onTap: () {
                    Uri url = Uri.parse("tel://7138079902");
                    launchUrl(url);
                  },
                  child: const Heading(
                    "Phone: (713) 807-9902",
                    fontSize: 26,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Uri url = Uri.parse("https://discoverleadership.com");
                    launchUrl(url);
                  },
                  child: const Heading(
                    "Email: info@discoverleadership.com",
                    fontSize: 26,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              subjectDropdown,
              TextArea(
                  hintText: 'Comment/Question', controller: commentController),
              TextButton(
                onPressed: () {
                  String userId = context
                      .read<AuthService>()
                      .attributes['user_id']
                      .toString();
                  saveComment(context, userId, subjectDropdown.dropdownValue,
                      commentController.text);
                },
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(ThemeColors.primary),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0)))),
                child: const Text(
                  'Send Comment/Question',
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ],
      ),
    );
  }
}
