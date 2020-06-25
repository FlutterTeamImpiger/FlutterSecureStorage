import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// StoreCriticalData class
class StoreCriticalData {
  /// Create Channel
  static const MethodChannel _channel = const MethodChannel('impiger_securestroage');

  /// WriteString function
  Future<void> writeString({@required String key, @required String value,}) async =>
      _channel.invokeMethod('write_string', <String, dynamic>{
        'key': key,
        'value': value
      });

  /// ReadString function
  Future<String> readString({@required String key,}) async {
    final String value = await _channel.invokeMethod(
        'read_string', <String, dynamic>{
      'key': key,
    });
    print(value);
    return value;
  }

  /// WriteDouble function
  Future<void> writeDouble({@required String key, @required double value,}) async =>
      _channel.invokeMethod('write_double', <String, dynamic>{
        'key': key,
        'value': value

      });

  /// ReadDouble function
  Future<double> readDoubleNew({@required String key}) async {
    final double value = await _channel.invokeMethod('read_double', <String, dynamic>{
      'key': key,
    });
    print(value);
    return value;
  }

  /// WriteInt function
  Future<void> writeInt({@required String key, @required int value}) async =>
      _channel.invokeMethod('write_int', <String, dynamic>{
        'key': key,
        'value': value
      });

  /// ReadInt function
  Future<int> readInt({@required String key }) async {
    final int value = await _channel.invokeMethod('read_int', <String, dynamic>{
      'key': key
    });
    print(value);
    return value;
  }

  /// WriteBoolean function
  Future<void> writeBoolean({@required String key, @required bool value,}) async =>
      _channel.invokeMethod('write_boolean', <String, dynamic>{
        'key': key,
        'value': value

      });

  /// ReadBoolean function
  Future<bool> readBoolean({@required String key}) async {
    final bool value = await _channel.invokeMethod(
        'read_boolean', <String, dynamic>{
      'key': key,
    });
    print(value);
    return value;
  }
}
