class MessageModel {
  final String content;
  final bool isSender;
  final String time;
  final bool isVoice;
  final MessageType messageType;
  final String? voiceFilePath;
  final Duration? voiceDuration;
  final CallData? callData;
  final List<double>? voiceLevels; // Voice wave levels for visualization

  MessageModel({
    required this.content,
    required this.isSender,
    required this.time,
    required this.isVoice,
    this.messageType = MessageType.text,
    this.voiceFilePath,
    this.voiceDuration,
    this.callData,
    this.voiceLevels,
  });
}

enum MessageType {
  text,
  voice,
  audioCall,
  videoCall,
  image,
}


class CallData {
  final String callId;
  final CallType callType;
  final CallStatus status;
  final Duration? duration;
  final DateTime startTime;

  CallData({
    required this.callId,
    required this.callType,
    required this.status,
    this.duration,
    required this.startTime,
  });
}

enum CallType { audio, video }
enum CallStatus { incoming, outgoing, missed, ended }