//
//  FireBaseProtocol.swift
//  ProjetoMarvel
//
//  Created by c94289a on 31/01/22.
//

import UIKit
import Firebase

protocol FireBaseProtocol {
    func selectedScreenView(screenName: String, screenClass: String)
    func selectedHero(heroName: String)
    func selectedID(nameID: String)
}
