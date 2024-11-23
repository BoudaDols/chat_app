import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/chat_provider.dart';
import 'package:chat_app/screens/chat/chat_room_screen.dart';
import 'package:chat_app/widgets/chat/user_avatar.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    if (token != null) {
      Provider.of<ChatProvider>(context, listen: false).initialize(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_outlined),
            color: Colors.amber,
            iconSize: 30.0,
            onPressed: () => Provider.of<AuthProvider>(context, listen: false).logout(),
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, _) {
          final chatRooms = chatProvider.chatRooms;
          
          return ListView.builder(
            itemCount: chatRooms.length,
            itemBuilder: (context, index) {
              final room = chatRooms[index];
              final lastMessage = room.lastMessage;
              
              return ListTile(
                leading: UserAvatar(
                  imageUrl: room.participants.first.avatarUrl,
                  name: room.participants.first.name,
                ),
                title: Text(room.name),
                subtitle: lastMessage != null
                    ? Text(
                        lastMessage.content,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: lastMessage != null
                    ? Text(
                        _formatDate(lastMessage.createdAt),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatRoomScreen(chatRoom: room),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return '${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    }
    return '${date.day}/${date.month}';
  }
}