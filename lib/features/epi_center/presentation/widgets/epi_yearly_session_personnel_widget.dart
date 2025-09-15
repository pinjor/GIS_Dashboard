import 'package:flutter/material.dart';

class EpiYearlySessionPersonnelWidget extends StatelessWidget {
  const EpiYearlySessionPersonnelWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final personnel = [
      {
        'category': 'HA/Vaccinator Name 1',
        'name': 'Habibur Rahman',
        'designation': 'HA',
        'phone': 'N/A',
      },
      {
        'category': 'HA/Vaccinator Name 2',
        'name': 'Nur Jahan',
        'designation': 'FWA',
        'phone': 'N/A',
      },
      {
        'category': 'Supervisor-1',
        'name': 'Dilruba Nasrin',
        'designation': 'AHI',
        'phone': 'N/A',
      },
      {
        'category': 'Supervisor-2',
        'name': 'Ab. Gone',
        'designation': 'HI',
        'phone': 'N/A',
      },
      {
        'category': 'Supervisor-3',
        'name': 'N/A',
        'designation': 'N/A',
        'phone': 'N/A',
      },
    ];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Yearly Session No.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                // color: Colors.blueGrey,
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: personnel.map((person) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: Card(
                      color: Colors.blueGrey[50],
                      child: SizedBox(
                        width: 250,
                        child: ListTile(
                          title: Text(
                            person['category'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${person['name']}'),
                              Text('Designation: ${person['designation']}'),
                              Text('Phone No.: ${person['phone']}'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
