import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testemobile/controllers/login_controller.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final loginController = Get.find<LoginController>();

  @override
  Widget build(BuildContext context) {
    // Obtém o tamanho da tela
    var screenSize = MediaQuery.of(context).size;
    double screenWidth = MediaQuery.of(context).size.width - 20;
    double buttonWidth = screenWidth - 10;

    return Scaffold(
      backgroundColor: Colors.red[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height:
                    screenSize.height * 0.25, // Proporcional à altura da tela
                color: Colors.red[200],
                child: const Center(
                  child: CustomRoundedContainer(
                    height: 100,
                    width: 100,
                    color: Colors.white,
                    child: Center(
                      child: Icon(
                        Icons.person_sharp,
                        size: 100,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),
              ClipPath(
                clipper: TopLeftRoundedClipper(),
                child: Container(
                  width: screenSize.width,
                  height:
                      screenSize.height * 0.75, // Proporcional à altura da tela
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Welcome',
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.red,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 50,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'User',
                              style: TextStyle(color: Colors.red, fontSize: 20),
                              //hintText: 'User',
                            ),
                          ],
                        ),
                        TextField(
                          onChanged: (value) =>
                              loginController.username.value = value,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                        ),
                        const Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Password',
                              style: TextStyle(color: Colors.red, fontSize: 20),
                              //hintText: 'User',
                            ),
                          ],
                        ),
                        TextField(
                          onChanged: (value) =>
                              loginController.password.value = value,
                          decoration: InputDecoration(
                            border: UnderlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(40),
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),
                        Obx(() => loginController.isLoading.value
                            ? const CircularProgressIndicator()
                            : SizedBox(
                                width: buttonWidth,
                                child: ElevatedButton(
                                  onPressed: loginController.login,
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all<
                                            Color>(
                                        Colors.red[200]!.withOpacity(
                                            1.0)), // Define a cor de fundo como vermelha
                                  ),
                                  child: const Text('LOGIN'),
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom clipper para o corpo com canto superior esquerdo arredondado
class TopLeftRoundedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 150);
    path.quadraticBezierTo(0, 0, 150, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CustomRoundedContainer extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final Widget child;

  const CustomRoundedContainer({
    super.key,
    required this.height,
    required this.width,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: CustomShapeClipper(),
      child: Container(
        height: height,
        width: width,
        color: color,
        child: child,
      ),
    );
  }
}

class CustomShapeClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 40); // Início com borda arredondada
    path.quadraticBezierTo(0, 0, 40, 0); // Canto superior esquerdo arredondado
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height - 40);
    path.quadraticBezierTo(size.width, size.height, size.width - 40,
        size.height); // Canto inferior direito arredondado
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
