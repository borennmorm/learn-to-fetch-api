import 'package:get/get.dart';

import '../models/user.dart';
import '../services/api_service.dart';

class UserController extends GetxController {
  var users = <User>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
    super.onInit();
  }

  void fetchUsers() async {
    try {
      isLoading(true);
      var fetchedUsers = await ApiService.fetchUsers();
      if (fetchedUsers.isNotEmpty) {
        users.value = fetchedUsers;
      }
    } finally {
      isLoading(false);
    }
  }
}
