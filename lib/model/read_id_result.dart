class ReadIdResult {
  bool success;
  String? msg;
  int? errorCode;

  ReadIdResult(this.success, this.msg, this.errorCode);

  factory ReadIdResult.fromJson(Map<dynamic, dynamic> json) {
    return ReadIdResult(
      json['success'] as bool,
      json['msg'] as String?,
      json['errorCode'] as int?,
    );
  }

  @override
  String toString() {
    return 'ReadIdResult{success: $success, msg: $msg, errorCode: $errorCode}';
  }
}
