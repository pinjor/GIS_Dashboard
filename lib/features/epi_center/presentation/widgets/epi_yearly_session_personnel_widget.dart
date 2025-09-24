import 'package:flutter/material.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_details_response.dart';

import '../../../../core/utils/utils.dart';

class EpiYearlySessionPersonnelWidget extends StatelessWidget {
  const EpiYearlySessionPersonnelWidget({
    super.key,
    required this.epiCenterDetailsData,
    required this.selectedYear,
  });
  final EpiCenterDetailsResponse? epiCenterDetailsData;
  final String selectedYear;

  @override
  Widget build(BuildContext context) {
    final demographicsData =
        epiCenterDetailsData?.area?.additionalData?.demographics[selectedYear];

    final personnel = [
      {
        'category': 'HA/Vaccinator Name 1',
        'name': demographicsData?.haVaccinatorName1 ?? 'N/A',
        'designation': demographicsData?.haVaccinatorDesignation1 ?? 'N/A',
        'phone': 'N/A',
      },
      {
        'category': 'HA/Vaccinator Name 2',
        'name': demographicsData?.haVaccinatorName2 ?? 'N/A',
        'designation': demographicsData?.haVaccinatorDesignation2 ?? 'N/A',
        'phone': 'N/A',
      },
      {
        'category': 'Supervisor-1',
        'name': demographicsData?.supervisor1Name ?? 'N/A',
        'designation': demographicsData?.supervisor1Designation ?? 'N/A',
        'phone': 'N/A',
      },
    ];

    logg.i(personnel);

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
                            person['category'].toString(),
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
