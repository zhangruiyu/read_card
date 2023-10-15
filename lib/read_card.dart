
import 'read_card_platform_interface.dart';

class ReadCard {
  /// 测试环境配置：
  /// appid:请填写测试环境分配的appid
  /// 测试环境ip：testeidcloudread.eidlink.com
  /// 端口：9989
  /// envCode：26814
  /// 生产环境配置：
  /// appid:请填写生产环境分配的appid
  /// 生产环境ip：eidcloudread.eidlink.com
  /// 端口：9989
  /// envCode：52302
  Future<bool> initEid({
    required String appId,
    required String ip,
    required int port,
    required int envCode,
  }) {
    return ReadCardPlatform.instance.initEid(
      appId: appId,
      ip: ip,
      port: port,
      envCode: envCode,
    );
  }

  Future<bool> readId() {
    return ReadCardPlatform.instance.readId();
  }

  Future<void> release() {
    return ReadCardPlatform.instance.release();
  }

}
