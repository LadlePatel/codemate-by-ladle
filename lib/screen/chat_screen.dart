import 'package:codebuddy/util/app_const.dart';
import 'package:codebuddy/widget/chat_text_form_field.dart';
import 'package:codebuddy/widget/message_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late final GenerativeModel model;
  late final ScrollController scrollController;
  late final TextEditingController textController;
  late final FocusNode focusNode;
  late bool isLoading;
  late ChatSession chatSession;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    textController = TextEditingController();
    focusNode = FocusNode();
    isLoading = false;

    model = GenerativeModel(model: geminiModel, apiKey: apiKey);

    chatSession = model.startChat();
  }

  @override
  void dispose() {
    scrollController.dispose();
    textController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("CodeMate By Ladle"),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                reverse: true,
                controller: scrollController,
                child: Column(
                  children: chatSession.history.map((content) {
                    var message = messageExtract(content);
                    return MessageWidget(
                        message: message, isfromUser: content.role == 'user');
                  }).toList(),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 3,
                    child: Form(
                      key: formKey,
                      child: ChattextFormField(
                        controller: textController,
                        onFieldSubmitted: sendChatMessage,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  if (!isLoading) ...[
                    IconButton(
                      onPressed: () {
                        sendChatMessage(textController.text);
                      },
                      icon: const Icon(Icons.send),
                    )
                  ] else ...[
                    const CircularProgressIndicator.adaptive(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: true,
    );
  }

  String messageExtract(Content content) {
    return content.parts.whereType<TextPart>().map((e) => e.text).join("");
  }

  void sendChatMessage(String message) async {
    final isValid = formKey.currentState?.validate() ?? false;
    if (isValid) {
      setLoading(true);
      try {
        var combinedPrompt =
            "Answer the following coding-related question or greeting directly: \"$message\". If it's not a coding-related question, suggest that you can only help with coding-related inquiries.";
        var response =
            await chatSession.sendMessage(Content.text(combinedPrompt));
        final text = response.text;
        if (text == null || text.isEmpty) {
          setLoading(false);
          error("No response found");
        } else {
          setLoading(false);
        }
      } catch (e) {
        error(e.toString());
      } finally {
        textController.clear();
        setLoading(false);
      }
    }
  }

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  void error(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Error"),
            scrollable: true,
            content: SingleChildScrollView(
              reverse: true,
              child: Text(message),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Ok"))
            ],
          );
        });
  }
}
