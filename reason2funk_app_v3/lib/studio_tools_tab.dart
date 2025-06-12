import 'package:flutter/material.dart';

class StudioToolsTab extends StatefulWidget {
  const StudioToolsTab({Key? key}) : super(key: key);

  @override
  State<StudioToolsTab> createState() => _StudioToolsTabState();
}

class _StudioToolsTabState extends State<StudioToolsTab> {
  static const Color primaryOrange = Color(0xFFC76E19);
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);

  final List<StudioTool> studioTools = [
    StudioTool(
      id: 'osc_control',
      title: 'OSC Control',
      description: 'Visual software parameter control\nMagic Music Visuals integration',
      iconPath: 'assets/icons/studio_tools/osc_control.webp',
      route: '/studio/osc-control',
    ),
    StudioTool(
      id: 'midi_mapping',
      title: 'MIDI Mapping',
      description: 'Controller templates and\ncustom mappings',
      iconPath: 'assets/icons/studio_tools/midi_mapping.webp',
      route: '/studio/midi-mapping',
    ),
    StudioTool(
      id: 'visuals',
      title: 'Visuals',
      description: 'Scene management and\neffects control',
      iconPath: 'assets/icons/studio_tools/visuals.webp',
      route: '/studio/visuals',
    ),
    StudioTool(
      id: 'obs_macros',
      title: 'OBS Macros',
      description: 'Stream control and\nautomation',
      iconPath: 'assets/icons/studio_tools/obs_macros.webp',
      route: '/studio/obs-macros',
    ),
    StudioTool(
      id: 'audio_routing',
      title: 'Audio Routing',
      description: 'Signal flow templates\nV10 mixer setup',
      iconPath: 'assets/icons/studio_tools/audio_routing.webp',
      route: '/studio/audio-routing',
    ),
    StudioTool(
      id: 'live_stream',
      title: 'Live Stream',
      description: 'Twitch integration and\nviewer interaction',
      iconPath: 'assets/icons/studio_tools/live_stream.webp',
      route: '/studio/live-stream',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackground,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120.0,
            floating: false,
            pinned: true,
            backgroundColor: darkBackground,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                'Studio Tools',
                style: TextStyle(
                  color: textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      primaryOrange.withOpacity(0.1),
                      darkBackground,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Jackson's Setup Banner
                _buildJacksonSetupBanner(),
                const SizedBox(height: 24),
                
                // Tools Grid
                _buildToolsGrid(),
                
                const SizedBox(height: 24),
                
                // Quick Actions
                _buildQuickActions(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJacksonSetupBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: primaryOrange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryOrange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.star,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Jackson\'s Studio Setup',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Professional preset templates ready to load',
                  style: TextStyle(
                    color: textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: primaryOrange,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildToolsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
      ),
      itemCount: studioTools.length,
      itemBuilder: (context, index) {
        return _buildToolCard(studioTools[index]);
      },
    );
  }

  Widget _buildToolCard(StudioTool tool) {
    return GestureDetector(
      onTap: () => _navigateToTool(tool),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: primaryOrange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Image.asset(
                tool.iconPath,
                color: primaryOrange,
                width: 24,
                height: 24,
              ),
            ),
            const SizedBox(height: 16),
            
            // Title
            Text(
              tool.title,
              style: const TextStyle(
                color: textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Description
            Expanded(
              child: Text(
                tool.description,
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                  height: 1.4,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            color: textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionButton(
                'Connect OSC',
                Icons.link,
                () => _connectOSC(),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionButton(
                'Load Preset',
                Icons.upload,
                () => _loadPreset(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primaryOrange.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: primaryOrange, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToTool(StudioTool tool) {
    // TODO: Navigate to specific tool interface
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${tool.title}...'),
        backgroundColor: primaryOrange,
      ),
    );
  }

  void _connectOSC() {
    // TODO: Implement OSC connection
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Connecting to OSC server...'),
        backgroundColor: primaryOrange,
      ),
    );
  }

  void _loadPreset() {
    // TODO: Implement preset loading
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Loading Jackson\'s Setup...'),
        backgroundColor: primaryOrange,
      ),
    );
  }
}

class StudioTool {
  final String id;
  final String title;
  final String description;
  final String iconPath;
  final String route;

  StudioTool({
    required this.id,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.route,
  });
}