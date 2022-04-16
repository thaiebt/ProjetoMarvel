//
//  File.swift
//  ProjetoMarvel
//
//  Created by c94289a on 29/11/21.
//

import Foundation
import CoreText

struct Results: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: Image?
    var comics: Comics?
    var series: Series?
    var urls: [Urls]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case thumbnail
        case comics
        case series
        case urls
    }
}
