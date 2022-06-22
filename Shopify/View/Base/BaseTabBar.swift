//
//  BaseTabBar.swift
//  Shopify
//
//  Created by Nader Said on 18/06/2022.
//

import UIKit

class BaseTabBar:  UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //TODO: - initiate tabBar VC(s)
        let vc1 = HomeVC()
        let vc2 = CategoryVC()
        let vc3 = MeVC()
        
        //TODO: - set tabBar title(s)
        vc1.title = "Home"
        vc2.title = "Category"
        vc3.title = "Me"
        
        
        //TODO: - set VC(s) in the tabBar
        self.setViewControllers([vc1, vc2, vc3], animated: true)
        
        //TODO: - set tabBar image
        guard let items = self.tabBar.items else { return }
        items[0].image = UIImage(systemName: "house")
        items[1].image = UIImage(systemName: "list.dash")
        items[2].image = UIImage(systemName: "person.circle")
       
        //TODO: - set default selected index
        
        //TODO: - set tabBar attributes
        
    }
}
