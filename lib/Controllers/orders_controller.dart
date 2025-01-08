import 'package:get/get.dart';

class OrdersController extends GetxController {
  Future<List<Map<String, dynamic>>> fetchData() async {
    //await Future.delayed(Duration(seconds: 1));
    return List.generate(
        5,
        (index) => {
              'orderId': 'ORD${(1000 + index)}',
              'customerName': 'Customer $index',
              'totalAmount': '\$${(index + 1) * 200}',
              'orderDate': '2024-10-1${index + 1}',
              'status': index % 2 == 0 ? "Delivered" : "Pending",
           });
  }
}
