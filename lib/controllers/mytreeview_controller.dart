import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:testemobile/controllers/login_controller.dart';
import 'package:testemobile/models/mytreeview.dart';

class MyTreeViewController extends GetxController {
  var treeData = <MyTreeView>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Inicializa a árvore com dados de exemplo ou carregados
    loadTreeData('');
  }

  Future<void> updateNodeName(int nodeId, String newName) async {
    // Função recursiva para atualizar o nome de um nó em qualquer nível da árvore
    bool updateNode(List<MyTreeView> nodes) {
      for (int i = 0; i < nodes.length; i++) {
        if (nodes[i].id == nodeId) {
          nodes[i] = nodes[i].copyWith(name: newName);
          return true; // Retorna true se o nó foi encontrado e atualizado
        } else if (nodes[i].children.isNotEmpty) {
          bool updated = updateNode(nodes[i].children);
          if (updated)
            return true; // Propaga o true se o nó foi encontrado e atualizado nos filhos
        }
      }
      return false; // Retorna false se o nó não foi encontrado
    }

    bool updated = updateNode(treeData);
    if (updated) {
      treeData
          .refresh(); // Atualiza a lista observável para refletir as mudanças
      await _updateNodeNameOnServer(nodeId, newName);
    } else {
      Get.snackbar('Error', 'Node not found');
    }
  }

  Future<void> _updateNodeNameOnServer(int nodeId, String newName) async {
    final loginController = Get.find<LoginController>();

    final url =
        Uri.parse('https://apitestemobile-production.up.railway.app/tree');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${loginController.accessToken.value}',
    };
    final body = jsonEncode({
      'id': nodeId,
      'name': newName,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Node name updated successfully on server');
      } else {
        Get.snackbar('Error', 'Failed to update node name on server');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  }

  Future<void> loadTreeData(String jsonString) async {
    try {
      if (jsonString.isNotEmpty) {
        List<dynamic> jsonData = jsonDecode(jsonString);
        treeData.value = MyTreeView.fromJsonList(jsonData);
      } else {
        // Se a resposta não for bem-sucedida, exibe uma mensagem de erro
        //Get.snackbar('Error', 'Failed to load tree data');
      }
    } catch (e) {
      // Se ocorrer algum erro durante a solicitação, exibe uma mensagem de erro
      Get.snackbar('Error', 'Failed to connect to the server');
    }
  }
}
