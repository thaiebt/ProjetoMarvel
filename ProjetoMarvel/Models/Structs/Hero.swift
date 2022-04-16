//
//  Hero.swift
//  ProjetoMarvel
//
//  Created by c94289a on 22/11/21.
//

import Foundation

struct Hero: Codable {
    var data: DataHero?
    
    enum CodingKeys: String, CodingKey {
        case data
    }
}
