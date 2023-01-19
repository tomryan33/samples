import 'package:dlt_app/utils/app_libraries.dart';

class PageWrap extends StatelessWidget {
  final Widget child;
  final BoxDecoration? decoration;
  final Color backgroundColor;
  final bool hideMessageIcon;
  final bool hideNav;
  final EdgeInsets padding;
  final bool hideAppBar;
  final String title;

  const PageWrap({
    super.key,
    required this.child,
    this.decoration,
    this.backgroundColor = Colors.transparent,
    this.hideMessageIcon = false,
    this.hideNav = false,
    this.padding = const EdgeInsets.only(top: 75, right: 15, bottom: 100, left: 15),
    this.hideAppBar = true,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey();

    Widget _nav = SizedBox();
    if(!hideNav){
      _nav = GestureDetector(
        onTap: () => key.currentState!.openDrawer(),
        child: const Image(
          image: AssetImage("assets/elements/hamburger.png"),
          height: 125,
        ),
      );
    }

    Widget mailIcon = SizedBox();
    if(!hideMessageIcon){
      mailIcon = Padding(
        padding: const EdgeInsets.only(right: 35),
        child: Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/rooms');
              },
              icon: const Icon(
                Icons.mail_outline_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(2.0),
            //   child: Container(
            //     width: 25,
            //     height: 25,
            //     decoration: const BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: ThemeColors.primary,
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: const [
            //         Heading("5", fontSize: 15, padding: EdgeInsets.zero,),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: backgroundColor,
        key: key,
        drawerEnableOpenDragGesture: !hideNav,
        drawer: const Nav(),
        appBar: !hideAppBar ? AppBar(
          title: Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: ThemeColors.primary,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ) : null,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                decoration: decoration,
                child: Padding(
                  padding: padding,
                  child: child,
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _nav,
                mailIcon,
              ],
            ),
          ],
        ),
      ),
    );
  }

}