package com.reason2funk.app

import android.os.Bundle
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import java.net.*
import java.nio.ByteBuffer
import java.nio.charset.StandardCharsets

class MainActivity: FlutterActivity() {
    private val CHANNEL = "reason2funk/osc"
    private val TAG = "OSCHandler"
    
    private var oscSocket: DatagramSocket? = null
    private var isConnected = false
    private var serverAddress: InetAddress? = null
    private var serverPort: Int = 8000
    private var clientPort: Int = 9000
    private var oscJob: Job? = null
    
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "connectOSC" -> {
                    val address = call.argument<String>("address") ?: "192.168.1.100"
                    val sPort = call.argument<Int>("serverPort") ?: 8000
                    val cPort = call.argument<Int>("clientPort") ?: 9000
                    
                    connectOSC(address, sPort, cPort, result)
                }
                "disconnectOSC" -> {
                    disconnectOSC(result)
                }
                "sendOSCMessage" -> {
                    val address = call.argument<String>("address") ?: ""
                    val arguments = call.argument<List<Any>>("arguments") ?: emptyList()
                    
                    sendOSCMessage(address, arguments, result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    private fun connectOSC(address: String, sPort: Int, cPort: Int, result: MethodChannel.Result) {
        try {
            // Close existing connection
            disconnectOSC()
            
            serverAddress = InetAddress.getByName(address)
            serverPort = sPort
            clientPort = cPort
            
            // Create UDP socket for OSC communication
            oscSocket = DatagramSocket(clientPort)
            oscSocket?.soTimeout = 5000 // 5 second timeout
            
            isConnected = true
            
            // Start listening for incoming OSC messages
            startOSCListener()
            
            // Notify Flutter of connection status
            notifyConnectionStatus(true)
            
            Log.d(TAG, "OSC Connected to $address:$sPort from port $cPort")
            result.success(true)
            
        } catch (e: Exception) {
            Log.e(TAG, "OSC Connection failed: ${e.message}")
            isConnected = false
            notifyConnectionStatus(false)
            result.error("CONNECTION_FAILED", e.message, null)
        }
    }
    
    private fun disconnectOSC(result: MethodChannel.Result? = null) {
        try {
            oscJob?.cancel()
            oscSocket?.close()
            oscSocket = null
            isConnected = false
            
            notifyConnectionStatus(false)
            
            Log.d(TAG, "OSC Disconnected")
            result?.success(true)
            
        } catch (e: Exception) {
            Log.e(TAG, "OSC Disconnect failed: ${e.message}")
            result?.error("DISCONNECT_FAILED", e.message, null)
        }
    }
    
    private fun sendOSCMessage(address: String, arguments: List<Any>, result: MethodChannel.Result) {
        if (!isConnected || oscSocket == null || serverAddress == null) {
            result.error("NOT_CONNECTED", "OSC not connected", null)
            return
        }
        
        try {
            val oscMessage = buildOSCMessage(address, arguments)
            val packet = DatagramPacket(
                oscMessage,
                oscMessage.size,
                serverAddress,
                serverPort
            )
            
            oscSocket?.send(packet)
            
            Log.d(TAG, "Sent OSC: $address -> $arguments")
            result.success(true)
            
        } catch (e: Exception) {
            Log.e(TAG, "Send OSC failed: ${e.message}")
            result.error("SEND_FAILED", e.message, null)
        }
    }
    
    private fun startOSCListener() {
        oscJob = CoroutineScope(Dispatchers.IO).launch {
            val buffer = ByteArray(1024)
            
            while (isConnected && oscSocket != null) {
                try {
                    val packet = DatagramPacket(buffer, buffer.size)
                    oscSocket?.receive(packet)
                    
                    val message = parseOSCMessage(packet.data, packet.length)
                    if (message != null) {
                        // Notify Flutter of incoming message
                        withContext(Dispatchers.Main) {
                            notifyIncomingMessage(message.first, message.second)
                        }
                    }
                    
                } catch (e: SocketTimeoutException) {
                    // Timeout is normal, continue listening
                    continue
                } catch (e: Exception) {
                    if (isConnected) {
                        Log.e(TAG, "OSC Receive error: ${e.message}")
                    }
                    break
                }
            }
        }
    }
    
    private fun buildOSCMessage(address: String, arguments: List<Any>): ByteArray {
        val addressBytes = padToMultipleOfFour(address.toByteArray(StandardCharsets.UTF_8))
        
        // Build type tag string
        val typeTag = buildString {
            append(",")
            for (arg in arguments) {
                when (arg) {
                    is Float, is Double -> append("f")
                    is Int -> append("i")
                    is String -> append("s")
                    else -> append("f") // Default to float
                }
            }
        }
        val typeTagBytes = padToMultipleOfFour(typeTag.toByteArray(StandardCharsets.UTF_8))
        
        // Build arguments
        val argumentsBuffer = ByteBuffer.allocate(arguments.size * 8) // Generous allocation
        for (arg in arguments) {
            when (arg) {
                is Float -> argumentsBuffer.putFloat(arg)
                is Double -> argumentsBuffer.putFloat(arg.toFloat())
                is Int -> argumentsBuffer.putInt(arg)
                is String -> {
                    val stringBytes = padToMultipleOfFour(arg.toByteArray(StandardCharsets.UTF_8))
                    argumentsBuffer.put(stringBytes)
                }
                else -> argumentsBuffer.putFloat(arg.toString().toFloatOrNull() ?: 0.0f)
            }
        }
        
        val argumentsBytes = argumentsBuffer.array().sliceArray(0..argumentsBuffer.position() - 1)
        
        // Combine all parts
        return addressBytes + typeTagBytes + argumentsBytes
    }
    
    private fun parseOSCMessage(data: ByteArray, length: Int): Pair<String, List<Any>>? {
        try {
            val buffer = ByteBuffer.wrap(data, 0, length)
            
            // Parse address
            val addressBuilder = StringBuilder()
            while (buffer.hasRemaining()) {
                val byte = buffer.get()
                if (byte == 0.toByte()) break
                addressBuilder.append(byte.toInt().toChar())
            }
            
            // Skip padding to next 4-byte boundary
            while (buffer.position() % 4 != 0 && buffer.hasRemaining()) {
                buffer.get()
            }
            
            val address = addressBuilder.toString()
            
            if (!buffer.hasRemaining()) {
                return Pair(address, emptyList())
            }
            
            // Parse type tags
            val typeTagBuilder = StringBuilder()
            while (buffer.hasRemaining()) {
                val byte = buffer.get()
                if (byte == 0.toByte()) break
                typeTagBuilder.append(byte.toInt().toChar())
            }
            
            // Skip padding
            while (buffer.position() % 4 != 0 && buffer.hasRemaining()) {
                buffer.get()
            }
            
            val typeTags = typeTagBuilder.toString()
            val arguments = mutableListOf<Any>()
            
            // Parse arguments based on type tags
            for (i in 1 until typeTags.length) { // Skip the comma
                when (typeTags[i]) {
                    'f' -> arguments.add(buffer.getFloat())
                    'i' -> arguments.add(buffer.getInt())
                    's' -> {
                        val stringBuilder = StringBuilder()
                        while (buffer.hasRemaining()) {
                            val byte = buffer.get()
                            if (byte == 0.toByte()) break
                            stringBuilder.append(byte.toInt().toChar())
                        }
                        // Skip padding
                        while (buffer.position() % 4 != 0 && buffer.hasRemaining()) {
                            buffer.get()
                        }
                        arguments.add(stringBuilder.toString())
                    }
                }
            }
            
            return Pair(address, arguments)
            
        } catch (e: Exception) {
            Log.e(TAG, "Parse OSC message failed: ${e.message}")
            return null
        }
    }
    
    private fun padToMultipleOfFour(bytes: ByteArray): ByteArray {
        val paddingNeeded = (4 - (bytes.size % 4)) % 4
        return if (paddingNeeded == 0) {
            bytes + byteArrayOf(0)
        } else {
            bytes + ByteArray(paddingNeeded + 1) { 0 }
        }
    }
    
    private fun notifyConnectionStatus(connected: Boolean) {
        runOnUiThread {
            MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL)
                .invokeMethod("onConnectionStatusChanged", mapOf("connected" to connected))
        }
    }
    
    private fun notifyIncomingMessage(address: String, arguments: List<Any>) {
        runOnUiThread {
            MethodChannel(flutterEngine?.dartExecutor?.binaryMessenger, CHANNEL)
                .invokeMethod("onOSCMessageReceived", mapOf(
                    "address" to address,
                    "arguments" to arguments
                ))
        }
    }
    
    override fun onDestroy() {
        disconnectOSC()
        super.onDestroy()
    }
}