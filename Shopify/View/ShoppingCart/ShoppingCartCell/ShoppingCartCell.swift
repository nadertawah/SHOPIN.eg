//
//  ShoppingCartCell.swift
//  Shopify
//
//  Created by Mohamed Azooz on 21/06/2022.
//

import UIKit

class ShoppingCartCell: UITableViewCell {

    //OutLets
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var qtyLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //MinusBtn Configrations
        minusBtn.layer.borderColor = UIColor.black.cgColor
        minusBtn.layer.borderWidth = 2.0
        minusBtn.layer.cornerRadius = 5
        
        //PlusBtn Configrations
        plusBtn.layer.borderColor = UIColor.black.cgColor
        plusBtn.layer.borderWidth = 2.0
        plusBtn.layer.cornerRadius = 5
        
    }

}
