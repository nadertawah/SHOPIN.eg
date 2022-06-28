//
//  UIView.swift
//  Shopify
//
//  Created by Mohamed Azooz on 21/06/2022.
//

import Foundation
import UIKit

extension UIButton
{
    func shopifyBtn (title : String)
    {
        self.layer.cornerRadius = 5
        self.backgroundColor = .black
        self.tintColor = .white
        self.setAttributedTitle(NSAttributedString(string: title,attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)]), for: .normal)
    }
}
