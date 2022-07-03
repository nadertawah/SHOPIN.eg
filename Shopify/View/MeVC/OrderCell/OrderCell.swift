//
//  OrderCell.swift
//  Shopify
//
//  Created by Moataz Hussein on 03/07/2022.
//

import UIKit

class OrderCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var totalAmountLabel: UILabel!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    @IBOutlet weak var orderIDLabel: UILabel!
    
}
