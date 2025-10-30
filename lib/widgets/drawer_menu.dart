import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerMenu extends StatefulWidget {
  @override
  _DrawerMenuState createState() => _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {
  String nama = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nama = prefs.getString('nama') ?? 'Habib Nasution';
      email = prefs.getString('email') ?? 'muhamadhabib2902@gmail.com';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange.shade700, Colors.deepOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Text(
                nama,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  nama.isNotEmpty ? nama[0].toUpperCase() : 'H',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ),
            ),

            // Menu List
            Expanded(
              child: ListView(
                children: [
                  buildMenuItem(
                    icon: Icons.account_circle_outlined,
                    text: 'Akun Saya',
                    onTap: () => Navigator.pushNamed(context, '/akun'),
                  ),
                  buildMenuItem(
                    icon: Icons.build_circle_outlined,
                    text: 'Booking Servis',
                    onTap: () => Navigator.pushNamed(context, '/booking'),
                  ),
                  buildMenuItem(
                    icon: Icons.notifications_active_outlined,
                    text: 'Reminder Servis',
                    onTap: () => Navigator.pushNamed(context, '/reminder'),
                  ),
                  buildMenuItem(
                    icon: Icons.history_edu_outlined,
                    text: 'Riwayat Servis',
                    onTap: () {},
                  ),
                  Divider(),
                  buildMenuItem(
                    icon: Icons.logout,
                    text: 'Keluar / Logout',
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('isLoggedIn');
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange.shade700),
      title: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}
