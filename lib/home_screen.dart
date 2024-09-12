import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini_ai/core/constant.dart';
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
  List geminiAnswers = [];

  Future<String?> sendMessage({required String msg}) async {
    final model =
        GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
    final content = [Content.text(msg)];
    final response = await model.generateContent(content);
    if (response.text != null) {
      setState(() {
        geminiAnswers.add(response.text);
      });
    }
    debugPrint('$geminiAnswers');
    return response.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
              child: ListView.builder(
                itemCount: geminiAnswers.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                        decoration: const BoxDecoration(color: Colors.blue),
                        child: Text(geminiAnswers[index])),
                  );
                },
              ),
            ),
            //
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sendMessageController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                //
                IconButton(
                    onPressed: () async {
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
