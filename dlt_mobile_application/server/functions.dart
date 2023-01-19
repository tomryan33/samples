import 'dart:math';

import 'package:intl/intl.dart';

import '../utils/app_libraries.dart';

void checkAdmin(BuildContext context) {
  if (!context.read<AuthService>().isAdmin()) {
    Navigator.pushReplacementNamed(context, '/totd');
  }
}

String maxCharacter(String content, int maxChar) {
  if (content.length > maxChar) {
    return "${content.characters.take(maxChar)}...";
  }
  return content;
}

String formatDateTimeForChats(TemporalTimestamp temporalTimestamp,
    {bool includeTime = false}) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final dateTime = DateTime.fromMicrosecondsSinceEpoch(
      temporalTimestamp.toSeconds() * 1000000);
  final aDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
  var formatter = DateFormat('MM/dd/yyyyy');
  if (includeTime) formatter = DateFormat('MM/dd/yyyyy hh:mm aa');
  if (aDate == today) {
    formatter = DateFormat("hh:mm aa");
  }
  for (var i = 1; i < 7; i++) {
    final date = DateTime(now.year, now.month, now.day - i);
    if (aDate == date) {
      formatter = DateFormat('EEEE');
      if (includeTime) formatter = DateFormat('EEEE hh:mm aa');
    }
  }

  return formatter.format(dateTime).toString();
}

String formatDateTime({required DateTime dateTime, required String format}) {
  return DateFormat(format).format(dateTime);
}

Future<String> findNameById(String userId) async {
  if (userId == '') {
    return 'Discover Leadership Training Team';
  }
  try {
    List<Users> users = await Amplify.DataStore.query(Users.classType,
        where: Users.ID.eq(userId));
    return "${users.last.user_detail?.first_name} ${users.last.user_detail?.last_name}";
  } catch (e) {
    print("Could not query DataStore: $e");
  }
  return "";
}

Future<void> addNewChat(
    {String roomId = '', String roomName = '', required Chats chat}) async {
  List<ChatRooms> findChatRoom = [];

  // Find chat room to add new chat to.
  if (roomId != '') {
    findChatRoom = await Amplify.DataStore.query(ChatRooms.classType,
        where: ChatRooms.ID.eq(roomId));
  } else if (roomName != '') {
    findChatRoom = await Amplify.DataStore.query(ChatRooms.classType,
        where: ChatRooms.NAME.eq(roomName));
  }

  // Create new chat room
  var chatRoom = ChatRooms(name: roomName, messages: [chat]);

  // If chat room already exists, update current char room.
  if (findChatRoom.isNotEmpty) {
    final currentRoom = findChatRoom.first;
    var messages = currentRoom.messages;
    if(messages == null){
      messages = [chat];
    } else {
      messages.add(chat);
    }
    chatRoom = currentRoom.copyWith(messages: messages);
  }
  Amplify.DataStore.save(chatRoom);
}

Future<void> updateReadChats({required String roomId}) async {
  final findChatRoom = await Amplify.DataStore.query(ChatRooms.classType,
      where: ChatRooms.ID.eq(roomId));
  if (findChatRoom.isNotEmpty) {
    final currentRoom = findChatRoom.first;
    final currentMessages = currentRoom.messages;
    List<Chats> updatedMessages = [];
    if (currentMessages != null) {
      for (Chats message in currentMessages) {
        var updatedMessage = message.copyWith(read: true);
        updatedMessages.add(updatedMessage);
      }
      var chatRoom = currentRoom.copyWith(messages: updatedMessages);
      Amplify.DataStore.save(chatRoom);
    }
  }
}

Map<String, String> fetchAttributes(Users user) {
  Map<String, String> attributes = {};
  attributes['account_type'] = user.user_meta?.account_type.toString() ?? "0";
  attributes['user_id'] = user.id;
  attributes['first_name'] = user.user_detail?.first_name ?? "";
  attributes['last_name'] = user.user_detail?.last_name ?? "";
  return attributes;
}

Future<Courses?> getCourse(String courseId) async {
  try {
    List<Courses> courses = await Amplify.DataStore.query(Courses.classType,
        where: Courses.ID.eq(courseId));
    return courses.first;
  } catch (e) {
    print("Could not query DataStore: $e");
  }
  return null;
}

Future<String> getRandomProfileImage() async {
  final response =
      await rootBundle.loadString('assets/json/random_images.json');

  final List<dynamic> decodedList = jsonDecode(response) as List;

  int index = randomNumber(0, decodedList.length);
  return decodedList[index];
}

int randomNumber(int min, int max) {
  var rng = Random();
  return rng.nextInt(max - min) + min;
}

Future<String> getRoomName({required String myId, required ChatRooms chatRoom}) async {
  String roomName = '';
  if(chatRoom.name == 'IM'){
    List<String> users = chatRoom.users ?? [];
    for(String user in users){
      if(user != myId){
        List<Users>? teamMember = await getUsers(Users.ID.eq(user));
        return '${teamMember?.first.user_detail?.first_name} ${teamMember?.first.user_detail?.last_name}';
      }
    }
  }
  return chatRoom.name;
}

String getMetaValueByKey({required List<Meta> metaList, required String key}){
  for(Meta meta in metaList){
    if(meta.key == key){
      return meta.value ?? "";
    }
  }
  return "";
}