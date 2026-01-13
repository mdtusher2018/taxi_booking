import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../model/message_model.dart';

class MessageController extends ChangeNotifier {
  /// DATA
  List<MessageModel> messages = [];

  bool isRecording = false;
  bool isPlaying = false;
  int currentPlayingIndex = -1;

  int recordingDuration = 0;
  double playbackProgress = 0.0;
  Duration playbackPosition = Duration.zero;

  List<double> voiceLevels = [];
  double currentAmplitude = 0.0;

  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;

  String? _currentRecordingPath;
  Timer? _recordingTimer;
  Timer? _amplitudeTimer;
  StreamSubscription? _playerSubscription;

  /// INIT
  Future<void> init() async {
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();

    await _recorder!.openRecorder();
    await _player!.openPlayer();
    await _player!.setSubscriptionDuration(const Duration(milliseconds: 100));
  }

  /// DISPOSE
  @override
  void dispose() {
    _recordingTimer?.cancel();
    _amplitudeTimer?.cancel();
    _playerSubscription?.cancel();
    _recorder?.closeRecorder();
    _player?.closePlayer();
    super.dispose();
  }

  /// PERMISSION
  Future<bool> requestMicPermission(BuildContext context) async {
    final status = await Permission.microphone.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission required')),
      );
      return false;
    }
    return true;
  }

  /// SEND TEXT
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

    notifyListeners();
  }

  /// START RECORDING
  Future<void> startRecording(BuildContext context) async {
    if (!await requestMicPermission(context)) return;

    voiceLevels.clear();
    currentAmplitude = 0.0;

    final dir = await getApplicationDocumentsDirectory();
    _currentRecordingPath =
        '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder!.startRecorder(
      toFile: _currentRecordingPath,
      codec: Codec.aacADTS,
    );

    isRecording = true;
    recordingDuration = 0;

    _startRecordingTimer();
    _startAmplitudeMonitoring();

    notifyListeners();
  }

  /// STOP RECORDING
  Future<void> stopRecording() async {
    if (!isRecording) return;

    await _recorder!.stopRecorder();
    isRecording = false;

    _recordingTimer?.cancel();
    _amplitudeTimer?.cancel();

    if (_currentRecordingPath != null) {
      final file = File(_currentRecordingPath!);
      if (await file.exists()) {
        final duration = Duration(seconds: recordingDuration);

        messages.add(
          MessageModel(
            content: _formatDuration(duration),
            isSender: true,
            time: _getCurrentTime(),
            isVoice: true,
            messageType: MessageType.voice,
            voiceFilePath: _currentRecordingPath,
            voiceDuration: duration,
            voiceLevels: List.from(voiceLevels),
          ),
        );
      }
    }

    recordingDuration = 0;
    voiceLevels.clear();
    currentAmplitude = 0.0;
    _currentRecordingPath = null;

    notifyListeners();
  }

  /// RECORD TIMER
  void _startRecordingTimer() {
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (isRecording) {
        recordingDuration++;
        notifyListeners();
      }
    });
  }

  /// AMPLITUDE SIMULATION
  void _startAmplitudeMonitoring() {
    _amplitudeTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
      if (!isRecording) return;

      final amp = (0.3 + Random().nextDouble() * 0.6).clamp(0.0, 1.0);

      currentAmplitude = amp;
      voiceLevels.add(amp);

      if (voiceLevels.length > 50) {
        voiceLevels.removeAt(0);
      }

      notifyListeners();
    });
  }

  /// PLAY VOICE
  Future<void> playVoiceMessage(int index) async {
    final msg = messages[index];
    if (!msg.isVoice || msg.voiceFilePath == null) return;

    if (isPlaying) {
      await _player!.stopPlayer();
      _playerSubscription?.cancel();
    }

    await _player!.startPlayer(
      fromURI: msg.voiceFilePath,
      codec: Codec.aacADTS,
      whenFinished: () {
        isPlaying = false;
        currentPlayingIndex = -1;
        playbackProgress = 0;
        playbackPosition = Duration.zero;
        notifyListeners();
      },
    );

    _playerSubscription = _player!.onProgress!.listen((event) {
      playbackProgress =
          event.position.inMilliseconds / event.duration.inMilliseconds;
      playbackPosition = event.position;
      notifyListeners();
    });

    isPlaying = true;
    currentPlayingIndex = index;
    notifyListeners();
  }

  /// HELPERS
  String _getCurrentTime() {
    final now = DateTime.now();
    final h = now.hour > 12 ? now.hour - 12 : now.hour;
    return "${h.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}";
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }
}
