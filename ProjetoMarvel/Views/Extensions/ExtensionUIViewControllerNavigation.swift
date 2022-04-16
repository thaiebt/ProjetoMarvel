//
//  ExtensionUIViewControllerNavigation.swift
//  ProjetoMarvel
//
//  Created by c94289a on 30/11/21.
//

import Foundation
import UIKit

extension UIViewController {
    func setupNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 32.0/255.0, green: 32.0/255.0, blue: 32.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 98, height: 39))
        let titleImage = UIImageView(image: UIImage(named: "logo-marvel"))
        titleImage.frame = CGRect(x: 0, y: 0, width: 88, height: 29)
        titleView.addSubview(titleImage)
        self.navigationItem.titleView = titleView
        
        titleView.isAccessibilityElement = true
        titleView.accessibilityLabel = "Marvel"
        titleView.accessibilityTraits = .header
        
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
    }
}
