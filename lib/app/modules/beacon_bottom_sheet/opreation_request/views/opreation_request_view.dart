import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/opreation_request_controller.dart';

class OpreationRequestView extends GetView<OpreationRequestController> {
  const OpreationRequestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OpreationRequestView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'OpreationRequestView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
