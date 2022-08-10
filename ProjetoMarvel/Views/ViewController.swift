//
//  ViewController.swift
//  ProjetoMarvel
//
//  Created by c94289a on 18/11/21.
//

import UIKit
import Lottie
import Firebase

protocol MainViewProtocol: AnyObject {
    var searchText: String {get set}
    func showUserAlert(message: String)
    func reloadDataCollectionViewHorizontal()
    func reloadDataCollectionViewVertical()
    func labelNoDataIsHidden()
    func labelNoDataIsNotHidden()
}

class ViewController: UIViewController, MainViewProtocol {
    private lazy var viewModelMain: MainViewModel? = {
        let viewModel = MainViewModel(view: self,
                                      api: API(url: UrlApi()),
                                      data: DataBaseController())
        return viewModel
    }()
    
    private var reuseIdentifier = "cell"
    
    var searchText: String = ""
    var searchImage: UIImageView = UIImageView(image: UIImage(named: "searchImage"))
    
    private lazy var labelFeatured: UILabel = {
        let label = UILabel()
        label.text = "FEATURED CHARACTER"
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private lazy var horizontalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 16
        layout.minimumLineSpacing = 16
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(HorizontalCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collection.showsHorizontalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    private lazy var labelCharacterList: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "MARVEL CHARACTERS LIST"
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Search characters"
        searchBar.searchBarStyle = .minimal
        searchBar.barStyle = .default
        searchBar.searchTextField.font = .italicSystemFont(ofSize: 13.0)
        return searchBar
    }()
    
    private lazy var viewLine: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var verticalCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(VerticalCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.showsVerticalScrollIndicator = false
        collection.backgroundColor = .clear
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
    private lazy var labelNoData: UILabel = {
        let label = UILabel()
        label.text = "No characters with that name were found."
        label.textColor = .darkGray
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var loading = Animation()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        setupConstraints()
        viewModelMain?.fillArrayHeroesApi()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.applyAccessibility()
        self.voiceOverStatusDidChange()
        
        AnalyticsServices().selectedScreenView(screenName: "main_screen_view", screenClass: "MainViewController")
    }

    //MARK: Functions
    func showUserAlert(message: String) {
        let alert = UIAlertController(title: "Attention", message: message, preferredStyle: .alert)
        let buttonRedoCallApi = UIAlertAction(title: "Try again", style: .default) { [weak self] _ in
            if self?.viewModelMain?.api.statusCode == 200 {
                self?.viewModelMain?.fillArrayHeroesApi()
                self?.reloadDataCollectionViewVertical()
            } else {
                self?.showUserAlert(message: "Sorry, couldn't load more characters.")
            }
        }
        
        let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(buttonRedoCallApi)
        alert.addAction(buttonCancel)
        self.present(alert, animated: true, completion: nil)
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
    
    @objc private func changedVoiceOverStatus() {
        reloadDataCollectionViewHorizontal()
        reloadDataCollectionViewVertical()
        view.layoutIfNeeded()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
        view.addSubview(labelFeatured)
        view.addSubview(horizontalCollectionView)
        view.addSubview(labelCharacterList)
        view.addSubview(searchBar)
        view.addSubview(viewLine)
        view.addSubview(verticalCollectionView)
        loading.hidden()
        view.addSubview(loading.loadingView)
        verticalCollectionView.backgroundView = labelNoData
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            horizontalCollectionView.topAnchor.constraint(equalTo: labelFeatured.bottomAnchor, constant: 16.0),
            horizontalCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            horizontalCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            horizontalCollectionView.heightAnchor.constraint(equalToConstant: view.frame.width/2),
            
            labelFeatured.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24.0),
            labelFeatured.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            labelFeatured.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24.0),
            labelFeatured.heightAnchor.constraint(equalToConstant: 20.0),
            
            labelCharacterList.topAnchor.constraint(equalTo: horizontalCollectionView.bottomAnchor, constant: 24.0),
            labelCharacterList.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24),
            labelCharacterList.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 24.0),
            labelCharacterList.heightAnchor.constraint(equalToConstant: 20.0),
            
