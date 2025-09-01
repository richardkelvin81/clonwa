import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:myapp/data/models/message.dart';

class MessageBubble extends StatefulWidget {
  final Message message;
  final VoidCallback onDisplayed;

  const MessageBubble(
      {super.key, required this.message, required this.onDisplayed});

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onDisplayed();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMe = widget.message.senderId == 'user1'; // Replace with actual user ID
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.green[200] : Colors.grey[300],
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.message.audioUrl != null)
              GestureDetector(
                onTap: () async {
                  if (_isPlaying) {
                    await _audioPlayer.pause();
                    setState(() {
                      _isPlaying = false;
                    });
                  } else {
                    await _audioPlayer.play(UrlSource(widget.message.audioUrl!));
                    setState(() {
                      _isPlaying = true;
                    });
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                    const SizedBox(width: 8.0),
                    const Text('Audio Message'),
                  ],
                ),
              )
            else
              Text(widget.message.text),
            const SizedBox(height: 4.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  DateFormat('HH:mm').format(widget.message.timestamp),
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                ),
                if (isMe)
                  Icon(
                    widget.message.isRead ? Icons.done_all : Icons.done,
                    color: Colors.blue,
                    size: 16.0,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
