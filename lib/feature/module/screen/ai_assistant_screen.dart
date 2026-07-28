import 'package:flutter/material.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() => _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final TextEditingController _messageController = TextEditingController();

  // Dummy message list to replicate ChatGPT state flow
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hello! How can I help you today?', 'isMe': false},
    {'text': 'Can you explain Suwidhaa Services?', 'isMe': true},
    {'text': 'Suwidhaa Services is a hyper-local platform that brings E-Commerce, IT Services, Education, and NGO resources right into your neighborhood seamlessly.', 'isMe': false},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'text': _messageController.text,
        'isMe': true,
      });
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Classic ChatGPT Premium Dark Aesthetic Colors
      backgroundColor: const Color(0xFF212121),
      appBar: AppBar(
        backgroundColor: const Color(0xFF212121),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white70, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Suwidhaa AI',
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withOpacity(0.5), size: 18),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.drive_file_rename_outline_rounded, color: Colors.white70, size: 22),
            onPressed: () {}, // Simulated Clear/New Chat action
          ),
        ],
      ),
      body: Column(
        children: [
          // Divider Line matching openAI look
          Divider(color: Colors.white.withOpacity(0.05), height: 1),

          /// Chat History List View
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              physics: const BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final chat = _messages[index];
                return _buildChatBubble(text: chat['text'], isMe: chat['isMe']);
              },
            ),
          ),

          /// ChatGPT styled Bottom Persistent Search/Text Bar Container
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Container(
                color: const Color(0xFF2F2F2F), // Input Box Background Accent
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    // Attachment Icon
                    IconButton(
                      icon: Icon(Icons.add_circle_outline_rounded, color: Colors.white.withOpacity(0.6), size: 24),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white, fontSize: 15),
                        cursorColor: Colors.white54,
                        decoration: InputDecoration(
                          hintText: 'Message Suwidhaa AI...',
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 15),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                        ),
                      ),
                    ),
                    // ChatGPT circular Send arrow button state
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.white, // Inverted clean look
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_upward_rounded, color: Color(0xFF212121), size: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ChatGPT specific Minimalist Layout bubble widget
  Widget _buildChatBubble({required String text, required bool isMe}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // System Avatar Icon for AI Responses
          if (!isMe) ...[
            Container(
              margin: const EdgeInsets.only(right: 12, top: 2),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981), // ChatGPT Spark Green Logo accent
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
            ),
          ],

          // Chat bubble text block
          Expanded(
            child: Align(
              alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                padding: isMe
                    ? const EdgeInsets.symmetric(horizontal: 16, vertical: 10)
                    : const EdgeInsets.only(top: 8), // AI has seamless plain response text layout like chatgpt website
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFF2F2F2F) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 15.5,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}