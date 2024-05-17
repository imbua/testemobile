import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemobile/controllers/login_controller.dart';
import 'package:testemobile/controllers/mytreeview_controller.dart';
import 'package:testemobile/models/mytreeview.dart';

class MyTreeViewView extends StatelessWidget {
  MyTreeViewView({super.key});
  final loginController = Get.find<LoginController>();

  final MyTreeViewController controller = Get.find<MyTreeViewController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[200],
      appBar: AppBar(
        backgroundColor: Colors.red[200],
        leading: IconButton(
          color: Colors.white,
          // Adicionando um ícone de voltar à esquerda da AppBar
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.offNamed('login');
          },
        ),
      ),
      body: Obx(
        () {
          if (controller.treeData.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Column(
              children: [
                Container(
                  height: 80,
                  padding: EdgeInsets.only(left: 20),
                  color: Colors.red[200],
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Text(
                            'Heloo',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            loginController.username.value,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ClipPath(
                    clipper: TopRoundedClipper(),
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(20),
                      child: ListView(
                        children: controller.treeData
                            .map((node) => buildNode(context, node))
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildNode(BuildContext context, MyTreeView node, {int level = 0}) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0 * level),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          node.children.isEmpty
              ? ListTile(
                  title: Row(
                    children: [
                      Text(node.name),
                      const SizedBox(
                        width: 20,
                      ),
                      TreeviewBotaoEdit(
                        treeviewcontroller: controller,
                        node: node,
                      ),
                    ],
                  ),
                  leading: const Icon(
                    Icons.sensors,
                    color: Colors.grey,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                )
              : ExpansionTile(
                  key: PageStorageKey<int>(node.id),
                  title: Row(
                    children: [
                      Text(node.name),
                      const SizedBox(
                        width: 20,
                      ),
                      TreeviewBotaoEdit(
                        treeviewcontroller: controller,
                        node: node,
                      ),
                    ],
                  ),
                  leading: const Icon(
                    Icons.folder_open,
                    color: Colors.black54,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  children: node.children
                      .map((child) =>
                          buildNode(context, child, level: level + 1))
                      .toList(),
                ),
        ],
      ),
    );
  }
}

class TreeviewBotaoEdit extends StatelessWidget {
  final MyTreeView node;
  final MyTreeViewController treeviewcontroller;

  const TreeviewBotaoEdit({
    super.key,
    required this.node,
    required this.treeviewcontroller,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.edit_outlined,
        color: Colors.red[300],
      ), // Replace with your desired icon
      onPressed: () {
        // Handle your onPressed event here
        showModalBottomSheet(
          context: context,

          isScrollControlled: true, // Allow scrolling if content is long

          builder: (BuildContext context) {
            return EditNodeBottomSheet(
                controller: treeviewcontroller, node); // Pass the current node
          },
        );
      },
    );
  }
}

class EditNodeBottomSheet extends StatelessWidget {
  final MyTreeView node; // Assuming MyTreeView is your node model
  final MyTreeViewController controller;
  EditNodeBottomSheet(this.node, {super.key, required this.controller});
  final TextEditingController _textEditingController =
      TextEditingController(); // Definindo o TextEditingController

  String getLabelText(int level) {
    switch (level) {
      case 0:
        return 'Edit Area';
      case 1:
        return 'Edit Setor';
      case 2:
        return 'Edit Conjunto';
      case 3:
        return 'Edit Equipamento';
      default:
        return 'Edit Node';
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width - 20;
    double buttonWidth = screenWidth - 10;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 16.0,
          left: 16.0,
          right: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: screenWidth,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textEditingController,
                      decoration: InputDecoration(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.red,

                          size: 30.0, // Adjust icon size as needed
                        ),
                        labelText: getLabelText(node.level),
                        labelStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () {
                  controller.updateNodeName(
                      node.id, _textEditingController.text);

                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors
                      .red[200]!
                      .withOpacity(1.0)), // Define a cor de fundo como vermelha
                ),
                child: const Text('Confirm'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: buttonWidth,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TopRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 80);
    path.quadraticBezierTo(0, 0, 80, 0); // Canto superior esquerdo arredondado
    path.lineTo(size.width - 80, 0);
    path.quadraticBezierTo(
        size.width, 0, size.width, 80); // Canto superior direito arredondado
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
