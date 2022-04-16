//
//  Data.swift
//  ProjetoMarvel
//
//  Created by c94289a on 26/11/21.
//

import Foundation

struct DataHero: Codable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var results: [Results]?
    
    enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
        case count
        case results
    }
}
