//
//  Item.swift
//  MuseumTicket
//
//  Created by Vinh Nguyen on 20/10/2021.
//

import Foundation

struct Category: Codable {
    let id: Int?
    let name: String?
}

struct Ticket: Codable {
    let id: Int?
    let title: String?
    let price: Int?
    let description: String?
}

struct Order: Codable {
    var groupId: Int?
    var groupName: String?
    let id: Int?
    let title: String?
    let price: Int?
    let description: String?
    var quantity: Int?
    var date: String?
    var nationality: String?
    
    init(groupId: Int, groupName: String, id: Int, title : String, price: Int, description: String, quantity: Int, date: String, nationality: String) {
        self.groupId = groupId
        self.groupName = groupName
        self.id = id
        self.title = title
        self.price = price
        self.description = description
        self.quantity = quantity
        self.date = date
        self.nationality = nationality
    }
}
