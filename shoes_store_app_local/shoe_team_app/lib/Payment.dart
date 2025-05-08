import 'package:flutter/material.dart';

class Payment extends StatefulWidget {
  const Payment({super.key});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  String selectedPayment = '신용카드';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("결제"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("주문 상품", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              child: ListTile(
                leading: Icon(Icons.shopping_bag),
                title: Text("나이키 에어맥스"),
                subtitle: Text("사이즈: 270mm\n수량: 1"),
                trailing: Text("129,000원"),
              ),
            ),
            SizedBox(height: 20),

            Text("배송지", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Card(
              child: ListTile(
                leading: Icon(Icons.home),
                title: Text("서울시 강남구 테헤란로 123"),
                subtitle: Text("홍길동 | 010-1234-5678"),
              ),
            ),
            SizedBox(height: 20),

            Text("결제 수단", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            DropdownButton<String>(
              value: selectedPayment,
              isExpanded: true,
              items: ['신용카드', '카카오페이', '무통장입금'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPayment = value!;
                });
              },
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("총 결제 금액", style: TextStyle(fontSize: 16)),
                Text("129,000원", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // 결제 처리 로직
                },
                child: Text("결제하기"),
              ),
            )
          ],
        ),
      ),
    );
  }
}