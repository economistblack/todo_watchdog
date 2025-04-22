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

  @override
  void initState() {
    super.initState();
    data = [];
    getJSONData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  } // build

  getJSONData() async {
    var url = Uri.parse(
      'https://stat.me.go.kr/openapi/tbaecodata17.do?KEY=e8af9384bb9041718ccdb847af18ddc4&Type=json',
    );
    var response = await http.get(url);
    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    List result = dataConvertedJSON['tbaecodata17'];
    data.addAll(result);
    print(result);
  }
} // class
