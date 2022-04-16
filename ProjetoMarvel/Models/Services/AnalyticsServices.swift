//
//  FireBaseController.swift
//  ProjetoMarvel
//
//  Created by c94289a on 31/01/22.
//

import Foundation
import Firebase
import UIKit

class AnalyticsServices: FireBaseProtocol {
    func selectedScreenView(screenName: String, screenClass: String){
        Analytics.logEvent(AnalyticsEventScreenView,
                           parameters: [AnalyticsParameterScreenName: screenName,
                                        AnalyticsParameterScreenClass: screenClass])
    }
    func selectedHero(heroName: String) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            "hero_name": heroName
        ])
    }
    
    func selectedID(nameID: String) {
        Analytics.setUserID("thaiebt")
        Analytics.setUserProperty(nameID, forName: "favorite_hero")
    }
}
