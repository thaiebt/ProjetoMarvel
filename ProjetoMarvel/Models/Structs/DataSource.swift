//
//  DataSource.swift
//  ProjetoMarvel
//
//  Created by c94289a on 22/11/21.
//

import Foundation

struct DataSource {
    func getheroesCharactersList() -> [HeroDadosMockados] {
        let heroes: [HeroDadosMockados] = [
            HeroDadosMockados(name: "3D-Man", urlImage: "3d-man"),
            HeroDadosMockados(name: "8-Ball", urlImage: "8-ball"),
            HeroDadosMockados(name: "Adbul Alhazred", urlImage: "adbul"),
            HeroDadosMockados(name: "Abomination", urlImage: "abomination"),
            HeroDadosMockados(name: "A", urlImage: "a"),
            HeroDadosMockados(name: "Aberration", urlImage: "aberration"),
            HeroDadosMockados(name: "Abraxas", urlImage: "abraxas"),
            HeroDadosMockados(name: "Abigail Brand", urlImage: "abigail"),
            HeroDadosMockados(name: "Aardwolf", urlImage: "aardwolf"),
            HeroDadosMockados(name: "3D-Man", urlImage: "3d-man-1"),
            HeroDadosMockados(name: "Black Widow", urlImage: "VIUVA"),
            HeroDadosMockados(name: "Wanda Maximoff", urlImage: "wanda")
        ]
        return heroes
    }

    func heroesFeaturedCharactersDS() -> [HeroDadosMockados] {
        let heroes: [HeroDadosMockados] = [
            HeroDadosMockados(name: "Black Widow", urlImage: "VIUVA"),
            HeroDadosMockados(name: "Wanda Maximoff", urlImage: "wanda"),
            HeroDadosMockados(name: "Adbul Alhazred", urlImage: "adbul"),
            HeroDadosMockados(name: "A", urlImage: "a"),
            HeroDadosMockados(name: "Abraxas", urlImage: "abraxas")
        ]
        return heroes
    }
}
