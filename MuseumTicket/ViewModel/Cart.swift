//
//  Cart.swift
//  MuseumTicket
//
//  Created by Vinh Nguyen on 20/10/2021.
//

import Foundation

class Cart {
    
    var orderAll = [[Order]]()
    var items = [Order]()

    static let shared = Cart()
    
    func addItem(_ item: Order) {
        
        if let index = items.firstIndex(where: { (arrayItem) -> Bool in
            return arrayItem.id == item.id
        }) {
            items[index].quantity = items[index].quantity! + 1
        } else {
            let newItem = item
            items.append(newItem)
        }
    }
    
    func removeItem(_ item: Order) {
        if let index = items.firstIndex(where: { (arrayItem) -> Bool in
            return arrayItem.id == item.id
        }) {
            if items[index].quantity! > 1 {
                items[index].quantity = items[index].quantity! - 1
            } else {
                items.remove(at: index)
            }
        }
    }
    
    var totalItems: Int {
        return items.count
    }
    
    var cartTotal: Int {
        var total: Int = 0
        items.forEach{ total += $0.price! * $0.quantity! }
        return total
    }
    
    var totalItemsAll: Int {
        return orderAll.flatMap { $0 }.count
    }
    
    var cartTotalAll: Int {
        var total: Int = 0
        orderAll.forEach{ $0.forEach{total += $0.price! * $0.quantity! }}
        return total
    }
}
