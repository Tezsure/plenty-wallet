class NodeSelectorModel {
  Mainnet? mainnet;
  Testnet? testnet;

  NodeSelectorModel({this.mainnet, this.testnet});

  NodeSelectorModel.fromJson(Map<String, dynamic> json) {
    if (json["mainnet"] is Map) {
      mainnet =
          json["mainnet"] == null ? null : Mainnet.fromJson(json["mainnet"]);
    }

    if (json["testnet"] is Map) {
      testnet =
          json["testnet"] == null ? null : Testnet.fromJson(json["testnet"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainnet != null) {
      data["mainnet"] = mainnet?.toJson();
    }
    if (testnet != null) {
      data["testnet"] = testnet?.toJson();
    }
    return data;
  }
}

class Testnet {
  List<String>? name;
  List<String>? urls;

  Testnet({this.name, this.urls});

  Testnet.fromJson(Map<String, dynamic> json) {
    if (json["name"] is List) {
      name = json["name"] == null ? null : List<String>.from(json["name"]);
    }
    if (json["urls"] is List) {
      urls = json["urls"] == null ? null : List<String>.from(json["urls"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) {
      data["name"] = name;
    }
    if (urls != null) {
      data["urls"] = urls;
    }
    return data;
  }
}

class Mainnet {
  List<String>? name;
  List<String>? urls;

  Mainnet({this.name, this.urls});

  Mainnet.fromJson(Map<String, dynamic> json) {
    if (json["name"] is List) {
      name = json["name"] == null ? null : List<String>.from(json["name"]);
    }
    if (json["urls"] is List) {
      urls = json["urls"] == null ? null : List<String>.from(json["urls"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) {
      data["name"] = name;
    }
    if (urls != null) {
      data["urls"] = urls;
    }
    return data;
  }
}

class NodeModel {
  String? name;
  String? url;

  NodeModel({
    this.name,
    this.url,
  });

  NodeModel.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) {
      data["name"] = name;
    }
    if (url != null) {
      data["url"] = url;
    }
    return data;
  }
}
