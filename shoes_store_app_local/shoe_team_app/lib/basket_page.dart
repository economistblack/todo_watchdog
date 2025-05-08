import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_team_project/Payment.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  late DatabaseHandler handler;
  int sum = 0;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("장바구니")),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: handler.queryBasket(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.memory(
                                  snapshot.data![index].image,
                                  width: 100,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("제품명: "),
                                        Text(snapshot.data![index].buyProductName),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("가격: "),
                                        Text("${snapshot.data![index].buyProductPrice}"),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text("장바구니가 비어있습니다."));
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("총 금액: ", style: TextStyle(fontSize: 16)),
                ElevatedButton(
                  onPressed: () {
                    Get.to(Payment());
                  },
                  child: Text("결제하기"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}