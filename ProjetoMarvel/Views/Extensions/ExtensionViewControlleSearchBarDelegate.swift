//
//  ExtensionViewControllerTextFieldDelegate.swift
//  ProjetoMarvel
//
//  Created by c94289a on 30/11/21.
//

import UIKit

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
