//
//  MenuBarCollectionViewCell.swift
//  MuseumTicket
//
//  Created by Vinh Nguyen on 20/10/2021.
//

import UIKit

class MenuBarCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var tabLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }

}
