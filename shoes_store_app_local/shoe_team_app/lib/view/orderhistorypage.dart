import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_team_project/model/order_history.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';
import 'package:intl/intl.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  late DatabaseHandler handler;
  late Future<List<OrderHistory>> orderListFuture;
  late TextEditingController returnreason;

  final numberFormat = NumberFormat("#,###");

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    orderListFuture = loadOrders();
    returnreason = TextEditingController();
  }

  Future<List<OrderHistory>> loadOrders() async {
    final db = await handler.initializeDB();
    final List<Map<String, dynamic>> result = await db.query('order_history');
    return result.map((e) => OrderHistory.fromMap(e)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('주문 내역'),
        backgroundColor: const Color.fromARGB(221, 230, 107, 107),
      ),
      body: FutureBuilder<List<OrderHistory>>(
        future: orderListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('데이터를 불러오는 데 실패했습니다'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('주문 내역이 없습니다'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                color: Colors.blue[100],
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '주문번호: ${order.orderId}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '₩${numberFormat.format(order.totalPrice)}',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${order.storeName}  •  ${order.orderDate.substring(0,10)}'),
                      const SizedBox(height: 8),
                      order.state == 1 ? Text(""):Text("환불신청 완료",style: TextStyle(color: Colors.red),),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: "환불 사유",
                              content: SizedBox(
                                width: 300,
                                height: 120,
                                child: TextField(
                                  controller: returnreason,
                                  maxLines: null, 
                                  expands: true, 
                                  decoration: const InputDecoration(
                                    hintText: "환불 사유를 입력하세요",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: ()async {
                                    final reason = returnreason.text.trim();
                                    if (reason.isEmpty) {
                                      Get.snackbar("입력 오류", "환불 사유를 입력해주세요");
                                      return;
                                    }

                                    // DB 업데이트 수행
                                    OrderHistory orderHistory = OrderHistory
                                    (orderId: order.orderId, 
                                    userId: order.userId, 
                                    storeCode: order.storeCode, 
                                    storeName: order.storeName, 
                                    totalPrice: order.totalPrice, 
                                    orderDate: order.orderDate,
                                    returnReason: returnreason.text, 
                                    state: 2,
                                    );

                                    await handler.updateOrderHistory(orderHistory);

                                    setState(() {
                                      orderListFuture = loadOrders();
                                    });

                                    // 입력창 초기화 및 다이얼로그 닫기
                                    returnreason.clear();
                                    Get.back();

                                    Get.snackbar("환불 요청 완료","");
                                  },
                                  child: const Text("환불신청하기"),
                                ),
                              ],
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                          child: const Text('환불 요청'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
