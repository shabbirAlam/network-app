//
//  CountriesResponse.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 19/04/26.
//

import Foundation

struct CountriesResponse: Decodable {
    let countries: [Country]
}

struct Country: Codable, Hashable {
    let code: String
    let name: String
    let capital: String?
}
