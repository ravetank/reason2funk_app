import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:osc/osc.dart';

class OSCService extends ChangeNotifier {
  static const MethodChannel _channel = MethodChannel('reason2funk/osc');
  
  // Connection State
  bool _isConnected = false;
  String _serverAddress = '192.168.1.100';
  int _serverPort = 8000;
  int _clientPort = 9000;
  
  // OSC Client & Server
  OSCSocket? _oscSocket;
  InternetAddress? _targetAddress;
  
  // Connection Status
  bool get isConnected => _isConnected;
  String get serverAddress => _serverAddress;
  int get serverPort => _serverPort;
  int get clientPort => _clientPort;
  
  // Magic Music Visuals Integration
  final Map<String, OSCParameter> _magicMusicParams = {
    'master_opacity': OSCParameter('/mmv/master/opacity', 0.0, 1.0, 1.0),
    'layer1_opacity': OSCParameter('/mmv/layer1/opacity', 0.0, 1.0, 1.0),
    'layer2_opacity': OSCParameter('/mmv/layer2/opacity', 0.0, 1.0, 1.0),
    'layer3_opacity': OSCParameter('/mmv/layer3/opacity', 0.0, 1.0, 1.0),
    'crossfader': OSCParameter('/mmv/crossfader', 0.0, 1.0, 0.5),
    'color_hue': OSCParameter('/mmv/color/hue', 0.0, 360.0, 180.0),
    'color_saturation': OSCParameter('/mmv/color/saturation', 0.0, 1.0, 1.0),
    'color_brightness': OSCParameter('/mmv/color/brightness', 0.0, 1.0, 1.0),
    'effect_strength': OSCParameter('/mmv/effect/strength', 0.0, 1.0, 0.5),
    'audio_sensitivity': OSCParameter('/mmv/audio/sensitivity', 0.0, 2.0, 1.0),
  };
  
  // Jackson's Studio Setup Parameters
  final Map<String, OSCParameter> _jacksonSetupParams = {
    // Pioneer CDJ Controls
    'cdj1_tempo': OSCParameter('/pioneer/cdj1/tempo', -100.0, 100.0, 0.0),
    'cdj2_tempo': OSCParameter('/pioneer/cdj2/tempo', -100.0, 100.0, 0.0),
    'cdj1_volume': OSCParameter('/pioneer/cdj1/volume', 0.0, 1.0, 0.8),
    'cdj2_volume': OSCParameter('/pioneer/cdj2/volume', 0.0, 1.0, 0.8),
    
    // Roland V10 Mixer
    'mixer_crossfader': OSCParameter('/roland/v10/crossfader', 0.0, 1.0, 0.5),
    'mixer_ch1_gain': OSCParameter('/roland/v10/ch1/gain', 0.0, 1.0, 0.8),
    'mixer_ch2_gain': OSCParameter('/roland/v10/ch2/gain', 0.0, 1.0, 0.8),
    'mixer_master_volume': OSCParameter('/roland/v10/master/volume', 0.0, 1.0, 0.9),
    
    // Native Instruments Maschine
    'maschine_pad1': OSCParameter('/ni/maschine/pad1', 0.0, 127.0, 0.0),
    'maschine_pad2': OSCParameter('/ni/maschine/pad2', 0.0, 127.0, 0.0),
    'maschine_knob1': OSCParameter('/ni/maschine/knob1', 0.0, 127.0, 64.0),
    'maschine_knob2': OSCParameter('/ni/maschine/knob2', 0.0, 127.0, 64.0),
  };

  OSCService() {
    _initializeNativeChannel();
  }

