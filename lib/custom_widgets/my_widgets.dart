import 'package:flutter/material.dart';

class UtilManager {
  List<String> separateNumbersAndChars(String input) {
    List<String> transformedValue = [];
    if (input.contains("'")) {
      List tempValue = input.split("");
      tempValue.remove('''"''');
      tempValue.remove("'");
      double toCM = ((double.parse(tempValue[0]) * 12) +
              double.parse(tempValue.length == 1 ? "0" : tempValue[1])) *
          2.54;
      transformedValue = ["$toCM", "cm"];
      return transformedValue;
    } else {
      // Regular expressions to match numbers and alphabetic characters
      RegExp numberPattern = RegExp(r'[\d.]+');
      RegExp charPattern = RegExp(r'[a-zA-Z]+');

      // Find all matches of numbers in the input string
      Iterable<Match> numberMatches = numberPattern.allMatches(input);

      // Find all matches of alphabetic characters in the input string
      Iterable<Match> charMatches = charPattern.allMatches(input);

      // Extract numbers from matches
      List<String> numbers =
          numberMatches.map((match) => match.group(0)!).toList();

      // Extract alphabetic characters from matches
      List<String> chars = charMatches.map((match) => match.group(0)!).toList();

      // Print the separated numbers and characters
      return numbers + chars;
    }
  }

