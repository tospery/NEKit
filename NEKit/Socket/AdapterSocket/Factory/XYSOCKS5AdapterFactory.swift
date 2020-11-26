//
//  XYSOCKS5AdapterFactory.swift
//  NEKit
//
//  Created by liaoya on 2020/11/17.
//  Copyright © 2020 Zhuhao Wang. All rights reserved.
//

import Foundation

open class XYSOCKS5AdapterFactory: ServerAdapterFactory {
    
    let username: String
    let password: String
    
    public init(serverHost: String, serverPort: Int, username: String, password: String) {
        self.username = username
        self.password = password
        super.init(serverHost: serverHost, serverPort: serverPort)
    }

    override open func getAdapterFor(session: ConnectSession) -> AdapterSocket {
        let adapter = XYSOCKS5Adapter(serverHost: serverHost, serverPort: serverPort, username: username, password: password)
        adapter.socket = RawSocketFactory.getRawSocket()
        return adapter
    }

}
