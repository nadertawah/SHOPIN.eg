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
        
        var fontSize : CGFloat = 18
        if UIScreen.main.nativeBounds.height < 1700
        {fontSize = 15}
        
        self.setAttributedTitle(NSAttributedString(string: title,attributes:[NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: fontSize)]), for: .normal)
    }
}
