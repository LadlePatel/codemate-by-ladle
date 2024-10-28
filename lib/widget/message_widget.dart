import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final bool isfromUser;

  const MessageWidget({
    super.key,
    required this.message,
    required this.isfromUser,
  });

  @override
  Widget build(BuildContext context) {
    final promptRegex = RegExp(r'\"([^\"]*)\"');
    String displayMessage = '';

    if (isfromUser) {
      final match = promptRegex.firstMatch(message);
      if (match != null) {
        displayMessage = match.group(1) ?? '';
      }
    }

    List<String> extractCodeBlocks(String message) {
      final RegExp codeBlockRegex = RegExp(r'```(.*?)```', dotAll: true);
      return codeBlockRegex
          .allMatches(message)
          .map((match) => match.group(1)?.trim() ?? '')
          .toList();
    }

    final codeBlocks = extractCodeBlocks(isfromUser ? displayMessage : message);

    return Row(
      mainAxisAlignment:
          isfromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Flexible(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.80,
            ),
            decoration: BoxDecoration(
              color: isfromUser
                  ? const Color.fromARGB(255, 194, 236, 255)
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 18.0, vertical: 12.0),
            margin: const EdgeInsets.only(bottom: 8.0),
            child: Stack(
              children: [
                MarkdownBody(
                  data: isfromUser
                      ? displayMessage
                      : (message.trim() != "")
                          ? message
                          : "No response available",
                  selectable: true,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 12, 48, 77),
                    ),
                    h1: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    h2: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    code: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      backgroundColor: Color.fromARGB(255, 24, 153, 65),
                    ),
                    codeblockPadding: const EdgeInsets.all(8),
                    codeblockDecoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                if (codeBlocks.isNotEmpty)
                  Positioned(
                    right: 8.0,
                    top: 8.0,
                    child: IconButton(
                      icon: const Icon(Icons.copy, color: Colors.black54),
                      onPressed: () {
                        Clipboard.setData(
                            ClipboardData(text: codeBlocks.first));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Code copied to clipboard!')),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
