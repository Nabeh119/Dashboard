import 'package:dashboard/Controllers/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerSection extends StatefulWidget {
  const CustomerSection({super.key});

  @override
  State<CustomerSection> createState() => _CustomerSectionState();
}

class _CustomerSectionState extends State<CustomerSection> {
  final CustomerController controller = Get.put(CustomerController());
  bool _ascendding = true;
  String _sortColumn = 'customerId';
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
              'Customer  Overview',
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
        _buildCard("Total Customer ", "100", Icons.people, Colors.blueAccent),
        _buildCard("Active Customer", "800", Icons.check_circle, Colors.greenAccent),
        _buildCard("Inactive Customers", "150", Icons.block, Colors.greenAccent),
        _buildCard("New Customer", "20", Icons.person_add, Colors.orange),
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
                hintText: 'Search Customers', 
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
                  'customerId',
                  'customerName',
                  'totalAmount',
                  'orderDate',
                  'status',
                ].indexOf(_sortColumn),
                sortAscending: _ascendding,
                columns: [
                  _builderDataColumn("Customer ID", 'orderId'),
                  _builderDataColumn("CustomerName", 'customerName'),
                  _builderDataColumn("Email", 'email'),
                  _builderDataColumn("Total Orders", 'totalOrders'),
                  _builderDataColumn("Status", 'status'),
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
      DataCell(Text(item['customerId']?.toString() ?? "N/A")),
      DataCell(Text(item['customerName']?.toString() ?? "N/A")),
      DataCell(Text(item['email']?.toString() ?? "N/A")),
      DataCell(Text(item['totlaOrders']?.toString() ?? "N/A")),
      DataCell(Text(item['status']?.toString() ?? "N/A")),
    ]);
  }

  List<Map<String, dynamic>> _applyFilers(List<Map<String, dynamic>> data) {
    String searchText = _searchController.text.toLowerCase();

    return data.where((item) {
      if (searchText.isNotEmpty &&
          !item['customerName'].toLowerCase().contains(searchText)) {
        return false;
      }
      return true;
    }).toList();
  }

  Widget _buildPageination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("1-30 of 200 customer"),
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
          child: Text('1'), 
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
