

class Podcast {
  List<PodcastData> data;

  Podcast({this.data});

  Podcast.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<PodcastData>();
      json['data'].forEach((v) {
        data.add(new PodcastData.fromJson(v));
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

class PodcastData {
  String podId;
  String type;
  String link;
  String title;

  PodcastData({this.podId, this.type, this.link});

  PodcastData.fromJson(Map<String, dynamic> json) {
    podId = json['pod_id'];
    type = json['type'];
    link = json['link'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pod_id'] = this.podId;
    data['type'] = this.type;
    data['link'] = this.link;
    data['title'] = this.title;
    return data;
  }
}
