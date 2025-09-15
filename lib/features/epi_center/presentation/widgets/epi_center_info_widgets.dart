import 'package:flutter/material.dart';

/// Collection of EPI Center information widgets
class EpiCenterLocationBreadcrumb extends StatelessWidget {
  final dynamic epiData;

  const EpiCenterLocationBreadcrumb({super.key, required this.epiData});

  @override
  Widget build(BuildContext context) {
    final breadcrumbs = <String>[];

    if (epiData.divisionName != null && epiData.divisionName.isNotEmpty) {
      breadcrumbs.add(epiData.divisionName);
    }
    if (epiData.districtName != null && epiData.districtName.isNotEmpty) {
      breadcrumbs.add(epiData.districtName);
    }
    if (epiData.upazilaName != null && epiData.upazilaName.isNotEmpty) {
      breadcrumbs.add(epiData.upazilaName);
    }
    if (epiData.unionName != null && epiData.unionName.isNotEmpty) {
      breadcrumbs.add(epiData.unionName);
    }
    if (epiData.wardName != null && epiData.wardName.isNotEmpty) {
      breadcrumbs.add(epiData.wardName);
    }

    if (breadcrumbs.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on, color: Colors.blue[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              breadcrumbs.join(' → '),
              style: TextStyle(
                color: Colors.blue[800],
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EpiCenterCityCorporationInfo extends StatelessWidget {
  final dynamic epiData;

  const EpiCenterCityCorporationInfo({super.key, required this.epiData});

  @override
  Widget build(BuildContext context) {
    if (epiData.cityCorporationName == null ||
        epiData.cityCorporationName.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_city, color: Colors.orange[600], size: 24),
              const SizedBox(width: 8),
              const Text(
                'City Corporation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            epiData.cityCorporationName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.orange[800],
            ),
          ),
          if (epiData.wardName != null && epiData.wardName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              'Ward: ${epiData.wardName}',
              style: TextStyle(fontSize: 14, color: Colors.orange[700]),
            ),
          ],
        ],
      ),
    );
  }
}

class EpiCenterInfoCards extends StatelessWidget {
  final String epiCenterName;

  const EpiCenterInfoCards({super.key, required this.epiCenterName});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LocationInfoCard(epiCenterName: epiCenterName),
        const SizedBox(height: 16),
        const ContactInfoCard(),
        const SizedBox(height: 16),
        const TransportInfoCard(),
        const SizedBox(height: 16),
        const CenterTypeCard(),
      ],
    );
  }
}

class LocationInfoCard extends StatelessWidget {
  final String epiCenterName;

  const LocationInfoCard({super.key, required this.epiCenterName});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.blue[600], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Location Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            InfoItem(label: 'EPI Center Name', value: epiCenterName),
            InfoItem(
              label: 'Address',
              value: 'Address information not available',
            ),
            InfoItem(label: 'Coordinates', value: 'Coordinates not available'),
          ],
        ),
      ),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.contact_phone, color: Colors.green[600], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Contact Information',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const InfoItem(label: 'Phone', value: 'Not available'),
            const InfoItem(label: 'Email', value: 'Not available'),
            const InfoItem(label: 'Officer in Charge', value: 'Not available'),
            const InfoItem(
              label: 'Operating Hours',
              value: '8:00 AM - 4:00 PM (assumed)',
            ),
          ],
        ),
      ),
    );
  }
}

class TransportInfoCard extends StatelessWidget {
  const TransportInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.directions_car, color: Colors.orange[600], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Transport & Accessibility',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const InfoItem(
              label: 'Vehicle Access',
              value: 'Information not available',
            ),
            const InfoItem(
              label: 'Cold Chain Storage',
              value: 'Available (assumed)',
            ),
            const InfoItem(
              label: 'Backup Power',
              value: 'Information not available',
            ),
            const InfoItem(
              label: 'Waste Management',
              value: 'Standard protocol (assumed)',
            ),
          ],
        ),
      ),
    );
  }
}

class CenterTypeCard extends StatelessWidget {
  const CenterTypeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital, color: Colors.purple[600], size: 24),
                const SizedBox(width: 8),
                const Text(
                  'Center Classification',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const InfoItem(
              label: 'Center Type',
              value: 'EPI Vaccination Center',
            ),
            const InfoItem(label: 'Service Level', value: 'Primary Healthcare'),
            const InfoItem(label: 'Catchment Area', value: 'Local community'),
            Container(
              margin: const EdgeInsets.only(top: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Active vaccination center providing immunization services',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InfoItem extends StatelessWidget {
  final String label;
  final String value;

  const InfoItem({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
