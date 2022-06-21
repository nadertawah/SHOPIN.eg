//
//  UIView.swift
//  Shopify
//
//  Created by Mohamed Azooz on 21/06/2022.
//

import Foundation
import UIKit

extension UIButton {
    func setBtn (tilte : String) {
        self.setTitle(tilte, for: .normal)
        self.layer.cornerRadius = 15
        self.backgroundColor = .black
        self.tintColor = .white
        self.configuration?.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
                        var outgoing = incoming
                        outgoing.font = UIFont.systemFont(ofSize: 18, weight: .bold)
                        return outgoing
                    }
    }
}
