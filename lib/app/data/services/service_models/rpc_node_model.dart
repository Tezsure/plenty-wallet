
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
}

class Testnet {
  List<NodeModel>? nodes;

  Testnet({this.nodes});

  Testnet.fromJson(json) {
    nodes = json == null
        ? null
        : List<NodeModel>.from(json.entries
            .map((k) => NodeModel(name: k.key, url: k.value))
            .toList());
  }
}

class Mainnet {
  List<NodeModel>? nodes;

  Mainnet({this.nodes});

  Mainnet.fromJson(json) {
    nodes = json == null
        ? null
        : List<NodeModel>.from(json.entries
            .map((k) => NodeModel(name: k.key, url: k.value))
            .toList());
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

  Map<String, String> toJson() {
    // final Map<String, dynamic> data = <String, dynamic>{};
    return {name ?? "": url ?? ""};
    // if (name != null) {
    //   data["name"] = name;
    // }
    // if (url != null) {
    //   data["url"] = url;
    // }
    // return data;
  }
}
