import 'package:dlt_app/utils/app_libraries.dart';

class ClassesPage extends StatefulWidget {
  const ClassesPage({super.key});

  @override
  State<StatefulWidget> createState() => _ClassesPage();
}

class _ClassesPage extends State {
  late List<Classes> _classes;

  _loadClasses() async {
    try {
      List<Classes> classes = await Amplify.DataStore.query(Classes.classType);
      setState(() {
        _classes = classes;
      });
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  @override
  void initState() {
    _loadClasses();

    super.initState();
  }

  Future<void> addClass(String id) async {
    try {
      List<Classes> classes = await Amplify.DataStore.query(Classes.classType,
          where: Classes.ID.eq(id));
      if (classes.isNotEmpty) {
        final currentClass = classes.first;
        List<String> newList = List.empty(growable: true);
        final currentUsers = currentClass.users;
        newList.addAll(currentUsers!);
        newList.add(context.read<AuthService>().attributes['user_id']!);
        final updatedClass = currentClass.copyWith(users: newList);
        Amplify.DataStore.save(updatedClass);
        _loadClasses();
      }
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  Future<void> removeClass(String id) async {
    try {
      List<Classes> classes = await Amplify.DataStore.query(Classes.classType,
          where: Classes.ID.eq(id));
      if (classes.isNotEmpty) {
        final currentClass = classes.first;
        List<String> newList = List.empty(growable: true);
        final currentUsers = currentClass.users;
        newList.addAll(currentUsers!);
        newList.remove(context.read<AuthService>().attributes['user_id']!);

        final updatedClass = currentClass.copyWith(users: newList);
        Amplify.DataStore.save(updatedClass);
        _loadClasses();
      }
    } catch (e) {
      print("Could not query DataStore: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageWrap(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Heading(
            "My Classes",
            fontSize: 50,
          ),
          const Divider(
            color: Colors.white,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0, bottom: 120),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                if (_classes[index].users != null &&
                    _classes[index].users!.contains(
                        context.read<AuthService>().attributes['user_id'])) {
                  return ClassWidget(index, false);
                }
                return const SizedBox();
              },
            ),
          ),
          const Heading(
            "Available Classes",
            fontSize: 50,
          ),
          const Divider(
            color: Colors.white,
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 0, bottom: 120),
              itemCount: _classes.length,
              itemBuilder: (context, index) {
                if (_classes[index].users == null ||
                    !_classes[index].users!.contains(
                        context.read<AuthService>().attributes['user_id'])) {
                  return ClassWidget(index, true);
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget ClassWidget(int index, bool add) {
    return FutureBuilder<Courses?>(
      future: getCourse(_classes[index].course_id),
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () {
            if(add) {
              addClass(_classes[index].id);
            } else {
              removeClass(_classes[index].id);
            }
          },
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.18,
                    child: Heading(
                      formatDateTime(
                          dateTime: _classes[index].date.getDateTime(),
                          format: 'MMM dd yyyy'),
                      padding: EdgeInsets.zero,
                      textAlign: TextAlign.center,
                      color: ThemeColors.primary,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Body(
                      snapshot.data?.name ?? '',
                      padding: EdgeInsets.zero,
                      fontSize: 24,
                    ),
                  ),
                  if(add) const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  if(!add) const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ],
              ),
              const Divider(
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
