//
//  NothingProtocol.swift
//  NothingMac
//
//  Created by Joe on 28/04/2023.
//

import Foundation
import IOBluetooth
import CrcSwift

enum NothingANCMode: UInt8 {
    case High = 1
    case Medium = 2
    case Low = 3
    case Adaptive = 4
    case Off = 5
    case Transparency = 7
}

class NothingProtocol: NSObject, IOBluetoothRFCOMMChannelDelegate {
    var channel: IOBluetoothRFCOMMChannel!
    var connected: Bool = false

    func send(message: [UInt8]) {
        var msg = message
        let crc = CrcSwift.computeCrc16(Data(msg), mode: .modbus).bigEndian
        
        msg.append(UInt8(truncatingIfNeeded: crc >> 8))
        msg.append(UInt8(truncatingIfNeeded: crc))
        
        let data = Data(msg)
        let dataLength = UInt16(data.count)
        
        data.withUnsafeBytes { (bufferPointer: UnsafeRawBufferPointer) in
            if let baseAddress = bufferPointer.baseAddress {
                let result = channel.writeSync(UnsafeMutableRawPointer(mutating: baseAddress), length: dataLength)
                if result == kIOReturnSuccess {
                    print("Sent data \(result)")
                } else {
                    print("Failed to send data")
                }
            } else {
                print("Failed to access the base address of data buffer")
            }
        }
    }
    
    func rfcommChannelData(_ rfcommChannel: IOBluetoothRFCOMMChannel!, data dataPointer: UnsafeMutableRawPointer!, length dataLength: Int) {
        // Read data from the device
        let data = Data(bytes: dataPointer, count: dataLength)
        print("Received data on RFCOMM")
        PrintBinary(data: data)
    }
    
    func rfcommChannelOpenComplete(_ rfcommChannel: IOBluetoothRFCOMMChannel!, status error: IOReturn) {
        if(error != kIOReturnSuccess){
            print("Failed to open RFCOMM channel");
        } else {
            print("Connect to RFCOMM");
        }
    }
    
    func connectToDevice(_ device: IOBluetoothDevice) {
        if (connected) {
            return
        }
        
        let resultConnection = device.openConnection()
        if resultConnection == kIOReturnSuccess {
            print("Connected to device")
        } else {
            print("Failed to connect")
        }

        // Open an RFCOMM channel to the device
        let resultRFCOMM = device.openRFCOMMChannelSync(&channel, withChannelID: 15, delegate: self)
        if resultRFCOMM == kIOReturnSuccess {
            print("Opened RFCOMM channel")
            connected = true
            // Start sending commands
        } else {
            print("Failed to open RFCOMM channel")
        }
    }
    
    func getMessageHeader(command: UInt16, payloadLength: UInt8) -> [UInt8] {
        return [0x55, 0x60, 0x01, UInt8(truncatingIfNeeded: command), UInt8(truncatingIfNeeded: command >> 8), payloadLength, 0x00, UInt8(Int.random(in: 1...200))];
    }
    
    func setANC(mode: NothingANCMode) {
        var message: [UInt8] = getMessageHeader(command: 0xf00f, payloadLength: 0x03)
        
        message.append(UInt8(0x01))
        message.append(mode.rawValue)
        message.append(UInt8(0x00))
        
        send(message: message)
    }
    
    func connect() {
        if let device = IOBluetoothDevice.pairedDevices().first(where: { ($0 as? IOBluetoothDevice)?.name == "Ear (2)" }) as? IOBluetoothDevice {
            print("Connecting to \(device.name)")
            connectToDevice(device)
        } else {
            print("Device 'Ear (2)' not found among paired devices")
        }
    }
}
