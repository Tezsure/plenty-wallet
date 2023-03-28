import 'package:get/get.dart';
import 'package:naan_wallet/app/data/services/service_models/event_models.dart';

import '../../../data/services/data_handler_service/data_handler_service.dart';

class VCAEventsController extends GetxController {
  RxMap<String, List<EventModel>> events = <String, List<EventModel>>{
    "Today": [],
    "Tomorrow": [],
    "This Week": [],
    "Next Week": [],
    "This Month": [],
    "Next Month": [],
    "This Year": [],
  }.obs;

  Map<String, List<EventModel>> eventsUnfiltered = <String, List<EventModel>>{
    "Today": [],
    "Tomorrow": [],
    "This Week": [],
    "Next Week": [],
    "This Month": [],
    "Next Month": [],
    "This Year": [],
  };

  RxInt selectedTab = 0.obs;

  RxList tags = [].obs;
  @override
  void onInit() async {
    super.onInit();
    eventsUnfiltered = await DataHandlerService().getVCAEventsDetail(
      events: events,
      tags: tags,
      //todo send stalls params
    );
  }

  void changeFilter(int index) {
    selectedTab.value = index;
    if (index == 0) {
      events.value = eventsUnfiltered;
      return;
    }

    if (tags.value.isNotEmpty) {
      events.value = eventsUnfiltered.map((key, value) {
        return MapEntry(
            key,
            value
                .where((element) =>
                    element.tag.toString().toLowerCase() ==
                    tags[index - 1].toString().toLowerCase())
                .toList());
      });
    }
  }
}
