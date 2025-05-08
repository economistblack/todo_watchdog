import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_team_project/basket_page.dart';
import 'package:shoe_team_project/model/basket.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class Ditail extends StatefulWidget {
  const Ditail({super.key});

  @override
  State<Ditail> createState() => _DitailState();
}

class _DitailState extends State<Ditail> {
  late DatabaseHandler handler;
  late String productcode;
  late String productname;

  var value = Get.arguments??"__";

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    productcode = "";
    productname = "";


  productcode = value[0];
  productname = value[1]; 

  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(productname),
    ),
    body: FutureBuilder(
      future: handler.queryImageregister(productcode),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final product = snapshot.data![0];
          int quantity = 1;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 대표 이미지
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(product.image, fit: BoxFit.cover),
                  ),
                  SizedBox(height: 20),

                  // 서브 이미지
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Image.memory(product.image01, height: 120)),
                      SizedBox(width: 10),
                      Expanded(child: Image.memory(product.image02, height: 120)),
                    ],
                  ),
                  SizedBox(height: 20),

                  // 상품 정보
                  Text(product.productName,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text("가격: ${product.price}원",
                      style: TextStyle(fontSize: 16, color: Colors.black87)),

                  SizedBox(height: 20),

                  // 장바구니 담기 버튼
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        Basket basket = Basket(
                          productCode: product.productCode,
                          buyProductName: product.productName,
                          buyProductPrice: product.price,
                          buyProductQuantity: quantity,
                          userid: "email",
                          image: product.image,
                          ischeck: 0
                        );
                        int result = await handler.insertBasket(basket);
                        if (result != 0) {
                          Get.defaultDialog(
                            title: "",
                            middleText: "장바구니에 담았습니다.",
                            backgroundColor: Colors.white,
                            barrierDismissible: false,
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("확인"),
                              ),
                            ],
                          );
                        }
                        setState(() {});
                      },
                      child: Text("장바구니에 담기"),
                    ),
                  ),

                  SizedBox(height: 10),

                  // 장바구니로 이동
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Get.to(() => BasketPage());
                      },
                      child: Text("장바구니로 이동"),
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    ),
  );
}
}