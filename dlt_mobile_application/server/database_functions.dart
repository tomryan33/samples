import 'package:dlt_app/utils/app_libraries.dart';

Future<List<Classes>?> getClasses([dynamic condition]) async {
  try {
    List<Classes> classes = await Amplify.DataStore.query(
      Classes.classType,
      where: condition,
    );
    return classes;
  } catch (e) {
    print("Could not query DataStore: $e");
  }
  return null;
}

Future<List<Users>?> getUsers([dynamic condition]) async {
  try {
    List<Users> users = await Amplify.DataStore.query(
      Users.classType,
      where: condition,
    );
    return users;
  } catch (e) {
    print("Could not query DataStore: $e");
  }
  return null;
}

Future<List<Courses>?> getCourses([dynamic condition]) async {
  try {
    List<Courses> courses = await Amplify.DataStore.query(
      Courses.classType,
      where: condition,
    );
    return courses;
  } catch (e) {
    print("Could not query DataStore: $e");
  }
  return null;
}

Future<List<ContentGroups>?> getContentGroups([dynamic condition]) async {
  try {
    List<ContentGroups> contentGroups = await Amplify.DataStore.query(
      ContentGroups.classType,
      where: condition,
    );
    return contentGroups;
  } catch (e) {
    print("Could not query DataStore: $e");
  }
  return null;
}

Future<List<ChatRooms>?> getChatRooms([dynamic condition]) async {
  try {
    List<ChatRooms> chatRooms = await Amplify.DataStore.query(
      ChatRooms.classType,
      where: condition,
    );
    return chatRooms;
  } catch (e) {
    print("Could not query DataStore: $e");
  }
  return null;
}

Future<void> startIM(BuildContext context, String teamMemberId) async {
  bool foundRoom = false;
  String myId = context.read<AuthService>().attributes['user_id'] ?? '';
  List<ChatRooms> myRooms = await getChatRooms(
          ChatRooms.NAME.eq("IM").and(ChatRooms.USERS.contains(myId))) ??
      [];
  if (myRooms.isNotEmpty) {
    for (ChatRooms room in myRooms) {
      if (room.users != null && room.users!.contains(teamMemberId)) {
        foundRoom = true;
        context.read<AuthService>().metaData['room_id'] = room.id;
        Navigator.pushNamed(context, "/rooms/chat");
      }
    }
  }
  if (!foundRoom) {
    ChatRooms newRoom = ChatRooms(name: 'IM', users: [myId, teamMemberId]);
    Amplify.DataStore.save(newRoom);
    context.read<AuthService>().metaData['room_id'] = newRoom.id;
    Navigator.pushNamed(context, "/rooms/chat");
  }
}
