import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:taxi_booking/role/driver/featured/chat/model/message_model.dart';

class ChatInputBarWidget extends StatefulWidget {
  ChatInputBarWidget({super.key});

  @override
  State<ChatInputBarWidget> createState() => _ChatInputBarWidgetState();
}

class _ChatInputBarWidgetState extends State<ChatInputBarWidget> {
  final TextEditingController _textController = TextEditingController();

  var messages = <MessageModel>[];
  var isRecording = false;
  var isPlaying = false;
  var currentPlayingIndex = (-1);
  var recordingDuration = 0;
  var playbackProgress = 0.0;
  var playbackPosition = Duration.zero;
  var voiceLevels = <double>[]; // For wave visualization
  var currentAmplitude = 0.0;

  String? _currentRecordingPath;
  Timer? _recordingTimer;
  Timer? _amplitudeTimer;

  FlutterSoundRecorder? _recorder;

  bool _showEmojiPicker = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }


  void _onBackspacePressed() {
    _textController
      ..text = _textController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
        TextPosition(offset: _textController.text.length),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Recording Wave Visualization (when recording)
        _buildRecordingWave(),

        SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  offset: const Offset(0, -1),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showEmojiPicker = !_showEmojiPicker;
                    });
                    if (_showEmojiPicker) {
                      _focusNode.unfocus();
                    } else {
                      _focusNode.requestFocus();
                    }
                  },
                  child: Icon(
                    _showEmojiPicker
                        ? Icons.keyboard
                        : Icons.emoji_emotions_outlined,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _textController,
                    focusNode: _focusNode,
                    onTap: () {
                      if (_showEmojiPicker) {
                        setState(() {
                          _showEmojiPicker = false;
                        });
                      }
                    },
                    decoration: InputDecoration(
                      hintText: "Type message...",
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
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
                GestureDetector(
                  onLongPressStart: (_) => startRecording(),
                  onLongPressEnd: (_) => stopRecording(),
                  onTap: () {
                    if (!isRecording) {}
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isRecording ? Colors.red : Colors.amber,
                      shape: BoxShape.circle,
                      boxShadow:
                          isRecording
                              ? [
                                BoxShadow(
                                  color: Colors.red.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                              : null,
                    ),
                    child: Icon(Icons.mic, color: Colors.white, size: 20),
                  ),
                ),

                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    if (_textController.text.trim().isNotEmpty) {
                      sendMessage(_textController.text);
                      _textController.clear();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber,
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
          ),
        ),

        // Emoji Picker
        if (_showEmojiPicker)
          SizedBox(
            height: 250,
            child: EmojiPicker(
              textEditingController: _textController,
              onBackspacePressed: _onBackspacePressed,
              config: Config(
                height: 250,
                checkPlatformCompatibility: true,
                emojiViewConfig: EmojiViewConfig(
                  columns: 7,
                  emojiSizeMax: 32.0,
                  verticalSpacing: 0,
                  horizontalSpacing: 0,
                  gridPadding: EdgeInsets.zero,
                  backgroundColor: const Color(0xFFF2F2F2),
                ),
                skinToneConfig: const SkinToneConfig(
                  enabled: true,
                  dialogBackgroundColor: Colors.white,
                  indicatorColor: Colors.grey,
                ),
                categoryViewConfig: CategoryViewConfig(
                  initCategory: Category.RECENT,
                  backgroundColor: const Color(0xFFF2F2F2),
                  indicatorColor: Colors.amber,
                  iconColor: Colors.grey,
                  iconColorSelected: Colors.amber,
                  backspaceColor: Colors.amber,
                  recentTabBehavior: RecentTabBehavior.RECENT,
                ),
                bottomActionBarConfig: const BottomActionBarConfig(
                  backgroundColor: Color(0xFFF2F2F2),
                  enabled: true,
                ),
                searchViewConfig: const SearchViewConfig(
                  backgroundColor: Color(0xFFF2F2F2),
                  buttonIconColor: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecordingWave() {
    return Builder(
      builder: (context) {
        if (!isRecording) return SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red.shade50, Colors.red.shade100],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withOpacity(0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Recording indicator with pulse animation
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.5),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Recording time
              Text(
                _formatRecordingTime(recordingDuration),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red.shade700,
                ),
              ),

              const SizedBox(width: 16),

              // Live wave visualization
              Expanded(
                child: Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: List.generate(25, (index) {
                      // Get amplitude value or default
                      final levelIndex =
                          index < voiceLevels.length
                              ? index
                              : index %
                                  (voiceLevels.isNotEmpty
                                      ? voiceLevels.length
                                      : 1);
                      final level =
                          voiceLevels.isNotEmpty
                              ? voiceLevels[levelIndex]
                              : 0.3;

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        width: 3,
                        height: 6 + (level * 28),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.7 + (level * 0.3)),
                          borderRadius: BorderRadius.circular(1.5),
                        ),
                      );
                    }),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Current amplitude indicator
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    width: 6 + (currentAmplitude * 16),
                    height: 6 + (currentAmplitude * 16),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatRecordingTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return "${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}";
  }

  Future<void> startRecording() async {
    final permissionsGranted = await _requestPermissions();
    if (!permissionsGranted) return;

    try {
      // Reset voice levels and amplitude
      voiceLevels.clear();
      currentAmplitude = 0.0;

      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'voice_${DateTime.now().millisecondsSinceEpoch}.aac';
      _currentRecordingPath = '${directory.path}/$fileName';

      await _recorder!.startRecorder(
        toFile: _currentRecordingPath,
        codec: Codec.aacADTS,
      );

      isRecording = true;
      _startRecordingTimer();
      _startAmplitudeMonitoring();

      HapticFeedback.lightImpact();
      print('Recording started: $_currentRecordingPath');
    } catch (e) {
      print('Recording error: $e');
      isRecording = false;
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording) return;

    try {
      await _recorder!.stopRecorder();
      isRecording = false;
      _recordingTimer?.cancel();
      _amplitudeTimer?.cancel();

      if (_currentRecordingPath != null && recordingDuration > 0) {
        final file = File(_currentRecordingPath!);
        if (await file.exists()) {
          final duration = Duration(seconds: recordingDuration);
          final fileSize = await file.length();

          // Create a copy of voice levels for this message
          final messageLevels = List<double>.from(voiceLevels);

          messages.add(
            MessageModel(
              content: _formatDuration(duration),
              isSender: true,
              time: _getCurrentTime(),
              isVoice: true,
              messageType: MessageType.voice,
              voiceFilePath: _currentRecordingPath,
              voiceDuration: duration,
              voiceLevels: messageLevels,
            ),
          );

          print('Recorded file saved: $_currentRecordingPath');
          print('File size: ${fileSize} bytes');
          print('Duration: ${duration.inSeconds} seconds');
        } else {
          print('File not found at: $_currentRecordingPath');
        }
      }

      // Reset values
      recordingDuration = 0;
      voiceLevels.clear();
      currentAmplitude = 0.0;
      _currentRecordingPath = null;

      HapticFeedback.lightImpact();
    } catch (e) {
      print('Stop recording error: $e');
      isRecording = false;
    }
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    final hour =
        now.hour == 0 ? 12 : (now.hour > 12 ? now.hour - 12 : now.hour);
    return "${hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      final minutes = twoDigits(duration.inMinutes % 60);
      final seconds = twoDigits(duration.inSeconds % 60);
      return "$hours:$minutes:$seconds";
    } else {
      final minutes = twoDigits(duration.inMinutes);
      final seconds = twoDigits(duration.inSeconds % 60);
      return "$minutes:$seconds";
    }
  }

  void _startRecordingTimer() {
    recordingDuration = 0;
    _recordingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (isRecording) {
        recordingDuration++;
      } else {
        timer.cancel();
      }
    });
  }

  void _startAmplitudeMonitoring() {
    _amplitudeTimer = Timer.periodic(Duration(milliseconds: 150), (
      timer,
    ) async {
      if (isRecording && _recorder != null) {
        try {
          // Since getRecorderDecibels is not available, we'll simulate
          // realistic voice amplitude based on recording duration and randomness
          final baseAmplitude = 0.3 + (Random().nextDouble() * 0.5);

          // Add some variation based on recording time to simulate speech patterns
          final timeVariation = sin(recordingDuration * 0.5) * 0.2;
          final randomVariation = (Random().nextDouble() - 0.5) * 0.3;

          double normalizedAmplitude =
              (baseAmplitude + timeVariation + randomVariation).clamp(0.0, 1.0);

          // Occasionally create silence periods (more realistic)
          if (Random().nextInt(20) == 0) {
            normalizedAmplitude = 0.05 + (Random().nextDouble() * 0.1);
          }

          currentAmplitude = normalizedAmplitude;

          // Add to voice levels array (keep last 50 values for wave visualization)
          voiceLevels.add(normalizedAmplitude);
          if (voiceLevels.length > 50) {
            voiceLevels.removeAt(0);
          }
        } catch (e) {
          // Generate fallback amplitude with more natural pattern
          final time = DateTime.now().millisecondsSinceEpoch / 1000.0;
          final amplitude1 = sin(time * 2.0) * 0.3 + 0.4;
          final amplitude2 = sin(time * 3.7) * 0.2;
          final randomAmplitude = (amplitude1 +
                  amplitude2 +
                  Random().nextDouble() * 0.2)
              .clamp(0.1, 0.9);

          currentAmplitude = randomAmplitude;
          voiceLevels.add(randomAmplitude);
          if (voiceLevels.length > 50) {
            voiceLevels.removeAt(0);
          }
        }
      } else {
        timer.cancel();
      }
    });
  }

  Future<bool> _requestPermissions() async {
    var micStatus = await Permission.microphone.request();

    if (!micStatus.isGranted) {
      if (micStatus.isPermanentlyDenied) {
      } else {}
      return false;
    }

    return true;
  }

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    messages.add(
      MessageModel(
        content: text,
        isSender: true,
        time: _getCurrentTime(),
        isVoice: false,
        messageType: MessageType.text,
      ),
    );
  }
}
