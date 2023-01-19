import 'package:dlt_app/create_account_page.dart';

import 'utils/app_libraries.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  static final String year = DateTime.now().year.toString();
  final _formkey = GlobalKey<FormState>();

  Future<void> checkUser(BuildContext context) async {
    if(await context.read<AuthService>().isLoggedIn()){
      Navigator.pushReplacementNamed(context, '/totd');
    }
  }

  Future<bool> signInUser(BuildContext context) async {
    if (_formkey.currentState != null && _formkey.currentState!.validate()) {
      try {
        emailController.text = emailController.text.toLowerCase();
        final result = await Amplify.Auth.signIn(
          username: emailController.text,
          password: passwordController.text,
        );

        return result.isSignedIn;

      } on AuthException catch (e) {
        safePrint(e.message);
      }
    }
    return false;
  }

  Widget _header(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: const [
        SizedBox(
          height: 50,
        ),
        Heading(
          "WELCOME TO",
          fontStyle: FontStyle.italic,
          textAlign: TextAlign.center,
        ),
        Logo(),
      ],
    );
  }

  Widget _loginForm(context){
    return Form(
      key: _formkey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Input(
            hintText: "Email",
            validator: (value) {
              if (value != null && value.isEmpty) {
                return "Please enter your email.";
              }
              return null;
            },
            controller: emailController,
          ),
          Input(
            hintText: 'Password',
            type: 'password',
            validator: (value) {
              if (value != null && value.isEmpty) {
                return "Please enter your password.";
              }
              return null;
            },
            controller: passwordController,
          ),
          TextButton(
            onPressed: () async {
              if(await signInUser(context)){
                await buildDummyData();
                Navigator.pushReplacementNamed(context, '/totd');
              }
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ThemeColors.primary),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)
                )
              )
              
            ),
            child: const Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/reset');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                          const RoundedRectangleBorder(
                            side: BorderSide(
                              color: ThemeColors.primary,
                              width: 2,
                            )
                          ),
                      ),
                    ),
                    child: const Text(
                      'Forgot Password',
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                            side: BorderSide(
                              color: ThemeColors.primary,
                              width: 2,
                            )
                        ),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 25,
          ),
          Heading(
            "© Copyright $year All Rights Reserved.",
            fontSize: 15,
            textAlign: TextAlign.center,
            fontStyle: FontStyle.italic,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    checkUser(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/team-work.jpg"),
            fit: BoxFit.cover,
            opacity: 120,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _header(),
                  _loginForm(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
