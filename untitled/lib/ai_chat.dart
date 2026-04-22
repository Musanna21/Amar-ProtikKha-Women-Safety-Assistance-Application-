import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'gemini_service.dart';
import 'device_location.dart'; 
import 'chat_storage.dart'; 

class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final GeminiService _gemini = GeminiService();
  final ChatStorage _storage = ChatStorage();
  
  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String userText = _controller.text;
    setState(() {
      _messages.add({"role": "user", "text": userText});
      _controller.clear();
    });

    final response = await _gemini.getAssistantResponse(
      userInput: userText,
      mode: AssistantMode.general,
      location: Provider.of<LocationProvider>(context, listen: false),
    );

    setState(() {
      _messages.add({"role": "model", "text": response});
    });


    _storage.saveHistory(_messages); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Safety Assistant")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, i) => ListTile(
                title: Text(_messages[i]["role"] == "user" ? "You" : "AI"),
                subtitle: Text(_messages[i]["text"]!),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(icon: const Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}