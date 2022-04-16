//
//  UrlProtocol.swift
//  ProjetoMarvel
//
//  Created by c94289a on 17/01/22.
//

import Foundation

protocol UrlApiProtocol {
    func setUrl() -> String
    func setUrlInfiniteScroll(offset: Int, limit: Int) -> String
    func setUrlSearchName(nameStartsWith: String, offset: Int, limit:Int) -> String
    var baseURL: String {get set}
    var publicKey: String {get set}
    var privateKey: String {get set}
    var ts: Int {get set}
}
