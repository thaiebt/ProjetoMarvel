//
//  ExtensionViewControllerCVDelegateFlowLayout.swift
//  ProjetoMarvel
//
//  Created by c94289a on 30/11/21.
//

import UIKit

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == horizontalCollectionView {
            let larguraCelula: CGFloat = (self.view.frame.width)/2-16
            let itemSize = CGSize(width: larguraCelula, height: larguraCelula)
//            let itemSize = CGSize(width: 180.0, height: 180.0)
            return itemSize
        } else {
            let larguraCelula: CGFloat = (self.view.frame.width*0.872)/2-15
            let itemSize = CGSize(width: larguraCelula, height: larguraCelula)
//            let itemSize = CGSize(width: 156.0, height: 156.0)
            return itemSize
        }
    }
}

