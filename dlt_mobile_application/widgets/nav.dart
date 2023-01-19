import '../utils/app_libraries.dart';

class Nav extends StatelessWidget {
  const Nav({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(200),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 75, right: 25, bottom: 75, left: 25),
            child: ListView(
              shrinkWrap: false,
              padding: EdgeInsets.only(bottom: 100),
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name == '/rooms') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/rooms');
                    }
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Heading(
                        "Messages",
                        fontSize: 60,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(bottom: 10, left: 10),
                      //   child: Container(
                      //     width: 40,
                      //     height: 40,
                      //     decoration: const BoxDecoration(
                      //       shape: BoxShape.circle,
                      //       color: ThemeColors.primary,
                      //     ),
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       mainAxisAlignment: MainAxisAlignment.center,
                      //       children: const [
                      //         Heading(
                      //           "5",
                      //           fontSize: 20,
                      //           padding: EdgeInsets.zero,
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name == '/team') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/team');
                    }
                  },
                  child: const Heading(
                    "My Team",
                    fontSize: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name == '/classes') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/classes');
                    }
                  },
                  child: const Heading(
                    "Classes",
                    fontSize: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name == '/totd') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/totd');
                    }
                  },
                  child: const Heading(
                    "Inspiration",
                    fontSize: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name ==
                        '/nominate') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/nominate');
                    }
                  },
                  child: const Heading(
                    "Nominate",
                    fontSize: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Uri url = Uri.parse(
                        "http://discoverwebstore.mybigcommerce.com/");
                    launchUrl(url);
                  },
                  child: const Heading(
                    "Shop",
                    fontSize: 60,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (ModalRoute.of(context)?.settings.name == '/contact') {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/contact');
                    }
                  },
                  child: const Heading(
                    "Contact DLT",
                    fontSize: 60,
                  ),
                ),
                if (int.parse(context
                            .read<AuthService>()
                            .attributes['account_type'] ??
                        '0') ==
                    9)
                  GestureDetector(
                    onTap: () {
                      if (ModalRoute.of(context)?.settings.name == '/admin') {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushReplacementNamed(context, '/admin');
                      }
                    },
                    child: const Heading(
                      "Admin Dashboard",
                      fontSize: 60,
                      color: Colors.red,
                    ),
                  )
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Image(
                  image: AssetImage("assets/elements/hamburger-inverse.png"),
                  height: 125,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15),
                child: SizedBox(
                  width: 100,
                  height: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (ModalRoute.of(context)?.settings.name ==
                              '/profile') {
                            Navigator.pop(context);
                          } else {
                            Navigator.pushReplacementNamed(context, '/profile');
                          }
                        },
                        icon: AvatarImage(
                          type: 'file',
                          image:
                              context.read<AuthService>().attributes['image'] ?? '',
                          size: 40,
                        ),
                        iconSize: 100,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
