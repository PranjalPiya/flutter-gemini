import 'package:flutter/material.dart';
import 'package:flutter_gemini_ai/core/colors.dart';
import 'package:flutter_gemini_ai/core/static_list.dart';

Widget initialContainer({TextEditingController? sendMessageController}) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        'How can I help you?',
        style: TextStyle(
            fontSize: 25, fontWeight: FontWeight.w600, color: headingColor),
      ),
      const SizedBox(
        height: 15,
      ),
      SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(onLoadQuestionList.length, (index) {
            return GestureDetector(
              onTap: () {
                sendMessageController!.text = '${onLoadQuestionList[index]}';
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  height: 110,
                  width: 120,
                  decoration: BoxDecoration(
                      color: appBarColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    '${onLoadQuestionList[index]}',
                    style: const TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    ],
  );
}
