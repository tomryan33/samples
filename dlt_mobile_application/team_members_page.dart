import 'package:dlt_app/utils/app_libraries.dart';

class TeamMembersPage extends StatefulWidget {
  const TeamMembersPage({super.key});

  @override
  State<StatefulWidget> createState() => _TeamState();
}

class _TeamState extends State {
  List<Users> _members = [];

  _loadTeam() async {
    String myId = context.read<AuthService>().attributes['user_id']!;

    List<Classes> myClasses =
        await getClasses(Classes.USERS.contains(myId)) ?? [];
    List<String> teamMembersIds = [];
    if (myClasses.isNotEmpty) {
      for (Classes myClass in myClasses) {
        if (myClass.users != null && myClass.users!.isNotEmpty) {
          for (String user in myClass.users!) {
            if (user != myId && !teamMembersIds.contains(user)) {
              teamMembersIds.add(user);
            }
          }
        }
      }
    }

    List<Users> members = [];
    if (teamMembersIds.isNotEmpty) {
      for (String id in teamMembersIds) {
        List<Users> member = await getUsers(Users.ID.eq(id)) ?? [];
        if (member.isNotEmpty) {
          members.add(member.first);
        }
      }
    }

    setState(() {
      _members = members;
    });
  }

  @override
  void initState() {
    _loadTeam();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrap(
      padding: const EdgeInsets.only(top: 75, right: 15, bottom: 0, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Heading(
            "My Team",
            fontSize: 50,
          ),
          _members.isNotEmpty
              ? Expanded(
                  child: ListView.builder(
                      padding: const EdgeInsets.only(top: 0, bottom: 120),
                      itemCount: _members.length,
                      itemBuilder: (context, index) {
                        return MemberContainer(
                          name:
                              '${_members[index].user_detail?.first_name} ${_members[index].user_detail?.last_name}',
                          image: _members[index].user_detail?.image ?? '',
                          location:
                              '${_members[index].user_detail?.address?.first.city}, ${_members[index].user_detail?.address?.first.state}',
                          id: _members[index].id,
                        );
                      }),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 50,
                    ),
                    Icon(Icons.people, color: Colors.white, size: 150,),
                    Body('Team members enrolled in\n your classes will appear here.',textAlign: TextAlign.center,),
                  ],
                ),
        ],
      ),
    );
  }
}

class MemberContainer extends StatelessWidget {
  final String name;
  final String image;
  final String location;
  final String id;

  const MemberContainer({
    super.key,
    required this.name,
    required this.image,
    required this.location,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            startIM(context, id);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 5),
                child: AvatarImage(
                  type: 'file',
                  image: image,
                  size: 35,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Heading(
                        name,
                      ),
                      Body(
                        location,
                        fontSize: 15,
                      )
                    ],
                  ),
                ),
              ),
              const Icon(
                Icons.messenger_outline,
                color: Colors.white,
              ),
            ],
          ),
        ),
        const Divider(
          height: 8,
          thickness: 1,
          color: ThemeColors.grey,
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }
}
