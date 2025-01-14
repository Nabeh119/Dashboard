
import 'package:get/get.dart';

class SalesController extends GetxController {
  Future<List<Map<String, dynamic>>> fetchData() async {
    //await Future.delayed(Duration(seconds: 1));
    return List.generate(
        5,
        (index) => {
           'salesID': 'Sale$index',
              'totalAmount': '\$ ${(index+1)*2000}',
              'orderCount': (index + 1) * 150,
              'date': '2025-10-1${index + 1}',
              'growth': '${(index+1)*5} %'});
  }
}
 