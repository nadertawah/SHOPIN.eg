//
//  PaymentMethodCell.swift
//  Shopify
//
//  Created by Mohamed Azooz on 22/06/2022.
//

import UIKit

class PaymentMethodCell: UITableViewCell {

    //MARK: - IBOutlet(s)
    @IBOutlet weak var checkPaymentBtn: UIButton!
    @IBOutlet weak var PaymentImage: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
