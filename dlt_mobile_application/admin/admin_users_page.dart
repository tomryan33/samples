import 'package:dlt_app/utils/app_libraries.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminUsersState();
}

class _AdminUsersState extends State {
  late List<Users> _users;

  _loadUsers() async {
    try {
      List<Users> users = await Amplify.DataStore.query(Users.classType);
      setState(() {
        _users = users;
      });
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  @override
  void initState() {
    _loadUsers();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkAdmin(context);
    return PageWrap(
      hideNav: true,
      hideMessageIcon: true,
      hideAppBar: false,
      title: 'Users',
      backgroundColor: ThemeColors.grey,
      padding: const EdgeInsets.only(top: 0, right: 15, bottom: 100, left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 15, bottom: 120),
              itemCount: _users == null ? 0 : _users.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<AuthService>().metaData['profile_id'] =
                            _users[index].id;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage()));
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            AvatarImage(type: 'file', image: _users[index].user_detail!.image ?? '', size: 25),
                            SizedBox(width: 10,),
                            Heading(
                              '${_users[index].user_detail!.first_name} ${_users[index].user_detail!.last_name}',
                              padding: EdgeInsets.zero,
                              fontSize: 30,
                            ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.navigate_next,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Divider(
                      color: Colors.white,
                    )
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
