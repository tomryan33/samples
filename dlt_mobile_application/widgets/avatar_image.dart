import 'package:dlt_app/utils/app_libraries.dart';

class AvatarImage extends StatelessWidget {
  final type;
  final image;
  final double size;

  const AvatarImage({
    super.key,
    required this.type,
    required this.image,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    dynamic avatar;

    double diffRatio = 0.08;
    double outerSize = size;
    double innerSize = size - (diffRatio * size);

    if(image == ''){
      avatar = FutureBuilder(
        future: getRandomProfileImage(),
        builder: (context, snapshot) {
          return CircleAvatar(
            radius: innerSize,
            backgroundImage: NetworkImage(snapshot.data ?? ''),
          );
        },
      );
    } else if (type == 'network') {
      avatar = CircleAvatar(
        radius: innerSize,
        backgroundImage: NetworkImage(image),
      );
    } else if (type == 'file') {
      avatar = CircleAvatar(
        radius: innerSize,
        backgroundImage: FileImage(File(image)),
      );
    } else if (type == 'asset') {
      avatar = CircleAvatar(
        radius: innerSize,
        backgroundImage: AssetImage(image),
      );
    }

    return CircleAvatar(
      radius: outerSize,
      backgroundColor: ThemeColors.primary,
      child: avatar,
    );
  }
}
