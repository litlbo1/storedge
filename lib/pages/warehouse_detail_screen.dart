import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:storedge/providers/AuthProvider.dart';

class WarehouseDetailScreen extends StatelessWidget {
  final String warehouseId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  WarehouseDetailScreen({required this.warehouseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Детали склада'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('warehouses').doc(warehouseId).collection("products").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Text("Ошибка: ${snapshot.error}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          var documents = snapshot.data!.docs;

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Название')),
                DataColumn(label: Text('Цена')),
                DataColumn(label: Text('Количество')),
              ],
              rows: documents.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return DataRow(
                  cells: [
                    DataCell(Text(data['name'] ?? 'Недоступно')),
                    DataCell(Text('${data['price'] ?? 0} руб.')),
                    DataCell(Text('${data['quantity'] ?? 0}')),
                  ]
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddProductDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Добавить товар',
      ),
    );
  }

  void _showAddProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Добавить новый товар'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Название'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите название';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Цена'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите цену';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Количество'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Пожалуйста, введите количество';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Отмена'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Сохранить'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _addProduct(context);
              }
            },
          ),
        ],
      ),
    );
  }

void _addProduct(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    int quantity = int.tryParse(_quantityController.text) ?? 0;
    double spacePerItem = 10.0;  // Каждый товар занимает 10 места
    double additionalSpace = quantity * spacePerItem;

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference warehouseRef = FirebaseFirestore.instance.collection('warehouses').doc(warehouseId);
        DocumentSnapshot warehouseSnapshot = await transaction.get(warehouseRef);
        if (!warehouseSnapshot.exists) {
          throw Exception("Склад не найден!");
        }
        Map<String, dynamic> warehouseData = warehouseSnapshot.data() as Map<String, dynamic>;
        double currentCapacity = double.tryParse(warehouseData['currentCapacity'].toString()) ?? 0.0;
        double totalCapacity = double.tryParse(warehouseData['capacity'].toString()) ?? 0.0;

        if (currentCapacity + additionalSpace > totalCapacity) {
          // Если после добавления товара превышена вместимость склада
          throw Exception("Недостаточно места на складе для добавления товара!");
        }

        transaction.update(warehouseRef, {
          'currentCapacity': currentCapacity + additionalSpace,
        });

        transaction.set(warehouseRef.collection("products").doc(), {
          'name': _nameController.text,
          'price': double.tryParse(_priceController.text) ?? 0,
          'quantity': quantity,
        });
      });

      Navigator.of(context).pop();  // Закрыть диалоговое окно
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Товар добавлен и место обновлено')),
      );
    } catch (error) {
      if (error is Exception) {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text('Ошибка'),
              content: Text(error.toString()),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();  // Закрыть только диалог ошибки
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    // Очистка контроллеров после всех операций
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();
  }
}




}
