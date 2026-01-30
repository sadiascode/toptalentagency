import 'package:get/get.dart';
import '../../services/api_service.dart';

class ManagerController extends GetxController {
  var isLoading = false.obs;
  var managerCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchManagerCount();
  }

  Future<void> fetchManagerCount() async {
    try {
      isLoading.value = true;
      final count = await ApiService.fetchManagerCount();
      managerCount.value = count;
    } catch (e) {
      managerCount.value = 0;
      print("Error fetching managers: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
