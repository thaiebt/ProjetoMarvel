//
//  Animation.swift
//  ProjetoMarvel
//
//  Created by c94289a on 08/12/21.
//

import Foundation
import Lottie

class Animation {
    var loading: AnimationView = {
       var animation = AnimationView(name: "loading-state")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 1.0
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    func showLoadingIcon() {
        self.loading.isHidden = false
        self.loading.play()
    }
    
    func hidden() {
        self.loading.isHidden = true
        self.loading.stop()
    }
}
