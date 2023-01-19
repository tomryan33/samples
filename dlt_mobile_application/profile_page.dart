import 'package:dlt_app/utils/app_libraries.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _ProfilePage();
}

class _ProfilePage extends State {
  late Users _user;
  late UserDetails _userDetails;
  bool _self = true;

  _loadUser() async {
    try {
      String userId = context.read<AuthService>().attributes['user_id'] ?? '';
      if (context.read<AuthService>().metaData['profile_id'] != null &&
          context.read<AuthService>().metaData['profile_id']!.isNotEmpty) {
        if (context.read<AuthService>().isAdmin()) {
          userId = context.read<AuthService>().metaData['profile_id'] ?? userId;
          _self = false;
          context.read<AuthService>().metaData['profile_id'] = '';
        }
      }

      List<Users> users = [
        Users(email: context.read<AuthService>().attributes['email'] ?? '')
      ];
      if (userId != '') {
        users = await Amplify.DataStore.query(Users.classType,
            where: Users.ID.eq(userId));
      }
      safePrint('Users: $users');

      setState(() {
        _user = users.first;
        _userDetails = _user.user_detail ?? UserDetails();
        safePrint(_user);
      });
    } catch (e) {
      print("Could not query DataStore: $e");
    }
    return null;
  }

  @override
  void initState() {
    _loadUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthService>().fetchCurrentUserAttributes();

    Widget phoneWidget = const SizedBox();
    if (_userDetails.phone != null) {
      List<Widget> phones = [];
      for (Phone phone in _userDetails.phone!) {
        phones.add(Body('${phone.type}: ${phone.number}'));
      }
      phoneWidget = Column(
        children: phones,
      );
    }

    Widget addressWidget = const SizedBox();
    if (_userDetails.address != null) {
      List<Widget> addresses = [];
      for (Address address in _userDetails.address!) {
        addresses.add(Body('Local: ${address.city}, ${address.state}'));
      }
      addressWidget = Column(
        children: addresses,
      );
    }

    return PageWrap(
      hideNav: !_self,
      hideMessageIcon: !_self,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          if (!_self)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.navigate_before,
                    color: Colors.white,
                    size: 50,
                  ),
                  Heading(
                    "Back",
                    fontSize: 50,
                    padding: EdgeInsets.zero,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AvatarImage(
                  type: 'file',
                  image: context.read<AuthService>().attributes['image'] ?? '',
                  size: 90),
              const SizedBox(
                height: 30,
              ),
              Heading(
                '${_userDetails.first_name ?? ""} ${_userDetails.last_name ?? ""}',
                textAlign: TextAlign.center,
                fontSize: 50,
              ),
              Body(
                _user.email,
                textAlign: TextAlign.center,
              ),
              phoneWidget,
              addressWidget,
              //locale,
              // const Body(
              //   "Company: Cool Company",
              //   textAlign: TextAlign.center,
              // ),
              // const Body(
              //   "MGLP Team #150",
              //   textAlign: TextAlign.center,
              // ),
              // const Body(
              //   "HOAS Team #68",
              //   textAlign: TextAlign.center,
              // ),
              const Body(
                "Password: ∙∙∙∙∙∙∙∙∙∙",
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/signup');
                },
                child: const Body(
                  "Edit Profile",
                  color: ThemeColors.primary,
                  textAlign: TextAlign.center,
                ),
              ),
              if (_self)
                GestureDetector(
                  onTap: () {
                    context.read<AuthService>().signOutCurrentUser();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  child: const Body(
                    "Logout",
                    color: Colors.red,
                    textAlign: TextAlign.center,
                  ),
                ),
              if (context.read<AuthService>().isAdmin() && !_self)
                GestureDetector(
                  onTap: () {},
                  child: const Body(
                    "Delete User",
                    color: Colors.red,
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
