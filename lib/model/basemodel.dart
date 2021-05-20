class BaseModel{
  int totalCount;
  bool isSuccess;
  String errMsg;
  dynamic data;

  BaseModel({this.totalCount, this.isSuccess, this.errMsg,this.data});
// 解析基础json 数据
  BaseModel.fromJson(Map<String,dynamic> json){
    isSuccess = json['isSuccess'];
    errMsg = json['errMsg'];
    totalCount = json['totalCount'] !=null ? json['totalCount'] : 0;
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['isSuccess'] = this.isSuccess;
    data['errMsg'] = this.errMsg;
    data['data'] = this.data;
    return data;
  }
}