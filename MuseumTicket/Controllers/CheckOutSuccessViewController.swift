//
//  CheckOutSuccessViewController.swift
//  MuseumTicket
//
//  Created by Vinh Nguyen on 20/10/2021.
//

import UIKit

class CheckOutSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Cart.shared.items.removeAll()
        Cart.shared.orderAll.removeAll()
    }


    @IBAction func backHomeSelected(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(identifier: "HomeViewController")
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: false, completion: nil)
    }
}
