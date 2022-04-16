//
//  DataBaseProtocol.swift
//  ProjetoMarvel
//
//  Created by c94289a on 15/01/22.
//

import Foundation
import CoreData

protocol DataBaseProtocol {
//    static var persistentContainer: NSPersistentContainer { get set }
    static func saveContext(completion: @escaping (Result<Void, Error>) -> Void)
    static func checkSavedData(name: String) -> Bool
    static func saveData(heroes: [Results])
    static func getDataFromCoreData() -> [HeroEntity]
    static func removeAllSavedData()
}
