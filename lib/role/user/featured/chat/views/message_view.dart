import 'package:flutter/material.dart';
import 'package:taxi_booking/role/user/featured/chat/widget/chat_input_bar_widget.dart';
import 'package:taxi_booking/role/user/featured/chat/widget/custom_chat_appbar.dart';
import '../controllers/message_controller.dart';
import '../model/message_model.dart';

class MessageView extends StatefulWidget {
  final String userImage;
  final String userName;
  final String targetUserId;

  const MessageView({
    super.key,
    required this.userImage,
    required this.userName,
    required this.targetUserId,
  });

  @override
  State<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends State<MessageView> {
  late MessageController messageController;

  @override
  void initState() {
    super.initState();
    messageController = MessageController();
    messageController.init();
    messageController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomChatAppbar(
        userImage: widget.userImage,
        userName: widget.userName,
        targetUserId: widget.targetUserId, 
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messageController.messages.length,
              itemBuilder: (_, index) {
                final msg = messageController.messages[index];

                switch (msg.messageType) {
                  case MessageType.text:
                    return _messageTile(
                      isSender: msg.isSender,
                      message: msg.content,
                      time: msg.time,
                    );
                  case MessageType.voice:
                    return _voiceMessageTile(
                      isSender: msg.isSender,
                      time: msg.time,
                      duration: msg.content,
                      index: index,
                    );
                  case MessageType.audioCall:
                  case MessageType.videoCall:
                    return _callMessageTile(
                      message: msg,
                      index: index,
                    );
                  default:
                    return _messageTile(
                      isSender: msg.isSender,
                      message: msg.content,
                      time: msg.time,
                    );
                }
              },
            ),
          ),
          ChatInputBarWidget(controller: messageController),
        ],
      ),
    );
  }

  Widget _messageTile({
    required bool isSender,
    required String message,
    required String time,
  }) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 250),
            decoration: BoxDecoration(
              color: isSender ? Colors.amber : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isSender ? const Radius.circular(16) : Radius.zero,
                bottomRight: isSender ? Radius.zero : const Radius.circular(16),
              ),
            ),
            child: Text(
              message,
              style: TextStyle(
                color: isSender ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
            child: Text(
              time,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _voiceMessageTile({
    required bool isSender,
    required String time,
    required String duration,
    required int index,
  }) {
    final message = messageController.messages[index];
    final isCurrentlyPlaying = messageController.isPlaying &&
        messageController.currentPlayingIndex == index;

    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 4),
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(maxWidth: 280, minWidth: 180),
            decoration: BoxDecoration(
              color: isSender ? Colors.amber : Colors.grey.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(16),
                topRight: const Radius.circular(16),
                bottomLeft: isSender ? const Radius.circular(16) : Radius.zero,
                bottomRight: isSender ? Radius.zero : const Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => messageController.playVoiceMessage(index),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSender
                          ? Colors.white.withOpacity(0.2)
                          : Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isCurrentlyPlaying ? Icons.pause : Icons.play_arrow,
                      color: isSender ? Colors.white : Colors.orange,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    height: 40,
                    child: isCurrentlyPlaying
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 4,
                                decoration: BoxDecoration(
                                  color: isSender
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: LinearProgressIndicator(
                                  value: messageController.playbackProgress,
                                  backgroundColor: Colors.transparent,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    isSender ? Colors.white : Colors.orange,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatPlaybackTime(
                                  messageController.playbackPosition,
                                  message.voiceDuration ?? Duration.zero,
                                ),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isSender
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          )
                        : _buildWaveVisualization(
                            message.voiceLevels ?? [],
                            isSender,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  duration,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSender
                        ? Colors.white.withOpacity(0.9)
                        : Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4, right: 4),
            child: Text(
              time,
              style: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveVisualization(List<double> voiceLevels, bool isSender) {
    if (voiceLevels.isEmpty) {
      voiceLevels = List.generate(
        25,
        (index) => 0.2 + (index % 3) * 0.15 + (index % 5) * 0.1,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: voiceLevels.take(30).map((level) {
        return Container(
          width: 3,
          height: 4 + (level * 20),
          decoration: BoxDecoration(
            color: isSender
                ? Colors.white.withOpacity(0.8)
                : Colors.orange.withOpacity(0.7),
            borderRadius: BorderRadius.circular(1.5),
          ),
        );
      }).toList(),
    );
  }

  String _formatPlaybackTime(Duration current, Duration total) {
    String formatDuration(Duration duration) {
      String twoDigits(int n) => n.toString().padLeft(2, '0');
      final minutes = twoDigits(duration.inMinutes);
      final seconds = twoDigits(duration.inSeconds % 60);
      return "$minutes:$seconds";
    }

    return "${formatDuration(current)} / ${formatDuration(total)}";
  }

  Widget _callMessageTile({
    required MessageModel message,
    required int index,
  }) {
    final isVideo = message.messageType == MessageType.videoCall;
    final callData = message.callData!;

    return Align(
      alignment:
          message.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: message.isSender ? Colors.amber.shade100 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: message.isSender ? Colors.amber : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isVideo ? Icons.videocam : Icons.phone,
                  color: isVideo ? Colors.blue : Colors.green,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    message.content,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              message.time,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.grey,
              ),
            ),
            if (callData.status == CallStatus.missed)
              Container(
                margin: const EdgeInsets.only(top: 4),
                child: const Text(
                  "Missed call",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
