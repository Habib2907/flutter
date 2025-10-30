import 'package:flutter/material.dart';
import 'package:s/pages/booking_page.dart';
import 'akun_page.dart';
import 'kategori_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CASMainPage extends StatefulWidget {
  @override
  _CASMainPageState createState() => _CASMainPageState();
}

class _CASMainPageState extends State<CASMainPage> {
  int _selectedIndex = 0;
  late String emergencyNumber;

  final List<Widget> _pages = [
    HomePageCAS(), // Halaman utama
    BookingPage(), // Booking Servis
    CategoryPage(), // Kategori
    Placeholder(), // Emergency
    AkunPage(), // Akun
  ];

  @override
  void initState() {
    super.initState();
    _loadEmergencyNumber();
  }

  void _loadEmergencyNumber() {
    SharedPreferences.getInstance().then((prefs) {
      emergencyNumber = prefs.getString('emergency_number') ?? '082362631000';
      setState(() {});
    });
  }

  /// Fungsi untuk membuka dialer dari SharedPreferences
Future<void> openDialerFromPrefs(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final phoneNumber = prefs.getString('emergency_number') ?? '082362631000';

  if (phoneNumber.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nomor darurat belum disimpan')),
    );
    return;
  }

  final Uri url = Uri.parse('tel:$phoneNumber');
  print('Dialing: $phoneNumber');

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    // Fallback: tampilkan dialog agar user bisa salin atau hubungi manual
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Nomor Darurat'),
        content: Text('Silakan hubungi: $phoneNumber'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Tutup'),
          ),
        ],
      ),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black87,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 3) {
            openDialerFromPrefs(context); // tetap pakai context
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },

        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Booking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category_rounded),
            label: 'Kategori',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warning),
            label: 'Emergency',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}

class HomePageCAS extends StatelessWidget {
  Color getCardColor(String title) {
    switch (title) {
      case 'Booking Servis':
        return Colors.white;

      default:
        return Colors.white;
    }
  }

  Widget buildUserHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.teal[500],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selamat Siang, Habib',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            icon: Icon(Icons.link, size: 18, color: Colors.black),
            label: Text(
              'Hubungkan Facebook',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {},
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.verified_user, color: Colors.black),
              SizedBox(width: 8),
              Text(
                'Level Tier Saya: White',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
              Spacer(),
              Icon(Icons.card_giftcard, color: Colors.black),
              SizedBox(width: 4),
              Text(
                '0 Gift',
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  final List<MenuCard> menuItems = [
    MenuCard(
      icon: Icons.build_circle,
      title: 'Booking Servis',
      subtitle: 'Pilih jenis servis kendaraan',
      route: '/booking',
    ),
    MenuCard(
      icon: Icons.notifications_active,
      title: 'Reminder Servis',
      subtitle: 'Atur pengingat servis rutin',
      route: '/reminder',
    ),
    MenuCard(
      icon: Icons.history,
      title: 'Riwayat Servis',
      subtitle: 'Lihat histori perbaikan',
      route: '/riwayat',
    ),
    MenuCard(
      icon: Icons.account_circle,
      title: 'Akun Saya',
      subtitle: 'Edit profil dan data pengguna',
      route: '/akun',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Beranda'),
        elevation: 4,
        backgroundColor: Colors.teal.shade500,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          buildUserHeader(),
          SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
            children: menuItems.map((item) {
              return GestureDetector(
                onTap: () => Navigator.pushNamed(context, item.route),
                child: Card(
                  elevation: 3,
                  color: getCardColor(item.title), // Warna background dinamis
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icon, size: 40, color: Colors.teal.shade500),
                        SizedBox(height: 12),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class MenuCard {
  final IconData icon;
  final String title;
  final String subtitle;
  final String route;

  MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.route,
  });
}
