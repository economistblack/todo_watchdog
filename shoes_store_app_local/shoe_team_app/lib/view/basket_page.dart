import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:shoe_team_project/model/basket.dart';
import 'package:shoe_team_project/view/Payment.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  late DatabaseHandler handler;
  List<Basket> basketList = [];

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    loadBasket();
  }

  loadBasket() async {
    basketList = await handler.queryBasket();
    setState(() {});
  }

  Future<void> deleteBasketItem(int id) async {
    await handler.deleteBasket(id);
    await loadBasket();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("장바구니"),
        backgroundColor: const Color.fromARGB(221, 230, 107, 107),
      ),
      body: basketList.isEmpty
          ? const Center(child: Text("장바구니가 비어있습니다."))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: basketList.length,
                    itemBuilder: (context, index) {
                      final item = basketList[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Slidable(
                          key: ValueKey(item.basketSeq),
                          endActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                onPressed: (_) => deleteBasketItem(item.basketSeq!),
                                backgroundColor: Colors.red,
                                icon: Icons.delete,
                                label: '삭제',
                              ),
                            ],
                          ),
                          child: Card(
                            color: Colors.blue[100],
                            child: Padding(
                              padding: const EdgeInsets.all(11.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.memory(item.image, width: 100),
                                  ),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text("제품명: ${item.buyProductName}"),
                                        Row(
                                          children: [
                                            Text("수량: ${item.buyProductQuantity}"),
                                            SizedBox(width: 40,),
                                            Text("가격: ${item.buyProductPrice}"),
                                            const SizedBox(width: 40),
                                            Checkbox(
                                              value: item.ischeck == 1,
                                              onChanged: (val) {
                                                setState(() {
                                                  item.ischeck = val! ? 1 : 0;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "총 금액: ₩${basketList.where((e) => e.ischeck == 1).fold(0, (sum, e) => sum + (e.buyProductPrice * e.buyProductQuantity))}",
                        style: const TextStyle(fontSize: 16),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(221, 230, 107, 107),
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          final selectedItems = basketList
                              .where((e) => e.ischeck == 1)
                              .toList();

                          if (selectedItems.isEmpty) {
                            Get.snackbar('경고', '선택된 상품이 없습니다',
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                            return;
                          }

                          Get.to(() => PaymentPage(selectedItems: selectedItems))!.then((result) async{
                            await loadBasket();
                            setState(() {
                            });
                          });
                        },
                        child: const Text("결제하기"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}