            searchBar.topAnchor.constraint(equalTo: labelCharacterList.bottomAnchor, constant: 19.0),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24.0),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24.0),
            searchBar.heightAnchor.constraint(equalToConstant: 40.0),
            
            searchBar.topAnchor.constraint(equalTo: labelCharacterList.bottomAnchor, constant: 19.0),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24.0),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24.0),
            searchBar.heightAnchor.constraint(equalToConstant: 40.0),
            
            viewLine.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5.0),
            viewLine.heightAnchor.constraint(equalToConstant: 1.0),
            viewLine.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24.0),
            viewLine.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24.0),
            
            verticalCollectionView.topAnchor.constraint(equalTo: viewLine.bottomAnchor, constant: 24.0),
            verticalCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            verticalCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.872),
            verticalCollectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            loading.loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            loading.loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loading.loadingView.widthAnchor.constraint(equalToConstant: 30.0),
            loading.loadingView.heightAnchor.constraint(equalToConstant: 30.0),
        ])
    }
    
    private func applyAccessibility() {
        labelFeatured.isAccessibilityElement = true
        labelFeatured.accessibilityLabel = "Featured Character."
        labelFeatured.accessibilityTraits = .header
        labelCharacterList.isAccessibilityElement = true
        labelCharacterList.accessibilityLabel = "Marvek Character List."
        labelCharacterList.accessibilityTraits = .header
        searchBar.isAccessibilityElement = true
        searchBar.accessibilityLabel = "Character search bar."
        searchBar.accessibilityTraits = .searchField
        searchBar.accessibilityHint = "Enter the name of the character you want to search for."
    }
}


// MARK: CollectionView Delegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = DetailViewController()
        if collectionView == horizontalCollectionView {
            guard let hero = viewModelMain?.arrayHorizontal[indexPath.row] else { return }
            detail.viewModelDetail.touchedHero = hero
            
            let heroName = hero.name?.replacingOccurrences(of: " ", with: "_")
            AnalyticsServices().selectedHero(heroName: heroName ?? "")
        } else {
            guard let hero = viewModelMain?.arrayVertical[indexPath.row] else { return }
            detail.viewModelDetail.touchedHero = hero
            
            guard let heroName = hero.name?.replacingOccurrences(of: " ", with: "_") else { return }
            AnalyticsServices().selectedHero(heroName: heroName)
        }
        
        navigationController?.pushViewController(detail, animated: true)
    }

}

//MARK: CollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == horizontalCollectionView {
            let larguraCelula: CGFloat = (self.view.frame.width)/2-16
            let itemSize = CGSize(width: larguraCelula, height: larguraCelula)
            return itemSize
        } else {
            let larguraCelula: CGFloat = (self.view.frame.width*0.872)/2-15
            let itemSize = CGSize(width: larguraCelula, height: larguraCelula)
            return itemSize
        }
    }
}

//MARK: CollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == horizontalCollectionView {
            if viewModelMain?.arrayHeroes.count ?? 0 > 0 {
                return 5
            } else {
                return 0
            }
        } else {
            return viewModelMain?.arrayVertical.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == horizontalCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? HorizontalCollectionViewCell else { return UICollectionViewCell() }
            
            guard let arrayHorizontalCount = viewModelMain?.arrayHorizontal.count, arrayHorizontalCount > 0,
                  let hero = viewModelMain?.arrayHorizontal[indexPath.row] else { return UICollectionViewCell() }
            cell.updateCell(hero: hero)
            return cell

        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? VerticalCollectionViewCell else { return UICollectionViewCell() }
           
            if let hero = viewModelMain?.arrayVertical[indexPath.row] {
                cell.configureCell(cell: cell, hero: hero)
            }
            return cell
        }
    }
}

//MARK: UIScrollDelegate
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // calcula aonde esta na posição y de cima para baixo
        let offsetY = verticalCollectionView.contentOffset.y
        let contentHeight = verticalCollectionView.contentSize.height
        // verifica se chegou no final da lista
        if offsetY > contentHeight - verticalCollectionView.frame.size.height && viewModelMain?.api.apiRequest == false && viewModelMain?.isFilter == false {
            self.loading.showLoadingIcon()
            self.viewModelMain?.infiniteScroll()
        }
        if offsetY > contentHeight - verticalCollectionView.frame.size.height && viewModelMain?.api.apiRequest == false && viewModelMain?.isFilter == true && viewModelMain?.isFilterEnd == false {
            self.loading.showLoadingIcon()
            self.viewModelMain?.getSearchHeroAPI(searchText: searchText)
        }
        if offsetY < contentHeight - verticalCollectionView.frame.size.height && viewModelMain?.api.apiRequest == false {
            self.loading.hidden()
            
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let search = searchBar.text else {return}
        if search.isEmpty {
            self.viewModelMain?.setupSearchBarWhenIsEmpty()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        guard let search = searchBar.text else {return}
        self.searchText = search
        if !searchText.isEmpty {
            viewModelMain?.startSearchBarWhenIsNotEmpty(searchText: searchText)
        }
    }
}
