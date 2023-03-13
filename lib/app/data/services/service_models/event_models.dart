/*     
    sample json data for event model
    {
      "title": "A curated 1/1  art space",
      "tag": "IN PERSON",
      "timestamp": "1679486400",
      "link": "https://objkt.com/explorer",
      "address": "Cannaught place, New Delhi",
      "description": "With a curatorial approach centred around putting diversity and community first.",
      "shareText": "Join me at this event",
      "bannerImage": "objktone_explorer_banner.png"
    }
 */

class EventModel {
  String? title;
  String? tag;
  DateTime? timestamp;
  String? link;
  String? address;
  String? description;
  String? shareText;
  String? bannerImage;

  EventModel(
      {this.title,
      this.tag,
      this.timestamp,
      this.link,
      this.address,
      this.description,
      this.shareText,
      this.bannerImage});

  EventModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    tag = json['tag'];
    timestamp =
        DateTime.fromMillisecondsSinceEpoch(int.parse(json['timestamp']));
    link = json['link'];
    address = json['address'];
    description = json['description'];
    shareText = json['shareText'];
    bannerImage = json['bannerImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['tag'] = tag;
    data['timestamp'] = timestamp!.millisecondsSinceEpoch.toString();
    data['link'] = link;
    data['description'] = description;
    data['address'] = address;
    data['shareText'] = shareText;
    data['bannerImage'] = bannerImage;
    return data;
  }

/*   @override
  String toString() {
    return 'DappModel(name: $name, logo: $logo, url: $url, backgroundImage: $backgroundImage, description: $description, discord: $discord, twitter: $twitter, telegram: $telegram)';
  } */
}
