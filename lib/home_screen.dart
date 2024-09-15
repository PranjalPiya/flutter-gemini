import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini_ai/core/colors.dart';
import 'package:flutter_gemini_ai/core/constant.dart';
import 'package:flutter_gemini_ai/core/custom/custom_text_bubble.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _sendMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? answer = '';
  //CREATE AN ARRAY TO SAVE THE ANSWER PROVIDED BY GEMINI
  List<Map<String, dynamic>> geminiAnswers = [];
  bool isLoading = false;
  //for auto scroll
  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(
          milliseconds: 750,
        ),
        curve: Curves.easeOutCirc,
      ),
    );
  }

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
        _scrollDown();
      });
    }
    debugPrint('$geminiAnswers');
    return response.text;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        centerTitle: true,
        title: const Text(
          'Gemini AI',
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
                child: geminiAnswers.isEmpty
                    ? initialContainer()
                    : ListView.builder(
                        // shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: geminiAnswers.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: CustomTextBubble(
                              isUser: geminiAnswers[index]['isUser'],
                              generatedMsg:
                                  '${geminiAnswers[index]['generatedMsg']}',
                              userMsg: '${geminiAnswers[index]['userMsg']}',
                            ),
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
                    style: const TextStyle(color: textColor),
                    controller: _sendMessageController,
                    decoration: InputDecoration(
                      hintText: 'Enter a prompt here',
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: headingColor),
                          borderRadius: BorderRadius.circular(10)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                //
                isLoading
                    ? const SpinKitSpinningLines(
                        color: Colors.blue,
                        size: 45,
                      )
                    : Container(
                        height: 50,
                        width: 50,
                        decoration: const BoxDecoration(
                            color: Colors.green, shape: BoxShape.circle),
                        child: IconButton(
                            onPressed: () async {
                              if (_sendMessageController.text.isEmpty) {
                                showErrorSnackBar();
                              } else {
                                _scrollDown();
                                geminiAnswers.add({
                                  'generatedMsg': '',
                                  'isUser': true,
                                  'userMsg': _sendMessageController.text.trim(),
                                });
                                await sendMessage(
                                    msg: _sendMessageController.text.trim());
                                _sendMessageController.clear();
                              }
                            },
                            icon: Icon(
                              Icons.send,
                              color: iconColor,
                            )),
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showErrorSnackBar() {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      content: const Text('Write some prompt before submitting!!'),
    );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  List onLoadQuestionList = [
    'Show me the best route from Chitwan to Kathmandu.',
    'Give me 10 best novel of all time.',
    'Can you provide me a roadmap to become a flutter developer.',
  ];

  Widget initialContainer() {
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(onLoadQuestionList.length, (index) {
            return GestureDetector(
              onTap: () {
                _sendMessageController.text = '${onLoadQuestionList[index]}';
              },
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
            );
          }),
        ),
      ],
    );
  }
}
