import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storedge/providers/AuthProvider.dart';

class Add_Screen extends StatefulWidget {
  const Add_Screen({super.key});

  @override
  State<Add_Screen> createState() => _Add_ScreenState();
}

class _Add_ScreenState extends State<Add_Screen> {

  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final capacityController = TextEditingController();
  final descriptionController = TextEditingController();
  final numberController = TextEditingController();

  void setNewData() async {
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.new_warehouse(nameController.text.trim(),
       addressController.text.trim(),
       capacityController.text.trim(),
        descriptionController.text.trim(),
        numberController.text.trim());
      Navigator.pushNamed(context, '/start');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Склад добавлен'),
          ),
        );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Добавление Склада"),),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
              controller: nameController,
              style: const TextStyle(color: Color(0xFFD1D1D1)),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Введите наименование',
                  hintStyle: const TextStyle(color: Color(0xFFD1D1D1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          width: 0, 
                          style: BorderStyle.none,
                      ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(9),
                  fillColor: const Color(0xff808080),
              ),
            ),
            ),
            
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
              controller: addressController,
              style: const TextStyle(color: Color(0xFFD1D1D1)),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Введите адрес',
                  hintStyle: const TextStyle(color: Color(0xFFD1D1D1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          width: 0, 
                          style: BorderStyle.none,
                      ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(9),
                  fillColor: const Color(0xff808080),
              ),
            ),
            ),
            
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
              controller: capacityController,
              style: const TextStyle(color: Color(0xFFD1D1D1)),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Введите вместимость',
                  hintStyle: const TextStyle(color: Color(0xFFD1D1D1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          width: 0, 
                          style: BorderStyle.none,
                      ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(9),
                  fillColor: const Color(0xff808080),
              ),
            ),
            ),
            
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
              controller: descriptionController,
              style: const TextStyle(color: Color(0xFFD1D1D1)),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Описание',
                  hintStyle: const TextStyle(color: Color(0xFFD1D1D1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          width: 0, 
                          style: BorderStyle.none,
                      ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(9),
                  fillColor: const Color(0xff808080),
              ),
            ),
            ),
            
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: TextField(
              controller: numberController,
              style: const TextStyle(color: Color(0xFFD1D1D1)),
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: 'Номер Склада',
                  hintStyle: const TextStyle(color: Color(0xFFD1D1D1)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          width: 0, 
                          style: BorderStyle.none,
                      ),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.all(9),
                  fillColor: const Color(0xff808080),
              ),
            ),
            ),
            
            SizedBox(height: 40,),
            SizedBox(width: 200, height: 40, child: ElevatedButton(onPressed: () {setNewData();}, child: Text("Сохранить")))
          ],
        ),
      ),
    );
  }
}