import 'package:dlt_app/utils/app_libraries.dart';

class AuthService extends ChangeNotifier {
  static init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static late final SharedPreferences _prefs;
  late Map<String, String> attributes = {};
  late Map<String, dynamic> metaData = {};
  Users? _userObject;
  bool _loggedIn = false;

  Future<bool> isLoggedIn() async {
    final result = await Amplify.Auth.fetchAuthSession();
    if (result.isSignedIn) {
      await buildDummyData();
      await fetchCurrentUserAttributes();
      var user = getCurrentUser();
      bool userChanged = false;
      List<Meta> updatedMetaData = [];
      if (user != null &&
          user.user_meta != null &&
          user.user_meta!.meta_data != null &&
          user.user_meta!.meta_data!.isNotEmpty) {
        for (Meta metaData in user.user_meta!.meta_data!) {
          if (metaData.key == 'imageHold' && metaData.value != '') {
            final imageFile = File(metaData.value!);
            // Upload the file to S3
            try {
              final UploadFileResult result = await Amplify.Storage.uploadFile(
                local: imageFile,
                key: 'profile-${attributes['user_id']}',
                options: S3UploadFileOptions(
                  accessLevel: StorageAccessLevel.private,
                ),
              );
              print('Successfully uploaded file: ${result.key}');
              userChanged = true;
            } on StorageException catch (e) {
              print('Error uploading file: $e');
            }
          } else {
            updatedMetaData.add(metaData);
          }
        }
      }
      if (userChanged) {
        try {
          List<Users> users = await Amplify.DataStore.query(Users.classType,
              where: Users.EMAIL.eq(attributes['email']));
          UserMeta currentUserMeta = users.first.user_meta!;
          UserMeta updatedUserMeta =
              currentUserMeta.copyWith(meta_data: updatedMetaData);
          UserDetails currentUserDetails = users.first.user_detail!;
          UserDetails updatedUserDetails = currentUserDetails.copyWith(
              image: 'profile-${attributes['user_id']}');
          Users updatedUser = users.first.copyWith(
              user_meta: updatedUserMeta, user_detail: updatedUserDetails);
          Amplify.DataStore.save(updatedUser);
        } catch (e) {
          print("Could not query DataStore: $e");
        }
      }
    }
    _loggedIn = result.isSignedIn;
    return _loggedIn;
  }

  bool getLoggedIn() {
    return _loggedIn;
  }

  bool isAdmin() {
    if (attributes.containsKey("account_type")) {
      if (attributes['account_type'] == '9') {
        return true;
      }
    }
    return false;
  }

  Future<void> signOutCurrentUser() async {
    try {
      await Amplify.Auth.signOut();
      _prefs.clear();
      attributes.clear();
      metaData.clear();
      _userObject = null;
      _loggedIn = false;
    } on AuthException catch (e) {
      print(e.message);
    }
  }

  Users? getCurrentUser() {
    fetchCurrentUserAttributes();
    if (_userObject != null) {
      return _userObject;
    }
    return null;
  }

  Future<void> fetchCurrentUserAttributes() async {
    try {
      final result = await Amplify.Auth.fetchUserAttributes();
      for (final element in result) {
        attributes[element.userAttributeKey.toString()] = element.value;
      }
      try {
        final user = await Amplify.DataStore.query(Users.classType,
            where: Users.EMAIL.eq(attributes['email']));
        if (user.isNotEmpty) {
          _userObject = user.first;
          attributes = {
            ...attributes,
            ...fetchAttributes(_userObject!),
          };
          if (user.first.user_detail != null &&
              user.first.user_detail!.image != null) {
            await getProfilePicture(user.first.user_detail!.image!);
          }
        }
      } on DataStoreException catch (e) {
        safePrint('Query failed: $e');
      }
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  void updateUserName(String newUserID) {
    _prefs.setString('userID', newUserID);
    notifyListeners();
  }

  Future<List<ChatRooms>> fetchChatRooms() async {
    try {
      List<ChatRooms> output = [];
      final classes = await Amplify.DataStore.query(
        Classes.classType,
        where: Classes.USERS.contains(attributes['user_id']!),
      );
      if(classes.isNotEmpty) {
        for (var classItem in classes) {
          if(classItem.users != null && classItem.users!.isNotEmpty) {
            if (classItem.users!.contains(attributes['user_id'])) {
              if(classItem.chat_rooms != null && classItem.chat_rooms!.isNotEmpty){
                for(var chatId in classItem.chat_rooms!){
                  ChatRooms chatRoom = await fetchChatRoomById(chatId);
                  output.add(chatRoom);
                }
              }
            }
          }
        }
      }

      final chatRooms = await Amplify.DataStore.query(
        ChatRooms.classType,
        where: ChatRooms.USERS.contains(
          attributes['user_id']!
        )
      );
      output.addAll(chatRooms);

      return output;
    } on DataStoreException catch (e) {
      safePrint('Query failed: $e');
    }
    throw const DataStoreException("Failed to fetch messages");
  }

  Future<ChatRooms> fetchChatRoomById([String? roomId]) async {
    roomId ??= metaData['room_id'];
    try {
      final chatRoom = await Amplify.DataStore.query(ChatRooms.classType,
          //where: ChatRooms.ID.eq(metaData['room_id']));
          where: ChatRooms.ID.eq(roomId));
      return chatRoom.first;
    } on DataStoreException catch (e) {
      safePrint('Query failed: $e');
    }
    throw const DataStoreException("Failed to fetch messages");
  }

  Future<void> updateUnreadCount() async {
    final chatRooms = await fetchChatRooms();
    var unread = 0;
    for (var element in chatRooms) {
      if (element.messages != null && element.messages!.isNotEmpty) {
        if (!element.messages!.last.read) unread++;
      }
    }
    metaData['unread'] = unread.toString();
  }

  Future<void> getProfilePicture(String imageKey) async {
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + '/' + imageKey;
    final file = File(filepath);
    try {
      await Amplify.Storage.downloadFile(
        key: imageKey,
        local: file,
        options: DownloadFileOptions(
          accessLevel: StorageAccessLevel.private,
        ),
      );
      attributes['image'] = file.path;
    } on StorageException catch (e) {
      print('Error downloading file: $e');
    }
  }
}
