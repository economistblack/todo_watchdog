import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoe_team_project/model/basket.dart';
import 'package:shoe_team_project/model/productDetail.dart';
import 'package:shoe_team_project/view_model/database_handler.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});
  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  late DatabaseHandler handler;
  late String productcode;
  late String productname;
  late String userId;

  final box = GetStorage();
  var value = Get.arguments ?? "__";

  String selectedColor = 'Black';
  int selectedSize = 250;
  int selectedQuantity = 1;
  int maxQuantity = 0;
  ProductDetail? selectedProduct;
  List<ProductDetail> allData = [];

  final Map<String, String> colorCodeMap = {
    'Black': '20', 'White': '21', 'Red': '22', 'Grey': '23', 'Blue': '24'
  };
  final List<int> fullSizeRange = [220, 230, 240, 250, 260, 270, 280, 290, 300];

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    userId = '';
    initStorage();
    if (value is List && value.length >= 2) {
      productcode = value[0];
      productname = value[1];
    } else {
      Get.back();
    }
  }

  initStorage() {
    userId = box.read('p_userId') ?? '';
  }

  void updateSelectedProduct() {
    final colorCode = colorCodeMap[selectedColor] ?? '';
    selectedProduct = allData.firstWhereOrNull(
      (e) => e.color.toString() == colorCode && e.size == selectedSize,
    );
    if (selectedProduct != null) {
      maxQuantity = selectedProduct!.quantity;
      if (selectedQuantity > maxQuantity) {
        selectedQuantity = maxQuantity > 0 ? 1 : 0;
      }
    } else {
      maxQuantity = 0;
      selectedQuantity = 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(221, 230, 107, 107),
        title: Text(productname),
      ),
      body: FutureBuilder<List<ProductDetail>>(
        future: handler.queryImageregister(productname),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data != null) {
            allData = snapshot.data!;

            if (allData.isEmpty) {
              return const Center(child: Text("상품 정보가 없습니다."));
            }

            updateSelectedProduct();

            final firstImageSet = allData.first;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(firstImageSet.image, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(firstImageSet.image01, height: 120, fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(firstImageSet.image02, height: 120, fit: BoxFit.cover),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(productname,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  if (firstImageSet.description.isNotEmpty)
                    Text("설명: ${firstImageSet.description}"),
                  const SizedBox(height: 10),
                  Text("가격: ${firstImageSet.price}원"),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Text("색상: "),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedColor,
                        dropdownColor: Colors.blue[100],
                        onChanged: (value) {
                          setState(() {
                            selectedColor = value!;
                            updateSelectedProduct();
                          });
                        },
                        items: colorCodeMap.keys.map((color) {
                          return DropdownMenuItem(
                            value: color,
                            child: Text(color),
                          );
                        }).toList(),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      const Text("사이즈: "),
                      const SizedBox(width: 10),
                      DropdownButton<int>(
                        value: selectedSize,
                        dropdownColor: Colors.blue[100],
                        onChanged: (value) {
                          setState(() {
                            selectedSize = value!;
                            updateSelectedProduct();
                          });
                        },
                        items: fullSizeRange
                            .map((size) => DropdownMenuItem(
                                  value: size,
                                  child: Text("$size"),
                                ))
                            .toList(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  if (selectedProduct == null)
                    const Text("해당 색상과 사이즈 조합은 품절되었습니다.",
                        style: TextStyle(color: Colors.red)),

                  if (selectedProduct != null && selectedProduct!.quantity > 0)
                    Row(
                      children: [
                        const Text("수량: "),
                        const SizedBox(width: 10),
                        DropdownButton<int>(
                          value: selectedQuantity,
                          dropdownColor: Colors.blue[100],
                          onChanged: (value) {
                            setState(() {
                              selectedQuantity = value!;
                            });
                          },
                          items: List.generate(selectedProduct!.quantity, (i) => i + 1)
                              .map((qty) => DropdownMenuItem(
                                    value: qty,
                                    child: Text("$qty"),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  if (selectedProduct != null && selectedProduct!.quantity > 0)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.shopping_cart),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(221, 230, 107, 107),
                          foregroundColor: Colors.white,
                          shape: ContinuousRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () async {
                          Basket basket = Basket(
                            productCode: selectedProduct!.productCode,
                            buyProductName:
                                '${selectedProduct!.productName}\n색상: $selectedColor | 사이즈: $selectedSize',
                            buyProductPrice: selectedProduct!.price,
                            buyProductQuantity: selectedQuantity,
                            userid: userId,
                            image: selectedProduct!.image,
                            ischeck: 0,
                          );
                          int result = await handler.insertBasket(basket);
                          if (result != 0) {
                            Get.defaultDialog(
                              title: "",
                              middleText: "장바구니에 담았습니다.",
                              backgroundColor: const Color.fromARGB(221, 230, 107, 107),
                              textConfirm: "확인",
                              onConfirm: () {
                                Get.back();
                                Get.back();
                              },
                            );
                          }
                        },
                        label: const Text("장바구니에 담기"),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("상품 정보를 불러올 수 없습니다."));
          }
        },
      ),
    );
  }
}