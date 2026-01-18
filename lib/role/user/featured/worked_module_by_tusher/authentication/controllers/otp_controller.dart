
import 'dart:async';
import 'package:flutter_riverpod/legacy.dart';

final otpProvider = StateNotifierProvider<OtpNotifier, OtpState>(
  (ref) => OtpNotifier(),
);

class OtpState {
  final int secondsRemaining;
  final bool enableResend;

  const OtpState({this.secondsRemaining = 60, this.enableResend = false});

  OtpState copyWith({int? secondsRemaining, bool? enableResend}) {
    return OtpState(
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      enableResend: enableResend ?? this.enableResend,
    );
  }
}

class OtpNotifier extends StateNotifier<OtpState> {
  OtpNotifier() : super(const OtpState()) {
    startTimer(); // replaces onInit()
  }

  Timer? _timer;

  void startTimer() {
    _timer?.cancel();

    state = state.copyWith(secondsRemaining: 60, enableResend: false);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.secondsRemaining > 0) {
        state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
      } else {
        state = state.copyWith(enableResend: true);
        _timer?.cancel();
      }
    });
  }

  void resendCode() {
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel(); // replaces onClose()
    super.dispose();
  }
}
