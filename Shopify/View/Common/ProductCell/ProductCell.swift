//
//  ProductCell.swift
//  Shopify
//
//  Created by Moataz Hussein on 22/06/2022.
//

import UIKit

class ProductCell: UICollectionViewCell {

    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: - IBOutlet(s)
    @IBOutlet weak var productImgView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
        
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var isAddedTowishlistBtn: UIButton!
    
    //MARK: - IBAction(s)
    @IBAction func wishListBtnPressed(_ sender: UIButton)
    {
        if Helper.getCustomerID() == 0
        {
            let alert = Alerts.instance.showAlert(title: "", message: "You must login first!")
            window?.rootViewController?.present(alert, animated: true)

        }
        else
        {
            VM?.toggleWishlist()
        }
    }
    
    //MARK: - VAR(s)
    var VM : ProductCellVM?
    
    
    //MARK: - Helper Funcs
    func configureCellVM()
    {
        VM?.isAddedToWishlist.bind
        {
            [weak self] isAdded in
            if isAdded == true
            {
                self?.isAddedTowishlistBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            }
            else if isAdded == false
            {
                self?.isAddedTowishlistBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            }
            
        }
    }
}
