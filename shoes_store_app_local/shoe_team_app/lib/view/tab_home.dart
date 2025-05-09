import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shoe_team_project/view/basket_page.dart';
import 'package:shoe_team_project/view/home.dart';
import 'package:shoe_team_project/view/orderhistorypage.dart';
import 'package:shoe_team_project/view/store_map.dart';

class TabHome extends StatefulWidget {
  const TabHome({super.key});

  @override
  State<TabHome> createState() => _TabHomeState();
}

class _TabHomeState extends State<TabHome> with SingleTickerProviderStateMixin {
  late TabController controller;
  late String userId;
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    userId = '';
    initStorage();
    controller = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void initStorage() {
    userId = box.read('p_userId') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: TabBarView(
        controller: controller,
        physics: const BouncingScrollPhysics(),
        children: const [
          Home(),
          BasketPage(),
          StoreMap(),
          OrderHistoryPage(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: TabBar(
          controller: controller,
          labelColor: Colors.amber[400],
          unselectedLabelColor: Colors.white60,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(width: .0, color: Colors.amber),
            insets: EdgeInsets.symmetric(horizontal: 30.0),
          ),
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.storefront, size: 26),
              text: '상품내역',
            ),
            Tab(
              icon: Icon(Icons.shopping_bag, size: 26),
              text: '장바구니',
            ),
            Tab(
              icon: Icon(Icons.location_on, size: 26),
              text: '상점위치',
            ),
            Tab(
              icon: Icon(Icons.receipt_long, size: 26),
              text: '주문내역',
            ),
          ],
        ),
      ),
    );
  }
}