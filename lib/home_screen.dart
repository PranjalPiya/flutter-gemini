import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini_ai/core/constant.dart';
import 'package:flutter_gemini_ai/core/custom/custom_text_bubble.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _sendMessageController = TextEditingController();
  String? answer = '';
  //CREATE AN ARRAY TO SAVE THE ANSWER PROVIDED BY GEMINI
  List<Map<String, dynamic>> geminiAnswers = [];
  bool isLoading = false;

  //
  Future<String?> sendMessage({required String msg}) async {
    setState(() {
      isLoading = true;
    });
    final model =
        GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
    final content = [Content.text(msg)];

    final response = await model.generateContent(content);

    if (response.text != null) {
      setState(() {
        geminiAnswers.add({
          'generatedMsg': '${response.text}',
          'isUser': false,
          'userMsg': '',
        });
        //turning loading animation off after getting the response.
        isLoading = false;
      });
    }
    debugPrint('$geminiAnswers');
    return response.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: const Text(
          'Gemini AI in flutter app',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: ListView.builder(
                  itemCount: geminiAnswers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: CustomTextBubble(
                        isUser: geminiAnswers[index]['isUser'],
                        generatedMsg: '${geminiAnswers[index]['generatedMsg']}',
                        userMsg: '${geminiAnswers[index]['userMsg']}',
                      ),
                      //  customTextBubble(
                      //     text: '${geminiAnswers[index]['generatedMsg']}'),
                    );
                  },
                ),
              ),
            ),
            //
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    maxLines: 3, // Allows the text field to expand vertically
                    minLines: 1,
                    controller: _sendMessageController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                //
                isLoading
                    ? const CircularProgressIndicator()
                    : IconButton(
                        onPressed: () async {
                          geminiAnswers.add({
                            'generatedMsg': '',
                            'isUser': true,
                            'userMsg': _sendMessageController.text.trim(),
                          });
                          await sendMessage(
                              msg: _sendMessageController.text.trim());
                          _sendMessageController.clear();
                        },
                        icon: const Icon(Icons.send)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
