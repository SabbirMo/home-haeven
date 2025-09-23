import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../home/model/home_model.dart';

class HomeController extends GetxController {
  var allItem = <HomeModel>[].obs;
  var filterItem = <HomeModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void fetchData() {
    FirebaseFirestore.instance
        .collection('products')
        .orderBy('id')
        .snapshots()
        .listen((snapshot) {
      allItem.value =
          snapshot.docs.map((doc) => HomeModel.fromJson(doc.data())).toList();

      filterItem.value = allItem;
      print("Realtime Data fetched: ${allItem.length} items");
    });
  }

  void searchProduct(String query) {
    if (query.isEmpty) {
      filterItem.value = allItem;
    } else {
      filterItem.value = allItem.where((item) {
        return item.title.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
  }
}
