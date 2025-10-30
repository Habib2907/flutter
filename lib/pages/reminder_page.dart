import 'package:flutter/material.dart';

class ReminderPage extends StatelessWidget {
  const ReminderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reminder Servis', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      backgroundColor: Colors.teal.shade500,
      
      ),
      
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Jadwal Servis Berikutnya',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.build_circle, color: Colors.blue),
                title: Text('Ganti Oli'),
                subtitle: Text('Tanggal: 23 April 2026\nJarak: 78.563km\nLokasi: Bengkel Chairul Auto Service'),
                trailing: Icon(Icons.notifications_active, color: Colors.red),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: Icon(Icons.car_repair, color: Colors.blue),
                title: Text('Pemeriksaan Rem'),
                subtitle: Text('Tanggal: 23 Februari 2026\nJarak: 75.563km\nLokasi: Bengkel Chairul Auto Service'),
                trailing: Icon(Icons.notifications_active, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
