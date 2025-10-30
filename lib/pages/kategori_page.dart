import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final List<CategoryItem> categories = [
    CategoryItem(Icons.car_repair, 'Reminder Servis'),

    CategoryItem(Icons.home_repair_service, 'Servis Dirumah'),
    CategoryItem(Icons.build, 'Aksesoris Tambah'),
    CategoryItem(Icons.card_giftcard, 'Kupon Servis'),
    CategoryItem(Icons.local_offer, 'Paket Servis'),
    CategoryItem(Icons.add_circle_outline, 'Tambah Mobil'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kategori Layanan'),
        backgroundColor: Colors.teal.shade500,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final item = categories[index];
            return GestureDetector(
              onTap: () {
                // Navigasi ke halaman detail kategori
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(item.icon, size: 40, color: Colors.teal.shade500),
                    SizedBox(height: 12),
                    Text(
                      item.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class CategoryItem {
  final IconData icon;
  final String label;

  CategoryItem(this.icon, this.label);
}
