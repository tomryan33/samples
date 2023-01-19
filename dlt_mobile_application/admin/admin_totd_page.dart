import 'package:dlt_app/utils/app_libraries.dart';

class AdminTOTDPage extends StatefulWidget {
  const AdminTOTDPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminTOTDState();
}

class _AdminTOTDState extends State {
  final totdController = TextEditingController();
  final dateController = TextEditingController();
  var _timestamp;

  @override
  void initState() {
    super.initState();
  }

  Future<void> postThoughtOfTheDay() async {
    final content = Content(
        user_id: context.read<AuthService>().attributes['user_id'] ?? '',
        conent: totdController.text,
        meta_data: [Meta(key: 'timestamp', value: _timestamp.toString())]);
    var contentGroup =
        ContentGroups(name: "Thought of the Day", content: [content]);

    final findTotD = await Amplify.DataStore.query(ContentGroups.classType,
        where: ContentGroups.NAME.eq('Thought of the Day'));
    if (findTotD.isNotEmpty) {
      final currentContentGroup = findTotD.first;
      final currentContent = currentContentGroup.content;
      currentContent?.add(content);
      contentGroup = currentContentGroup.copyWith(content: currentContent);
    }
    await Amplify.DataStore.save(contentGroup);
    setState(() {
      totdController.text = '';
    });
  }

  Widget ThoughtOfTheDayForm() {
    DateTime now = DateTime.now();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: dateController,
          style: const TextStyle(color: Colors.white, fontSize: 24),
          decoration: const InputDecoration(
            icon: Icon(
              Icons.calendar_today,
              color: Colors.white,
            ),
            hintText: "Select Date",
            hintStyle: TextStyle(color: Colors.white),
            border: InputBorder.none,
          ),
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(), //get today's date
              firstDate: DateTime(now.year, now.month - 1, now.day),
              lastDate: DateTime(now.year + 1, now.month, now.day),
            );
            if (pickedDate != null) {
              String formattedDate =
                  formatDateTime(dateTime: pickedDate, format: 'MM/dd/yyyy');

              setState(() {
                dateController.text = formattedDate;
                _timestamp = pickedDate.microsecondsSinceEpoch;
              });
            } else {
              print("Date is not selected");
            }
          },
        ),
        const SizedBox(
          height: 10,
        ),
        TextArea(hintText: 'Thought of the day...', controller: totdController),
        TextButton(
          onPressed: () {
            postThoughtOfTheDay();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(ThemeColors.primary),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0)))),
          child: const Text(
            'Post Thought of the Day',
            style: TextStyle(
              color: Colors.white,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    checkAdmin(context);
    return PageWrap(
      hideNav: true,
      hideMessageIcon: true,
      backgroundColor: ThemeColors.grey,
      hideAppBar: false,
      title: "Thought of the Day",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ThoughtOfTheDayForm(),
        ],
      ),
    );
  }
}
