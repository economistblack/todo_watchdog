class OrderHistory {
  final String orderId;
  final String userId;
  final int storeCode;
  final String storeName;
  final int totalPrice;
  final String orderDate;
  final int state;
  final String? returnReason;

  OrderHistory({
    required this.orderId,
    required this.userId,
    required this.storeCode,
    required this.storeName,
    required this.totalPrice,
    required this.orderDate,
    required this.state,
    this.returnReason
  });

  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'storeCode': storeCode,
      'storeName': storeName,
      'totalPrice': totalPrice,
      'orderDate': orderDate,
      'state':state,
      'returnReason':returnReason
    };
  }

  factory OrderHistory.fromMap(Map<String, dynamic> map) {
    return OrderHistory(
      orderId: map['orderId'],
      userId: map['userId'],
      storeCode: map['storeCode'],
      storeName: map['storeName'],
      totalPrice: map['totalPrice'],
      orderDate: map['orderDate'],
      state: map['state'],
      returnReason: map['returnReason']
    );
  }
}