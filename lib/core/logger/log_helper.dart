import 'dart:developer' as dev;

enum LogLevel { debug, info, warning, error }

class AppLogger {
  AppLogger._();

  static const bool _enabled = true;

  // =========================
  // PUBLIC API
  // =========================

  static void d(String message, {String tag = 'APP', Object? data}) {
    _log(LogLevel.debug, message, tag, data);
  }

  static void i(String message, {String tag = 'APP', Object? data}) {
    _log(LogLevel.info, message, tag, data);
  }

  static void w(String message, {String tag = 'APP', Object? data}) {
    _log(LogLevel.warning, message, tag, data);
  }

  static void e(
    String message, {
    String tag = 'APP',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _log(LogLevel.error, message, tag, error, stackTrace: stackTrace);
  }

  // =========================
  // CORE LOGGER
  // =========================

  static void _log(
    LogLevel level,
    String message,
    String tag,
    Object? data, {
    StackTrace? stackTrace,
  }) {
    if (!_enabled) return;

    final time = DateTime.now().toIso8601String().replaceFirst('T', ' ');
    final levelName = level.name.toUpperCase();
    final emoji = _emoji(level);

    final buffer =
        StringBuffer()
          ..writeln(
            '┌────────────────────────────────────────────────────────────',
          )
          ..writeln('│ $emoji $levelName | $tag | $time')
          ..writeln(
            '├────────────────────────────────────────────────────────────',
          )
          ..writeln('│ Message : $message');

    if (data != null) {
      buffer.writeln('│ Data    : $data');
    }

    if (stackTrace != null) {
      buffer
        ..writeln(
          '├────────────────────────────────────────────────────────────',
        )
        ..writeln('│ StackTrace:');
      for (final line in stackTrace.toString().split('\n')) {
        buffer.writeln('│ $line');
      }
    }

    buffer.writeln(
      '└────────────────────────────────────────────────────────────',
    );

    dev.log(
      buffer.toString(),
      name: tag,
      level: _devLevel(level),
      error: level == LogLevel.error ? data : null,
      stackTrace: stackTrace,
    );
  }

  // =========================
  // HELPERS
  // =========================

  static String _emoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '❌';
    }
  }

  static int _devLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
    }
  }
}
