import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:upbit_http_api/model/minichart.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List data;
  late int seconds;
  late TooltipBehavior tooltipBehavior;
  late List<Minichart> miniChart;
  late String chartName;
  late Timer _timer;
  late String urlUpBit;
  late String cryptoImage;

  @override
  void initState() {
    super.initState();
    data = [];
    seconds = 3;
    miniChart = [];
    chartName = 'KRW-BTC';
    cryptoImage = 'images/bitcoin.png';
    tooltipBehavior = TooltipBehavior(enable: true);
    urlUpBit =
        'https://api.upbit.com/v1/ticker?markets=KRW-BTC,KRW-ETH,KRW-XRP,KRW-XLM,KRW-SOL,KRW-ADA,KRW-USDC,KRW-USDT';

    _timer = Timer.periodic(Duration(seconds: seconds), (timer) {
      data.clear();
      getJSONData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    'Crypto Prices',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 17,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    width: 70,
                    height: 70,
                    
                    decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color.fromARGB(255, 229, 188, 173), width: 1),
                  ),
                    child: ClipOval(
                      child: Image.asset(
                        cryptoImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 280,
              height: 150,
              child: SfCartesianChart(
                tooltipBehavior: tooltipBehavior,
                legend: Legend(isVisible: true),

                primaryXAxis: DateTimeAxis(
                  dateFormat: DateFormat.Hms(),
                  intervalType: DateTimeIntervalType.seconds,
                  edgeLabelPlacement: EdgeLabelPlacement.shift,
                  labelStyle: TextStyle(
                    color: Colors.white, // X축 라벨 색
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                primaryYAxis: NumericAxis(
                  numberFormat: NumberFormat.compact(
                    locale: 'en_US',
                  ), // 간단한 숫자 형식
                  opposedPosition: false,
                  majorGridLines: const MajorGridLines(dashArray: [2, 2]),
                  axisLine: const AxisLine(width: 0),
                  labelStyle: TextStyle(
                    color: Colors.white, // Y축 라벨 색
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                series: [
                  LineSeries<Minichart, DateTime>(
                    name: chartName,
                    dataSource: miniChart,
                    xValueMapper: (Minichart time, _) => time.time,
                    yValueMapper:
                        (Minichart currentPrice, _) =>
                            currentPrice.currentPrice,
                    dataLabelSettings: DataLabelSettings(isVisible: false),
                    enableTooltip: false,
                    color: Colors.lightGreenAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
        toolbarHeight: 170,
      ),
      body: Center(
        child:
            data.isEmpty
                ? CircularProgressIndicator()
                : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      height: 100,
                      child: GestureDetector(
                        onTap: () {
                          _timer.cancel();
                          miniChart.clear();
                          chartRun(index);
                          data.clear();
                          _timer = Timer.periodic(Duration(seconds: seconds), (
                            timer,
                          ) {
                            data.clear();
                            chartRun(index);
                          });
                        },
                        child: Card(
                          color:
                              (data[index]['change'] == 'RISE')
                                  ? Colors.amber[400]
                                  : Colors.grey[400],
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(width: 15),
                              (data[index]['change'] == 'RISE')
                                  ? Icon(
                                    Icons.arrow_circle_up,
                                    color: Colors.red,
                                  )
                                  : Icon(
                                    Icons.arrow_circle_down,
                                    color: Colors.blue,
                                  ),
                              SizedBox(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('${data[index]['market']} '),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '현재가 (KRW) : ${NumberFormat('#,###.0').format(data[index]['trade_price'])}',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
      ),
    );
  } // build

  getJSONData() async {
    var url = Uri.parse(urlUpBit);
    final response = await http.get(url);
    // print(response.body);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    data.addAll(dataConvertedJSON);

    final crypto = data.firstWhere((coin) => coin['market'] == 'KRW-BTC');
    final double currentPrice = crypto['trade_price'].toDouble();
    final DateTime now = DateTime.now();

    miniChart.add(Minichart(time: now, currentPrice: currentPrice));

    if (miniChart.length > 50) {
      miniChart.removeAt(0);
    }

    setState(() {});
  }

  chartRun(int index) async {
    var url = Uri.parse(urlUpBit);
    final response = await http.get(url);
    // print(response.body);

    var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
    data.addAll(dataConvertedJSON);
    chartName = data[index]['market'];
    final double currentPrice = data[index]['trade_price'].toDouble();
    final DateTime now = DateTime.now();

    miniChart.add(Minichart(time: now, currentPrice: currentPrice));

    switch (chartName) {
      case 'KRW-BTC':
        cryptoImage = 'images/bitcoin.png';
        break;
      case 'KRW-ETH':
        cryptoImage = 'images/ethereum.png';
        break;
      case 'KRW-XRP':
        cryptoImage = 'images/xrp.png';
        break;
      case 'KRW-XLM':
        cryptoImage = 'images/stellar.png';
        break;
      case 'KRW-SOL':
        cryptoImage = 'images/solana.png';
        break;
      case 'KRW-ADA':
        cryptoImage = 'images/cardano.png';
        break;
      case 'KRW-USDC':
        cryptoImage = 'images/usd-coin.png';
        break;
      case 'KRW-USDT':
        cryptoImage = 'images/tether.png';
        break;
    }

    if (miniChart.length > 50) {
      miniChart.removeAt(0);
    }

    setState(() {});
  }
} // class
