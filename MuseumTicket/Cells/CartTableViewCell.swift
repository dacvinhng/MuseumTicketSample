//
//  CartTableViewCell.swift
//  MuseumTicket
//
//  Created by Vinh Nguyen on 20/10/2021.
//

import UIKit

protocol CartCellDelegate {
    func updateCartItem(cell: CartTableViewCell, calculate: Int)
}

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    
    var delegate: CartCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
    }
    
    @IBAction func minusBtnSelected(_ sender: Any) {
        print("minus")
        self.delegate?.updateCartItem(cell: self, calculate: -1)
    }
    
    
    @IBAction func plusBtnSelected(_ sender: Any) {
        print("plus")
        self.delegate?.updateCartItem(cell: self, calculate: 1)
    }
    
}
