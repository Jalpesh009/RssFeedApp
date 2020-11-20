class podcast {
  List<Data> data;

  podcast({this.data});

  podcast.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String podId;
  String type;
  String link;

  Data({this.podId, this.type, this.link});

  Data.fromJson(Map<String, dynamic> json) {
    podId = json['pod_id'];
    type = json['type'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pod_id'] = this.podId;
    data['type'] = this.type;
    data['link'] = this.link;
    return data;
  }
}
