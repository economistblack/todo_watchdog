import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:must_eat_place_app/model/eatplace.dart';
import 'package:must_eat_place_app/view/inserteatplace.dart';
import 'package:must_eat_place_app/view/mapeatplace.dart';
import 'package:must_eat_place_app/view/updateeatplace.dart';
import 'package:must_eat_place_app/vm/database_handler.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Queryeatplace extends StatefulWidget {
  const Queryeatplace({super.key});

  @override
  State<Queryeatplace> createState() => _QueryeatplaceState();
}

class _QueryeatplaceState extends State<Queryeatplace> {
  DatabaseHandler handler = DatabaseHandler();
  TextEditingController searchController = TextEditingController();
  int eatPlaceCount = 0;
  List<Eatplace> filteredData = [];
  bool isSearching = false;
  bool showOnlyFavorite = false;

  @override
  void initState() {
    super.initState();
    eatPlaceLength();
    loadAllData();
  }

  loadAllData()async{
    final result = await handler.queryEatPlace(searchController.text);
    filteredData = result;
    setState(() {});
  }
  


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(  
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '내가 경험한 맛집 리스트 : $eatPlaceCount 항목',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),   // x, y 축으로 그림자 이동
                      blurRadius: 0.5,            // 그림자 흐림 정도
                      color: Colors.grey,      // 그림자 색상
                    ),
                  ]
                  ),
                  
                ),
                
                SizedBox(
                  width: 250,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) async{
                      handler.queryEatPlace(value);
                      eatPlaceLength();
                      setState(() {
                        
                      });
                    },
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.white,),
                      fillColor: Colors.white,
                      hoverColor: Colors.white,
                      focusColor: Colors.white,
                      labelText: '맛집을 검색하세요.',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      floatingLabelStyle: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    keyboardType: TextInputType.text,
                  ),
                )
              ],
            ),
          ),
          backgroundColor: Colors.deepOrange,
          actions: [
            IconButton(
              onPressed: () {
                 showOnlyFavorite = !showOnlyFavorite; 
                 setState(() {});
              },
              icon: Icon(
                Icons.bookmark, 
                color:
                showOnlyFavorite ?
                 Colors.amber[300]
                : Colors.white
                
                ),
            ),
            IconButton(
              onPressed: () {
                Get.to(Inserteatplace())!.then((value) => reloadData());
              },
              icon: Icon(Icons.add, color: Colors.white),
            ),
          ],
          toolbarHeight: 100,
        ),
        body: 
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('images/background.png'),
              fit: BoxFit.cover,
              ),
            ),
            child: FutureBuilder(
            future: showOnlyFavorite
                ? handler.queryFavoriteOnly()
                : handler.queryEatplaceWithFavorite(searchController.text),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: BehindMotion(),
                        children:[
                          SlidableAction(
                            backgroundColor: Colors.red,
                            icon: Icons.delete,
                            label: '삭제',
                            onPressed: (context) async{
                              await handler.deleteEatPlace(snapshot.data![index]['id']);
                              snapshot.data!.remove(snapshot.data![index]);
                              eatPlaceLength();
                              setState(() {});
                            },
                            ),
                        ] 
                        ),
                      startActionPane: ActionPane(
                        motion: DrawerMotion(), 
                        children: [
                          SlidableAction(
                            backgroundColor: Colors.green,
                            icon: Icons.edit,
                            label: '수정',
                            onPressed: (context) {
                              Get.to(Updateeatplace(),
                              arguments: [
                                snapshot.data![index]['id'],
                                snapshot.data![index]['name'],
                                snapshot.data![index]['phone'],
                                snapshot.data![index]['comment'],
                                snapshot.data![index]['latitude'],
                                snapshot.data![index]['longitude'],
                                snapshot.data![index]['image01'],
                                snapshot.data![index]['image02'],
                                snapshot.data![index]['date'],
                                snapshot.data![index]['isfavorite'],
                              ]
                              )!.then((value) => reloadData());
                            },),
                        ]
                        ),
                      child: GestureDetector(
                        onDoubleTap: () {
                          Get.to(Mapeatplace(),
                          arguments: [
                                snapshot.data![index]['id'],
                                snapshot.data![index]['name'],
                                snapshot.data![index]['phone'],
                                snapshot.data![index]['comment'],
                                snapshot.data![index]['latitude'],
                                snapshot.data![index]['longitude'],
                                snapshot.data![index]['image01'],
                                snapshot.data![index]['image02'],
                                snapshot.data![index]['date'],
                                snapshot.data![index]['isfavorite'],
                              ]
                          )!.then((value) => reloadData());
                        },
                        child: Card(
                          elevation: 10,
                          color:
                              (index % 2 == 0)
                                  ? Colors.brown[300]
                                  : Colors.blueGrey[300],
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: CarouselSlider(
                                    items: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          snapshot.data![index]['image01'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 120,
                                          filterQuality: FilterQuality.high,
                                        ),
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.memory(
                                          snapshot.data![index]['image02'],
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 120,
                                          filterQuality: FilterQuality.high,
                                        ),
                                      ),
                                    ],
                                    options: CarouselOptions(
                                      height: 120,
                                      enlargeCenterPage: true,
                                      enableInfiniteScroll: false,
                                      autoPlay: true,
                                      autoPlayInterval: Duration(seconds: 3),
                                      autoPlayAnimationDuration: Duration(
                                        milliseconds: 800,
                                      ),
                                      autoPlayCurve: Curves.easeInOut,
                                      viewportFraction: 0.9,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 25),
                                // 오른쪽: 텍스트
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 0, 55, 0),
                                            child: Text(
                                              '등록일 : ${snapshot.data![index]['date']}',
                                              style: TextStyle(
                                                color: Colors.grey[200]
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              (snapshot.data![index]['isfavorite'] != 0) ? Icons.bookmark : Icons.bookmark_border,
                                              color: (snapshot.data![index]['isfavorite'] != 0) ? Colors.amber[300] : Colors.white,
                                            ),
                                            onPressed: () async{
                                                int id = snapshot.data![index]['id'];
                                                bool currentStatus = snapshot.data![index]['isfavorite'] != 0;
                                                print(currentStatus);
                                                await handler.updateFavoriteStatus(id, !currentStatus);
                                                reloadData();
                                            },
                                          )
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.restaurant,
                                            color: Colors.lime,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            _shortenText(snapshot.data![index]['name']),
                                            style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.lime,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.phone,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            snapshot.data![index]['phone'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.rate_review,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                          SizedBox(width: 10),
                                          Text(
                                            _shortenText(snapshot.data![index]['comment']),
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
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
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
                    ),
          ),
      ),
    );
  } // builder

  // 카드에서 글자 줄임
  String _shortenText(String text) {
    if (text.length <= 20) {
      return text;
    } else {
      // ignore: prefer_interpolation_to_compose_strings
      return text.substring(0, 18) + '...';
    }
  }

  reloadData(){
    handler.queryEatPlace(searchController.text);
    eatPlaceLength(); 
    setState(() {});
  }

  eatPlaceLength() async{
    final data = await handler.queryEatPlace(searchController.text);
    eatPlaceCount = data.length;
    setState(() {
    });
  }
} // class
