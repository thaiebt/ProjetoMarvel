//
//  Gradient.swift
//  ProjetoMarvel
//
//  Created by c94289a on 22/11/21.
//


import UIKit

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

