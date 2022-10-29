import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/payload_request_controller.dart';

class PayloadRequestView extends GetView<PayloadRequestController> {
  const PayloadRequestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PayloadRequestView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'PayloadRequestView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
