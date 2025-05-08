import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shoe_team_project/ditail.dart';

import '../view_model/database_handler.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DatabaseHandler handler;
  late TextEditingController search;


  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    search = TextEditingController();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("상품내역"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: search,
              decoration: InputDecoration(
                labelText: "검색"
              ),
              onChanged: (value) {
                handler.queryProductsearch(search.text);
                setState(() {
                  
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: handler.queryProductsearch(search.text), 
              builder: (context, snapshot) {
                if(snapshot.hasData){
                return GridView.builder(
                  itemCount: snapshot.data!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,//한줄에 몇개 쓸꺼냐
                    crossAxisSpacing: 10,//각각의 사각형의 간격
                    mainAxisSpacing: 10//전체 간격
                ), 
                  itemBuilder:(context, index) {
                    return GestureDetector(
                      onTap: () {
                        Get.to(Ditail(),
                        arguments: [
                          snapshot.data![index].productCode,
                          snapshot.data![index].productName
                        ]);
                      },
                      child: Card(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Image.memory(snapshot.data![index].image,
                              height: 150,),
                              Text(snapshot.data![index].productName),
                              Text("${snapshot.data![index].price}원")
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
                }else{
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}