  void _initializeNativeChannel() {
    _channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case 'onOSCMessageReceived':
          _handleIncomingOSCMessage(
            call.arguments['address'],
            call.arguments['arguments'],
          );
          break;
        case 'onConnectionStatusChanged':
          _handleConnectionStatusChange(call.arguments['connected']);
          break;
      }
    });
  }

  // Connection Management
  Future<bool> connect({
    String? address,
    int? serverPort,
    int? clientPort,
  }) async {
    try {
      _serverAddress = address ?? _serverAddress;
      _serverPort = serverPort ?? _serverPort;
      _clientPort = clientPort ?? _clientPort;

      // Create OSC socket
      _oscSocket = OSCSocket(
        socketConfig: SocketConfig.from(
          InternetAddress.anyIPv4,
          _clientPort,
          InternetAddress(_serverAddress),
          _serverPort,
        ),
      );

      await _oscSocket!.listen();
      _targetAddress = InternetAddress(_serverAddress);
      
      // Notify native layer
      await _channel.invokeMethod('connectOSC', {
        'address': _serverAddress,
        'serverPort': _serverPort,
        'clientPort': _clientPort,
      });

      _isConnected = true;
      notifyListeners();
      
      // Send initial connection test
      await sendOSCMessage('/test/connection', [1.0]);
      
      return true;
    } catch (e) {
      debugPrint('OSC Connection Error: $e');
      _isConnected = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> disconnect() async {
    try {
      await _oscSocket?.close();
      await _channel.invokeMethod('disconnectOSC');
      
      _oscSocket = null;
      _targetAddress = null;
      _isConnected = false;
      notifyListeners();
    } catch (e) {
      debugPrint('OSC Disconnect Error: $e');
    }
  }

  // OSC Message Sending
  Future<void> sendOSCMessage(String address, List<dynamic> arguments) async {
    if (!_isConnected || _oscSocket == null) {
      debugPrint('OSC not connected');
      return;
    }

    try {
      final message = OSCMessage(address, arguments: arguments);
      await _oscSocket!.send(message);
      
      // Also send via native channel for additional processing
      await _channel.invokeMethod('sendOSCMessage', {
        'address': address,
        'arguments': arguments,
      });
    } catch (e) {
      debugPrint('Send OSC Message Error: $e');
    }
  }

  // Parameter Control
  Future<void> setParameter(String paramId, double value) async {
    OSCParameter? param = _magicMusicParams[paramId] ?? _jacksonSetupParams[paramId];
    
    if (param == null) {
      debugPrint('Parameter not found: $paramId');
      return;
    }

    // Clamp value to parameter range
    double clampedValue = value.clamp(param.minValue, param.maxValue);
    param.currentValue = clampedValue;
    
    await sendOSCMessage(param.address, [clampedValue]);
  }

  // Magic Music Visuals Presets
  Future<void> loadMagicMusicPreset(String presetName) async {
    await sendOSCMessage('/mmv/preset/load', [presetName]);
  }

  Future<void> triggerVisualEffect(String effectName) async {
    await sendOSCMessage('/mmv/effect/trigger', [effectName]);
  }

  // Jackson's Studio Setup
  Future<void> loadJacksonSetup() async {
    // Load preset values for all parameters
    for (String paramId in _jacksonSetupParams.keys) {
      OSCParameter param = _jacksonSetupParams[paramId]!;
      await sendOSCMessage(param.address, [param.currentValue]);
      await Future.delayed(const Duration(milliseconds: 10));
    }
    
    // Load Magic Music Visuals setup
    await loadMagicMusicPreset('Jackson_Studio_V1');
  }

  Future<void> syncBPM(double bpm) async {
    await sendOSCMessage('/sync/bpm', [bpm]);
    await sendOSCMessage('/mmv/sync/bpm', [bpm]);
  }

  // Message Handling
  void _handleIncomingOSCMessage(String address, List<dynamic> arguments) {
    debugPrint('Received OSC: $address - $arguments');
    
    // Handle specific incoming messages
    switch (address) {
      case '/mmv/status':
        // Handle Magic Music Visuals status updates
        break;
      case '/sync/bpm':
        // Handle BPM sync from external source
        if (arguments.isNotEmpty) {
          double bpm = arguments[0].toDouble();
          // Update UI or trigger actions based on BPM
        }
        break;
    }
    
    notifyListeners();
  }

  void _handleConnectionStatusChange(bool connected) {
    _isConnected = connected;
    notifyListeners();
  }

  // Getters for parameters
  Map<String, OSCParameter> get magicMusicParams => _magicMusicParams;
  Map<String, OSCParameter> get jacksonSetupParams => _jacksonSetupParams;
  
  OSCParameter? getParameter(String paramId) {
    return _magicMusicParams[paramId] ?? _jacksonSetupParams[paramId];
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}

class OSCParameter {
  final String address;
  final double minValue;
  final double maxValue;
  double currentValue;

  OSCParameter(this.address, this.minValue, this.maxValue, this.currentValue);

  double get normalizedValue => (currentValue - minValue) / (maxValue - minValue);
  
  void setNormalizedValue(double normalizedValue) {
    currentValue = minValue + (normalizedValue * (maxValue - minValue));
  }
}