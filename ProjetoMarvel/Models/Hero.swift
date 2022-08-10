//
//  Hero.swift
//  ProjetoMarvel
//
//  Created by c94289a on 22/11/21.
//

import Foundation

struct Hero: Codable {
    var data: DataHero?
}

struct DataHero: Codable {
    var offset: Int?
    var limit: Int?
    var total: Int?
    var count: Int?
    var results: [Results]?
}

struct Results: Codable {
    var id: Int?
    var name: String?
    var description: String?
    var thumbnail: Image?
    var comics: Comics?
    var series: Series?
    var urls: [Urls]?
}

struct Comics: Codable {
    var items: [Items]?
}

struct Series: Codable {
    var items: [Items]?
}

struct Items: Codable {
    var name: String?
}

struct Urls: Codable {
    var type: String?
    var url: String?
}

struct Image: Codable {
    var path:  String?
    var imageExtension: String?
    
    enum CodingKeys: String, CodingKey {
        case path
        case imageExtension = "extension"
    }
}
