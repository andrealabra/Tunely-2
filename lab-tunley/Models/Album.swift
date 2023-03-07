//
//  Album.swift
//  lab-tunley
//
//  Created by Andrea Labra Orozco on 3/05/23.
//

import Foundation

struct Album: Decodable {
    let artworkUrl100: URL
}

struct AlbumSearchResponse: Decodable {
    let results: [Album]
}
