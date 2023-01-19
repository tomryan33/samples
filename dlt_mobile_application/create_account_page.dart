import 'utils/app_libraries.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: ThemeColors.grey,
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              top: 100, right: 25, bottom: 75, left: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Logo(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Heading("Have you attended a Discover Leadership Training course?", textAlign: TextAlign.center,),
                  BasicButton("Yes"),
                  BasicButton("No"),
                ],
              ),
              Body("< Back To Login Page", textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}
