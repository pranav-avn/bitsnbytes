import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';

const apiKey = 'AIzaSyAluPdptLfyseXOgSBuFc-8JEFa8XD6g0U';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Assistant',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ChatPage(),
    );
  }
}

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ChatUser _currentUser;
  final ChatUser _gptChatUser = ChatUser(
    id: '2',
    firstName: 'Gemini',
    lastName: 'AI',
  );

  List<ChatMessage> _messages = <ChatMessage>[];
  List<ChatUser> _typingUsers = <ChatUser>[];

  @override
  void initState() {
    super.initState();
    _initializeCurrentUser();
  }

  void _initializeCurrentUser() {
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      _currentUser = ChatUser(
        id: firebaseUser.uid,
        firstName: firebaseUser.displayName ?? 'Anonymous',
        lastName: firebaseUser.email,
      );
    } else {
      _currentUser = ChatUser(
        id: '0',
        firstName: 'Guest',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generative AI Chat'),
      ),
      body: DashChat(
        currentUser: _currentUser,
        onSend: (ChatMessage message) {
          setState(() {
            _messages.insert(0, message);
            _typingUsers.add(_gptChatUser);
          });
          getAIResponse(message);
        },
        messages: _messages,
        typingUsers: _typingUsers,
        messageOptions: const MessageOptions(
          currentUserContainerColor: Colors.blue,
          containerColor: Colors.green,
          textColor: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Future<void> getAIResponse(ChatMessage message) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-latest',
        apiKey: apiKey,
      );

      final prompt = message.text;
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);

      // Access and clean the generated text from the response
      var generatedText = response.text ?? 'No response generated';
      generatedText = generatedText.replaceAll('**', '').trim();

      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _gptChatUser,
            createdAt: DateTime.now(),
            text: generatedText,
          ),
        );
        _typingUsers.remove(_gptChatUser);
      });
    } catch (e) {
      setState(() {
        _messages.insert(
          0,
          ChatMessage(
            user: _gptChatUser,
            createdAt: DateTime.now(),
            text: 'Error: Unable to generate response.',
          ),
        );
        _typingUsers.remove(_gptChatUser);
      });
    }
  }
}
