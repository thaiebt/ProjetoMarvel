//
//  Url.swift
//  ProjetoMarvel
//
//  Created by c94289a on 08/12/21.
//

import Foundation

class UrlApi: UrlApiProtocol {
    var baseURL = "http://gateway.marvel.com"
    let path = "v1/public/characters"
    var publicKey = Bundle.main.object(forInfoDictionaryKey: "publicKey") as! String
    var privateKey = Bundle.main.object(forInfoDictionaryKey: "privateKey") as! String
    var ts = Int(Date().timeIntervalSince1970)
    let getMD5 = MD5()

    // Hash
    func setUrl() -> String {

        let content = String(ts) + privateKey + publicKey
        let hash = getMD5.MD5(string: content)
        let url = baseURL + "/" + path + "?" + "ts=\(ts)" + "&apikey=\(publicKey)" + "&hash=\(hash)"
        
        return url
    }
    
    func setUrlInfiniteScroll(offset: Int, limit: Int) -> String {
        let content = String(ts) + privateKey + publicKey
        let hash = getMD5.MD5(string: content)
        return baseURL + "/" + path + "?" + "limit=\(limit)&offset=\(offset)" + "&ts=\(ts)" + "&apikey=\(publicKey)" + "&hash=\(hash)"
    }
    
    func setUrlSearchName(nameStartsWith: String, offset: Int, limit:Int) -> String {
        let content = String(ts) + privateKey + publicKey
        let hash = getMD5.MD5(string: content)
        
        return baseURL + "/" + path + "?" + "nameStartsWith=\(nameStartsWith)" + "&offset=\(offset)&limit=\(limit)" + "&ts=\(ts)" + "&apikey=\(publicKey)" + "&hash=\(hash)"
    }
}
