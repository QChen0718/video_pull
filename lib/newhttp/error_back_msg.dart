class ErrorBackMsg {
  int code;
  String message;
  Object data;

  ErrorBackMsg({this.code, this.message});

  ErrorBackMsg.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['msg'];
    data = json['data'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map();
    data['code'] = this.code;
    data['msg'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
