//
//  DetailViewModel.swift
//  ProjetoMarvel
//
//  Created by c94289a on 15/01/22.
//

import Foundation
import SafariServices

class DetailViewModel {
    var view: DetailViewController
    init(view: DetailViewController) {
        self.view = view
    }
    var touchedHero: Results = Results()
    
    func setupImageUrlString() -> String {
        if let path = touchedHero.thumbnail?.path,
           let imageExtension = touchedHero.thumbnail?.imageExtension {
                let url = "\(path)/standard_fantastic.\(imageExtension)"
                
            return url
        } else {
            return ""
        }
    }
    
    func setupLabelNameText() -> String {
        if let name = touchedHero.name {
            return name
        } else {
            return "Sorry, this character doesn't have a name registered yet."
        }
        
    }
    
    func setupLabelDescriptionText() -> String {
        if let description = touchedHero.description, !description.isEmpty {
            return description
        } else {
            return "Sorry, this character doesn't have a biography registered yet."
        }
    }
    
    func setupLabelComicsText() -> String {
        if let comicsItems = touchedHero.comics?.items {
            if comicsItems.count > 0 {
                var comicsNames = """
                            """
                for name in comicsItems {
                    if let names = name.name {
                        comicsNames.append("▸ \(names)\n")
                    }
                }
                return comicsNames
            } else {
                return "Sorry, this character doesn't have any comics registered yet."
            }
        } else {
            return "Sorry, this character doesn't have any comics registered yet."
        }
    }
    
    func setupLabelSeriesText() -> String {
        if let seriesItems = touchedHero.series?.items {
            if seriesItems.count > 0 {
                var seriesNames = """
                                """
                for name in seriesItems {
                    if let names = name.name {
                        seriesNames.append("▸ \(names)\n")
                    }
                }
                return seriesNames
            } else {
                return "Sorry, this character doesn't have any series registered yet."
            }
        } else {
            return "Sorry, this character doesn't have any series registered yet."
        }
    }
    
    func setUrlButtonAction() {
        if let urls = touchedHero.urls {
            var urlDetails = ""
            for url in urls {
                guard let type = url.type else {return}
                if type == "detail"{
                    guard let url = url.url else {return}
                    urlDetails = url
                    break
                }
            }
            guard let url = URL(string: urlDetails) else { return }
            let safariViewController = SFSafariViewController(url: url)
            
            self.view.showDetailViewController(safariViewController, sender: nil)
        }
    }
}
