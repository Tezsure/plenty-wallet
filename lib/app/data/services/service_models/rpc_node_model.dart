class NodeSelectorModel {
  Mainnet? mainnet;
  Testnet? testnet;

  NodeSelectorModel({this.mainnet, this.testnet});

  NodeSelectorModel.fromJson(Map<String, dynamic> json) {
    if (json["mainnet"] is List) {
      mainnet =
          json["mainnet"] == null ? null : Mainnet.fromJson(json["mainnet"]);
    }

    if (json["testnet"] is List) {
      testnet =
          json["testnet"] == null ? null : Testnet.fromJson(json["testnet"]);
    }
  }
}

class Customnet {
  List<NodeModel>? nodes;

  Customnet({this.nodes});

  Customnet.fromJson(List? json) {
    nodes = json == null
        ? null
        : List<NodeModel>.from(json.map((e) => NodeModel.fromJson(e)));
  }
}

class Testnet {
  List<NodeModel>? nodes;

  Testnet({this.nodes});

  Testnet.fromJson(List? json) {
    nodes = json == null
        ? null
        : List<NodeModel>.from(json.map((e) => NodeModel.fromJson(e)));
  }
}

class Mainnet {
  List<NodeModel>? nodes;

  Mainnet({this.nodes});

  Mainnet.fromJson(List? json) {
    nodes = json == null
        ? null
        : List<NodeModel>.from(json.map((e) => NodeModel.fromJson(e)));
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
