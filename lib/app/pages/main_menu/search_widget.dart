import 'package:flutter/material.dart';
import 'package:sirah/colors.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: () {
          // print("TAP"); // TODO: implement search view.
        },
        color: lightGrey,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        child: Row(children: [
          Container(
            margin: const EdgeInsets.only(right: 15.5),
            child: Image.asset("assets/search_icon.png",
                height: 17.5,
                width: 17.5,
                color: Colors.black.withOpacity(0.5)),
          ),
          Text(
            "Type to search...",
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: "Roboto",
              color: darkText.withOpacity(darkText.opacity * 0.5),
            ),
          )
        ]));
  }
}
