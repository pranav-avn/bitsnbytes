import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

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

  void _sendRecommendationRequest() {
    String sensorDataMessage = '''
What kind of recommendations can be given to the user who is in a room with sensor data as below:
Temperature: 38°C
Humidity: 40%
Dust: 20
Gas levels: CO2 - 10%, O2 - 70%, LPG - 20%
Occupancy count: 40 out of 45
Lights: ON
Ambient Lights value: 70 out of 100
Soil moisture value (for indoor plants in the room): 50
Ammonia/Urea sensor in bathroom: 40

Give it as short & direct bulletin points.
''';
    ChatMessage sensorMessage = ChatMessage(
      user: _currentUser,
      createdAt: DateTime.now(),
      text: sensorDataMessage,
    );
    getAIResponse(sensorMessage);

    ChatMessage recommendationmessage = ChatMessage(
        user: _currentUser,
        createdAt: DateTime.now(),
        text: "Give me recommendations for my room");

    setState(() {
      _messages.insert(0, recommendationmessage);
      _typingUsers.add(_gptChatUser);
    });
  }

  void sendPromptToNode(String Prompt) async {
    const baseurl = "http://192.168.99.89:3000/api/data";
    try {
      final url = Uri.parse(baseurl);
      final response = await http.post(url,
          body: jsonEncode({'prompt': Prompt}), //User sending to server
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body.toString().replaceAll("**", " ").trim());
        print(data['message']);
      }
    } catch (e) {
      print('ERROR : While sending to Node : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generative AI Chat'),
        actions: [
          ElevatedButton(
              onPressed: _sendRecommendationRequest,
              child: Text('Recommendations'))
        ],
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

  Future<void> getAIResponse(ChatMessage Prompt) async {
    const baseurl = "http://192.168.99.89:3000/api/data";
    try {
      final url = Uri.parse(baseurl);
      final prompt = Prompt.text;
      final content = [Content.text(prompt)];
      final String generatedText = 'No Response Generated';
      final response = await http.post(url,
          body: jsonEncode({'prompt': prompt}), //User sending to server
          headers: {"Content-Type": "application/json"});
      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body.toString().replaceAll("**", "").trim());
        final generatedText = data['message'] ?? 'No Response Generated';
        print(data['message']);
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
      }
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
