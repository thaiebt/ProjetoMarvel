//
//  MainViewModelProtocol.swift
//  ProjetoMarvel
//
//  Created by c94289a on 14/01/22.
//

import Foundation

protocol MainViewProtocol: AnyObject {
    var searchText: String {get set}
    var count: Int { get set }
    var countShowAlert: Int { get set }
    func showUserAlert(message: String)
    func reloadDataCollectionViewHorizontal()
    func reloadDataCollectionViewVertical()
    func labelNoDataIsHidden()
    func labelNoDataIsNotHidden()
    func setupLoading()
    func setupView()
}
