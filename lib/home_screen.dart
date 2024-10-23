import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini_ai/core/colors.dart';
import 'package:flutter_gemini_ai/core/constant.dart';
import 'package:flutter_gemini_ai/core/custom/custom_initial_containers.dart';
import 'package:flutter_gemini_ai/core/custom/custom_text_bubble.dart';
import 'package:flutter_gemini_ai/core/error.dart';
import 'package:flutter_gemini_ai/core/static_list.dart';
import 'package:flutter_gemini_ai/presentation/login/bloc/login_bloc.dart';
import 'package:flutter_gemini_ai/presentation/login/screens/login_screen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _sendMessageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  // String? answer = '';
  //CREATE AN ARRAY TO SAVE THE ANSWER PROVIDED BY GEMINI
  List<Map<String, dynamic>> geminiAnswers = [];
  bool isLoading = false;
  double confidenceLevel = 0;
  final SpeechToText _speechToText = SpeechToText();
  bool speechEnabled = false;
  String _wordsSpoken = '';

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
  void initState() {
    super.initState();
    _initSpeech();
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {
      confidenceLevel = 0;
    });
    log('trigger');
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
    log('stop listen');
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _wordsSpoken = result.recognizedWords;
      confidenceLevel = result.confidence;
      _sendMessageController.text = _wordsSpoken;
    });
    log('words spoken $_wordsSpoken');
  }

  //

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
          actions: [
            IconButton(
              icon: const Icon(
                Icons.replay_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  geminiAnswers.clear();
                });
              },
            ),
            const Logout(),
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: geminiAnswers.isEmpty
                    ? initialContainer(
                        sendMessageController: _sendMessageController)
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
                //
                // Container(
                //   height: 40,
                //   width: 40,
                //   decoration: const BoxDecoration(
                //       color: Colors.blue, shape: BoxShape.circle),
                //   child: IconButton(
                //       onPressed: () {
                //         showModalBottomSheet(
                //           context: context,
                //           builder: (context) {
                //             return const Column(
                //               children: [Text('hehe')],
                //             );
                //           },
                //         );
                //       },
                //       icon: Icon(
                //         Icons.add,
                //         color: iconColor,
                //       )),
                // ),
                // const SizedBox(
                //   width: 5,
                // ),
                //
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
                Container(
                  height: 40,
                  width: 40,
                  decoration: const BoxDecoration(
                      color: Colors.blue, shape: BoxShape.circle),
                  child: IconButton(
                      onPressed: _speechToText.isListening
                          ? _stopListening
                          : _startListening,
                      icon: Icon(
                        _speechToText.isNotListening
                            ? Icons.mic_off
                            : Icons.mic,
                        color: iconColor,
                      )),
                ),
                const SizedBox(
                  width: 5,
                ),
                //
                isLoading
                    ? const SpinKitSpinningLines(
                        color: Colors.blue,
                        size: 45,
                      )
                    : Container(
                        height: 40,
                        width: 40,
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
}

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LogoutSuccessState) {
          log('${state.successMsg}');
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const LoginScreen()));
        }
        if (state is LogoutFailedState) {
          log('${state.errorMsg}');
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: () {
              context.read<LoginBloc>().add(LogoutButtonPressedEvent());
              // await GoogleSignIn().signOut();
            },
          );
        },
      ),
    );
  }
}
