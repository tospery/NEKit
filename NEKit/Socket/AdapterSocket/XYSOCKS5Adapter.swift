//
//  XYSOCKS5Adapter.swift
//  NEKit
//
//  Created by liaoya on 2020/11/17.
//  Copyright © 2020 Zhuhao Wang. All rights reserved.
//

import os
import Foundation

public class XYSOCKS5Adapter: AdapterSocket {
    enum XunyouAdapterStatus {
        case invalid,
        connecting,
        readingMethodResponse,
        readingAuthResponse,
        readingConnectResponse,
        readingAddressResponse,
        forwarding
    }
    public let serverHost: String
    public let serverPort: Int
    public let username: String
    public let password: String

    var internalStatus: XunyouAdapterStatus = .invalid

    var isRetry = false
    var helloData = Data([0x05, 0x01, 0x02])

    public enum ReadTag: Int {
        case methodResponse = -20000, connectResponseFirstPart, connectResponseSecondPart
    }

    public enum WriteTag: Int {
        case open = -21000, connectIPv4, connectIPv6, connectDomainLength, connectPort
    }

    public init(serverHost: String, serverPort: Int, username: String, password: String) {
        self.serverHost = serverHost
        self.serverPort = serverPort
        self.username = username
        self.password = password
        super.init()
    }

    public override func openSocketWith(session: ConnectSession) {
        super.openSocketWith(session: session)

        guard !isCancelled else {
            return
        }

        do {
            internalStatus = .connecting
            try socket.connectTo(host: serverHost, port: serverPort, enableTLS: false, tlsSettings: nil)
        } catch {}
    }

    public override func didConnectWith(socket: RawTCPSocketProtocol) {
        nelog("[\(serverHost): \(serverPort))]已连接")
        super.didConnectWith(socket: socket)

        write(data: helloData)
        internalStatus = .readingMethodResponse
        socket.readDataTo(length: 2)
    }
    
    public override func disconnect(becauseOf error: Error? = nil) {
        super.disconnect(becauseOf: error)
    }
    
    public override func didDisconnectWith(socket: RawTCPSocketProtocol) {
        super.didDisconnectWith(socket: socket)
    }

    public override func didRead(data: Data, from socket: RawTCPSocketProtocol) {
        super.didRead(data: data, from: socket)

        switch internalStatus {
        case .readingMethodResponse:
            if data != Data([0x05, 0x02]) {
                disconnect()
                return
            }
            nelog("[\(self.serverHost): \(self.serverPort))]认证方法成功")
            let uData = [UInt8](self.username.utf8)
            let uLen = UInt8(self.username.count)
            let pData = [UInt8](self.password.utf8)
            let pLen = UInt8(self.password.count)
            var auth = ([0x01, uLen] as [UInt8]) + uData
            auth.append(pLen)
            auth += pData
            write(data: Data(auth))
            internalStatus = .readingAuthResponse
            socket.readDataTo(length: 2)
        case .readingAuthResponse:
            if data != Data([0x05, 0x00]) &&
                data != Data([0x01, 0x00]) {
                disconnect()
                return
            }
            nelog("[\(self.serverHost): \(self.serverPort))]认证账号成功")
            var connect: [UInt8]
            if session.isIPv4() {
                connect = [0x05, 0x01, 0x00, 0x01]
                let address = IPAddress(fromString: session.host)!
                connect += [UInt8](address.dataInNetworkOrder)
            } else if session.isIPv6() {
                connect = [0x05, 0x01, 0x00, 0x04]
                let address = IPAddress(fromString: session.host)!
                connect += [UInt8](address.dataInNetworkOrder)
            } else {
                connect = [0x05, 0x01, 0x00, 0x03]
                connect.append(UInt8(session.host.utf8.count))
                connect += [UInt8](session.host.utf8)
            }
            let portBytes: [UInt8] = Utils.toByteArray(UInt16(session.port)).reversed()
            connect.append(contentsOf: portBytes)
            write(data: Data(connect))
            internalStatus = .readingConnectResponse
            socket.readDataTo(length: 2)
        case .readingConnectResponse:
            if data != Data([0x05, 0x00]) {
                nelog("[\(self.serverHost): \(self.serverPort))]认证连接失败: \([UInt8](data))")
                disconnect()
                return
            }
            nelog("[\(self.serverHost): \(self.serverPort))]认证连接成功")
            internalStatus = .forwarding
            observer?.signal(.readyForForward(self))
            delegate?.didBecomeReadyToForwardWith(socket: self)
//        case .readingConnectResponse:
//            nelog("[\(self.serverHost): \(self.serverPort))]链接1")
//            var readLength = 0
//            switch data[3] {
//            case 1:
//                readLength = 3 + 2
//            case 3:
//                readLength = Int(data[4]) + 2
//            case 4:
//                readLength = 15 + 2
//            default:
//                break
//            }
//            internalStatus = .readingAddressResponse
//            socket.readDataTo(length: readLength)
//        case .readingAddressResponse:
//            nelog("[\(self.serverHost): \(self.serverPort))]链接2")
//            internalStatus = .forwarding
//            observer?.signal(.readyForForward(self))
//            delegate?.didBecomeReadyToForwardWith(socket: self)
        case .forwarding:
            delegate?.didRead(data: data, from: self)
        default:
            return
        }
    }

    override open func didWrite(data: Data?, by socket: RawTCPSocketProtocol) {
        super.didWrite(data: data, by: socket)

        if internalStatus == .forwarding {
            delegate?.didWrite(data: data, by: self)
        }
    }

}
