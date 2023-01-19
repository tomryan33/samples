import 'package:dlt_app/utils/app_libraries.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatState();
}

class _ChatState extends State {
  ChatRooms? _room;
  String? _roomName;

  _loadChats() async {
    final chatRoom = await context.read<AuthService>().fetchChatRoomById();

    safePrint(chatRoom);

    if (chatRoom.messages != null && !chatRoom.messages!.last.read) {
      updateReadChats(roomId: chatRoom.id);
      safePrint('Updated Read Chats');
    }

    String roomName = await getRoomName(
        myId: context.read<AuthService>().attributes['user_id'] ?? '',
        chatRoom: chatRoom);

    setState(() {
      _room = chatRoom;
      _roomName = roomName;
    });
  }

  onMessageSent(Chats entity) async {
    await addNewChat(roomId: _room!.id, chat: entity);
    final chatRoom = await context.read<AuthService>().fetchChatRoomById();
    setState(() {
      _room = chatRoom;
    });
  }

  @override
  void initState() {
    _loadChats();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageWrap(
      hideNav: true,
      hideMessageIcon: true,
      hideAppBar: false,
      title: _roomName ?? "",
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                itemCount:
                    _room?.messages == null ? 0 : _room?.messages!.length,
                reverse: true,
                itemBuilder: (context, index) {
                  final reversedIndex = _room?.messages == null
                      ? 0
                      : _room!.messages!.length - 1 - index;
                  return ChatBubble(
                    isIM: _room!.name == 'IM',
                      alignment: _room?.messages![reversedIndex].user_id ==
                              context.read<AuthService>().attributes['user_id']
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      entity: _room!.messages![reversedIndex],
                      lastUser: reversedIndex > 0
                          ? _room?.messages![reversedIndex - 1]
                          : null);
                }),
          ),
          ChatInput(onSubmit: onMessageSent),
        ],
      ),
    );
  }
}
