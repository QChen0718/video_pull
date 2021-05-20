import 'dart:convert';

class CommonResponse<T> {
  final int code;
  final String message;
  final T data;

  CommonResponse({this.code, this.message, this.data});
  factory CommonResponse.fromJson(
      Map<String, dynamic> json, T parseData(dataJson)) {
    return CommonResponse(
      code: json['code'],
      message: json['message'],
      data: parseData == null
          ? json['data']
          : (json['data'] != null ? parseData(json['data']) : null),
    );
  }

  bool isSuccess() => code == 0;

  static CommonResponse<T> parseData<T>(String responseBody) {
    return CommonResponse.fromJson(json.decode(responseBody), (data) => data);
  }
}

class DataString {
  static CommonResponse<String> parseData(String responseBody) {
    return CommonResponse.fromJson(
        json.decode(responseBody), (data) => (data ?? '').toString());
  }
}
