//
//  ShoppingCartCell.swift
//  Shopify
//
//  Created by Mohamed Azooz on 21/06/2022.
//

import UIKit

class ShoppingCartCell: UITableViewCell {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        minusBtn.layer.borderColor = UIColor.black.cgColor
        minusBtn.layer.borderWidth = 2.0
        minusBtn.layer.cornerRadius = 5
        
        plusBtn.layer.borderColor = UIColor.black.cgColor
        plusBtn.layer.borderWidth = 2.0
        plusBtn.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
