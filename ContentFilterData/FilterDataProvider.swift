//
//  FilterDataProvider.swift
//  ContentFilterData
//
//  Created by Vivek Patel on 25/04/25.
//

import NetworkExtension

class FilterDataProvider: NEFilterDataProvider {

    // MARK: NEFilterDataProvider
    
    /// Handle a new flow of data.
    override func handleNewFlow(_ flow: NEFilterFlow) -> NEFilterNewFlowVerdict {
        let result = NEFilterNewFlowVerdict.needRules()
        return result
    }
    
    /// Filter an inbound chunk of data.
    override func handleInboundData(from flow: NEFilterFlow, readBytesStartOffset offset: Int, readBytes: Data) -> NEFilterDataVerdict {
        var result = NEFilterDataVerdict.allow()
        result = NEFilterDataVerdict.needRules()
        return result
    }
    
    /// Handle the event where all of the inbound data for a flow has been filtered.
    override func handleInboundDataComplete(for flow: NEFilterFlow) -> NEFilterDataVerdict {
        var result = NEFilterDataVerdict.allow()
        result = NEFilterDataVerdict.needRules()
        //result = NEFilterDataVerdict.drop()
        return result
    }
    
    /// Filter an outbound chunk of data.
    override func handleOutboundData(from flow: NEFilterFlow, readBytesStartOffset offset: Int, readBytes: Data) -> NEFilterDataVerdict {
        
        var result = NEFilterDataVerdict.allow()
        result = NEFilterDataVerdict.needRules()
        //result = NEFilterDataVerdict.drop()
        return result
    }
    
    /// Handle the event where all of the outbound data for a flow has been filtered.
    override func handleOutboundDataComplete(for flow: NEFilterFlow) -> NEFilterDataVerdict {
        var result = NEFilterDataVerdict.allow()
        result = NEFilterDataVerdict.needRules()
        //result = NEFilterDataVerdict.drop()
        return result
    }
    
    /// Handle the user tapping on the "Request Access" link in the block page.
    override func handleRemediation(for flow: NEFilterFlow) -> NEFilterRemediationVerdict {

        return .allow()
    }
}

