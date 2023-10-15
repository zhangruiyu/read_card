import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'model/read_id_result.dart';
import 'read_card_platform_interface.dart';

/// An implementation of [ReadCardPlatform] that uses method channels.
class MethodChannelReadCard extends ReadCardPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('read_card')
    ..setMethodCallHandler(_methodHandler);

  static final _onDartMessageListener =
      StreamController<NativeResponse>.broadcast();

  static Stream<NativeResponse> get onDartMessageListener =>
      _onDartMessageListener.stream;

  static Future _methodHandler(MethodCall methodCall) {
    var response =
        NativeResponse.create(methodCall.method, methodCall.arguments);
    _onDartMessageListener.add(response);
    return Future.value();
  }

  @override
  Future<bool> initEid({
    required String appId,
    required String ip,
    required int port,
    required int envCode,
  }) async {
    final initSuccess = await methodChannel.invokeMethod<bool>('initEid', {
      'appId': appId,
      'ip': ip,
      'port': port,
      'envCode': envCode,
    });
    return initSuccess!;
  }

  @override
  Future<ReadIdResult> readId() async {
    final result = await methodChannel.invokeMethod('readId');
    return ReadIdResult.fromJson(result!);
  }

  @override
  Future<void> release() async {
    await methodChannel.invokeMethod('release');
  }
}

class NativeResponse {
  final dynamic params;

  NativeResponse._(this.params);

  /// create response from response pool
  factory NativeResponse.create(String name, Map? argument) =>
      _nameAndResponseMapper[name]!(argument);
}

Map<String, _NativeResponseInvoker> _nameAndResponseMapper = {
  "onSuccess": (Map? argument) => IdOnSuccessNativeResponse.fromMap(argument),
};

typedef NativeResponse _NativeResponseInvoker(Map? argument);

class IdOnSuccessNativeResponse extends NativeResponse {
  IdOnSuccessNativeResponse.fromMap(Map? map) : super._(map);
}
