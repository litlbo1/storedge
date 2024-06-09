import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/AuthProvider.dart';

class Registr_Screen extends StatefulWidget {
  const Registr_Screen({super.key});

  @override
  State<Registr_Screen> createState() => _Registr_ScreenState();
}

class _Registr_ScreenState extends State<Registr_Screen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void signUp() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUp(_emailController.text.trim(), _passwordController.text.trim(), _nameController.text.trim());
      Navigator.pushNamed(context, '/start');
    } catch (e) {
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
            const SizedBox(height: 50),
            SizedBox(width: 200, child: TextField(controller: _emailController, decoration: InputDecoration(hintText: "Почта"))),
            const SizedBox(height: 30),
            SizedBox(width: 200, child: TextField(controller: _nameController, decoration: InputDecoration(hintText: "Имя"))),
            const SizedBox(height: 30),
            SizedBox(width: 200, child: TextField(controller: _passwordController, decoration: InputDecoration(hintText: "Пароль"), obscureText: true)),
            const SizedBox(height: 60),
            SizedBox(width: 230, child: ElevatedButton(onPressed: signUp, child: const Text("Зарегистрироваться")))
          ],
        ),
      ),
    );
  }
}
