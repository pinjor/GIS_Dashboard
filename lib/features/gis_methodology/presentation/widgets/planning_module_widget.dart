import 'package:flutter/material.dart';

import '../../../../core/common/constants/constants.dart';

class PlanningModulesWidget extends StatefulWidget {
  const PlanningModulesWidget({super.key});

  @override
  State<PlanningModulesWidget> createState() => _PlanningModulesWidgetState();
}

class _PlanningModulesWidgetState extends State<PlanningModulesWidget>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<_TabItem> _tabs = [
    _TabItem(
      icon: Icons.location_on_outlined,
      title: "Micro-plan",
      color: const Color(0xFFF3E8FF),
    ),
    _TabItem(
      icon: Icons.calendar_today_rounded,
      title: "Session Plan",
      color: const Color(0xFFE8F5FF),
    ),
    _TabItem(
      icon: Icons.bar_chart_rounded,
      title: "Zero Dose Dashboard",
      color: const Color(0xFFFFF0F0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // On small screens → Tabs on top
          if (constraints.maxWidth < 600) {
            return Column(
              children: [
                _buildMobileTabBar(),
                const SizedBox(height: 20),
                _buildTabContent(),
              ],
            );
          }

          // On larger phones/tablets → Tabs on left, content on right
          return Row(
            children: [
              _buildVerticalTabs(),
              const SizedBox(width: 20),
              Expanded(child: _buildTabContent()),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMobileTabBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _tabs.asMap().entries.map((entry) {
          int idx = entry.key;
          var tab = entry.value;
          bool isSelected = _selectedIndex == idx;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = idx),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? tab.color : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.deepPurple : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      tab.icon,
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      tab.title,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? Colors.deepPurple
                            : Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVerticalTabs() {
    return Container(
      width: 140,
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: _tabs.asMap().entries.map((entry) {
          int idx = entry.key;
          var tab = entry.value;
          bool isSelected = _selectedIndex == idx;

          return GestureDetector(
            onTap: () => setState(() => _selectedIndex = idx),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? tab.color : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.deepPurple : Colors.transparent,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    tab.icon,
                    size: 32,
                    color: isSelected
                        ? Colors.deepPurple
                        : Colors.grey.shade600,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    tab.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.deepPurple
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedIndex) {
      case 0:
        return const MicroPlanContent();
      case 1:
        return const SessionPlanContent();
      case 2:
        return const ZeroDoseDashboardContent();
      default:
        return const SizedBox();
    }
  }
}

// Individual Tab Contents
class MicroPlanContent extends StatelessWidget {
  const MicroPlanContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Micro-plan Module",
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: Colors.deepPurple),
        ),
        const Text(
          "From the Micro-plan menu user can see the Detailed Microplan of the selected Administrative Unit (Division to Sub-block)",
          style: TextStyle(fontSize: 12),
        ),
        const SizedBox(height: 16),
        Image.asset(Constants.microPlanModuleImgPath, fit: BoxFit.contain),
      ],
    );
  }
}

class SessionPlanContent extends StatelessWidget {
  const SessionPlanContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Session Plan Module",
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: Colors.blue),
        ),
        const Text(
          "Plan and manage vaccination sessions with optimal scheduling, location selection, and resource management.",
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _featureItem("Session scheduling and calendar management"),
            _featureItem("Venue selection based on geographic data"),
            _featureItem("Team deployment and logistics coordination"),
            _featureItem("Vaccine and cold chain equipment planning"),
          ],
        ),
      ],
    );
  }

  Widget _featureItem(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Flexible(child: Text(text, style: const TextStyle(fontSize: 15))),
      ],
    );
  }
}

class ZeroDoseDashboardContent extends StatelessWidget {
  const ZeroDoseDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Zero Dose Dashboard",
          style: Theme.of(
            context,
          ).textTheme.titleLarge!.copyWith(color: Colors.redAccent),
        ),
        const Text("Track and reach unvaccinated children"),
        const SizedBox(height: 16),
        const Text(
          "Track and reach zero-dose children (those who have not received Penta-1 vaccine) to ensure complete immunization coverage. Zero Dose is calculated as: (Target − Penta 1 Covered) = Zero Dose.",
        ),
        const SizedBox(height: 16),
        const Text(
          "Map Symbology (4 categories)",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        _symbolRow(const Color(0xFF4CAF50), "≤ 0% - Green"),
        _symbolRow(const Color(0xFF8BC34A), ">0% - ≤5% - Light Green"),
        _symbolRow(const Color(0xFFFF9800), ">5% - ≤15% - Orange"),
        _symbolRow(const Color(0xFFF44336), "≥ 15% - Red"),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _chip("Penta-1 specific tracking (no vaccine selection needed)"),
            const SizedBox(height: 8),
            _chip(
              "Top 5 Districts, Upazilas, City Corporations, Unions, and Wards bar diagram",
            ),
            const SizedBox(height: 8),
            _chip("Interactive map with 4-category color-coded symbology"),
            const SizedBox(height: 8),
            _chip("Drilldown capability across administrative levels"),
          ],
        ),
      ],
    );
  }

  Widget _symbolRow(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(width: 20, height: 20, color: color),
          const SizedBox(width: 12),
          Text(text),
        ],
      ),
    );
  }

  Widget _chip(String label) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, size: 20, color: Colors.orange),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper class
class _TabItem {
  final IconData icon;
  final String title;
  final Color color;
  _TabItem({required this.icon, required this.title, required this.color});
}
