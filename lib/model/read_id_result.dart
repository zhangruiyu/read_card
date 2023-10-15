class ReadIdResult {
  bool success;
  String? msg;
  int? errorCode;

  ReadIdResult(this.success, this.msg, this.errorCode);

  factory ReadIdResult.fromJson(Map<String, dynamic> json) {
    return ReadIdResult(
      json['success'] as bool,
      json['msg'] as String?,
      json['errorCode'] as int?,
    );
  }
}
