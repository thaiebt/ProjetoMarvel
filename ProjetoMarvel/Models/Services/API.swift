//
//  API.swift
//  ProjetoMarvel
//
//  Created by c94289a on 26/11/21.
//

import Foundation

import UIKit

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

            // Contruindo a sessão
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
//                    completion(Result.failure(ApiError.noInternet))
                } else if self.statusCode != 0 && self.statusCode != 200 {
//                    completion(Result.failure(ApiError.emptyData))
                    DispatchQueue.main.async {
                        completion(Result.failure(ApiError.emptyData))
                    }
                }
                
                if let data = data {
                    do {
                        let decoder: JSONDecoder = JSONDecoder()
//                        let res = String(data: data, encoding: .utf8)
//                        print(res ?? "")
                        let decodeData = try decoder.decode(Hero.self, from: data)
                        DispatchQueue.main.async {
                            completion(Result.success(decodeData))
                        }
//                        completion(Result.success(decodeData))
                    }catch {
                        DispatchQueue.main.async {
                            completion(Result.failure(ApiError.invalidData))
                        }
//                        completion(Result.failure(ApiError.invalidData))
                    }
                }
            }
            task.resume()
        }
    }
}
//struct APIService {
//    let apiClient: MarvelAPIProtocol
//    
//    func getDados(url: String, completion: @escaping (Result<Hero?, ApiError>) -> Void) {
//        apiClient.getDados(url: url) { result in
//            switch result {
//            case .success(let hero):
//                guard (hero?.data?.results) != nil else {return}
//            case .failure(var error):
//                error = ApiError.emptyData
//                print(error)
//            }
//        }
//    }
//}

