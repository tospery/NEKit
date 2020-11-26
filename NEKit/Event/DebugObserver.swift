import os
import Foundation
import CocoaLumberjack

open class DebugObserverFactory: ObserverFactory {
    public override init() {}

    override open func getObserverForTunnel(_ tunnel: Tunnel) -> Observer<TunnelEvent>? {
        return DebugTunnelObserver()
    }

    override open func getObserverForProxyServer(_ server: ProxyServer) -> Observer<ProxyServerEvent>? {
        return DebugProxyServerObserver()
    }

    override open func getObserverForProxySocket(_ socket: ProxySocket) -> Observer<ProxySocketEvent>? {
        return DebugProxySocketObserver()
    }

    override open func getObserverForAdapterSocket(_ socket: AdapterSocket) -> Observer<AdapterSocketEvent>? {
        return DebugAdapterSocketObserver()
    }

    open override func getObserverForRuleManager(_ manager: RuleManager) -> Observer<RuleMatchEvent>? {
        return DebugRuleManagerObserver()
    }
}

open class DebugTunnelObserver: Observer<TunnelEvent> {
    override open func signal(_ event: TunnelEvent) {
        switch event {
        case .receivedRequest,
             .closed:
            nelog("\(event)")
        case .opened,
             .connectedToRemote,
             .updatingAdapterSocket:
            nelog("\(event)")
        case .closeCalled,
             .forceCloseCalled,
             .receivedReadySignal,
             .proxySocketReadData,
             .proxySocketWroteData,
             .adapterSocketReadData,
             .adapterSocketWroteData:
            nelog("\(event)")
        }
    }
}

open class DebugProxySocketObserver: Observer<ProxySocketEvent> {
    override open func signal(_ event: ProxySocketEvent) {
        switch event {
        case .errorOccured:
            nelog("\(event)")
        case .disconnected,
             .receivedRequest:
            nelog("\(event)")
        case .socketOpened,
             .askedToResponseTo,
             .readyForForward:
            nelog("\(event)")
        case .disconnectCalled,
             .forceDisconnectCalled,
             .readData,
             .wroteData:
            nelog("\(event)")
        }
    }
}

open class DebugAdapterSocketObserver: Observer<AdapterSocketEvent> {
    override open func signal(_ event: AdapterSocketEvent) {
        switch event {
        case .errorOccured:
            nelog("\(event)")
        case .disconnected,
             .connected:
            nelog("\(event)")
        case .socketOpened,
             .readyForForward:
            nelog("\(event)")
        case .disconnectCalled,
             .forceDisconnectCalled,
             .readData,
             .wroteData:
            nelog("\(event)")
        }
    }
}

open class DebugProxyServerObserver: Observer<ProxyServerEvent> {
    override open func signal(_ event: ProxyServerEvent) {
        switch event {
        case .started,
             .stopped:
            nelog("\(event)")
        case .newSocketAccepted,
             .tunnelClosed:
            nelog("\(event)")
        }
    }
}

open class DebugRuleManagerObserver: Observer<RuleMatchEvent> {
    open override func signal(_ event: RuleMatchEvent) {
        switch event {
        case .ruleDidNotMatch, .dnsRuleMatched:
            nelog("\(event)")
        case .ruleMatched:
            nelog("\(event)")
        }
    }
}

func nelog<T>(_ message: T) {
    os_log("%{public}s", "XYAcc[NEKit]: \(message)")
}
