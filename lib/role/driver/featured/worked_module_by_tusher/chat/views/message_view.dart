import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/chat/controller/message_controller.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/chat/model/message_response_model.dart';

class MessageView extends ConsumerStatefulWidget {
  final String reciverId;
  MessageView({super.key, required this.reciverId});

  @override
  ConsumerState<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends ConsumerState<MessageView> {
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppLogger.i(" Reciver Id: ${widget.reciverId}");
    Future.microtask(() {
      ref.read(messageControllerProvider.notifier).openChat(widget.reciverId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _ChatAppBar(user: state.receiver),
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator())
          : _buildChat(state),
    );
  }

  Widget _buildChat(MessageState state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            reverse: true,
            padding: const EdgeInsets.all(16),
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              final msg = state.messages[index];
              final isMe = msg.sender != widget.reciverId;

              return _MessageBubble(isMe: isMe, message: msg.text);
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: textEditingController,
                  decoration: InputDecoration(
                    hintText: "Type a message...",
                    filled: true,

                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              /// Send Button
              InkWell(
                onTap: () {
                  ref
                      .read(messageControllerProvider.notifier)
                      .sendMessage(
                        receiverId: widget.reciverId,
                        text: textEditingController.text.trim(),
                      );
                  textEditingController.clear();
                },
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.send, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChatAppBar extends StatelessWidget {
  final ReceiverUser? user;

  const _ChatAppBar({this.user});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      title: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: Image.network(
                user?.image ?? '',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 30);
                },
              ),
            ),
          ),

          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user?.name ?? "Loading..."),
              Text(
                user?.isOnline == true ? "Online" : "Offline",
                style: TextStyle(
                  fontSize: 12,
                  color: user?.isOnline == true ? Colors.green : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;

  const _MessageBubble({required this.isMe, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * .7,
        ),
        decoration: BoxDecoration(
          color: isMe ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(16).copyWith(
            bottomLeft: Radius.circular(isMe ? 16 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 16),
          ),
          boxShadow: [
            BoxShadow(blurRadius: 3, color: Colors.black.withOpacity(.05)),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
