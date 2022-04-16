//
//  ExtensioViewControllerCVDelegate.swift
//  ProjetoMarvel
//
//  Created by c94289a on 30/11/21.
//

import UIKit

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = DetailViewController()
        if collectionView == horizontalCollectionView {
            guard let hero = self.viewModelMain?.arrayHorizontal[indexPath.row] else { return }
            detail.viewModelDetail.touchedHero = hero
            
            guard let heroName = hero.name?.replacingOccurrences(of: " ", with: "_") else { return }
            AnalyticsServices().selectedHero(heroName: heroName)
        } else {
            guard let hero = self.viewModelMain?.arrayVertical[indexPath.row] else { return }
            detail.viewModelDetail.touchedHero = hero
            
            guard let heroName = hero.name?.replacingOccurrences(of: " ", with: "_") else { return }
            AnalyticsServices().selectedHero(heroName: heroName)
        }
        self.navigationController?.pushViewController(detail, animated: true)
    }

}
