import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionModel {
  final String title;
  final IconData icon;

  SectionModel({required this.title, required this.icon});
}

class DashboardController extends GetxController {
  final RxInt currentSectionIndex = 0.obs;
  final RxBool sidebarOpen = true.obs;

  final RxList<SectionModel> sections = <SectionModel>[
    SectionModel(title: 'Statistics', icon: Icons.show_chart),
    SectionModel(title: 'Products', icon: Icons.shopping_bag),
    SectionModel(title: 'Orders', icon: Icons.list_alt),
    SectionModel(title: 'Customers', icon: Icons.people),
    SectionModel(title: 'Inventory', icon: Icons.inventory),
    SectionModel(title: 'Sales', icon: Icons.attach_money),
  ].obs;

  //getting And Creating dumy data, you can use Api or DataBase
  Future<List<Map<String, dynamic>>> fetchData() async {
    //await Future.delayed(Duration(seconds: 1));
    return List.generate(
        5,
        (index) => {
              'productName': 'Product $index',
              'sales': '\$ ${(index + 1) * 100}',
              'stock': '${(index + 1) * 20} units',
              'category': 'Category $index',
              'dateAdded': '2025-10-1 ${index + 1}',
              'totalRevenue': '\$ ${(index + 1) * 5000}',
              'averageOrderValue': '\$ ${(index + 1) * 50}',
              'customerCount': (index + 1) * 100,
            });
  }

  void changeSection(int index) {
    currentSectionIndex.value = index;
  }

  void toggleSidebar() {
    sidebarOpen.value = !sidebarOpen.value;
  }
}
