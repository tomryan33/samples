import 'package:dlt_app/nomination_page.dart';
import 'package:dlt_app/utils/app_libraries.dart';

class AdminNominationsPage extends StatefulWidget {
  const AdminNominationsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminNominationsState();
}

class _AdminNominationsState extends State{
  late ChatRooms _nominationRoom;

  _loadNominations() async {
    try {
      List<ChatRooms> chats = await Amplify.DataStore.query(ChatRooms.classType, where: ChatRooms.NAME.eq('Nominate Someone'));
      setState(() {
        _nominationRoom = chats.first;
      });
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  @override
  void initState() {

    _loadNominations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkAdmin(context);
    return PageWrap(
      hideNav: true,
      hideMessageIcon: true,
      hideAppBar: false,
      title: 'Nominations',
      backgroundColor: ThemeColors.grey,
      padding: const EdgeInsets.only(top: 0, right: 15, bottom: 100, left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 15, bottom: 120),
              itemCount: _nominationRoom.messages == null ? 0 : _nominationRoom.messages!.length,
              itemBuilder: (context, index) {
                Chats chat = _nominationRoom.messages![index];
                String firstName = getMetaValueByKey(metaList: chat.meta_data ?? [], key: 'First Name');
                String lastName = getMetaValueByKey(metaList: chat.meta_data ?? [], key: 'Last Name');
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<AuthService>().metaData['nomination'] = chat;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AdminNominationPage()));
                      },
                      child: ListTile(
                        title: Row(
                          children: [
                            Heading(
                              '$firstName $lastName',
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