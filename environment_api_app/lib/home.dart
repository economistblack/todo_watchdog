import 'package:environment_api_app/view/restapi.dart';
import 'package:flutter/material.dart';
import 'package:environment_api_app/view/map.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('공모전 초안'),
        bottom: TabBar(
          controller: controller,
          tabs: [
            Tab(
              text: 'Rest API',
            ),
            Tab(
              text: 'Lake Map',
            ),
          ]
          ),
      
      ),
      body: TabBarView(controller: controller, 
      children: [
        RestApi(), 
        LakeMap()
        ]
        ),
    );
  }
}
