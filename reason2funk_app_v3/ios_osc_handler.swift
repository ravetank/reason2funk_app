import UIKit
import Flutter
import Network

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    private let CHANNEL = "reason2funk/osc"
    private var oscConnection: NWConnection?
    private var oscListener: NWListener?
    private var isConnected = false
    private var serverEndpoint: NWEndpoint?
    private var clientPort: UInt16 = 9000
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let oscChannel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        
        oscChannel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let self = self else { return }
            
            switch call.method {
            case "connectOSC":
                if let args = call.arguments as? [String: Any] {
                    let address = args["address"] as? String ?? "192.168.1.100"
                    let serverPort = args["serverPort"] as? Int ?? 8000
                    let clientPort = args["clientPort"] as? Int ?? 9000
                    
                    self.connectOSC(address: address, serverPort: serverPort, clientPort: clientPort, result: result)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                }
                
            case "disconnectOSC":
                self.disconnectOSC(result: result)
                
            case "sendOSCMessage":
                if let args = call.arguments as? [String: Any] {
                    let address = args["address"] as? String ?? ""
                    let arguments = args["arguments"] as? [Any] ?? []
                    
                    self.sendOSCMessage(address: address, arguments: arguments, result: result)
                } else {
                    result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
                }
                
            default:
                result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    private func connectOSC(address: String, serverPort: Int, clientPort: Int, result: @escaping FlutterResult) {
        // Disconnect existing connection
        disconnectOSC()
        
        // Create server endpoint
        guard let host = NWEndpoint.Host(address) else {
            result(FlutterError(code: "INVALID_ADDRESS", message: "Invalid server address", details: nil))
            return
        }
        
        let port = NWEndpoint.Port(integerLiteral: UInt16(serverPort))
        serverEndpoint = NWEndpoint.hostPort(host: host, port: port)
        self.clientPort = UInt16(clientPort)
        
        // Create UDP connection for sending
        oscConnection = NWConnection(to: serverEndpoint!, using: .udp)
        
        oscConnection?.stateUpdateHandler = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .ready:
                    self?.isConnected = true
                    self?.notifyConnectionStatus(connected: true)
                    print("OSC Connected to \(address):\(serverPort)")
                    result(true)
                    
                case .failed(let error):
                    self?.isConnected = false
                    self?.notifyConnectionStatus(connected: false)
                    print("OSC Connection failed: \(error)")
                    result(FlutterError(code: "CONNECTION_FAILED", message: error.localizedDescription, details: nil))
                    
                default:
                    break
                }
            }
        }
        
        // Start connection
        oscConnection?.start(queue: .global())
        
        // Start UDP listener for incoming messages
        startOSCListener()
    }
    
    private func disconnectOSC(result: FlutterResult? = nil) {
        oscConnection?.cancel()
        oscConnection = nil
        
        oscListener?.cancel()
        oscListener = nil
        
        isConnected = false
        notifyConnectionStatus(connected: false)
        
        print("OSC Disconnected")
        result?(true)
    }
    
    private func sendOSCMessage(address: String, arguments: [Any], result: @escaping FlutterResult) {
        guard isConnected, let connection = oscConnection else {
            result(FlutterError(code: "NOT_CONNECTED", message: "OSC not connected", details: nil))
            return
        }
        
        do {
            let oscData = try buildOSCMessage(address: address, arguments: arguments)
            
            connection.send(content: oscData, completion: .contentProcessed({ error in
                DispatchQueue.main.async {
                    if let error = error {
                        print("Send OSC failed: \(error)")
                        result(FlutterError(code: "SEND_FAILED", message: error.localizedDescription, details: nil))
                    } else {
                        print("Sent OSC: \(address) -> \(arguments)")
                        result(true)
                    }
                }
            }))
            
        } catch {
            result(FlutterError(code: "BUILD_FAILED", message: error.localizedDescription, details: nil))
        }
    }
    
    private func startOSCListener() {
        guard let port = NWEndpoint.Port(integerLiteral: clientPort) else { return }
        
        do {
            oscListener = try NWListener(using: .udp, on: port)
            
            oscListener?.newConnectionHandler = { [weak self] connection in
                connection.start(queue: .global())
                self?.receiveOSCMessages(connection: connection)
            }
            
            oscListener?.start(queue: .global())
            
        } catch {
            print("Failed to start OSC listener: \(error)")
        }
    }
    
    private func receiveOSCMessages(connection: NWConnection) {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 1024) { [weak self] data, _, isComplete, error in
            
            if let data = data, !data.isEmpty {
                if let message = self?.parseOSCMessage(data: data) {
                    DispatchQueue.main.async {
                        self?.notifyIncomingMessage(address: message.0, arguments: message.1)
                    }
                }
            }
            
            if !isComplete {
                self?.receiveOSCMessages(connection: connection)
            }
        }
    }
    
    private func buildOSCMessage(address: String, arguments: [Any]) throws -> Data {
        var data = Data()
        
        // Add address with null terminator and padding
        let addressData = address.data(using: .utf8)!
        data.append(addressData)
        data.append(0) // null terminator
        
        // Pad to 4-byte boundary
        while data.count % 4 != 0 {
            data.append(0)
        }
        
        // Build type tag string
        var typeTag = ","
        for arg in arguments {
            switch arg {
            case is Float, is Double:
                typeTag += "f"
            case is Int:
                typeTag += "i"
            case is String:
                typeTag += "s"
            default:
                typeTag += "f" // Default to float
            }
        }
        
        // Add type tag with padding
        let typeTagData = typeTag.data(using: .utf8)!
        data.append(typeTagData)
        data.append(0) // null terminator
        
        while data.count % 4 != 0 {
            data.append(0)
        }
        
        // Add arguments
        for arg in arguments {
            switch arg {
            case let floatVal as Float:
                data.append(floatVal.bitPattern.bigEndian.data)
            case let doubleVal as Double:
                data.append(Float(doubleVal).bitPattern.bigEndian.data)
            case let intVal as Int:
                data.append(Int32(intVal).bigEndian.data)
            case let stringVal as String:
                let stringData = stringVal.data(using: .utf8)!
                data.append(stringData)
                data.append(0) // null terminator
                
                while data.count % 4 != 0 {
                    data.append(0)
                }
            default:
                if let floatVal = Float(String(describing: arg)) {
                    data.append(floatVal.bitPattern.bigEndian.data)
                } else {
                    data.append(Float(0.0).bitPattern.bigEndian.data)
                }
            }
        }
        
        return data
    }
    
    private func parseOSCMessage(data: Data) -> (String, [Any])? {
        var offset = 0
        
        // Parse address
        guard let addressEndIndex = data[offset...].firstIndex(of: 0) else { return nil }
        let addressData = data[offset..<addressEndIndex]
        guard let address = String(data: addressData, encoding: .utf8) else { return nil }
        
        // Move past address and padding
        offset = addressEndIndex + 1
        while offset % 4 != 0 && offset < data.count {
            offset += 1
        }
        
        if offset >= data.count {
            return (address, [])
        }
        
        // Parse type tags
        guard let typeTagEndIndex = data[offset...].firstIndex(of: 0) else { return nil }
        let typeTagData = data[offset..<typeTagEndIndex]
        guard let typeTagString = String(data: typeTagData, encoding: .utf8) else { return nil }
        
        // Move past type tags and padding
        offset = typeTagEndIndex + 1
        while offset % 4 != 0 && offset < data.count {
            offset += 1
        }
        
        var arguments: [Any] = []
        
        // Parse arguments based on type tags
        for i in 1..<typeTagString.count { // Skip the comma
            let typeTag = typeTagString[typeTagString.index(typeTagString.startIndex, offsetBy: i)]
            
            switch typeTag {
            case "f":
                if offset + 4 <= data.count {
                    let floatBits = data[offset..<offset+4].withUnsafeBytes { $0.load(as: UInt32.self).bigEndian }
                    arguments.append(Float(bitPattern: floatBits))
                    offset += 4
                }
            case "i":
                if offset + 4 <= data.count {
                    let intValue = data[offset..<offset+4].withUnsafeBytes { $0.load(as: Int32.self).bigEndian }
                    arguments.append(Int(intValue))
                    offset += 4
                }
            case "s":
                guard let stringEndIndex = data[offset...].firstIndex(of: 0) else { break }
                let stringData = data[offset..<stringEndIndex]
                if let string = String(data: stringData, encoding: .utf8) {
                    arguments.append(string)
                }
                offset = stringEndIndex + 1
                while offset % 4 != 0 && offset < data.count {
                    offset += 1
                }
            default:
                break
            }
        }
        
        return (address, arguments)
    }
    
    private func notifyConnectionStatus(connected: Bool) {
        guard let controller = window?.rootViewController as? FlutterViewController else { return }
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        
        channel.invokeMethod("onConnectionStatusChanged", arguments: ["connected": connected])
    }
    
    private func notifyIncomingMessage(address: String, arguments: [Any]) {
        guard let controller = window?.rootViewController as? FlutterViewController else { return }
        let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)
        
        channel.invokeMethod("onOSCMessageReceived", arguments: [
            "address": address,
            "arguments": arguments
        ])
    }
}

// Extensions for data conversion
extension UInt32 {
    var data: Data {
        var value = self
        return Data(bytes: &value, count: MemoryLayout<UInt32>.size)
    }
}

extension Int32 {
    var data: Data {
        var value = self
        return Data(bytes: &value, count: MemoryLayout<Int32>.size)
    }
}