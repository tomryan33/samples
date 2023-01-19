import '../utils/app_libraries.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    checkAdmin(context);
    return PageWrap(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Heading(
            "Admin Dashboard",
            fontSize: 60,
            color: Colors.red,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminUsersPage()));
              },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Heading(
                  "Users",
                  fontSize: 45,
                  padding: EdgeInsets.zero,
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                  size: 55,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminRoomsPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Heading(
                  "Chat Rooms",
                  fontSize: 45,
                  padding: EdgeInsets.zero,
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                  size: 55,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminNominationsPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Heading(
                  "Nominations",
                  fontSize: 45,
                  padding: EdgeInsets.zero,
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                  size: 55,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminTOTDPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Heading(
                  "Thought of the Days",
                  fontSize: 45,
                  padding: EdgeInsets.zero,
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                  size: 55,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AdminCoursesPage()));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Heading(
                  "Courses",
                  fontSize: 45,
                  padding: EdgeInsets.zero,
                ),
                Icon(
                  Icons.navigate_next,
                  color: Colors.white,
                  size: 55,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
