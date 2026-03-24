import 'package:flutter/material.dart';

class EtlProcessingWidget extends StatelessWidget {
  const EtlProcessingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFDF6),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE86909),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.settings_applications_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ETL Processing',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0037B8),
                      ),
                    ),
                    Text(
                      'Extract, Transform, and Load data for seamless integration',
                      style: TextStyle(fontSize: 28, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              if (isWide) {
                return Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 52, child: _buildWhatIsEtlCard()),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 48,
                          child: _buildDataIntegrationSourcesCard(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 52,
                          child: Column(
                            children: [
                              _buildProcessCard(
                                icon: Icons.storage_rounded,
                                title: 'Extract',
                                description:
                                    'Automated data extraction via REST APIs (DHIS2 Analytics, KoBo REST API v2), geospatial file parsing (Shapefile, GeoJSON, KML), and scheduled batch imports. Implements OAuth 2.0 authentication, rate limiting, and incremental sync protocols with error handling and retry mechanisms for data integrity.',
                              ),
                              const SizedBox(height: 12),
                              _buildProcessCard(
                                icon: Icons.code_rounded,
                                title: 'Transform',
                                description:
                                    'Geospatial normalization (WGS84 coordinate system), topological validation, attribute mapping, and data quality checks (null handling, duplicate detection, geocoding validation). Executes spatial joins, buffer analysis, polygon aggregation, and calculates coverage metrics using FME Workbench, GDAL/OGR, and PostGIS functions.',
                              ),
                              const SizedBox(height: 12),
                              _buildProcessCard(
                                icon: Icons.link_rounded,
                                title: 'Load',
                                description:
                                    'Upsert operations into PostgreSQL/PostGIS data warehouse with spatial indexing (R-Tree, GiST). Implements transaction management, referential integrity checks, and optimized bulk loading. Creates materialized views for aggregated metrics, enables real-time dashboard queries, and maintains audit trails for data lineage.',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(flex: 48, child: _buildEtlOutputCard()),
                      ],
                    ),
                  ],
                );
              }

              return Column(
                children: [
                  _buildWhatIsEtlCard(),
                  const SizedBox(height: 12),
                  _buildDataIntegrationSourcesCard(),
                  const SizedBox(height: 12),
                  _buildProcessCard(
                    icon: Icons.storage_rounded,
                    title: 'Extract',
                    description:
                        'Automated data extraction via REST APIs (DHIS2 Analytics, KoBo REST API v2), geospatial file parsing (Shapefile, GeoJSON, KML), and scheduled batch imports. Implements OAuth 2.0 authentication, rate limiting, and incremental sync protocols with error handling and retry mechanisms for data integrity.',
                  ),
                  const SizedBox(height: 12),
                  _buildProcessCard(
                    icon: Icons.code_rounded,
                    title: 'Transform',
                    description:
                        'Geospatial normalization (WGS84 coordinate system), topological validation, attribute mapping, and data quality checks (null handling, duplicate detection, geocoding validation). Executes spatial joins, buffer analysis, polygon aggregation, and calculates coverage metrics using FME Workbench, GDAL/OGR, and PostGIS functions.',
                  ),
                  const SizedBox(height: 12),
                  _buildEtlOutputCard(),
                  const SizedBox(height: 12),
                  _buildProcessCard(
                    icon: Icons.link_rounded,
                    title: 'Load',
                    description:
                        'Upsert operations into PostgreSQL/PostGIS data warehouse with spatial indexing (R-Tree, GiST). Implements transaction management, referential integrity checks, and optimized bulk loading. Creates materialized views for aggregated metrics, enables real-time dashboard queries, and maintains audit trails for data lineage.',
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          _buildToolsAndTechnologiesCard(),
        ],
      ),
    );
  }

  Widget _buildWhatIsEtlCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCC9A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What is ETL Processing?',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0037B8),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'ETL Processing stands for Extract, Transform, Load - a standard data engineering process used to move and prepare data for analysis.',
            style: TextStyle(fontSize: 18, height: 1.4),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF7EE),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFCC9A)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Purpose of ETL',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  'Enable API-driven integration and standardization of nationwide immunization data from DHIS2 and OpenSRP. The ETL process systematically extracts, cleans, and transforms heterogeneous datasets into a centralized geospatial database for accurate GIS visualization, real-time monitoring, and evidence-informed decision-making.',
                  style: TextStyle(fontSize: 16, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataIntegrationSourcesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE86909),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Data Integration Sources',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 10),
          _buildSourceItem(
            icon: Icons.layers_rounded,
            title: 'GIS-Based Crowd Map Data',
            description:
                'Comprehensive administrative boundaries from Division to Sub-block level with integrated DHIS2/OpenSRP UID and BBS Geocode mapping',
          ),
          const SizedBox(height: 8),
          _buildSourceItem(
            icon: Icons.show_chart_rounded,
            title: 'EPI Performance Analytics',
            description:
                'Real-time vaccination coverage tracking: Total Children (0-11 months), complete immunization records for BCG, Penta 1/2/3, and MR 1/2 vaccines',
          ),
          const SizedBox(height: 8),
          _buildSourceItem(
            icon: Icons.groups_rounded,
            title: 'Microplan Intelligence',
            description:
                'Strategic population demographics and center infrastructure including yearly session planning and vaccinator team assignments',
          ),
          const SizedBox(height: 8),
          _buildSourceItem(
            icon: Icons.calendar_month_rounded,
            title: 'Dynamic Session Planning',
            description:
                'Monthly immunization session schedules cascading from Sub-block to District level for optimized service delivery',
          ),
        ],
      ),
    );
  }

  Widget _buildSourceItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProcessCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD8E7FF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFFF2C9),
            ),
            child: Icon(icon, color: Color(0xFFE86909), size: 24),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEtlOutputCard() {
    final outputs = [
      'Normalized PostGIS geodatabase with DHIS2 UID foreign keys, WGS84 (EPSG:4326) geometry columns, and spatial indexes for optimal query performance',
      'Validated EPI performance metrics (Penta-1 coverage, DPT dropout rates, zero-dose children counts) with completeness scores and data quality flags',
      'Integrated multi-scale boundary layers (administrative hierarchies) with health facility point geometries, catchment polygons',
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2D62FF), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Color(0xFFE86909)),
              SizedBox(width: 8),
              Text(
                'ETL Output',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...outputs.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: Color(0xFF00A86B),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(fontSize: 14, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolsAndTechnologiesCard() {
    final tools = [
      {'title': 'PostgreSQL', 'subtitle': 'Spatial database management', 'icon': Icons.storage_rounded},
      {'title': 'PHP, Laravel', 'subtitle': 'Backend', 'icon': Icons.code_rounded},
      {'title': 'DHIS2/OPENSRP', 'subtitle': 'Data Validation', 'icon': Icons.layers_rounded},
      {'title': 'REST API', 'subtitle': 'API Integration', 'icon': Icons.link_rounded},
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAEF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFCC9A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.layers_rounded, color: Color(0xFFE86909)),
              SizedBox(width: 8),
              Text(
                'ETL Tools & Technologies',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossAxisCount = constraints.maxWidth > 1100
                  ? 4
                  : constraints.maxWidth > 700
                      ? 2
                      : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 1.8,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: tools.length,
                itemBuilder: (context, index) {
                  final tool = tools[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE6EEF8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFFFF2C9),
                          ),
                          child: Icon(
                            tool['icon']! as IconData,
                            color: const Color(0xFFE86909),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          tool['title']! as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF0037B8),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          tool['subtitle']! as String,
                          style: const TextStyle(fontSize: 13),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}