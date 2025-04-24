import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestApi extends StatefulWidget {
  const RestApi({super.key});

  @override
  State<RestApi> createState() => _RestApiState();
}

class _RestApiState extends State<RestApi> {
  late List data;
  late List dataAir;
  late String airGrade;

  @override
  void initState() {
    super.initState();
    data = [];
    dataAir = [];
    airGrade = '';
    getJSONData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) {
            return SizedBox(
              height: 90,
              child: Card(
                child: Row(
                  children: [
                    Text(data[index]['P_PARK']),
                    SizedBox(width: 20,),
                    FutureBuilder(
                      future: getJSONDataAir(data[index]['P_ZONE']), 
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // 로딩 표시
                        } else if (snapshot.hasError) {
                          return const Text('에러');
                        } else {
                          return Text('${snapshot.data}');
                        }
                      },
                    ),
                    
                  ],
                ),
              ),
            );
          }, 
          ),
      )
    );
  } // build

  getJSONData() async {
    // 서울 주요공원 정보
    var url = Uri.parse(
      'http://openAPI.seoul.go.kr:8088/4d69615a5065636f39336259446153/json/SearchParkInfoService/1/131',
    );
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['SearchParkInfoService']['row'];
    data.addAll(result);
    print(result);
    setState(() {});
  }

  Future<String> getJSONDataAir(String gu) async {
    // 서울 대기 정보
    var url = Uri.parse(
      'http://openapi.seoul.go.kr:8088/6b5848546565636f3130356951786e46/json/ListAirQualityByDistrictService/1/25/',
    );
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['ListAirQualityByDistrictService']['row'];
    for (var item in result) {
    if (item['MSRSTENAME'] == gu) {
      return item['GRADE'] ?? '정보 없음'; // 대기등급(GRADE) 표시
    }
  }
  return '구 일치 안 됨';

  }
} // class
