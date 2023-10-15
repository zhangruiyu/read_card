import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'model/read_id_result.dart';
import 'read_card_method_channel.dart';

abstract class ReadCardPlatform extends PlatformInterface {
  /// Constructs a ReadCardPlatform.
  ReadCardPlatform() : super(token: _token);

  static final Object _token = Object();

  static ReadCardPlatform _instance = MethodChannelReadCard();

  /// The default instance of [ReadCardPlatform] to use.
  ///
  /// Defaults to [MethodChannelReadCard].
  static ReadCardPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ReadCardPlatform] when
  /// they register themselves.
  static set instance(ReadCardPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool> initEid({
    required String appId,
    required String ip,
    required int port,
    required int envCode,
  }) {
    throw UnimplementedError('initEid() has not been implemented.');
  }

  Future<ReadIdResult> readId() {
    throw UnimplementedError('readId() has not been implemented.');
  }
  Future<void> release() {
    throw UnimplementedError('release() has not been implemented.');
  }
}