  Widget customListTile({
    required IconData leadingIcon,
    required String title,
    required Function()? onTap,
    Color tileColor = Colors.black54,
    double iconSize = 28,
    double horizontalPadding = 5,
    double verticalPadding = 0,
    Color iconColor = Colors.white,
    double titleSize = 18,
    Color? textColor = Colors.white,
    double borderRadius = 15,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: ListTile(
        leading: Icon(
          leadingIcon,
          size: iconSize,
          color: iconColor,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: titleSize,
            color: textColor,
          ),
        ),
        tileColor: tileColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        onTap: onTap,
      ),
    );
  }

  // Widget dayNightSwitcher(Function(void) setState){
  //   return GestureDetector(
  //     onTap: () {
  //       _basicStates.put(
  //           "darkLightMode", _basicStates.get("darkLightMode") == 1 ? 0 : 1);
  //       setState;
  //     },
  //     child: AnimatedSwitcher(
  //       duration: const Duration(milliseconds: 300),
  //       transitionBuilder: (child, anim) => RotationTransition(
  //         turns: _basicStates.get("darkLightMode") == 0
  //             ? Tween<double>(begin: 1, end: 0.75).animate(anim)
  //             : Tween<double>(begin: 0.75, end: 1).animate(anim),
  //         child: FadeTransition(opacity: anim, child: child),
  //       ),
  //       child: _basicStates.get("darkLightMode") == 0
  //           ? const Icon(
  //         Icons.light_mode,
  //         key: ValueKey("lightMode"),
  //       )
  //           : const Icon(
  //         Icons.dark_mode,
  //         key: ValueKey("darkMode"),
  //       ),
  //     ),
  //   );
  // }

  Widget customTextField({
    String? hintText,
    String? labelText,
    required TextEditingController controller,
    Function(String)? onChanged,
    Widget? prefixIcon,
    Color prefixIconColor = Colors.black26,
    Widget? suffixIcon,
    Color suffixIconColor = Colors.black26,
    bool obscureText = false,
    bool enabled = true,
    Color focusedColor = Colors.blue,
    Color fillColor = Colors.white,
    Color enabledBorderColor = Colors.black,
    Color hintColor = Colors.black,
    Color labelColor = Colors.black,
    Color textColor = Colors.black,
    var validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    // bool buttonPressed = false;
    return SizedBox(
      child: TextFormField(
        controller: controller,
        validator: validator,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
        onChanged: onChanged,
        enabled: enabled,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: prefixIcon,
          prefixIconColor: prefixIconColor,
          suffixIcon: suffixIcon,
          suffixIconColor: suffixIconColor,
          filled: true,
          fillColor: fillColor,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 2,
            horizontal: 15,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.2,
              color: Colors.white,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.2,
              color: focusedColor,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 1.2,
              color: enabledBorderColor,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          labelText: labelText,
          labelStyle: TextStyle(color: labelColor),
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor),
        ),
      ),
    );
  }

  Widget customTextButton({
    required String buttonText,
    required Function() onTap,
    Color splashColor = Colors.white,
    Color color = Colors.white,
    Color textColor = Colors.black,
    double borderRadius = 10,
    double fontSize = 25,
    FontWeight fontWeight = FontWeight.w500,
    String? fontFamily,
    double width = 200,
    double height = 60,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: Text(
              buttonText,
              style: TextStyle(
                color: textColor,
                fontSize: fontSize,
                fontWeight: fontWeight,
                fontFamily: fontFamily,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget customButton({
    required Widget child,
    required Function() onTap,
    Color splashColor = Colors.white,
    Color color = Colors.white,
    Color borderColor = Colors.transparent,
    double borderWidth = 0,
    double borderRadius = 10,
    double width = 200,
    double height = 60,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        splashColor: splashColor,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Ink(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            ),
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Center(
            child: child,
          ),
        ),
      ),
    );
  }

  Widget customRadioList({
    required String title,
    required dynamic value,
    required List groupItems,
    required Function(dynamic currentValue) onChanged,
    Alignment alignment = Alignment.center,
    Color selectedColor = Colors.blue,
    Color unselectedColor = Colors.black12,
    Color selectedTextColor = Colors.white,
    Color unselectedTextColor = Colors.black,
    Color boxColor = Colors.black45,
    BorderRadius? borderRadius,
    bool horizontal = true,
    double fontSize = 18,
    double maxWidth = 20,
    double width = 80,
    double maxHeight = double.maxFinite,
    double height = 80,
    double padding = 80,
    double tileWidth = 110,
    bool dense = false,
  }) {
    double calWidth = ((width * (groupItems.length + 1)) + ((padding * 1) / 2));
    double calHeight =
        ((height * (groupItems.length + 1)) + ((padding * 4) / 6));
    if (horizontal) {
      return Container(
        alignment: alignment,
        width: calWidth < maxWidth ? calWidth : maxWidth,
        height: height,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: borderRadius,
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: borderRadius,
              ),
              width: width,
              height: height,
              child: Text(
                title,
                style: TextStyle(
                  color: selectedTextColor,
                  fontSize: fontSize,
                ),
              ),
            ),
            SizedBox(
              width: calWidth < maxWidth ? calWidth - width : maxWidth,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: groupItems.length,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                  child: customTextButton(
                    width: width,
                    height: height,
                    buttonText: groupItems[index],
                    color: value == groupItems[index]
                        ? selectedColor
                        : unselectedColor,
                    textColor: value == groupItems[index]
                        ? selectedTextColor
                        : unselectedTextColor,
                    fontSize: fontSize,
                    onTap: () {
                      value = groupItems[index];
                      onChanged(groupItems[index]);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        alignment: alignment,
        width: width,
        height: calHeight < maxHeight ? calHeight : maxHeight,
        decoration: BoxDecoration(
          color: boxColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: borderRadius,
              ),
              width: width,
              height: height,
              child: Text(
                title,
                style: TextStyle(
                  color: selectedTextColor,
                  fontSize: fontSize,
                ),
              ),
            ),
            SizedBox(
              height: calHeight < maxHeight ? calHeight - height : maxHeight,
              child: ListView.builder(
                scrollDirection: horizontal ? Axis.horizontal : Axis.vertical,
                shrinkWrap: true,
                itemCount: groupItems.length,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: customTextButton(
                    width: width,
                    height: height,
                    buttonText: groupItems[index],
                    color: value == groupItems[index]
                        ? selectedColor
                        : unselectedColor,
                    textColor: value == groupItems[index]
                        ? selectedTextColor
                        : unselectedTextColor,
                    fontSize: fontSize,
                    onTap: () {
                      value = groupItems[index];
                      onChanged(groupItems[index]);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}

// class CustomRadio extends StatelessWidget {
//   CustomRadio({
//     super.key,
//     required this.value,
//     required this.groupItems,
//     required this.onChanged,
//     this.alignment = Alignment.center,
//     this.selectedColor = Colors.blue,
//     this.unselectedColor = Colors.black12,
//     this.selectedTextColor = Colors.white,
//     this.unselectedTextColor = Colors.black,
//     this.boxColor = Colors.black45,
//     this.borderRadius,
//     this.maxWidth = 20,
//     this.width = 80,
//     this.maxHeight = double.maxFinite,
//     this.height = 80,
//     this.padding = 80,
//     this.tileWidth = 110,
//     this.dense = false,
//   });
//
//   late dynamic value;
//   final List groupItems;
//   final Function(dynamic currentValue) onChanged;
//   Alignment alignment;
//   Color selectedColor;
//   Color unselectedColor;
//   Color selectedTextColor;
//   Color unselectedTextColor;
//   Color boxColor;
//   BorderRadius? borderRadius;
//   double maxWidth;
//   double width;
//   double maxHeight;
//   double height;
//   double padding;
//   double tileWidth;
//   bool dense;
//
//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     return LayoutBuilder(builder: (context, constraints) {
//       double maxWidth = screenSize.width;
//       return Container(
//         alignment: alignment,
//         width: ((width * groupItems.length) + ((padding * 2) / 3)) < maxWidth
//             ? (width * groupItems.length) + ((padding * 2) / 3)
//             : maxWidth,
//         height: height,
//         decoration: BoxDecoration(
//           color: boxColor,
//           borderRadius: borderRadius,
//         ),
//         child: ListView.builder(
//           scrollDirection: Axis.horizontal,
//           shrinkWrap: true,
//           itemCount: groupItems.length,
//           itemBuilder: (context, index) => Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: UtilManager().customButton(
//               width: width,
//               height: height,
//               buttonText: groupItems[index],
//               color:
//               value == groupItems[index] ? selectedColor : unselectedColor,
//               textColor: value == groupItems[index]
//                   ? selectedTextColor
//                   : unselectedTextColor,
//               fontSize: 18,
//               onTap: () {
//                 print(
//                     "${((width * groupItems.length) + ((padding * 2) / 3))}\n$maxWidth");
//                 value = groupItems[index];
//                 onChanged(groupItems[index]);
//               },
//             ),
//           ),
//         ),
//       );
//     });
//   }
// }
