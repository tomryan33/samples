import 'package:dlt_app/utils/app_libraries.dart';

class RoomsPage extends StatefulWidget {
  const RoomsPage({super.key});

  @override
  State<StatefulWidget> createState() => _RoomsState();
}

class _RoomsState extends State {
  List<ChatRooms> _rooms = [];
  String _unread = '0';

  _loadRooms() async {
    final chatRooms = await context.read<AuthService>().fetchChatRooms();
    setState(() {
      _rooms = chatRooms;
      _unread = context.read<AuthService>().metaData['unread'] ?? '0';
    });
  }

  @override
  void initState() {
    context.read<AuthService>().updateUnreadCount();
    _loadRooms();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrap(
      hideMessageIcon: true,
      padding: const EdgeInsets.only(top: 75, right: 15, bottom: 0, left: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Heading(
                "Messages",
                fontSize: 50,
              ),
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

class RoomContainer extends StatelessWidget {
  final String name;
  final String date;
  final String message;
  final bool read;

  const RoomContainer({
    super.key,
    required this.name,
    required this.date,
    required this.message,
    required this.read,
  });

  @override
  Widget build(BuildContext context) {
    SizedBox readDot = SizedBox();
    if (!read) {
      readDot = const SizedBox(
        width: 10,
        child: Icon(
          Icons.circle,
          color: ThemeColors.primary,
          size: 10,
        ),
      );
    }
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: readDot,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Heading(
                          name,
                          fontSize: 22,
                        ),
                        Body(
                          date,
                          fontStyle: FontStyle.italic,
                          fontSize: 14,
                        ),
                      ],
                    ),
                    Container(
                      height: 60,
                      child: Body(
                        message,
                        fontSize: 13,
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
        const Divider(
          height: 8,
          thickness: .5,
          color: Colors.white,
        ),
        const SizedBox(
          height: 8,
        )
      ],
    );
  }
}
