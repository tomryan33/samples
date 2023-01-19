import 'package:dlt_app/utils/app_libraries.dart';

class AdminCoursesPage extends StatefulWidget {
  const AdminCoursesPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdminCoursesState();
}

class _AdminCoursesState extends State {
  late List<Courses> _courses;
  final _courseFormKey = GlobalKey<FormState>();
  final courseNameController = TextEditingController();
  final courseAbbreviationController = TextEditingController();
  final courseMaxSizeController = TextEditingController();

  _loadCourses() async {
    try {
      List<Courses> courses = await Amplify.DataStore.query(Courses.classType);

      safePrint(courses);
      setState(() {
        _courses = courses;
        safePrint(_courses.length);
      });
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  @override
  void initState() {
    _loadCourses();

    super.initState();
  }

  Future<void> addNewCourse() async {
    if (_courseFormKey.currentState != null &&
        _courseFormKey.currentState!.validate()) {
      final course = Courses(
          name: courseNameController.text,
          abbreviation: courseAbbreviationController.text,
          default_max_size: int.parse(courseMaxSizeController.text),
          );
      await Amplify.DataStore.save(course);

      setState(() {
        courseNameController.text = '';
        courseAbbreviationController.text = '';
        courseMaxSizeController.text = '';
        _loadCourses();
      });
    }
  }

  Widget CourseRegistrationForm() {
    return Form(
      key: _courseFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Input(
            hintText: 'Course Name*',
            controller: courseNameController,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return "Please enter course name.";
              }
              return null;
            },
          ),
          Input(
            hintText: 'Course Abbreviation*',
            controller: courseAbbreviationController,
            validator: (value) {
              if (value != null && value.isEmpty) {
                return "Please enter course abbreviation.";
              }
              return null;
            },
          ),
          Input(
            hintText: 'Default Max Class Size*',
            controller: courseMaxSizeController,
            type: 'number',
            validator: (value) {
              if (value != null && value.isEmpty) {
                return "Please enter default max size for course.";
              }
              return null;
            },
          ),
          TextButton(
            onPressed: () {
              addNewCourse();
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(ThemeColors.primary),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0)))),
            child: const Text(
              'Add New Course',
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
      backgroundColor: ThemeColors.grey,
      hideAppBar: false,
      title: 'Courses',
      padding: const EdgeInsets.only(top: 0, right: 15, bottom: 100, left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 15, bottom: 120),
              itemCount: _courses.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        context.read<AuthService>().metaData['course_id'] =
                            _courses[index].id;
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdminClassesPage()));
                      },
                      child: ListTile(
                        title: Heading(
                          '${_courses[index].abbreviation}: ${_courses[index].name} [${_courses[index].default_max_size}]',
                          padding: EdgeInsets.zero,
                          fontSize: 18,
                        ),
                        trailing: const Icon(
                          Icons.navigate_next,
                          color: Colors.white,
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
          CourseRegistrationForm(),
        ],
      ),
    );
  }
}
