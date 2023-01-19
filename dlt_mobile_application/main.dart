import 'dart:async';

import 'package:dlt_app/nomination_page.dart';
import 'package:dlt_app/utils/app_libraries.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService.init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(ChangeNotifierProvider(
            create: (BuildContext context) => AuthService(),
            child: DiscoverApp(),
          )));
}

class DiscoverApp extends StatefulWidget {
  const DiscoverApp({Key? key}) : super(key: key);

  @override
  State<DiscoverApp> createState() => _DiscoverAppState();
}

class _DiscoverAppState extends State<DiscoverApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  Future<void> _configureAmplify() async {
    final auth = AmplifyAuthCognito();
    final datastorePlugin =
        AmplifyDataStore(modelProvider: ModelProvider.instance);
    final api = AmplifyAPI(modelProvider: ModelProvider.instance);
    final storage = AmplifyStorageS3();
    await Amplify.addPlugins([auth, storage, datastorePlugin, api]);
    try {
      await Amplify.configure(amplifyconfig);
    } on Exception catch (e) {
      safePrint('An error occurred configuring Amplify: $e');
    }

    try {
      List<Users> users = await Amplify.DataStore.query(Users.classType);
    } catch (e) {
      safePrint("Could not query DataStore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Discover Leadership Training",
      theme: ThemeData(
        primaryColor: ThemeColors.primary,
        fontFamily: 'BigNoodleTitling',
        backgroundColor: Colors.black,
      ),
      home: FutureBuilder<bool>(
          future: context.read<AuthService>().isLoggedIn(),
          builder: (context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData && snapshot.data!) {
                return ThoughtOfTheDayPage();
              } else {
                return AnimatedSplashScreen(
                  duration: 3000,
                  splash: const Image(
                    image: AssetImage("assets/logos/logo-solid-white.png"),
                  ),
                  nextScreen: LoginPage(),
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.rightToLeft,
                  backgroundColor: ThemeColors.primary,
                );
              }
            }
            return CircularProgressIndicator();
          }),
      routes: {
        '/signup': (context) => const SignUpPage(),
        '/reset': (context) => const ResetPasswordPage(),
        '/totd': (context) => ThoughtOfTheDayPage(),
        '/nav': (context) => const Nav(),
        '/rooms': (context) => const RoomsPage(),
        '/rooms/chat': (context) => const ChatPage(),
        '/classes': (context) => const ClassesPage(),
        '/contact': (context) => ContactUsPage(),
        '/profile': (context) => const ProfilePage(),
        '/team': (context) => const TeamMembersPage(),
        '/nominate': (context) => NominationPage(),
        '/admin': (context) => AdminPage(),
      },
    );
  }
}
