//
//  Image.swift
//  ProjetoMarvel
//
//  Created by c94289a on 29/11/21.
//

import Foundation

struct Image: Codable {
    var path:  String?
    var imageExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}
