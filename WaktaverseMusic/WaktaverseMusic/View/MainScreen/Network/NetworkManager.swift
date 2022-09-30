//
//  NetworkManager.swift
//  Billboardoo
//
//  Created by yongbeomkwak on 2022/09/04.
//

import Foundation
import Network

class NetworkManager: ObservableObject {
    
    let  monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkManager")
    @Published var isConnected = true
    
    init() {
        
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
    
    deinit
    {
        stopMonitoring()
    }
    
    public func stopMonitoring()
    {
        monitor.cancel()
    }
    
}
