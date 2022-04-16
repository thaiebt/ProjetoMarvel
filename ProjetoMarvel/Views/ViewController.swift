//
//  ViewController.swift
//  ProjetoMarvel
//
//  Created by c94289a on 18/11/21.
//

import UIKit
import Lottie
import Firebase

class ViewController: UIViewController, MainViewProtocol {
    lazy var viewModelMain: MainViewModel? = {
        let viewModel = MainViewModel(view: self, api: API(url: UrlApi()), data: DataBaseController())
        return viewModel
    }()
    var reuseIdentifier = "cell"
    var loading = Animation()
    var searchText: String = ""
    var count: Int = 510
    var countShowAlert: Int = 0
    
    var searchImage: UIImageView = UIImageView(image: UIImage(named: "searchImage"))
    
    var labelFeatured: UILabel = {
        let label = UILabel()
        label.text = "FEATURED CHARACTER"
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        
        label.isAccessibilityElement = true
        label.accessibilityLabel = "Featured Character."
        
        return label
    }()
    
    lazy var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collectionHorizontal = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionHorizontal.translatesAutoresizingMaskIntoConstraints = false
        collectionHorizontal.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionHorizontal.showsHorizontalScrollIndicator = false
        collectionHorizontal.backgroundColor = .clear
        
        collectionHorizontal.delegate = self
        collectionHorizontal.dataSource = self
        
        return collectionHorizontal
    }()
    
    var labelCharacterList: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "MARVEL CHARACTERS LIST"
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        
        label.isAccessibilityElement = true
        label.accessibilityLabel = "Marvek Character List."
        
        return label
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search characters"
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .default
        searchBar.searchTextField.font = .italicSystemFont(ofSize: 13.0)
        
        searchBar.isAccessibilityElement = true
        searchBar.accessibilityLabel = "Character search bar."
        
        
        return searchBar
    }()
    
    var viewLine: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = .black
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        return lineView
    }()
    
    lazy var verticalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        
        let collectionVertival = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionVertival.translatesAutoresizingMaskIntoConstraints = false
        collectionVertival.register(VerticalCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionVertival.showsVerticalScrollIndicator = false
        collectionVertival.backgroundColor = .clear
        
        collectionVertival.delegate = self
        collectionVertival.dataSource = self
        
        return collectionVertival
    }()
    
    lazy var labelNoData: UILabel = {
        let noDataLabel = UILabel()
        noDataLabel.text = "No characters with that name were found."
        noDataLabel.textColor = .darkGray
        noDataLabel.font = UIFont.boldSystemFont(ofSize: 15)
        noDataLabel.textAlignment = .center
        self.verticalCollectionView.backgroundView = noDataLabel
        noDataLabel.isHidden = true
        
        return noDataLabel
    }()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigation()
        self.setupView()
        self.viewModelMain?.fillArrayHeroesApi()
        self.setupLoading()
        
        AnalyticsServices().selectedID(nameID: "hulk")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.applyAccessibility()
        self.voiceOverStatusDidChange()
        
        AnalyticsServices().selectedScreenView(screenName: "main_screen_view", screenClass: "MainViewController")
    }

    //MARK: Functions
    func showUserAlert(message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
            
            let buttonRedoCallApi = UIAlertAction(title: "Try again", style: .default) { _ in
                if self.viewModelMain?.api.statusCode == 200 {
                    self.viewModelMain?.fillArrayHeroesApi()
                    self.reloadDataCollectionViewVertical()
                } else {
                    self.showUserAlert(message: "Sorry, couldn't load more characters.")
                }
            }
            
            let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(buttonRedoCallApi)
            alert.addAction(buttonCancel)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func reloadDataCollectionViewHorizontal() {
        horizontalCollectionView.reloadData()
    }
    
    func reloadDataCollectionViewVertical() {
        verticalCollectionView.reloadData()
    }
    
    func labelNoDataIsHidden() {
        labelNoData.isHidden = true
    }
    
    func labelNoDataIsNotHidden() {
        labelNoData.isHidden = false
    }
    
    func voiceOverStatusDidChange() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changedVoiceOverStatus),
                                               name: UIAccessibility.voiceOverStatusDidChangeNotification,
                                               object: nil)
    }
    
    @objc func changedVoiceOverStatus() {
        self.reloadDataCollectionViewHorizontal()
        self.reloadDataCollectionViewVertical()
        self.view.layoutIfNeeded()
    }
    
    func applyAccessibility() {
        labelFeatured.accessibilityTraits = .header
        labelCharacterList.accessibilityTraits = .header
        searchBar.accessibilityTraits = .searchField
        searchBar.accessibilityHint = "Enter the name of the character you want to search for."
    }
    
    func setupLoading(){
        self.loading.hidden()
        self.view.addSubview(self.loading.loading)
        NSLayoutConstraint.activate([
            self.loading.loading.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            self.loading.loading.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            self.loading.loading.widthAnchor.constraint(equalToConstant: 30.0),
            self.loading.loading.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        
        self.view.addSubview(labelFeatured)
        NSLayoutConstraint.activate([
            self.labelFeatured.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            self.labelFeatured.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            self.labelFeatured.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24.0),
            self.labelFeatured.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        
        self.view.addSubview(horizontalCollectionView)
        NSLayoutConstraint.activate([
            self.horizontalCollectionView.topAnchor.constraint(equalTo: labelFeatured.bottomAnchor, constant: 16.0),
            self.horizontalCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            self.horizontalCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.horizontalCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width/2)
        ])
        
        self.view.addSubview(labelCharacterList)
        NSLayoutConstraint.activate([
            self.labelCharacterList.topAnchor.constraint(equalTo: horizontalCollectionView.bottomAnchor, constant: 24.0),
            self.labelCharacterList.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            self.labelCharacterList.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24.0),
            self.labelCharacterList.heightAnchor.constraint(equalToConstant: 20.0)
        ])
        
        self.view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            self.searchBar.topAnchor.constraint(equalTo: labelCharacterList.bottomAnchor, constant: 19.0),
            self.searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24.0),
            self.searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24.0),
            self.searchBar.heightAnchor.constraint(equalToConstant: 40.0)
        ])
        
        self.view.addSubview(viewLine)
        NSLayoutConstraint.activate([
            self.viewLine.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5.0),
            self.viewLine.heightAnchor.constraint(equalToConstant: 1.0),
            self.viewLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24.0),
            self.viewLine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24.0)
        ])
        
        self.view.addSubview(verticalCollectionView)
        NSLayoutConstraint.activate([
            self.verticalCollectionView.topAnchor.constraint(equalTo: viewLine.bottomAnchor, constant: 24.0),
            self.verticalCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            self.verticalCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.872),
            self.verticalCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
//    func fillArrayHeroes() -> [HeroDadosMockados] {
//        let heroes = data.getheroesCharactersList() 0.872
//        return heroes
//    }
//
//    func fillArrayFeaturedCharacteres() -> [HeroDadosMockados] {
//        let heroes = data.heroesFeaturedCharactersDS()
//        return heroes
//    }

}

