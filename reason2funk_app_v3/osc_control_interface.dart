import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OSCControlInterface extends StatefulWidget {
  const OSCControlInterface({Key? key}) : super(key: key);

  @override
  State<OSCControlInterface> createState() => _OSCControlInterfaceState();
}

class _OSCControlInterfaceState extends State<OSCControlInterface> with TickerProviderStateMixin {
  static const Color primaryOrange = Color(0xFFC76E19);
  static const Color darkBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB3B3B3);

  late TabController _tabController;
  String _connectionStatus = 'Disconnected';
  bool _isConnecting = false;

  final TextEditingController _addressController = TextEditingController(text: '192.168.1.100');
  final TextEditingController _portController = TextEditingController(text: '8000');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _addressController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OSCService>(
      builder: (context, oscService, child) {
        return Scaffold(
          backgroundColor: darkBackground,
          appBar: AppBar(
            backgroundColor: darkBackground,
            title: const Text('OSC Control', style: TextStyle(color: textPrimary)),
            bottom: TabBar(
              controller: _tabController,
              labelColor: primaryOrange,
              unselectedLabelColor: textSecondary,
              indicatorColor: primaryOrange,
              tabs: const [
                Tab(text: 'Magic Music'),
                Tab(text: 'Jackson Setup'),
                Tab(text: 'Connection'),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: oscService.isConnected ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  oscService.isConnected ? 'Connected' : 'Disconnected',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildMagicMusicControls(oscService),
              _buildJacksonSetupControls(oscService),
              _buildConnectionTab(oscService),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMagicMusicControls(OSCService oscService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Preset Selection
          _buildSectionHeader('Visual Presets'),
          _buildPresetGrid(),
          
          const SizedBox(height: 24),
          
          // Layer Controls
          _buildSectionHeader('Layer Mixing'),
          _buildLayerControls(oscService),
          
          const SizedBox(height: 24),
          
          // Color Controls
          _buildSectionHeader('Color Control'),
          _buildColorControls(oscService),
          
          const SizedBox(height: 24),
          
          // Audio Reactivity
          _buildSectionHeader('Audio Reactivity'),
          _buildAudioControls(oscService),
        ],
      ),
    );
  }

  Widget _buildJacksonSetupControls(OSCService oscService) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Load Jackson's Setup
          _buildJacksonSetupBanner(oscService),
          
          const SizedBox(height: 24),
          
          // Pioneer CDJ Controls
          _buildSectionHeader('Pioneer CDJs'),
          _buildCDJControls(oscService),
          
          const SizedBox(height: 24),
          
          // Roland V10 Mixer
          _buildSectionHeader('Roland V10 Mixer'),
          _buildMixerControls(oscService),
          
          const SizedBox(height: 24),
          
          // Native Instruments Maschine
          _buildSectionHeader('Native Instruments Maschine'),
          _buildMaschineControls(oscService),
        ],
      ),
    );
  }

  Widget _buildConnectionTab(OSCService oscService) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('OSC Server Settings'),
          
          const SizedBox(height: 16),
          
          // Server Address
          TextField(
            controller: _addressController,
            style: const TextStyle(color: textPrimary),
            decoration: InputDecoration(
              labelText: 'Server Address',
              labelStyle: TextStyle(color: textSecondary),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: textSecondary),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: primaryOrange),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Server Port
          TextField(
            controller: _portController,
            style: const TextStyle(color: textPrimary),
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Server Port',
              labelStyle: TextStyle(color: textSecondary),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: textSecondary),
              ),
              foc