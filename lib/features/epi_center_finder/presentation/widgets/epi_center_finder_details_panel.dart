import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:gis_dashboard/core/common/constants/constants.dart';
import 'package:gis_dashboard/core/common/widgets/custom_loading_widget.dart';
import 'package:gis_dashboard/features/epi_center/domain/epi_center_details_response.dart';
import 'package:gis_dashboard/features/filter/presentation/controllers/filter_controller.dart';
import '../../domain/epi_center_finder_state.dart';
import '../../domain/epi_center_result.dart';

class EpiCenterFinderDetailsPanel extends ConsumerWidget {
  const EpiCenterFinderDetailsPanel({
    super.key,
    required this.state,
    required this.selectedResult,
  });

  final EpiCenterFinderState state;
  final EpiCenterResult selectedResult;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterControllerProvider);
    final selectedYear = filterState.selectedYear;
    final details = state.selectedCenterDetails;
    final primaryColor = Color(Constants.primaryColor);

    if (state.isLoadingDetails) {
      return const Center(
        child: CustomLoadingWidget(
          loadingText: 'Loading EPI center details...',
        ),
      );
    }

    if (state.detailsError != null && details == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            state.detailsError!,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
          ),
        ),
      );
    }

    if (details == null) {
      return Center(
        child: Text(
          'Select an EPI center to view details.',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
        ),
      );
    }

    final demographics = details.getDemographicsForYear(selectedYear);
    final rows = _buildDetailRows(demographics);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                selectedResult.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'EPI Center Details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: WidgetStateProperty.all(primaryColor),
                  dataRowMinHeight: 48,
                  dataRowMaxHeight: 72,
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(
                      label: Text(
                        'Field',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Value',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                  rows: rows.map((row) {
                    final canDial = row.dialNumber != null &&
                        row.dialNumber!.length >= 6 &&
                        row.displayValue != 'N/A';

                    return DataRow(
                      cells: [
                        DataCell(
                          SizedBox(
                            width: 180,
                            child: Text(
                              row.label,
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        DataCell(
                          _DetailValueCell(
                            displayValue: row.displayValue,
                            showAsLink: canDial,
                          ),
                          onTap: canDial
                              ? () => launchPhoneDialer(context, row.dialNumber!)
                              : null,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_DetailRowData> _buildDetailRows(YearDemographics? demographics) {
    return [
      _DetailRowData(
        label: 'Name and Address of EPI Center',
        displayValue: _displayValue(demographics?.epiCenterNameAddress),
      ),
      _DetailRowData(
        label: 'EPI Center Implementer Name',
        displayValue: _displayValue(demographics?.epiCenterImplementerName),
      ),
      _DetailRowData(
        label: 'Distance from CC to EPI Center',
        displayValue: _displayValue(demographics?.distanceFromCcToEpiCenter),
      ),
      _DetailRowData(
        label: 'Transportation',
        displayValue:
            _displayValue(demographics?.modeOfTransportationDistribution),
      ),
      _DetailRowData(
        label: 'Time required to reach EPI Center (minute)',
        displayValue: _displayValue(demographics?.timeToReachEpiCenter),
      ),
      _DetailRowData(
        label: 'Porter Name',
        displayValue: _displayValue(demographics?.porterName),
      ),
      _DetailRowData(
        label: 'Porter Phone',
        displayValue: _formatPhoneDisplay(demographics?.porterMobile),
        dialNumber: _phoneDialValue(demographics?.porterMobile),
      ),
      _DetailRowData(
        label: 'Center Type',
        displayValue: _displayValue(demographics?.epiCenterType),
      ),
    ];
  }

  static String _displayValue(dynamic value) {
    if (value == null) return 'N/A';
    final text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return 'N/A';
    return text;
  }

  static String _formatPhoneDisplay(dynamic value) {
    final dial = _phoneDialValue(value);
    if (dial.isEmpty) return 'N/A';
    return dial;
  }

  static String _phoneDialValue(dynamic value) {
    if (value == null) return '';

    String text = value.toString().trim();
    if (text.isEmpty || text.toLowerCase() == 'null') return '';

    if (text.contains('E') || text.contains('e')) {
      try {
        final parsed = double.parse(text);
        text = parsed.toInt().toString();
      } catch (_) {}
    }

    if (value is num && !text.contains('E') && !text.contains('e')) {
      text = value.toInt().toString();
    }

    return text.replaceAll(RegExp(r'[^\d+]'), '');
  }
}

Future<void> launchPhoneDialer(BuildContext context, String number) async {
  final uri = Uri(scheme: 'tel', path: number);

  try {
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the phone dialer.')),
      );
    }
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open the phone dialer.')),
      );
    }
  }
}

class _DetailRowData {
  const _DetailRowData({
    required this.label,
    required this.displayValue,
    this.dialNumber,
  });

  final String label;
  final String displayValue;
  final String? dialNumber;
}

class _DetailValueCell extends StatelessWidget {
  const _DetailValueCell({
    required this.displayValue,
    this.showAsLink = false,
  });

  final String displayValue;
  final bool showAsLink;

  @override
  Widget build(BuildContext context) {
    if (!showAsLink) {
      return SizedBox(
        width: 220,
        child: Text(displayValue),
      );
    }

    return SizedBox(
      width: 220,
      child: Row(
        children: [
          Expanded(
            child: Text(
              displayValue,
              style: TextStyle(
                color: Color(Constants.primaryColor),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(
            Icons.phone,
            size: 18,
            color: Color(Constants.primaryColor),
          ),
        ],
      ),
    );
  }
}
