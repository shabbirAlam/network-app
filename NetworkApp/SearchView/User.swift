//
//  Todo.swift
//  NetworkApp
//
//  Created by Md Shabbir Alam on 18/02/26.
//

import Foundation

struct Todo: Codable {
    let userID, id: Int
    let title: String
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, completed
    }
}
