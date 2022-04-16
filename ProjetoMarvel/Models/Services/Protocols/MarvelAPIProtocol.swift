//
//  File.swift
//  ProjetoMarvel
//
//  Created by c94289a on 03/12/21.
//

import Foundation

protocol MarvelAPIProtocol {
    func getDados(url : String, completion: @escaping (Result<Hero?, ApiError>) -> Void)
    var getURL: UrlApiProtocol { get set }
    var apiRequest: Bool { get set }
    var statusCode: Int { get set }
    var offset: Int { get set }
}
