import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future<void> generateAndSavePdf(BuildContext context, String warehouseId) async {
  final pdf = pw.Document();

  // Заголовок документа
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Накладная для склада №$warehouseId', style: pw.TextStyle(fontSize: 24)),
            pw.Divider(),
            pw.Text('Товары:', style: pw.TextStyle(fontSize: 18)),
            // Пример товаров, добавьте реальные данные
            pw.Bullet(text: "Товар 1: Количество - 5"),
            pw.Bullet(text: "Товар 2: Количество - 3"),
            // Добавьте другие данные по необходимости
          ],
        );
      }
    ),
  );

  // Предложение пользователю сохранить файл
  await Printing.sharePdf(bytes: await pdf.save(), filename: 'invoice_$warehouseId.pdf');
}
