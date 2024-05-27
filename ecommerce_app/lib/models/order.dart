class Order {
  final String id;
  final int orderId;
  final String name;
  final String phone;
  final String city;
  final String postalAddress;
  final List<String> productIds;
  final DateTime orderPlaced;
  final bool orderProcessedStatus;
  final bool orderShippedStatus;
  final bool outForDeliveryStatus;
  final bool deliveredStatus;

  Order({
    required this.id,
    required this.orderId,
    required this.name,
    required this.phone,
    required this.city,
    required this.postalAddress,
    required this.productIds,
    required this.orderPlaced,
    required this.orderProcessedStatus,
    required this.orderShippedStatus,
    required this.outForDeliveryStatus,
    required this.deliveredStatus,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      orderId: json['id'],
      name: json['name'],
      phone: json['phone'],
      city: json['city'],
      postalAddress: json['postalAddress'],
      productIds: List<String>.from(json['productIds']),
      orderPlaced: DateTime.parse(json['orderPlaced']),
      orderProcessedStatus: json['orderProcessedStatus'],
      orderShippedStatus: json['orderShippedStatus'],
      outForDeliveryStatus: json['outForDeliveryStatus'],
      deliveredStatus: json['deliveredStatus'],
    );
  }
}
