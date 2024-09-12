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

  Future<String?> sendMessage({String? msg}) async {
    final model =
        GenerativeModel(model: 'gemini-1.5-flash-latest', apiKey: apiKey);
    // const prompt = 'Write a story about a magic backpack.';
    final prompt = '$msg';
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    debugPrint('gemini ans: ${response.text}');
    geminiAnswers.add(response.text);
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
            // Expanded(child: Text(answer!)),
            Expanded(
              child: FutureBuilder(
                future: sendMessage(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    return Text('$geminiAnswers');
                  }
                  return const Text('data');
                },
              ),
            ),
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
                IconButton(
                    onPressed: () {
                      setState(() {
                        sendMessage(msg: _sendMessageController.text.trim());
                      });
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
