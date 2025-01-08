import 'package:dashboard/Controllers/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductSection extends StatefulWidget {
  const ProductSection({super.key});

  @override
  State<ProductSection> createState() => _ProductSectionState();
}

class _ProductSectionState extends State<ProductSection> {
  final ProductController controller = Get.put(ProductController());
  bool _ascendding = true;
  String _sortColumn = 'product';
  String _filterCategory = 'All';
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Products Overview',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildDashboardCars(),
            SizedBox(height: 30),
            _buildFilters(),
            SizedBox(height: 30),
            _buildDataTable(),
            SizedBox(height: 20),
            _buildPageination(),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildCard("Total Products", "5000", Icons.inventory, Colors.orange),
        _buildCard("Out of stock", "500", Icons.warning, Colors.redAccent),
        _buildCard("New Products", "30", Icons.new_releases, Colors.blueAccent),
        _buildCard("Catefories", "20", Icons.category, Colors.greenAccent),
      ],
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search Product',
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                fillColor: Colors.grey[100],
                filled: true,
              ),
            ),
          ),
          SizedBox(width: 16),
          DropdownButton<String>(
            value: _filterCategory,
            onChanged: (value) => setState(() {}),
            underline: Container(),
            icon: Icon(Icons.filter_list),
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            items: [
              'All',
              'Category 0',
              'Category 1',
              'Category 2',
              'Category 3',
              'Category 4',
              'Category 5',
            ]
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDataTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: FutureBuilder<List<Map<String, dynamic>>>(
          future: controller.fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator(
                color: Colors.redAccent,
              ));
            }
            if (snapshot.hasError) {
              return Center(
                child: Text("Something Went Wrong"),
              );
            }
            final data = _applyFilers(snapshot.data!);
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: [
                  'productName',
                  'category',
                  'stock',
                  'price',
                  'sku',
                ].indexOf(_sortColumn),
                sortAscending: _ascendding,
                columns: [
                  _builderDataColumn("ProductName", 'productName'),
                  _builderDataColumn("Category", 'category'),
                  _builderDataColumn("Stock", 'stock', numeric: true),
                  _builderDataColumn("Price", 'price', numeric: true),
                  _builderDataColumn("SKU", 'sku', numeric: true),
                ],
                rows: data.map((iteme) => _buildDataRow(iteme)).toList(),
              ),
            );
          }),
    );
  }

  DataColumn _builderDataColumn(String label, String key,
      {bool numeric = false}) {
    return DataColumn(
        label: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        numeric: numeric,
        onSort: (columnIndex, ascendding) {
          setState(() {
            _sortColumn = key;
            _ascendding = ascendding;
          });
        });
  }

  DataRow _buildDataRow(Map<String, dynamic> item) {
    return DataRow(cells: [
      DataCell(Text(item['productName']?.toString() ?? "N/A")),
      DataCell(Text(item['category']?.toString() ?? "N/A")),
      DataCell(Text(item['stock']?.toString() ?? "N/A")),
      DataCell(Text(item['cprice']?.toString() ?? "N/A")),
      DataCell(Text(item['sku']?.toString() ?? "N/A")),
    ]);
  }

  List<Map<String, dynamic>> _applyFilers(List<Map<String, dynamic>> data) {
    String searchText = _searchController.text.toLowerCase();

    var filterData = data.where((item) {
      if (_filterCategory != 'All' && item['category'] != _filterCategory) {
        return false;
      }
      if (searchText.isNotEmpty &&
          !item['productName'].toLowerCase().contains(searchText)) {
        return false;
      }
      return true;
    }).toList();

    filterData.sort((a, b) {
      var aValue = a[_sortColumn];
      var bValue = b[_sortColumn];
      if (aValue is String && bValue is String) {
        return _ascendding
            ? aValue.compareTo(bValue)
            : bValue.compareTo(aValue);
      } else if (aValue is num && bValue is num) {
        return _ascendding
            ? aValue.compareTo(bValue)
            : bValue.compareTo(aValue);
      }
      return 0;
    });
    return filterData;
  }

  Widget   _buildPageination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("1-5 of 5 items"),
        SizedBox(width: 16),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.chevron_left),
          color: Colors.grey,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.redAccent,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.chevron_right),
          color: Colors.redAccent,
        ),
      ],
    );
  }
}
