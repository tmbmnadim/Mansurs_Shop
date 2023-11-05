import 'package:flutter/material.dart';

// This was made to stop the use of context!

class GoToPageProvider extends ChangeNotifier {
  void goToPage(BuildContext context, {required Widget page, bool removeThisPage = false}) {
    if(removeThisPage){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => page,
        ),
      );
    }
  }
}
