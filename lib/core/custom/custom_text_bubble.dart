import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget customTextBubble({String? text}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
    decoration: BoxDecoration(
      color: Colors.deepPurpleAccent.shade400,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(0),
        bottomRight: Radius.circular(20),
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    ),
    child: Text(
      '$text',
      style: const TextStyle(color: Colors.white),
    ),
  );
}

/// CREATE A CUSTOM TEXT BUBBLE WHERE GENERATED TEXT SHOULD BE ALIGNED IN LEFT SIDE
/// WHEREAS USER MSG SHOULD BE ALIGNED IN THE RIGHT SIDE
///
class CustomTextBubble extends StatelessWidget {
  final String? generatedMsg;
  final String? userMsg;
  final bool isUser;
  const CustomTextBubble(
      {super.key, this.userMsg, this.generatedMsg, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 13),
            decoration: BoxDecoration(
              color: isUser ? Colors.blue : Colors.deepPurpleAccent.shade400,
              borderRadius: BorderRadius.only(
                bottomLeft: isUser
                    ? const Radius.circular(20)
                    : const Radius.circular(0),
                bottomRight: isUser
                    ? const Radius.circular(0)
                    : const Radius.circular(20),
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
              ),
            ),
            child: Text(
              isUser ? '$userMsg' : '$generatedMsg',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
