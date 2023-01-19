import 'package:dlt_app/utils/app_libraries.dart';

class AdminNominationPage extends StatefulWidget {
  const AdminNominationPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminNominationState();
}

class _AdminNominationState extends State {
  late Users _nominator;
  late Chats _chat;
  late List<Widget> _moreChats;

  _loadNominee() async {
    Chats chat = context.read<AuthService>().metaData['nomination'];
    try {
      List<Users> users = await Amplify.DataStore.query(Users.classType,
          where: Users.ID.eq(chat.user_id));

      List<Widget> moreChats = [];
      List<ChatRooms> chats = await Amplify.DataStore.query(ChatRooms.classType, where: ChatRooms.NAME.eq('Nominate Someone'));
      for(Chats chatMessage in chats.first.messages!){
        if(chatMessage.user_id == chat.user_id){
          if(chatMessage.timestamp != chat.timestamp) {
            moreChats.add(nomineeCard(chatMessage));
          }
        }
      }
      safePrint(chats);
      setState(() {
        _nominator = users.first;
        _chat = chat;
        _moreChats = moreChats;
      });
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  @override
  void initState() {
    _loadNominee();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkAdmin(context);
    return PageWrap(
        hideNav: true,
        hideMessageIcon: true,
        hideAppBar: false,
        title: '${getMetaValueByKey(metaList: _chat.meta_data ?? [], key: 'First Name') ?? ''} ${getMetaValueByKey(metaList: _chat.meta_data ?? [], key: 'Last Name') ?? ''}',
        backgroundColor: ThemeColors.grey,
        padding:
            const EdgeInsets.only(top: 0, right: 15, bottom: 0, left: 15),
        child: ListView(
          children: [
            const SizedBox(height: 15,),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AvatarImage(
                            type: 'file',
                            image: context
                                    .read<AuthService>()
                                    .attributes['image'] ??
                                '',
                            size: 50),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Body(
                              '${_nominator.user_detail!.first_name ?? ''} ${_nominator.user_detail!.last_name ?? ''}',
                              color: Colors.black,
                            ),
                            Body(
                              '${_nominator.email ?? ''}',
                              color: Colors.black,
                            ),
                            Body(
                              '${_nominator.user_detail!.phone!.first.number ?? ''}',
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 15,),
            const Heading(
              "Nominee",
            ),
            nomineeCard(_chat),
            const SizedBox(height: 30,),
            Heading(
              "Other Nominations by ${_nominator.user_detail!.first_name ?? ''}",
            ),
            Column(
              children: _moreChats,
            ),
          ],
        ),
    );
  }
}

Card nomineeCard(Chats chat){
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Body(
                '${getMetaValueByKey(metaList: chat.meta_data ?? [], key: 'First Name') ?? ''} ${getMetaValueByKey(metaList: chat.meta_data ?? [], key: 'Last Name') ?? ''}',
                color: Colors.black,
              ),
              Body(
                getMetaValueByKey(metaList: chat.meta_data ?? [], key: 'Email') ?? '',
                color: Colors.black,
              ),
              Body(
                getMetaValueByKey(metaList: chat.meta_data ?? [], key: 'Phone') ?? '',
                color: Colors.black,
              ),
              Body(
                'Relationship: ${getMetaValueByKey(metaList: chat.meta_data ?? [], key: 'Relationship') ?? ''}',
                color: Colors.black,
              ),
              Body(
                'Message: ${chat.message ?? ''}',
                color: Colors.black,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}