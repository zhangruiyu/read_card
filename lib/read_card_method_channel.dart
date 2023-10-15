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
  factory NativeResponse.create(String name, Map<dynamic, dynamic> argument) =>
      _nameAndResponseMapper[name]!(argument);
}

Map<String, _NativeResponseInvoker> _nameAndResponseMapper = {
  "onSuccess": (Map<dynamic, dynamic> argument) =>
      IdCardResponse.fromMap(argument),
};

typedef NativeResponse _NativeResponseInvoker(Map<dynamic, dynamic> argument);

class IdCardResponse extends NativeResponse {
  late String classify;
  late String idType;
  late String birthDate;
  late String address;
  late String nation;
  late String sex;
  late String name;
  late String endTime;
  late String signingOrganization;
  late String beginTime;
  late String idnum;
  String? signingTimes;
  String? otherIdNum;
  String? enName;
  String? countryCode;
  String? version;
  Uint8List? picture;

  IdCardResponse.fromMap(Map<dynamic, dynamic> json) : super._(json) {
    this
      ..classify = json['classify'] as String
      ..idType = json['idType'] as String
      ..birthDate = json['birthDate'] as String
      ..address = json['address'] as String
      ..nation = json['nation'] as String
      ..sex = json['sex'] as String
      ..name = json['name'] as String
      ..endTime = json['endTime'] as String
      ..signingOrganization = json['signingOrganization'] as String
      ..beginTime = json['beginTime'] as String
      ..idnum = json['idnum'] as String
      ..signingTimes = json['signingTimes'] as String?
      ..otherIdNum = json['otherIdNum'] as String?
      ..enName = json['enName'] as String?
      ..countryCode = json['countryCode'] as String?
      ..version = json['version'] as String?
      ..picture = json['picture'] as Uint8List?;
  }

  @override
  String toString() {
    return 'IdOnSuccessNativeResponse{classify: $classify, idType: $idType, birthDate: $birthDate, address: $address, nation: $nation, sex: $sex, name: $name, endTime: $endTime, signingOrganization: $signingOrganization, beginTime: $beginTime, idnum: $idnum, signingTimes: $signingTimes, otherIdNum: $otherIdNum, enName: $enName, countryCode: $countryCode, version: $version';
  }
}
