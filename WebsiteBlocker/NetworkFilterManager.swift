//
//  NetworkFilterManager.swift
//  WebsiteBlocker
//
//  Created by Vivek Patel on 01/05/25.
//

import Foundation
import NetworkExtension

class NetworkFilterManager {
    static let shared = NetworkFilterManager()
    
    private let manager = NEFilterManager.shared()
    
    
    func checkNetworkPrefences(completion : @escaping (Bool) -> Void) {
        // Load the current filter configuration
        manager.loadFromPreferences { error in
            if let error = error {
                print("Failed to load filter preferences: \(error)")
                return
            }
            
            if self.manager.providerConfiguration == nil {
                self.configureNetwork()
            }
            
            // Enable the filter manager
            self.manager.isEnabled = true
            
            
            // Save the updated preferences
            self.manager.saveToPreferences { error in
                if let error = error {
                    completion(false)
                } else {
                    completion(true)
                }
            }
            
        }
    }

    private func configureNetwork(){
        let newConfig = NEFilterProviderConfiguration()
        newConfig.organization = "Website Blocker"
        newConfig.filterBrowsers = true
        newConfig.filterSockets = true
        manager.providerConfiguration = newConfig
    }
}
