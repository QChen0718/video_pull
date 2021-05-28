

class PosterListDataModel {
  String adResourceTypeName;
  int id;
  int mediaType;
  int adResourceTypeId;
  String name;
  String image;

  PosterListDataModel(
      {this.adResourceTypeName,
        this.id,
        this.mediaType,
        this.adResourceTypeId,
        this.name,
        this.image});

  PosterListDataModel.fromJson(Map<String, dynamic> json) {
    adResourceTypeName = json['adResourceTypeName'];
    id = json['id'];
    mediaType = json['mediaType'];
    adResourceTypeId = json['adResourceTypeId'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['adResourceTypeName'] = this.adResourceTypeName;
    data['id'] = this.id;
    data['mediaType'] = this.mediaType;
    data['adResourceTypeId'] = this.adResourceTypeId;
    data['name'] = this.name;
    data['image'] = this.image;
    return data;
  }
}