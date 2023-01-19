import 'utils/app_libraries.dart';

class ThoughtOfTheDayPage extends StatelessWidget {
  late final todayKey;

  ThoughtOfTheDayPage({super.key});

  int getTodayKey(Map<int, String> map) {
    int today = DateTime.now().microsecondsSinceEpoch;
    for (var key in map.keys) {
      if (key < today) {
        return key;
      }
    }
    return 0;
  }

  Future<Map<int, String>> getTOTD() async {
    final Map<int, String> output = {};
    try {
      List<ContentGroups> contentGroups = await Amplify.DataStore.query(
        ContentGroups.classType,
        where: ContentGroups.NAME.eq("Thought of the Day"),
      );
      if (contentGroups.isNotEmpty) {
        final content = contentGroups.first.content;
        for (Content item in content!) {
          int timestamp = 0;
          for (Meta meta in item.meta_data!) {
            if (meta.key == 'timestamp') {
              timestamp = int.parse(meta.value!);
            }
          }
          if (timestamp != 0) {
            output[timestamp] = item.conent ?? '';
          }
        }
      }
    } catch (e) {
      print("Could not query DataStore: $e");
    }

    final sortedOutput = Map.fromEntries(
        output.entries.toList()..sort((e1, e2) => e2.key.compareTo(e1.key)));
    return sortedOutput;
  }

  @override
  Widget build(BuildContext context) {
    context.read<AuthService>().fetchCurrentUserAttributes();
    return PageWrap(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/sunset.jpg"),
          fit: BoxFit.cover,
          opacity: 120,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Logo(),
            FutureBuilder<Map<int, String>>(
                future: getTOTD(),
                builder: (context, snapshot) {
                  int todayKey = getTodayKey(snapshot.data ?? {});
                  final DateTime today = DateTime.fromMicrosecondsSinceEpoch(todayKey);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Heading(
                          'THOUGHT OF THE DAY - ${formatDateTime(dateTime: today, format: 'MM.dd.yyyy')}',
                          textAlign: TextAlign.center),
                      Body(
                        '${snapshot.data?[todayKey]}',
                        textAlign: TextAlign.center,
                        fontStyle: FontStyle.italic,
                        fontSize: 16,
                      ),
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
