
import 'package:get/get.dart';

class InventoryController extends GetxController {
  Future<List<Map<String, dynamic>>> fetchData() async {
    //await Future.delayed(Duration(seconds: 1));
    return List.generate(
        5,
        (index) => {
          'productName':'Product $index',
          'stock':'${(index + 1 )*20} units',
          'reorderLevel':'${(index + 1 )*5}units',
          'status' : index % 2==0 ? "In Stock":"Low Stock", 
            });
  }
}
