import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart' show rootBundle;

class DocsGenScreen extends StatefulWidget {
  const DocsGenScreen({Key? key}) : super(key: key);

  @override
  State<DocsGenScreen> createState() => _DocsGenScreenState();
}

class _DocsGenScreenState extends State<DocsGenScreen> {
Future<void> generateAndSavePdf(String warehouseId) async {
  // Загрузка шрифта
  final fontData = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
  final ttf = pw.Font.ttf(fontData.buffer.asByteData());

  final pdf = pw.Document();

  // Получение данных товаров со склада
  var productsSnapshot = await FirebaseFirestore.instance
    .collection('warehouses')
    .doc(warehouseId)
    .collection('products')
    .get();

  // Создаем список строк для таблицы в PDF
  List<List<String>> productsTable = [
    <String>['ID', 'Название', 'Количество', 'Цена'] // Заголовки столбцов
  ];

  for (var doc in productsSnapshot.docs) {
    productsTable.add([
      doc.id, // ID товара
      doc['name'], // Название товара
      doc['quantity'].toString(), // Количество
      doc['price'].toString() + ' руб.' // Цена
    ]);
  }

  // Добавляем страницу в PDF
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text("Накладная для склада №$warehouseId", style: pw.TextStyle(fontSize: 20, font: ttf)),
            pw.SizedBox(height: 20),
            pw.Table.fromTextArray(
              context: context,
              headerStyle: pw.TextStyle(font: ttf, fontSize: 14),
              cellStyle: pw.TextStyle(font: ttf, fontSize: 12),
              data: productsTable,
            ),
          ],
        );
      }
    )
  );

  // Запрос разрешения на хранение
  var status = await Permission.storage.request();
  if (!status.isGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Необходимо разрешение на использование хранилища для сохранения файла'))
    );
    return;
  }

  // Сохранение PDF файла
  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
  if (selectedDirectory == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Выбор папки отменен пользователем'))
    );
    return;
  }

  final file = File('$selectedDirectory/invoice_$warehouseId.pdf');
  await file.writeAsBytes(await pdf.save());
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Файл сохранен в: $selectedDirectory'))
  );
}

  void showWarehouseSelectionDialog() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('warehouses').get();
    final List<DocumentSnapshot> warehouses = querySnapshot.docs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Выберите склад"),
          content: Container(
            width: double.maxFinite,
            child: ListView(
              children: warehouses.map((doc) {
                return ListTile(
                  title: Text(doc['number'] ?? 'Нет номера'),
                  subtitle: Text(doc['description'] ?? 'Описание отсутствует'),
                  onTap: () {
                    Navigator.of(context).pop(); // Закрыть диалог
                    generateAndSavePdf(doc.id);
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: showWarehouseSelectionDialog,
              child: const Text("Сделать накладную по складу")
            )
          ],
        )
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: DocsGenScreen()));
}
