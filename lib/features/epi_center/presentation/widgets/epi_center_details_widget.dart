import 'package:flutter/material.dart';

class EpiCenterDetailsWidget extends StatelessWidget {
  const EpiCenterDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final details = [
      {
        'label': 'Name and Address of EPI Center',
        'value': 'Dr. Khalak, Tanggatipara',
      },
      {'label': 'EPI Center Implementer Name', 'value': 'Nur Jahan'},
      {'label': 'Distance from CC to EPI Center', 'value': '60'},
      {'label': 'Transportation', 'value': 'রিকশা (Rickshaw)'},
      {'label': 'Time required to reach EPI Center (minute)', 'value': '60'},
      {'label': 'Porter Name', 'value': 'Abdul Alim'},
      {'label': 'Porter Phone', 'value': 'N/A'},
      {'label': 'Center Type', 'value': 'Outreach Center'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Epi Center Details',
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
                children: details.map((detail) {
                  return Container(
                    width:
                        MediaQuery.of(context).size.width *
                        0.8, // 80% of screen width for each card
                    margin: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      color: Colors.blueGrey[50],
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              detail['label'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                // color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              detail['value'] as String,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
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
