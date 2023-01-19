import 'package:dlt_app/utils/app_libraries.dart';

class AdminRoomsPage extends StatefulWidget {
  const AdminRoomsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminRoomsState();
}

class _AdminRoomsState extends State {
  List<ChatRooms> _rooms = [];
  String _unread = '0';

  _loadRooms() async {
    try {
      List<ChatRooms> rooms = await Amplify.DataStore.query(ChatRooms.classType, where: ChatRooms.NAME.ne('IM').and(ChatRooms.NAME.ne('Nominate Someone')));
      setState(() {
        _rooms = rooms;
      });
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  @override
  void initState() {
    context.read<AuthService>().updateUnreadCount();
    _loadRooms();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkAdmin(context);
    return PageWrap(
      hideNav: true,
      hideMessageIcon: true,
      hideAppBar: false,
      title: 'Chat Rooms',
      backgroundColor: ThemeColors.grey,
      padding: const EdgeInsets.only(top: 0, right: 15, bottom: 100, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 15,),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_unread != '0')
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, left: 10),
                  child: Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ThemeColors.primary,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Heading(
                          _unread,
                          fontSize: 15,
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0, bottom: 120),
              itemCount: _rooms.length,
              itemBuilder: (context, index) {
                return FutureBuilder<String>(
                  future: getRoomName(
                      myId: context.read<AuthService>().attributes['user_id'] ??
                          '',
                      chatRoom: _rooms[index]),
                  builder: (context, snapshot) {
                    return GestureDetector(
                      onTap: () {
                        context.read<AuthService>().metaData['room_id'] =
                            _rooms[index].id;
                        Navigator.pushNamed(context, "/rooms/chat");
                      },
                      child: RoomContainer(
                        name: maxCharacter(snapshot.data ?? '', 35),
                        date: _rooms[index].messages == null
                            ? ''
                            : formatDateTimeForChats(
                            _rooms[index].messages!.last.timestamp),
                        message: _rooms[index].messages == null
                            ? ''
                            : maxCharacter(
                            _rooms[index].messages!.last.message!, 200),
                        read: _rooms[index].messages == null
                            ? true
                            : _rooms[index].messages!.last.read,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
