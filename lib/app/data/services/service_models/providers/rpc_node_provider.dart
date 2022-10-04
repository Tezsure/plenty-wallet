import 'package:get/get.dart';

import '../rpc_node_model.dart';

class RpcNodeProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return NodeSelectorModel.fromJson(map);
      if (map is List) {
        return map.map((item) => NodeSelectorModel.fromJson(item)).toList();
      }
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<NodeSelectorModel?> getRpcNode(int id) async {
    final response = await get('rpcnode/$id');
    return response.body;
  }

  Future<Response<NodeSelectorModel>> postRpcNode(
          NodeSelectorModel rpcnode) async =>
      await post('rpcnode', rpcnode);
  Future<Response> deleteRpcNode(int id) async => await delete('rpcnode/$id');
}
