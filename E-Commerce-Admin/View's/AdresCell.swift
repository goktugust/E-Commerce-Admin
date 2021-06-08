//
//  AdresCell.swift
//  E-Commerce-Admin
//
//  Created by Göktuğ Üstüner on 22.05.2021.
//

import UIKit

class AdresCell: UITableViewCell {

    @IBOutlet weak var home: UIImageView!
    @IBOutlet weak var adresView: UIView!
    @IBOutlet weak var adresAdi: UILabel!
    @IBOutlet weak var adresTarifi: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
