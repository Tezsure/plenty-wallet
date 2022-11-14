// ignore_for_file: prefer_typing_uninitialized_variables

class NftTokenModel {
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

  NftTokenModel(
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

  NftTokenModel.fromJson(Map<String, dynamic> json) {
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
        royalties!.add(Royalties.fromJson(v));
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
        creators!.add(Creators.fromJson(v));
      });
    }
    if (json['holders'] != null) {
      holders = <Holders>[];
      json['holders'].forEach((v) {
        holders!.add(Holders.fromJson(v));
      });
    }
    if (json['events'] != null) {
      events = <Events>[];
      json['events'].forEach((v) {
        events!.add(Events.fromJson(v));
      });
    }
    fa = json['fa'] != null ? Fa.fromJson(json['fa']) : null;
    metadata = json['metadata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['artifact_uri'] = artifactUri;
    data['description'] = description;
    data['display_uri'] = displayUri;
    data['lowest_ask'] = lowestAsk;
    data['level'] = level;
    data['mime'] = mime;
    data['pk'] = pk;
    if (royalties != null) {
      data['royalties'] = royalties!.map((v) => v.toJson()).toList();
    }
    data['supply'] = supply;
    data['thumbnail_uri'] = thumbnailUri;
    data['timestamp'] = timestamp;
    data['fa_contract'] = faContract;
    data['token_id'] = tokenId;
    data['name'] = name;
    if (creators != null) {
      data['creators'] = creators!.map((v) => v.toJson()).toList();
    }
    if (holders != null) {
      data['holders'] = holders!.map((v) => v.toJson()).toList();
    }
    if (events != null) {
      data['events'] = events!.map((v) => v.toJson()).toList();
    }
    if (fa != null) {
      data['fa'] = fa!.toJson();
    }
    data['metadata'] = metadata;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['decimals'] = decimals;
    data['amount'] = amount;
    return data;
  }
}

class Creators {
  String? creatorAddress;
  int? tokenPk;
  FaHolder? holder;

  Creators({this.creatorAddress, this.tokenPk, this.holder});

  Creators.fromJson(Map<String, dynamic> json) {
    creatorAddress = json['creator_address'];
    tokenPk = json['token_pk'];
    holder = FaHolder.fromJson(json['holder']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['creator_address'] = creatorAddress;
    data['token_pk'] = tokenPk;
    data['holder'] = holder!.toJson();
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['quantity'] = quantity;
    data['holder_address'] = holderAddress;
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
        json['creator'] != null ? Creator.fromJson(json['creator']) : null;
    eventType = json['event_type'];
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fa_contract'] = faContract;
    data['price'] = price;
    data['recipient_address'] = recipientAddress;
    data['timestamp'] = timestamp;
    if (creator != null) {
      data['creator'] = creator!.toJson();
    }
    data['event_type'] = eventType;
    data['amount'] = amount;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['alias'] = alias;
    return data;
  }
}

class Fa {
  String? name;
  String? collectionType;
  int? floorPrice;
  String? logo;
  String? contract;
  String? description;

  Fa({
    this.name,
    this.collectionType,
    this.floorPrice,
    this.contract,
    this.logo,
    this.description,
  });

  Fa.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    collectionType = json['collection_type'];
    floorPrice = json['floor_price'];
    logo = json['logo'] ?? "";
    contract = json['contract'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['collection_type'] = collectionType;
    data['floor_price'] = floorPrice;
    data['logo'] = logo;
    data['contract'] = contract;
    data['description'] = description;
    return data;
  }
}

class FaHolder {
  String? alias;
  String? address;

  FaHolder({this.alias, this.address});

  FaHolder.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alias'] = alias;
    data['address'] = address;
    return data;
  }
}

class FaHolder {
  String? alias;
  String? address;

  FaHolder({this.alias, this.address});

  FaHolder.fromJson(Map<String, dynamic> json) {
    alias = json['alias'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['alias'] = alias;
    data['address'] = address;
    return data;
  }
}
