import 'package:dlt_app/utils/app_libraries.dart';

class ChatInput extends StatefulWidget {
  final Function(Chats) onSubmit;

  ChatInput({Key? key, required this.onSubmit}) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  ImagePicker picker = ImagePicker();
  XFile? _image;

  final chatMessageController = TextEditingController();

  void onSendButtonPressed() async {
    final newChatMessage = Chats(
        message: chatMessageController.text,
        timestamp: TemporalTimestamp(DateTime.now()),
        user_id: context.read<AuthService>().attributes['user_id'] ?? '',
        file: _image != null ? _image!.path : null,
        read: false);

    widget.onSubmit(newChatMessage);

    setState(() {
      chatMessageController.clear();
      _image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.grey,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 5, bottom: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {
                var image = await picker.pickImage(source: ImageSource.gallery);
                setState(() {
                  _image = image;
                });
              },
              icon: const Icon(
                Icons.image,
                color: Colors.white,
              ),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextArea(
                    hintText: 'Type your message',
                    minLines: 1,
                    validator: (value) {
                      if(value != null) {
                        if (value.contains('\n')) {
                          String message = chatMessageController.text;
                          String result = message.replaceAll('\n', '');
                          chatMessageController.text = result;
                          onSendButtonPressed();
                        }
                      }
                    },
                    controller: chatMessageController),
                if (_image != null)
                  Image.file(
                    File(_image!.path),
                    height: 50,
                  ),
              ],
            )),
            IconButton(
              onPressed: onSendButtonPressed,
              icon: const Icon(
                Icons.send,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
