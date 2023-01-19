import '../utils/app_libraries.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<String> list;
  late String dropdownValue = list.first;

  CustomDropdownButton({
    super.key,
    required this.list,
  });

  @override
  State<CustomDropdownButton> createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: DropdownButton(
            value: widget.dropdownValue,
            icon: const Icon(
              Icons.arrow_downward,
              color: Colors.white,
            ),
            elevation: 16,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            underline: SizedBox(),
            dropdownColor: ThemeColors.grey,
            items: widget.list.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? value) {
              setState(() {
                widget.dropdownValue = value!;
              });
            },
          ),
        ),
      ),
    );
  }
}
