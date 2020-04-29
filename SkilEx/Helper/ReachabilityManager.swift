//
//  ReachabilityManager.swift
//  SkilEx
//
//  Created by Happy Sanz Tech on 06/05/19.
//  Copyright © 2019 Happy Sanz Tech. All rights reserved.
//

import UIKit
import ReachabilitySwift

class ReachabilityManager: NSObject {
    
    static  let shared = ReachabilityManager()
    
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .notReachable
    }
    
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    
    // 5. Reachability instance for Network status monitoring
    let reachability = Reachability()!

    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability
        switch reachability.currentReachabilityStatus {
        case .notReachable:
                print("Network became unreachable")
                Alert.defaultManager.showErrorAlert(error: ReachabilityError.UnableToSetCallback)
                case .reachableViaWiFi:
                print("Network reachable through WiFi")
                case .reachableViaWWAN:
                print("Network reachable through Cellular Data")
                }
   }
    
    // Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    // Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
}


