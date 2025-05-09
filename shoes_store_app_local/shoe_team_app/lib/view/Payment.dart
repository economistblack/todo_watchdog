import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoe_team_project/model/basket.dart';
import 'package:shoe_team_project/model/store.dart';
import 'package:shoe_team_project/model/order_history.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class PaymentPage extends StatefulWidget {
  final List<Basket> selectedItems;
  const PaymentPage({super.key, required this.selectedItems});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late DatabaseHandler handler;
  late int totalPrice;
  late int vat;
  late int supplyPrice;

  final numberFormat = NumberFormat("#,###");
  late String orderId;
  late String paymentDate;
  final box = GetStorage();
  late String userId;

  List<Store> storeList = [];
  Store? selectedStore;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    loadStores();

    totalPrice = widget.selectedItems.fold(
      0,
      (sum, item) => sum + (item.buyProductPrice * item.buyProductQuantity),
    );

    vat = (totalPrice * 0.1).round();
    supplyPrice = totalPrice - vat;

    orderId = const Uuid().v4().substring(0, 8).toUpperCase();
    paymentDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    userId = box.read('p_userId') ?? 'UNKNOWN';
  }

  Future<void> loadStores() async {
    final db = await handler.initializeDB();
    final List<Map<String, Object?>> result = await db.rawQuery(
      'SELECT * FROM store',
    );
    setState(() {
      storeList = result.map((e) => Store.fromMap(e)).toList();
    });
  }

  Future<void> saveOrderHistory() async {
    final order = OrderHistory(
      orderId: orderId,
      userId: userId,
      storeCode: selectedStore!.storeCode,
      storeName: selectedStore!.storeName,
      totalPrice: totalPrice,
      orderDate: paymentDate,
      state: 1,
    );
    await handler.insertOrderHistory(order);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('결제 영수증'),
        backgroundColor: const Color.fromARGB(221, 230, 107, 107),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            '🧾 구매 영수증',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 1.5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                buildMetaRow("주문번호", orderId),
                buildMetaRow("결제일자", paymentDate),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "결제 매장",
                      style: TextStyle(fontSize: 15, color: Colors.black54),
                    ),
                    DropdownButton<Store>(
                      value: selectedStore,
                      dropdownColor: Colors.blue[100],
                      hint: const Text("매장 선택"),
                      onChanged: (Store? value) {
                        setState(() {
                          selectedStore = value;
                        });
                      },
                      items:
                          storeList.map((store) {
                            return DropdownMenuItem<Store>(
                              value: store,
                              child: Text(store.storeName),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(thickness: 1.5),
          Expanded(
            child: ListView.separated(
              itemCount: widget.selectedItems.length,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                final item = widget.selectedItems[index];
                final int itemTotal =
                    item.buyProductPrice * item.buyProductQuantity;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.buyProductName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("수량: ${item.buyProductQuantity}개"),
                          Text(
                            "단가: ₩${numberFormat.format(item.buyProductPrice)}",
                          ),
                          Text(
                            "합계: ₩${numberFormat.format(itemTotal)}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                buildSummaryRow("공급가액", supplyPrice),
                buildSummaryRow("부가세 (10%)", vat),
                const Divider(thickness: 1),
                buildSummaryRow(
                  "총 결제 금액",
                  totalPrice,
                  isBold: true,
                  highlight: true,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () async {
                    if (selectedStore == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("결제할 매장을 선택하세요."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    List<String> lowStockItems = [];

                    for (var item in widget.selectedItems) {
                      int currentQty = await handler.getCurrentProductQuantity(item.productCode);
                      if (currentQty <= 5) {
                        lowStockItems.add('${item.buyProductName} (남은 수량: $currentQty)');
                      }
                    }

                    if (lowStockItems.isNotEmpty) {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('⚠️ 재고 5개 이하'),
                          content: Text('재고 5개 이하 시 판매가 중단됩니다:\n\n${lowStockItems.join('\n')}'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text('확인'),
                            ),
                          ],
                        ),
                      );
                      return;
                    }

                    await saveOrderHistory();

                    for (var item in widget.selectedItems) {
                      await handler.decreaseProductQuantity(
                        item.productCode,
                        item.buyProductQuantity,
                      );
                      await handler.deleteBasket(item.basketSeq!);
                    }

                    showDialog(
                      context: context,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("💳 결제 완료"),
                            content: Text(
                              "주문번호 [$orderId]\n'${selectedStore!.storeName}' 매장에서 결제가 완료되었습니다.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: const Text("확인"),
                              ),
                            ],
                          ),
                    );
                  },
                  icon: const Icon(Icons.check_circle_outline),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(221, 230, 107, 107),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  label: const Text('결제하기'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMetaRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, color: Colors.black54),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget buildSummaryRow(
    String label,
    int amount, {
    bool isBold = false,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: highlight ? Colors.black : Colors.grey[800],
            ),
          ),
          Text(
            '₩${numberFormat.format(amount)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: highlight ? Colors.black : Colors.grey[900],
            ),
          ),
        ],
      ),
    );
  }
}
