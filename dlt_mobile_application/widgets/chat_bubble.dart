import 'package:dlt_app/utils/app_libraries.dart';

bool readCheck = false;

class ChatBubble extends StatelessWidget {
  final Chats entity;
  final Alignment alignment;
  final Chats? lastUser;
  String _last_user_id = '-1';
  TemporalTimestamp _last_user_timestamp =
      TemporalTimestamp(DateTime.now().subtract(const Duration(days: 1)));
  final bool isIM;

  ChatBubble({
    Key? key,
    required this.alignment,
    required this.entity,
    required this.lastUser,
    required this.isIM,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAuthor =
        entity.user_id == context.read<AuthService>().attributes['user_id'];

    final lastUser = this.lastUser;
    if (lastUser != null) {
      _last_user_id = lastUser.user_id;
      _last_user_timestamp = lastUser.timestamp;
    }

    var lastDateTime = DateTime.fromMicrosecondsSinceEpoch(
        _last_user_timestamp.toSeconds() * 1000000);
    var dateTime = DateTime.fromMicrosecondsSinceEpoch(
        entity.timestamp.toSeconds() * 1000000);
    return Column(
      children: [
        if (dateTime.difference(lastDateTime).inHours > 1)
          Body(
            dateTime.difference(lastDateTime).inHours > 1
                ? formatDateTimeForChats(entity.timestamp, includeTime: true)
                : '',
            fontSize: 12,
          ),
        //Body('- New -',fontSize: 14, color: ThemeColors.primary,),
        Align(
          alignment: alignment,
          child: Row(
            mainAxisAlignment:
                isAuthor ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              !isAuthor && !isIM
                  ? AvatarImage(
                      type: 'asset',
                      image: 'assets/logos/favicon.png',
                      size: 15)
                  : SizedBox(),
              !isAuthor && !isIM
                  ? SizedBox(
                      width: 5,
                    )
                  : SizedBox(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_last_user_id != entity.user_id && !isAuthor && !isIM)
                    FutureBuilder<String>(
                        future: findNameById(entity.user_id),
                        builder: (context, snapshot) {
                          return Body(
                            _last_user_id != entity.user_id && !isAuthor && !isIM ? '${snapshot.data}' : '',
                            fontSize: 12,
                            padding: EdgeInsets.only(bottom: 5),
                          );
                        }),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.7),
                    padding:
                        EdgeInsets.only(top: 15, left: 15, bottom: 10, right: 15),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: isAuthor
                            ? Theme.of(context).primaryColor
                            : ThemeColors.grey,
                        borderRadius: isAuthor
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12))
                            : const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12))),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (entity.message != null && entity.message != '')
                          Body(
                            '${entity.message}',
                            textAlign: TextAlign.left,
                            fontSize: 15,
                          ),
                        if (entity.file != null)
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(File(entity.file!))),
                                borderRadius: BorderRadius.circular(12)),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
