class Constants {
  static const int primaryColor = 0xFF1CB0EA;
  static const int scaffoldBackgroundColor = 0xFFF5F5F5;
  static const int cardColor = 0xFFEAEAEA;
  static const String envFileName = '.env';
  static const String appTitle = 'GIS Dashboard';
  static const String bdMapLogoPath = 'assets/icons/bd_map_logo.png';
  static const String eqmsLogoPath = 'assets/icons/eqms_logo.png';
  static const String unicefLogoPath = 'assets/icons/unicef_logo.png';
  static const String poweredByLeftLogosPath =
      'assets/icons/powered_by_left_logos.png';
  static const String mapLocationIconPath = 'assets/icons/map_location.svg';
  static const String lineGraphIconPath = 'assets/icons/line_graph.svg';
  static const String filterIconPath = 'assets/icons/filter_data.svg';
  static const String childrenIconPath = 'assets/icons/children.svg';
  static const String dosesIconPath = 'assets/icons/doses.svg';

  static const String urlTemplate =
      'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
  static final subDomains = ['a', 'b', 'c'];

  static const String fallbackUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const String userAgentPackageName = 'com.example.gis_dashboard';
}
