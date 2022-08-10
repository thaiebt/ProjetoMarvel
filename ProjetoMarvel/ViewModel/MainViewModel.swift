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
                    
                    let hero = Results(id: Int(hero.heroId),
                                       name: hero.heroName,
                                       description: hero.heroDescription,
                                       thumbnail: Image(path: hero.heroThumbnailPath,
                                                        imageExtension: hero.heroThumbnailExtension),
                                       comics: comics,
                                       series: series,
                                       urls: nil)
                    
                    returnedHeroes.append(hero)
                }
                self.arrayHeroes = returnedHeroes.sorted(by: { hero1, hero2 in
                    let name1 = hero1.name
                    let name2 = hero2.name
                    return (name1?.localizedCaseInsensitiveCompare(name2 ?? "") == .orderedAscending)
                })
            }
            
            setArrays(arrayHeroes: arrayHeroes)
            view?.reloadDataCollectionViewHorizontal()
            view?.reloadDataCollectionViewVertical()
        }
    }
    
    func fillArrayHeroesApi() {
        let context = DataBaseController.persistentContainer.viewContext
        context.processPendingChanges()
        
        api.getDados(url: api.getURL.setUrl()) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let hero):
                guard let heroes = hero?.data?.results else {return}
                self.arrayHeroes = heroes
                self.setArrays(arrayHeroes: self.arrayHeroes)
                self.view?.reloadDataCollectionViewHorizontal()
                self.view?.reloadDataCollectionViewVertical()
                DataBaseController.saveData(heroes: heroes)
            case .failure(let error):
                print(error.localizedDescription)
                self.fillArrayHeroDataBase()
            }
        }
    }
    
    func infiniteScroll() {
        api.offset = self.arrayVertical.count + arrayHorizontal.count
        let limit = 50
        
        api.getDados(url: api.getURL.setUrlInfiniteScroll(offset: api.offset, limit: limit)) { [weak self] result in
            guard let self = self else { return }
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
                    self.view?.showUserAlert(message: "You have no internet access, log in and try to reload more characters")
                case .emptyData, .invalidData:
                    self.view?.showUserAlert(message: "Unable to connect to server, wait a moment and try again")
                }
            }
        }
    }
    
    func getSearchHeroAPI(searchText: String) {
        api.getDados(url: api.getURL.setUrlSearchName(nameStartsWith: searchText,
                                                      offset: api.offset,
                                                      limit: 50)) {[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let hero):
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
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setupSearchBarWhenIsEmpty() {
        isFilter = false
        isFilterEnd = false
        api.offset = 0
        view?.reloadDataCollectionViewVertical()
        view?.labelNoDataIsHidden()
        setArrays(arrayHeroes: self.arrayHeroes)
    }
    
    func startSearchBarWhenIsNotEmpty(searchText: String) {
        isFilter = true
        if api.statusCode == 200 {
            arrayVertical = []
            getSearchHeroAPI(searchText: searchText)
        } else {
            arrayVertical = arrayVertical.filter { hero in
                guard let heroName = hero.name else {return false}
                return heroName.contains(searchText)
            }
            view?.reloadDataCollectionViewVertical()
        }
    }
}
