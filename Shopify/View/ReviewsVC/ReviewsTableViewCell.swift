//
//  ReviewsTableViewCell.swift
//  Shopify
//
//  Created by Nader Said on 22/06/2022.
//

import UIKit
import HCSStarRatingView

class ReviewsTableViewCell: UITableViewCell {

    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - IBOutlet(s)
    
    @IBOutlet weak var reviewerNameLabel: UILabel!
    
    @IBOutlet weak var rateView: HCSStarRatingView!
    {
        didSet
        {
            rateView.allowsHalfStars = true
            rateView.tintColor = .black
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var reviewBodyLabel: UILabel!
}
