import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gemini_ai/core/colors.dart';

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
              color: isUser ? userTextBubbleColor : generatedTextBubbleColor,
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
            child:
                // Text(isUser ? userMsg! : generatedMsg!),
                RichText(
              text: TextSpan(
                style: const TextStyle(
                    color: Colors.white, fontSize: 15, wordSpacing: 1),
                children: _buildTextSpans(isUser ? userMsg! : generatedMsg!),
              ),
            ),
          ),
        ),
      ],
    );
  }

  ///THIS IS TO CONVERT THE ** TO BOLD WHICH

  List<TextSpan> _buildTextSpans(String message) {
    final List<TextSpan> spans = [];

    // Split the message into lines to handle headings and bullet points
    final lines = message.split('\n');

    for (String line in lines) {
      // Handle heading (##) by checking if the line starts with '##'
      if (line.startsWith('##')) {
        spans.add(TextSpan(
          text: '${line.replaceFirst('##', '').trim()}\n',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ));
      }
      // // Handle bullet point (*) by checking if the line starts with '*'
      // else if (line.startsWith('*')) {
      //   spans.add(TextSpan(
      //     text: '• ${line.replaceFirst('*', '').trim()}\n',
      //     style: const TextStyle(fontSize: 16),
      //   ));
      // }
      // Handle regular and bold text
      else {
        final RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');
        final matches = boldPattern.allMatches(line);

        int lastMatchEnd = 0;
        for (final match in matches) {
          if (match.start > lastMatchEnd) {
            // Add non-bold text before the match
            spans.add(TextSpan(
              text: line.substring(lastMatchEnd, match.start),
            ));
          }
          // Add bold text
          spans.add(TextSpan(
            text: match.group(1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ));
          lastMatchEnd = match.end;
        }

        // Add any remaining non-bold text after the last bold match
        if (lastMatchEnd < line.length) {
          spans.add(TextSpan(text: line.substring(lastMatchEnd)));
        }
        // Add a newline after regular text to keep formatting consistent
        spans.add(const TextSpan(text: '\n'));
      }
    }

    return spans;
  }
}



// List<TextSpan> _buildTextSpans(String message) {
//     final List<TextSpan> spans = [];
//     final lines = message.split('\n'); // Split the message into lines

//     for (String line in lines) {
//       // Handle heading (##)
//       if (line.startsWith('##')) {
//         spans.add(TextSpan(
//           text: '${line.replaceFirst('##', '').trim()}\n',
//           style: const TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ));
//       }
//       // Handle bullet point (*) and process the rest of the line for bold (**)
//       else if (line.startsWith('*')) {
//         // Add bullet point
//         spans.add(const TextSpan(
//           text: '• ',
//           style: TextStyle(fontSize: 16),
//         ));
//         // Remove the bullet point '*' and trim the rest
//         String lineWithoutBullet = line.replaceFirst('*', '').trim();

//         // Process the rest of the line to handle bold (**)
//         spans.addAll(_processBoldText(lineWithoutBullet));

//         // Add newline after the bullet point line
//         spans.add(const TextSpan(text: '\n'));
//       }
//       // Handle normal text with bold (**)
//       else {
//         spans.addAll(_processBoldText(line));
//         spans.add(const TextSpan(text: '\n'));
//       }
//     }

//     return spans;
//   }

// // Helper function to process bold text (between **)
//   List<TextSpan> _processBoldText(String text) {
//     final RegExp boldPattern = RegExp(r'\*\*(.*?)\*\*');
//     final List<TextSpan> textSpans = [];
//     int lastMatchEnd = 0;

//     // Find all bold text matches
//     final matches = boldPattern.allMatches(text);

//     for (final match in matches) {
//       if (match.start > lastMatchEnd) {
//         // Add non-bold text before the bold match
//         textSpans
//             .add(TextSpan(text: text.substring(lastMatchEnd, match.start)));
//       }
//       // Add the bold text
//       textSpans.add(TextSpan(
//         text: match.group(1),
//         style: const TextStyle(fontWeight: FontWeight.bold),
//       ));
//       lastMatchEnd = match.end;
//     }

//     // Add any remaining non-bold text after the last match
//     if (lastMatchEnd < text.length) {
//       textSpans.add(TextSpan(text: text.substring(lastMatchEnd)));
//     }

//     return textSpans;
//   }
