import 'package:Connectify/core/chat.dart';
import 'package:Connectify/utils/chatManagement.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ChatPreview extends StatelessWidget {
  final int contactId;
  final String name;
  final String lastMessage;
  final String phoneNum;
  final String time;
  final VoidCallback onNavigate;
  final String? imageUrl;
  final Chat? chat;
  final VoidCallback onDelete;
  final int unseenMessages; // New property for unseen messages

  const ChatPreview({
    Key? key,
    required this.contactId,
    required this.name,
    required this.lastMessage,
    required this.phoneNum,
    required this.time,
    required this.onNavigate,
    required this.imageUrl,
    required this.chat,
    required this.onDelete,
    required this.unseenMessages, // Initialize unseenMessages
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () async {
        await Navigator.of(context).pushNamed('/Chat',
            arguments: Chat(name, phoneNum, lastMessage, 0, time));
        onNavigate();
        print('clicked');
      },
      child: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: theme.colorScheme.primary,
                      backgroundImage:
                          imageUrl != null ? NetworkImage(imageUrl!) : null,
                      child: imageUrl == null
                          ? Text(
                              name[0].toUpperCase(),
                              style: TextStyle(
                                fontSize: 24,
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
                    ),
                    // Badge to show unseen messages count
                    if (unseenMessages > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            unseenMessages.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            DateFormat('HH:mm a').format(DateTime.parse(time)),
                            style: TextStyle(
                              fontSize: 16,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        lastMessage,
                        style: TextStyle(
                          fontSize: 18,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    chat!.favourite == 1
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: chat!.favourite == 1
                        ? Colors.red
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  onPressed: () {
                    ChatManagement.update_favourite(chat!);
                    ChatManagement.refreshHome();
                    onDelete();
                    print(chat!.favourite);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: theme.colorScheme.onSurface),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context);
                  },
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
            color: theme.colorScheme.primary.withOpacity(0.5),
            indent: 0,
            endIndent: 0,
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Chat'),
          content: Text('Are you sure you want to delete this chat?'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                ChatManagement.deleteChat(chat!);
                ChatManagement.refreshHome();
                onDelete();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
