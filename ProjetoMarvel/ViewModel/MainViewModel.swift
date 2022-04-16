//
//  MainViewModel.swift
//  ProjetoMarvel
//
//  Created by c94289a on 14/01/22.
//

import Foundation

class MainViewModel {
    weak var view: MainViewProtocol?
    var api: MarvelAPIProtocol
    var data: DataBaseProtocol
    init(view: MainViewProtocol, api: MarvelAPIProtocol, data: DataBaseProtocol) {
        self.view = view
        self.api = api
        self.data = data
    }
    var arrayHeroes: [Results] = [] 
    var arrayHorizontal: [Results] = []
    var arrayVertical: [Results] = []
    var hero: Results?
    var heroesDataBase: [HeroEntity] = []
    var isFilter: Bool = false
    var isFilterEnd: Bool = false
    var error: Error?
    
    func setArrays(arrayHeroes: [Results]) {
        self.arrayHorizontal = Array(arrayHeroes[0...4])
        self.arrayVertical = Array(arrayHeroes[5..<arrayHeroes.count])
    }
    
    func fillArrayHeroDataBase() {
        heroesDataBase = DataBaseController.getDataFromCoreData()
        print(heroesDataBase)
        var returnedHeroes: [Results] = []
        
        if heroesDataBase.count > 0 {
            for hero in heroesDataBase {
                
                if hero.heroName != nil {
                    var comicsItems: [Items] = []
                    guard let comicsItemsData = hero.heroComics?.allObjects as? [ItemsEntity] else { return }
                    for comic in comicsItemsData {
                        let items = Items(name: comic.name)
                        comicsItems.append(items)
                    }
                        
                    let comics = Comics(items: comicsItems)

                    var seriesItems: [Items] = []
                    guard let seriesItemsData = hero.heroSeries?.allObjects as? [ItemsEntity] else { return }
                    for serie in seriesItemsData {
                        let item = Items(name: serie.name)
                        seriesItems.append(item)
                    }
                    let series = Series(items: seriesItems)
                    
                    let hero = Results(id: Int(hero.heroId), name: hero.heroName, description: hero.heroDescription, thumbnail: Image(path: hero.heroThumbnailPath, imageExtension: hero.heroThumbnailExtension), comics: comics, series: series, urls: nil)
                    
                    returnedHeroes.append(hero)
                }
                self.arrayHeroes = returnedHeroes.sorted(by: { hero1, hero2 in
                    let name1 = hero1.name
                    let name2 = hero2.name
                    return (name1?.localizedCaseInsensitiveCompare(name2 ?? "") == .orderedAscending)
                })
            }
            self.setArrays(arrayHeroes: arrayHeroes)

            print(self.arrayHorizontal.count)
            self.view?.reloadDataCollectionViewHorizontal()
            self.view?.reloadDataCollectionViewVertical()

        }
    }
    
    func fillArrayHeroesApi() {
        let context = DataBaseController.persistentContainer.viewContext
        context.processPendingChanges()
        
        api.getDados(url: api.getURL.setUrl()) { result in
            switch result {
            case .success(let hero):
                guard let heroes = hero?.data?.results else {return}
                self.arrayHeroes = heroes
                self.setArrays(arrayHeroes: self.arrayHeroes)
                DataBaseController.saveData(heroes: heroes)

                self.view?.reloadDataCollectionViewHorizontal()
                self.view?.reloadDataCollectionViewVertical()

            case .failure(let error):
                switch error {
                case .noInternet:
                    self.fillArrayHeroDataBase()
                    self.error = error
                    print("No Internet Access")
                case .emptyData:
                    self.fillArrayHeroDataBase()
                    self.error = error
                    print("Empty Data")
                case .invalidData:
                    self.fillArrayHeroDataBase()
                    self.error = error
                    print("Invalid Data")
                }
            }
        }
    }
    
    func infiniteScroll() {
        api.offset = self.arrayVertical.count + arrayHorizontal.count
        let limit = 50
        
        api.getDados(url: api.getURL.setUrlInfiniteScroll(offset: api.offset, limit: limit)) { result in
            switch result {
            case .success(let hero):
                guard let heroes = hero?.data?.results else {return}
                self.arrayVertical += heroes
                DataBaseController.saveData(heroes: heroes)
                self.api.offset += limit

                self.view?.reloadDataCollectionViewVertical()

            case .failure(let error):
                switch error {
                case .noInternet:
                    print("No Internet Access")
                    self.error = error
                    self.view?.showUserAlert(message: "You have no internet access, log in and try to reload more characters")
                case .emptyData:
                    print("Empty Data")
                    self.error = error
                case .invalidData:
                    self.view?.showUserAlert(message: "Unable to connect to server, wait a moment and try again")
                    self.error = error
                    print("Invalid Data")
                }
            }
        }
    }
    
    func getSearchHeroAPI(searchText: String) {
        api.getDados(url: api.getURL.setUrlSearchName(nameStartsWith: searchText, offset: api.offset, limit: 50)) { result in
            if case .success(let hero) = result {
//                print(hero?.data?.results?[0].name)
                guard let heroes = hero?.data?.results, heroes.count > 0 else {
                    self.view?.reloadDataCollectionViewVertical()
                    self.view?.labelNoDataIsNotHidden()
                    return
                }
                self.arrayVertical += heroes
                self.api.offset += self.arrayVertical.count
                
                if heroes.count < 50 {
                    self.isFilterEnd = true
                }
                self.view?.reloadDataCollectionViewVertical()
            }
        }
    }
    
    func setupSearchBarWhenIsEmpty() {
        self.isFilter = false
        self.isFilterEnd = false
        self.api.offset = 0
        
        self.view?.reloadDataCollectionViewVertical()
        self.view?.labelNoDataIsHidden()

        self.setArrays(arrayHeroes: self.arrayHeroes)
    }
    
    func startSearchBarWhenIsNotEmpty(searchText: String) {
        isFilter = true
        if api.statusCode == 200 {
            self.arrayVertical = []
            self.getSearchHeroAPI(searchText: searchText)
        } else {
            self.arrayVertical = arrayVertical.filter { hero in
                guard let heroName = hero.name else {return false}
                return heroName.contains(searchText)
            }
            self.view?.reloadDataCollectionViewVertical()
        }
    }
}
