import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/chat_provider.dart';

class ConversationDetailScreen extends StatefulWidget {
  final int conversationId;

  const ConversationDetailScreen({super.key, required this.conversationId});

  @override
  _ConversationDetailScreenState createState() => _ConversationDetailScreenState();
}

class _ConversationDetailScreenState extends State<ConversationDetailScreen> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer<ChatProvider>(
          builder: (context, provider, child) {
            // Find the conversation
            try {
              final conversation = provider.conversations
                  .firstWhere((c) => c.id == widget.conversationId);
              return Text(conversation.immobile.propertyType);
            } catch (e) {
              // If not found, show a generic title and pop back
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Conversa não encontrada.')),
                );
                Navigator.pop(context);
              });
              return const Text('Conversa');
            }
          },
        ),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          // Find the conversation
          try {
            final conversation = provider.conversations
                .firstWhere((c) => c.id == widget.conversationId);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: conversation.messages.length,
                    itemBuilder: (context, index) {
                      final message = conversation.messages[index];
                      final isMe = message.sender.id == 1; // Replace with actual logged-in user ID logic
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.green[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Column(
                            crossAxisAlignment:
                                isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                            children: [
                              Text(
                                message.content,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                DateFormat('HH:mm').format(DateTime.parse(message.sentAt)),
                                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              ),
                              if (isMe && message.isRead)
                                const Icon(Icons.check_circle, size: 12, color: Colors.blue),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _messageController,
                          decoration: InputDecoration(
                            hintText: 'Digite sua mensagem...',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.green),
                        onPressed: () {
                          if (_messageController.text.isNotEmpty) {
                            provider.sendMessage(
                              widget.conversationId,
                              _messageController.text,
                            );
                            _messageController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } catch (e) {
            // If conversation not found, show error and pop
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Conversa não encontrada.')),
              );
              Navigator.pop(context);
            });
            return const Center(child: CircularProgressIndicator(color: Colors.green));
          }
        },
      ),
    );
  }
}