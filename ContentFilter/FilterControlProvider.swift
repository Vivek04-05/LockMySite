//
//  FilterControlProvider.swift
//  ContentFilter
//
//  Created by Vivek Patel on 25/04/25.
//

import NetworkExtension

class FilterControlProvider: NEFilterControlProvider {
    
    
    override func startFilter(completionHandler: @escaping (Error?) -> Void) {
        // Add code to initialize the filter
        completionHandler(nil)
    }
    
    override func stopFilter(with reason: NEProviderStopReason, completionHandler: @escaping () -> Void) {
        // Add code to clean up filter resources
        completionHandler()
    }
    
    override func handleNewFlow(_ flow: NEFilterFlow, completionHandler: @escaping (NEFilterControlVerdict) -> Void) {
        // Add code to determine if the flow should be dropped or not, downloading new rules if required
        
        guard let url = flow.url, let host = url.host?.lowercased() else {
                completionHandler(.allow(withUpdateRules: false))
                return
            }
        let blockedDomains = SharedData.getBlockedDomains()
        
        if blockedDomains.contains(where: { host == $0 || host.hasSuffix("." + $0) }) {
                completionHandler(.drop(withUpdateRules: false))
                return
            }
        
        completionHandler(.allow(withUpdateRules: false))
    }
    
}
