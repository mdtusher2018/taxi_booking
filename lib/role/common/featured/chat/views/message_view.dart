import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/resource/app_colors.dart';
import 'package:taxi_booking/resource/common_widget/custom_text.dart';
import 'package:taxi_booking/role/common/featured/chat/controller/message_controller.dart';
import 'package:taxi_booking/role/common/featured/chat/model/message_response_model.dart';
import 'package:taxi_booking/role/driver/featured/worked_module_by_tusher/vehicals/view/my_vehicales_view.dart';

class MessageView extends ConsumerStatefulWidget {
  final String reciverId;
  final bool isDriverToDriverConversation;
  const MessageView({
    super.key,
    required this.reciverId,
    required this.isDriverToDriverConversation,
  });

  @override
  ConsumerState<MessageView> createState() => _MessageViewState();
}

class _MessageViewState extends ConsumerState<MessageView> {
  final TextEditingController textEditingController = TextEditingController();
  late MessageController controller;

  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    AppLogger.i(" Reciver Id: ${widget.reciverId}");
    controller = ref.read(messageControllerProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.startListeningNewMessage();
      controller.loadPriviousChat(widget.reciverId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messageControllerProvider);

    ref.listen(messageControllerProvider, (previous, next) {
      if (previous?.errorMessage == null && next.errorMessage != null) {
        ref
            .read(snackbarServiceProvider)
            .showError(next.errorMessage ?? "Unknown Error Occurred");
      }
    });

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: _ChatAppBar(user: state.receiver),
      ),
      body: state.loading
          ? const Center(child: CircularProgressIndicator()) // Loading state
          : _buildChat(state), // Messages display
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
              AppLogger.i(msg.imageUrl.toString());
              return _MessageBubble(
                isMe: isMe,
                message: msg.text,
                images: msg.imageUrl ?? [],
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.black12)],
          ),
          child: Column(
            children: [
              if (selectedImages.isNotEmpty)
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      final file = selectedImages[index];

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Image.file(
                                file,
                                height: 70,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedImages.removeAt(index);
                                  });
                                },
                                child: const CircleAvatar(
                                  radius: 12,
                                  backgroundColor: Colors.black54,
                                  child: Icon(
                                    Icons.close,
                                    size: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              Row(
                children: [
                  SizedBox(width: 8),
                  InkWell(
                    onTap: pickImages,
                    child: Icon(Icons.image_rounded, size: 32),
                  ),
                  SizedBox(width: 8),
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
                            images: selectedImages,
                          );

                      textEditingController.clear();
                      selectedImages.clear();
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);

    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images.map((e) => File(e.path)));
      });
    }
  }
}

class _MessageBubble extends StatelessWidget {
  final bool isMe;
  final String message;
  final List<MessageImage> images;

  const _MessageBubble({
    required this.isMe,
    required this.message,
    required this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(10),
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
        child: Column(
          crossAxisAlignment: isMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            /// 🖼 Images
            if (images.isNotEmpty)
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: images.map((messageImage) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      messageImage.url,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      loadingBuilder: (c, w, p) {
                        if (p == null) return w;
                        return const SizedBox(
                          height: 100,
                          width: 100,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                    ),
                  );
                }).toList(),
              ),

            /// 📝 Text
            if (message.trim().isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                message,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
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
                user?.user.identityUploads ?? '',
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(user?.user.fullName ?? "Loading..."),
                Text(
                  user?.isOnline == true ? "Online" : "Offline",
                  style: TextStyle(
                    fontSize: 12,
                    color: user?.isOnline == true ? Colors.green : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return MyVehiclesView(
                      isForAssign: true,
                      driverId: user?.id,
                    );
                  },
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.btnColor,
                borderRadius: BorderRadius.circular(4),
              ),

              child: CustomText(
                title: "Assign",
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
