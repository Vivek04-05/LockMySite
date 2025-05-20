//
//  WebsiteBlockerApp.swift
//  WebsiteBlocker
//
//  Created by Vivek Patel on 25/04/25.
//

import SwiftUI

@main
struct WebsiteBlockerApp: App {
    var body: some Scene {
        WindowGroup {
        
            BlockerView()
                .preferredColorScheme(.light)
        }
    }
}
