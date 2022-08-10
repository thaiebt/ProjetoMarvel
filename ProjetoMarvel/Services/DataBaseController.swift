//
//  DataBaseController.swift
//  ProjetoMarvel
//
//  Created by c94289a on 15/12/21.
//

import Foundation
import CoreData

protocol DataBaseProtocol {
    static func saveContext(completion: @escaping (Result<Void, Error>) -> Void)
    static func checkSavedData(name: String) -> Bool
    static func saveData(heroes: [Results])
    static func getDataFromCoreData() -> [HeroEntity]
    static func removeAllSavedData()
}

class DataBaseController: DataBaseProtocol{
    // MARK: - Core Data stack

    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ProjetoMarvel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    
    static func saveContext(completion: @escaping (Result<Void, Error>) -> Void) {
                let context = persistentContainer.viewContext
                if context.hasChanges {
                    do {
                        try context.save()
                        completion(Result.success(()))
                    } catch let error {
                        completion(Result.failure(error))
                }
            }
        }
    
    //MARK: Mathods
    static func checkSavedData(name: String) -> Bool {
        
        let currentHeroSaved = DataBaseController.getDataFromCoreData()
        let currentName: [String]
        currentName = currentHeroSaved.map({ $0.heroName ?? "" })

        if currentName.contains(name) {
            return true
        }
        return false
        
//        let context = DataBaseController.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "HeroEntity")
//
//        let predicate = NSPredicate(format: "heroName =%@", name)
//        fetchRequest.predicate = predicate
//
//        do {
//            let nameHero = try context.fetch(fetchRequest)
//            if nameHero.count > 0 {
//                return true
//            } else {
//                return false
//            }
//        } catch let error as NSError{
//            print(error)
//            return false
//        }
    }
    
    static func saveData(heroes: [Results]) {
        let context = DataBaseController.persistentContainer.viewContext
        
        for hero in heroes {
            let heroEntity = HeroEntity(context: context)
            context.processPendingChanges()
    
            guard let id = hero.id,
                  let name = hero.name,
                  let thumbnailPath = hero.thumbnail?.path,
                  let comics = hero.comics?.items,
                  let series = hero.series?.items,
                  let thumbnailImageExtension = hero.thumbnail?.imageExtension else { return }
            
            
            if !self.checkSavedData(name: name) {
                heroEntity.heroId = Int32(id)
                heroEntity.heroName = name
                heroEntity.heroThumbnailPath = thumbnailPath
                heroEntity.heroThumbnailExtension = thumbnailImageExtension
                heroEntity.heroDescription = hero.description ?? "Sorry, this character doesn't have a biography registered yet."
                
                if comics.count > 0 {
                    var comicsItems: [ItemsEntity] = []
                    for comic in comics {
                        context.processPendingChanges()
                        let itemsEntity = ItemsEntity(context: context)
                        itemsEntity.name = comic.name
                        itemsEntity.comicsItems = heroEntity
                        comicsItems.append(itemsEntity)
                    }
                    let comicData = Set(comicsItems) as NSSet
                    heroEntity.heroComics = comicData
                }
    
                if series.count > 0 {
                    var seriesItems: [ItemsEntity] = []
                    for serie in series {
                        context.processPendingChanges()
                        let itemsEntity = ItemsEntity(context: context)
                        itemsEntity.name = serie.name
                        itemsEntity.seriesItems = heroEntity
                        seriesItems.append(itemsEntity)
                    }
                    let seriesItemsData = Set(seriesItems) as NSSet
                    heroEntity.heroSeries = seriesItemsData
                }
                print(name)
            }
        }
        
        DataBaseController.saveContext { result in
            switch result {
            case .success:
                print("salvando")
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func getDataFromCoreData() -> [HeroEntity] {
        var dataHero: [HeroEntity] = []
        do {
            let fetchRequest = HeroEntity.fetchRequest()
            dataHero = try DataBaseController.persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("Impossible get data from Core Data")
        }
        print(dataHero.count)
        return dataHero
    }
    
    
    static func removeAllSavedData() {
        let context =  DataBaseController.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HeroEntity")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch {
            print("Could not remove all.")
        }
    }

}
