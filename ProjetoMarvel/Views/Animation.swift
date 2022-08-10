//
//  Animation.swift
//  ProjetoMarvel
//
//  Created by c94289a on 08/12/21.
//

import Foundation
import Lottie

class Animation {
    var loadingView: AnimationView = {
       var animation = AnimationView(name: "loading-state")
        animation.contentMode = .scaleAspectFit
        animation.loopMode = .loop
        animation.animationSpeed = 1.0
        animation.translatesAutoresizingMaskIntoConstraints = false
        return animation
    }()
    
    func showLoadingIcon() {
        self.loadingView.isHidden = false
        self.loadingView.play()
    }
    
    func hidden() {
        self.loadingView.isHidden = true
        self.loadingView.stop()
    }
}
