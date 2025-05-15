//
//  SharedData.swift
//  WebsiteBlocker
//
//  Created by Vivek Patel on 29/04/25.
//

import Foundation

class SharedData {
    static let suiteName = "group.com.Vivek.WebsiteBlocker"
       static let blockedDomainsKey = "BlockedDomains"
    
    static var defaults: UserDefaults? {
            return UserDefaults(suiteName: suiteName)
    }
    
    /// Save the list of blocked domains
    static func saveBlockedDomains(_ domains: [String]) {
           defaults?.set(domains, forKey: blockedDomainsKey)
    }
    
    /// Retrieve the list of blocked domains
        static func getBlockedDomains() -> [String] {
            return defaults?.stringArray(forKey: blockedDomainsKey) ?? []
        }
    
    /// Remove a specific domain from the blocked list
        static func removeBlockedDomain(_ domain: String) {
            var currentDomains = getBlockedDomains()
            currentDomains.removeAll { $0.lowercased() == domain.lowercased() }
            saveBlockedDomains(currentDomains)
        }
    
    
}
