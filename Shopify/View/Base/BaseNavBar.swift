//
//  BaseNavBar.swift
//  Shopify
//
//  Created by Nader Said on 18/06/2022.
//

import Foundation
import UIKit

class BaseNavBar : UINavigationController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.isNavigationBarHidden = false
        
        // TODO: - NavBar Attributes
        self.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)]
        self.navigationBar.tintColor = .black
        
        //set VC(s)
        //let vc = MeVC.init(nibName: "MeVC", bundle: nil)
        let vc = ProductDetailsVC.init(nibName: "ProductDetailsVC", bundle: nil)

        self.viewControllers = [vc]
    }

}
