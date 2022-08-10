//
//  API.swift
//  ProjetoMarvel
//
//  Created by c94289a on 26/11/21.
//

import Foundation

protocol MarvelAPIProtocol {
    func getDados(url : String, completion: @escaping (Result<Hero?, ApiError>) -> Void)
    var getURL: UrlApiProtocol { get set }
    var apiRequest: Bool { get set }
    var statusCode: Int { get set }
    var offset: Int { get set }
}

class API: MarvelAPIProtocol {
    var getURL: UrlApiProtocol
    init(url: UrlApiProtocol) {
        self.getURL = url
    }
    var apiRequest: Bool = false
    var statusCode: Int = 0
    var offset: Int = 0

    func getDados(url: String, completion: @escaping (Result<Hero?, ApiError>) -> Void) {
        if let url = URL(string: url) {
            apiRequest = true
            let config: URLSessionConfiguration = .default
            let session: URLSession = URLSession(configuration: config)
            
            let task = session.dataTask(with: url) { data, response, error in
                self.apiRequest = false
                
                if let response = response as? HTTPURLResponse {
                    self.statusCode = response.statusCode
                    print(self.statusCode)
                }
                
                if self.statusCode == 0 {
                    DispatchQueue.main.async {
                        completion(Result.failure(ApiError.noInternet))
                    }
                } else if self.statusCode != 0 && self.statusCode != 200 {
                    DispatchQueue.main.async {
                        completion(Result.failure(ApiError.emptyData))
                    }
                }
                
                if let data = data {
                    do {
                        let decoder: JSONDecoder = JSONDecoder()
                        let decodeData = try decoder.decode(Hero.self, from: data)
                        DispatchQueue.main.async {
                            completion(Result.success(decodeData))
                        }
                    }catch {
                        DispatchQueue.main.async {
                            completion(Result.failure(ApiError.invalidData))
                        }
                    }
                }
            }
            task.resume()
        }
    }
}

