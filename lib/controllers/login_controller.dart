import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:testemobile/controllers/mytreeview_controller.dart';

class LoginController extends GetxController {
  final RxString username = RxString(''); // Use RxString for reactive updates
  final RxString password = RxString('');
  final RxBool isLoading = RxBool(false);
  final RxString accessToken = RxString('');

  final MyTreeViewController myTreeVewController =
      Get.find<MyTreeViewController>();

  Future<void> login() async {
    isLoading.value = true;

    final Map<String, String> data = {
      'username': 'user_test', //username.value, user_test
      'password': 'test_password', //password.value, test_password
    };

    try {
      String jsonData = json.encode(data);

      final response = await http.post(
        Uri.parse('https://apitestemobile-production.up.railway.app/login'),
        body: jsonData,
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        accessToken.value = jsonResponse['access_token'];
        Get.snackbar('Success', 'Login successful');

        //Preenche Depois do Login
        await fetchTreeData();

        Get.offNamed('/mytreeview'); // Navega para a página home
      } else {
        Get.snackbar('Error', 'Invalid username or password');
      }
    } catch (e) {
      // print('Error: $e');
      Get.snackbar('Error', 'Failed to connect to the server');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTreeData() async {
    String url = 'https://apitestemobile-production.up.railway.app/tree';
    final Map<String, String> headers = {
      'Authorization': 'Bearer ${accessToken.value}',
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = response.body;
        await myTreeVewController.loadTreeData(jsonData);
        // Process the fetched tree data (replace with your logic)
      } else {
        Get.snackbar('Error', 'Failed to fetch tree data');
      }
    } catch (e) {
      // print('Error: $e');
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  }
}
