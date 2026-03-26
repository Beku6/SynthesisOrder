import 'dart:async';

abstract final class SynorMockLatency {
  static const shell = Duration(milliseconds: 320);
  static const services = Duration(milliseconds: 340);
  static const quickAlerts = Duration(milliseconds: 240);

  static Future<T> resolve<T>(T value, {Duration duration = shell}) async {
    await Future<void>.delayed(duration);
    return value;
  }

  static Future<T> run<T>(
    FutureOr<T> Function() action, {
    Duration duration = shell,
  }) async {
    await Future<void>.delayed(duration);
    return await action();
  }
}
