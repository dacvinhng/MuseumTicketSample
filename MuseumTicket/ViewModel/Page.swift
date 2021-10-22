//
//  Page.swift
//  MuseumTicket
//
//  Created by Vinh Nguyen on 20/10/2021.
//

import UIKit

import Foundation
import UIKit

struct Page {
    var name = ""
    var vc = UIViewController()
    
    init(with _name: String, _vc: UIViewController) {
        name = _name
        vc = _vc
    }
}

struct PageCollection {
    var pages = [Page]()
    var selectedPageIndex = 0 //The first page is selected by default in the beginning
}
