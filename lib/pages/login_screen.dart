import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storedge/providers/AuthProvider.dart';

class Login_Screen extends StatefulWidget {
  const Login_Screen({super.key});

  @override
  State<Login_Screen> createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {

final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signIn() async{
    final authService = Provider.of<AuthService>(context, listen: false);

    try{
      await authService.signInEmail(emailController.text.trim(), passwordController.text.trim());
      Navigator.pushNamed(context, '/start');
    }catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Добро пожаловать!"),
            const SizedBox(height: 50,),
            SizedBox(width: 200, child: TextField(controller: emailController, decoration: InputDecoration(hintText: "Почта"),)),
            const SizedBox(height: 30,),
            SizedBox(width: 200, child: TextField(controller: passwordController, decoration: InputDecoration(hintText: "Пароль"),)),
            const SizedBox(height: 60,),
            SizedBox(width: 150, child: ElevatedButton(onPressed: () {signIn();}, child: const Text("Войти"))),
            const SizedBox(height: 60,),
            SizedBox(width: 200, child: ElevatedButton(onPressed: () {Navigator.pushNamed(context, "/registr");}, child: const Text("Создать аккаунт")))
          ],
        ),
      ),
    );
  }
}