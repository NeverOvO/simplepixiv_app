class PicResponerModel {
  String code;
  String msg;
  String quota;
  String quotaMinTtl;
  String count;
  List<PicResponerList> data = [];

  PicResponerModel({this.code,this.msg,this.quota,this.quotaMinTtl,this.data, this.count});

  factory PicResponerModel.fromJson(Map<String, dynamic> json) {
    return PicResponerModel(
      code : json['code'].toString(),
      msg : json['msg'].toString(),
      quota : json['quota'].toString(),
      quotaMinTtl : json['quota_min_ttl'].toString(),
      count : json['count'].toString(),
      data: (json['data'] as List).map((i) => PicResponerList.fromJson(i)).toList(),
    );
  }

}

class PicResponerList{
  final String pid;
  final String p;
  final String uid;
  final String title;
  final String author;
  final String url;
  final bool r18;
  final int width;
  final int height;
  final List<String> tags;

  PicResponerList({this.pid, this.p, this.uid, this.title, this.author, this.url, this.r18, this.width, this.height, this.tags});

  factory PicResponerList.fromJson(Map<String, dynamic> json) {
    return PicResponerList(
      pid : json['pid'].toString(),
      p : json['p'].toString(),
      uid : json['uid'].toString(),
      title : json['title'].toString(),
      author : json['author'].toString(),
      url : json['url'].toString(),
      r18 : json['r18'],
      width : json['width'],
      height : json['height'],
      tags : json['tags'].cast<String>(),
    );
  }
}