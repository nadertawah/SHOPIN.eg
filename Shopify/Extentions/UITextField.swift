//
//  UITextField.swift
//  Shopify
//
//  Created by Mohamed Azooz on 22/06/2022.
//

import Foundation
import UIKit

extension UITextField {
    
    func shopifyTF (placeholder : String)
    {
        self.layer.cornerRadius = 5
        self.backgroundColor = .lightGray
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
    }
}
