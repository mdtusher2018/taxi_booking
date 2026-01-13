/*
import 'package:flutter/material.dart';


import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../controllers/call_controller.dart';

class VideoCallView extends GetView<CallController> {
  final String callID;
  final String userID;
  final String userName;
  final String targetUserId;
  final String targetUserName;
  const VideoCallView({super.key, required this.callID, required this.userID, required this.userName, required this.targetUserId, required this.targetUserName});

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: CallController.appID,
      appSign: CallController.appSign,
      userID: userID,
      userName: userName,
      callID: callID,
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
        // ..onOnlySelfInRoom = (context) {
        //   Get.back(); // Go back when alone in room
        // }
        // ..onCallEnd = (context, _, __) {
        //   Get.back(); // Go back when call ends
        // },
    );
  }
}
*/
