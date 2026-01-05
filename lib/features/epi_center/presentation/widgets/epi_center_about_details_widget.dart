import 'package:flutter/material.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_details_response.dart';

class EpiCenterAboutDetailsWidget extends StatelessWidget {
  const EpiCenterAboutDetailsWidget({
    super.key,
    required this.epiCenterDetailsData,
    required this.selectedYear,
  });
  final EpiCenterDetailsResponse? epiCenterDetailsData;
  final String selectedYear;
  @override
  Widget build(BuildContext context) {
    // ✅ Use helper method that handles both country-level and EPI-level data
    final demographicsData = epiCenterDetailsData?.getDemographicsForYear(
      selectedYear,
    );
    final details = [
      {
        'label': 'Name and Address of EPI Center',
        'value': demographicsData?.epiCenterNameAddress ?? 'N/A',
      },
      {
        'label': 'EPI Center Implementer Name',
        'value': demographicsData?.epiCenterImplementerName ?? 'N/A',
      },
      {
        'label': 'Distance from CC to EPI Center',
        'value': demographicsData?.distanceFromCcToEpiCenter ?? 'N/A',
      },
      {
        'label': 'Transportation',

        'value': demographicsData?.modeOfTransportationDistribution ?? 'N/A',
      },
      {
        'label': 'Time required to reach EPI Center (minute)',
        'value': demographicsData?.timeToReachEpiCenter ?? 'N/A',
      },
      {'label': 'Porter Name', 'value': demographicsData?.porterName ?? 'N/A'},
      {'label': 'Porter Phone', 'value': 'N/A'},
      {
        'label': 'Center Type',
        'value': demographicsData?.epiCenterType ?? 'N/A',
      },
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
                              detail['label'].toString(),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                // color: Colors.blueGrey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              detail['value'].toString(),
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
