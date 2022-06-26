//
//  ProductCell.swift
//  Shopify
//
//  Created by Moataz Hussein on 22/06/2022.
//

import UIKit

class ProductCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - IBOutlet(s)
    @IBOutlet weak var productImgView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
        
    @IBOutlet weak var productNameLabel: UILabel!
    
    //MARK: - IBAction(s)
    @IBAction func wishListBtn(_ sender: UIButton) {
        
        // TODO: Set add to wish list
        debugPrint("Add to wishList Btn Pressed!")
    }
}
