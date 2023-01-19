import 'package:dlt_app/utils/app_libraries.dart';

class Logo  extends StatelessWidget{
  final double height;

  const Logo({
    super.key,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Image(
        image: AssetImage("assets/logos/logo-solid-white-green-i.png"),
        height: 100,
      ),
    );
  }

}
