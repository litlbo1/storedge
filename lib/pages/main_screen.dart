import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:storedge/pages/warehouse_detail_screen.dart';

class ProductCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('warehouses').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Произошла ошибка: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        var documents = snapshot.data!.docs;
        var carouselOptions = CarouselOptions(
          height: 600,
          enlargeCenterPage: true,
          autoPlay: false,
          aspectRatio: 16/9,
          enableInfiniteScroll: false,
          initialPage: 0,
        );

        return CarouselSlider(
          options: carouselOptions,
          items: documents.map((document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            double currentCapacity = double.tryParse(data['currentCapacity'].toString()) ?? 0.0;
            double totalCapacity = double.tryParse(data['capacity'].toString()) ?? 0.0;

            double filledPercentage = (currentCapacity / totalCapacity) * 100;
            double freePercentage = 100 - filledPercentage;

            Map<String, double> dataMap = {
              "Заполнено": filledPercentage,
              "Свободно": freePercentage,
            };

            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(
                    color: Colors.amber,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Склад номер: ${data['number']}", style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(data['description']),
                      ),
                      const SizedBox(height: 30,),
                      PieChart(
                        dataMap: dataMap,
                        animationDuration: const Duration(milliseconds: 800),
                        chartLegendSpacing: 32,
                        chartRadius: MediaQuery.of(context).size.width / 3,
                        colorList: const [Colors.blue, Colors.lightBlueAccent],
                        initialAngleInDegree: 0,
                        chartType: ChartType.ring,
                        ringStrokeWidth: 32,
                        centerText: "100%",
                        legendOptions: const LegendOptions(
                          showLegendsInRow: false,
                          legendPosition: LegendPosition.right,
                          showLegends: true,
                          legendShape: BoxShape.circle,
                          legendTextStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        chartValuesOptions: const ChartValuesOptions(
                          showChartValueBackground: true,
                          showChartValues: true,
                          showChartValuesInPercentage: true,
                          showChartValuesOutside: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child:ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WarehouseDetailScreen(warehouseId: document.id),
                            ),
                          ),
                          child: const Text('Перейти на склад'),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          }).toList(),
        );
      },
    );
  }
}
