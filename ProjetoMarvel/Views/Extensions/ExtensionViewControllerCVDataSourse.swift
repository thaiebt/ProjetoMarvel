//
//  ExtensionViewControllerCVDataSourse.swift
//  ProjetoMarvel
//
//  Created by c94289a on 30/11/21.
//

import UIKit
import Kingfisher

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
            
            guard let arrayHorizontalCount = viewModelMain?.arrayHorizontal.count else { return UICollectionViewCell() }
            if arrayHorizontalCount > 0 {
                if let hero = viewModelMain?.arrayHorizontal[indexPath.row] {
                    cell.configureCell(cell: cell, hero: hero)
                }
            }
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
