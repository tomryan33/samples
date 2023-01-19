import 'package:dlt_app/utils/app_libraries.dart';

class AdminClassesPage extends StatefulWidget {
  const AdminClassesPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminClassesState();
}

class _AdminClassesState extends State {
  final classDateController = TextEditingController();
  late DateTime _timestamp;
  final classSizeController = TextEditingController();
  final classMaxSizeController = TextEditingController();
  final classNumberController = TextEditingController();

  final _classesFormKey = GlobalKey<FormState>();
  late final Courses _course;
  late List<Classes> _classes;

  _loadCourse() async {
    try {
      List<Courses> courses = await Amplify.DataStore.query(Courses.classType,
          where: Courses.ID.eq(context.read<AuthService>().metaData['course_id']));
      setState(() {
        _course = courses.first;
        safePrint(_course);
      });
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  _loadClasses() async {
    try {
      List<Classes> classes = await Amplify.DataStore.query(Classes.classType,
          where: Classes.COURSE_ID.eq(context.read<AuthService>().metaData['course_id']));
      setState(() {
        _classes = classes;
        safePrint(_classes);
      });
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  @override
  void initState() {
    _loadCourse();
    _loadClasses();
    super.initState();
  }

  Future<void> addNewClass() async {
    if (_classesFormKey.currentState != null &&
        _classesFormKey.currentState!.validate()) {
      final newChatRoom = ChatRooms(
        name:
            "${_course.abbreviation} Team ${classNumberController.text}",
      );
      await Amplify.DataStore.save(newChatRoom);

      final newClass = Classes(
          date: TemporalDate(_timestamp),
          size: 0,
          custom_max_size: classMaxSizeController.text == ''
              ? null
              : int.parse(classMaxSizeController.text),
          class_num: int.parse(classNumberController.text),
          course_id: _course.id,
          chat_rooms: [newChatRoom.id]);
      await Amplify.DataStore.save(newClass);

      setState(() {
        classDateController.text = '';
        classSizeController.text = '';
        classMaxSizeController.text = '';
        classNumberController.text = '';
        _loadClasses();
      });
    }
  }

  Widget ClassRegistrationForm() {
    DateTime now = DateTime.now();
    return Form(
      key: _classesFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: classDateController,
            style: const TextStyle(color: Colors.white, fontSize: 24),
            decoration: const InputDecoration(
              icon: Icon(
                Icons.calendar_today,
                color: Colors.white,
              ),
              hintText: "Select Date*",
              hintStyle: TextStyle(color: Colors.white),
              border: InputBorder.none,
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: now,
                lastDate: DateTime(now.year + 2, now.month, now.day),
              );
              if (pickedDate != null) {
                String formattedDate =
                    formatDateTime(dateTime: pickedDate, format: 'MM/dd/yyyy');

                setState(() {
                  classDateController.text = formattedDate;
                  _timestamp = pickedDate;
                });
              } else {
                safePrint("Date is not selected");
              }
            },
          ),
          Input(
            hintText:
                'Custom Max Class Size (Default: ${_course.default_max_size})',
            type: 'number',
            controller: classMaxSizeController,
          ),
          Input(
            hintText: 'Class Number',
            type: 'number',
            controller: classNumberController,
          ),
          TextButton(
            onPressed: () {
              addNewClass();
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(ThemeColors.primary),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
            ),
            child: const Text(
              'Add New Class',
              style: TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    checkAdmin(context);
    return PageWrap(
      hideNav: true,
      hideMessageIcon: true,
      hideAppBar: false,
      title: _course.name,
      backgroundColor: ThemeColors.grey,
      padding: const EdgeInsets.only(top: 0, right: 15, bottom: 100, left: 15),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 15, bottom: 120),
                itemCount: _classes.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: ListTile(
                          title: Heading(
                            '${_course.abbreviation} ${_classes[index].class_num}: ${formatDateTime(dateTime: _classes[index].date.getDateTime(), format: 'MM/dd/yyyy')} [${_classes[index].size}/${_classes[index].custom_max_size ?? _course.default_max_size}]',
                            padding: EdgeInsets.zero,
                            fontSize: 24,
                          ),
                          trailing: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const Divider(
                        color: Colors.white,
                      )
                    ],
                  );
                },
              ),
            ),
            ClassRegistrationForm(),
          ]),
    );
  }
}
