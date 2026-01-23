import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_booking/core/di/service.dart';
import 'package:taxi_booking/core/logger/log_helper.dart';
import 'package:taxi_booking/core/routes/common_app_pages.dart';
import 'package:taxi_booking/core/services/storage/storage_key.dart';
import 'package:taxi_booking/core/utilitis/helper.dart';
import 'package:taxi_booking/resource/common_widget/custom_app_bar.dart';
import 'package:taxi_booking/role/common/featured/chat/controller/chat_list_controller.dart';

import '../widget/chat_list_widget.dart';

class ChatListView extends ConsumerStatefulWidget {
  const ChatListView({super.key});

  @override
  ConsumerState<ChatListView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatListView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final token =
          await ref
              .read(localStorageServiceProvider)
              .readKey(StorageKey.accessToken) ??
          "";
      ref
          .read(chatListControllerProvider.notifier)
          .getAllChatList(decodeJwtField(token, "_id"));
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatListControllerProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Messages', leading: SizedBox()),
      body: _buildBody(chatState),
    );
  }

  Widget _buildBody(ChatListState state) {
    if (state.isLoading && state.chats.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text(state.error!));
    }

    if (state.chats.isEmpty) {
      return const Center(child: Text("No chats found"));
    }

    return ListView.builder(
      itemCount: state.chats.length,
      itemBuilder: (context, index) {
        final chat = state.chats[index];

        final participant = chat.chat.participants.isNotEmpty
            ? chat.chat.participants.first
            : null;

        final lastMessage = chat.message.text;

        return CustomChatTile(
          imageUrl: participant?.image ?? "",
          userName: participant?.email ?? "Unknown User",
          lastMessage: lastMessage,
          rating: chat.unreadMessageCount.toDouble(),
          onTap: participant == null
              ? null
              : () {
                  AppLogger.d(participant.id);
                  context.push(
                    CommonAppRoutes.messagingView,

                    extra: {
                      'id': participant.id,
                      'isDriverToDriverConversation': true,
                    },
                  );
                },
        );
      },
    );
  }
}
