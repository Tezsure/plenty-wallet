import 'dart:math';

import 'package:naan_wallet/app/data/services/service_config/service_config.dart';
import 'package:naan_wallet/app/data/services/service_models/contact_model.dart';
import 'package:simple_gql/simple_gql.dart';
import 'package:naan_wallet/utils/utils.dart';

class TezosDomainService {
  final apiUrl = "https://api.tezos.domains/graphql";

  Future<List<ContactModel>> searchUsingText(String text) async {
    if (text.isEmpty) return <ContactModel>[];
    bool isAddress = false;
    var query = """{
  domains(where: {name: {startsWith: "$text"},}) {
    items {
      address
      owner
      name
      level
    }
  }
}
""";
    if (text.isValidWalletAddress) {
      isAddress = true;
      query = """
  {
  reverseRecords(
    where: {
      address: {
        in: [
          "$text"
        ]
      }
    }
  ) {
    items {
      address
      owner
      domain {
        name
      }
    }
  }
}
""";
    }

    try {
      var response = await GQLClient(apiUrl).query(query: query);
      return response.data[isAddress ? 'reverseRecords' : 'domains']['items']
          .where((e) => e['address'] != null || e['owner'] != null)
          .toList()
          .map<ContactModel>(
            (e) => ContactModel(
              name: isAddress ? e['domain']['name'] : e['name'],
              address: e['address'] ?? e['owner'],
              imagePath: ServiceConfig.allAssetsProfileImages[Random().nextInt(
                ServiceConfig.allAssetsProfileImages.length - 1,
              )],
            ),
          )
          .toList();
    } catch (e) {
      return <ContactModel>[];
    }
  }
}
