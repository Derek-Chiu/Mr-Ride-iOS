//
//  TrackingActionHelper.swift
//  Mr-Ride-iOS
//
//  Created by Derek on 7/1/16.
//  Copyright © 2016 AppWorks School Derek. All rights reserved.
//

import Foundation
import Google
import Amplitude_iOS

class TrackingActionHelper {

    
    func trackingAction(viewName viewName: String, action: String?) {
        trackingActionToolGA(viewName, action: action)
        trackingScreenToolAmplitute(name: viewName)
    }
    
    
}

extension TrackingActionHelper {

    func trackingActionToolGA(name: String, action: String?) {
        // tracking action
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createEventWithCategory(
            name,
            action: action,
            label: nil,
            value: nil
        )
        
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    private func trackingScreenToolGA(name name: String ) {
        // tracking action
        let tracker = GAI.sharedInstance().defaultTracker
        tracker.set(kGAIScreenName, value: name)
        
        let builder = GAIDictionaryBuilder.createScreenView()
        tracker.send(builder.build() as [NSObject : AnyObject])
    }
    
    private func trackingActionToolAmplitute(name name: String ) {
        Amplitude.instance().logEvent(name)

    }
    
    private func trackingScreenToolAmplitute(name name: String ) {
        Amplitude.instance().logEvent(name)
    }
    
}

extension TrackingActionHelper {

    static var sharedInstance: TrackingActionHelper?
    
    static func getInstance() -> TrackingActionHelper {
    
        if sharedInstance == nil {
            sharedInstance = TrackingActionHelper()
        }
        
        return sharedInstance!
    }
    
}