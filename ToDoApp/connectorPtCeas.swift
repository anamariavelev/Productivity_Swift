//
//  connectorPtCeas.swift
//  ToDoApp
//
//  Created by Ana Maria Velev on 14.05.2024.
//

import Foundation



class WatchConnector: NSObject, ObservableObject {
    var wcSession: WCSession?

    override init() {
        super.init()
        if WCSession.isSupported() {
            self.wcSession = WCSession.default
            self.wcSession?.delegate = self
            self.wcSession?.activate()
        }
    }
}

extension WatchConnector: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState: \(activationState) error: \(String(describing: error))")
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive: \(session)")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate: \(session)")
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
        print("sessionWatchStateDidChange: \(session)")
    }
}
