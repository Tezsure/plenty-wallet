class NFTToken {
  String? artifactUri;
  var description;
  String? displayUri;
  var lowestAsk;
  int? level;
  String? mime;
  int? pk;
  List<Royalties>? royalties;
  int? supply;
  String? thumbnailUri;
  String? timestamp;
  String? faContract;
  String? tokenId;
  String? name;
  List<Creators>? creators;
  List<Holders>? holders;
  List<Events>? events;
  Fa? fa;
  String? metadata;

  NFTToken(
      {this.artifactUri,
      this.description,
      this.displayUri,
      this.lowestAsk,
      this.level,
      this.mime,
      this.pk,
      this.royalties,
      this.supply,
      this.thumbnailUri,
      this.timestamp,
      this.faContract,
      this.tokenId,
      this.name,
      this.creators,
      this.holders,
      this.events,
      this.fa,
      this.metadata});

  NFTToken.fromJson(Map<String, dynamic> json) {
    artifactUri = json['artifact_uri'];
    description = json['description'];
    displayUri = json['display_uri'];
    lowestAsk = json['lowest_ask'];
    level = json['level'];
    mime = json['mime'];
    pk = json['pk'];
    if (json['royalties'] != null) {
      royalties = <Royalties>[];
      json['royalties'].forEach((v) {
        royalties!.add(new Royalties.fromJson(v));
      });
    }
    supply = json['supply'];
    thumbnailUri = json['thumbnail_uri'];
    timestamp = json['timestamp'];
    faContract = json['fa_contract'];
    tokenId = json['token_id'];
    name = json['name'];
    if (json['creators'] != null) {
      creators = <Creators>[];
      json['creators'].forEach((v) {
        creators!.add(new Creators.fromJson(v));
      });
    }
    if (json['holders'] != null) {
      holders = <Holders>[];
      json['holders'].forEach((v) {
        holders!.add(new Holders.fromJson(v));
      });
    }
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(new Events.fromJson(v));
      });
    }
    fa = json['fa'] != null ? new Fa.fromJson(json['fa']) : null;
    metadata = json['metadata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artifact_uri'] = this.artifactUri;
    data['description'] = this.description;
    data['display_uri'] = this.displayUri;
    data['lowest_ask'] = this.lowestAsk;
    data['level'] = this.level;
    data['mime'] = this.mime;
    data['pk'] = this.pk;
    if (this.royalties != null) {
      data['royalties'] = this.royalties!.map((v) => v.toJson()).toList();
    }
    data['supply'] = this.supply;
    data['thumbnail_uri'] = this.thumbnailUri;
    data['timestamp'] = this.timestamp;
    data['fa_contract'] = this.faContract;
    data['token_id'] = this.tokenId;
    data['name'] = this.name;
    if (this.creators != null) {
      data['creators'] = this.creators!.map((v) => v.toJson()).toList();
    }
    if (this.holders != null) {
      data['holders'] = this.holders!.map((v) => v.toJson()).toList();
    }
    if (this.events != null) {
      data['events'] = this.events!.map((v) => v.toJson()).toList();
    }
    if (this.fa != null) {
      data['fa'] = this.fa!.toJson();
    }
    data['metadata'] = this.metadata;
    return data;
  }
}

class Royalties {
  int? id;
  int? decimals;
  int? amount;

  Royalties({this.id, this.decimals, this.amount});

  Royalties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    decimals = json['decimals'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['decimals'] = this.decimals;
    data['amount'] = this.amount;
    return data;
  }
}

class Creators {
  String? creatorAddress;
  int? tokenPk;

  Creators({this.creatorAddress, this.tokenPk});

  Creators.fromJson(Map<String, dynamic> json) {
    creatorAddress = json['creator_address'];
    tokenPk = json['token_pk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['creator_address'] = this.creatorAddress;
    data['token_pk'] = this.tokenPk;
    return data;
  }
}

class Holders {
  int? quantity;
  String? holderAddress;

  Holders({this.quantity, this.holderAddress});

  Holders.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
    holderAddress = json['holder_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quantity'] = this.quantity;
    data['holder_address'] = this.holderAddress;
    return data;
  }
}

class Events {
  int? id;
  String? faContract;
  var price;
  String? recipientAddress;
  String? timestamp;
  Creator? creator;
  String? eventType;
  int? amount;

  Events(
      {this.id,
      this.faContract,
      this.price,
      this.recipientAddress,
      this.timestamp,
      this.creator,
      this.eventType,
      this.amount});

  Events.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    faContract = json['fa_contract'];
    price = json['price'];
    recipientAddress = json['recipient_address'];
    timestamp = json['timestamp'];
    creator =
        json['creator'] != null ? new Creator.fromJson(json['creator']) : null;
    eventType = json['event_type'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fa_contract'] = this.faContract;
    data['price'] = this.price;
    data['recipient_address'] = this.recipientAddress;
    data['timestamp'] = this.timestamp;
    if (this.creator != null) {
      data['creator'] = this.creator!.toJson();
    }
    data['event_type'] = this.eventType;
    data['amount'] = this.amount;
    return data;
  }
}

class Creator {
  String? address;
  String? alias;

  Creator({this.address, this.alias});

  Creator.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    alias = json['alias'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['alias'] = this.alias;
    return data;
  }
}

class Fa {
  String? name;
  String? collectionType;
  int? floorPrice;

  Fa({this.name, this.collectionType, this.floorPrice});

  Fa.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    collectionType = json['collection_type'];
    floorPrice = json['floor_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['collection_type'] = this.collectionType;
    data['floor_price'] = this.floorPrice;
    return data;
  }
}
