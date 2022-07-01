//
//  BaseTabBar.swift
//  Shopify
//
//  Created by Nader Said on 18/06/2022.
//

import UIKit

class BaseTabBar:  UITabBarController
{
    var dataProvider : DataProviderProtocol!
    var dataPersistant : DataPersistantProtocol!
    
    init(dataProvider : DataProviderProtocol,dataPersistant : DataPersistantProtocol)
    {
        self.dataProvider = dataProvider
        self.dataPersistant = dataPersistant
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //initiate tabBar VC(s)
        
        //home screen
        let homeVC = HomeVC()
        homeVC.VM = HomeViewModel(dataProvider: dataProvider, dataPersistant: dataPersistant)
        
        //category Screen
        let categoryVC = CategoryVC()
        categoryVC.VM = CategoryViewModel(dataProvider: dataProvider, dataPersistant: dataPersistant)
        
        //me screen
        let meVC = MeVC()
        meVC.VM = MeViewModel(dataProvider: dataProvider, dataPersistant: dataPersistant)
        
        
        let vc1 = BaseNavBar.init(rootViewController: homeVC)
        let vc2 = BaseNavBar.init(rootViewController: categoryVC)
        let vc3 = BaseNavBar.init(rootViewController: meVC)
        
        //set tabBar title(s)
        vc1.title = "Home"
        vc2.title = "Category"
        vc3.title = "Me"
        
        
        //Set VC(s) in the tabBar
        self.setViewControllers([vc1, vc2, vc3], animated: true)
        
        //Set tabBar image
        guard let items = self.tabBar.items else { return }
        items[0].image = UIImage(systemName: "house")
        items[1].image = UIImage(systemName: "list.dash")
        items[2].image = UIImage(systemName: "person.circle")

       
        //TODO: - set default selected index
        
        //set tabBar attributes
        self.tabBar.tintColor = .black
        
        
        //set delegate
        self.delegate = self
    }
    
}


extension BaseTabBar : UITabBarControllerDelegate
{
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController)
    {
        if viewController is MeVC
        {
            let vc = viewController as! MeVC
            vc.VM.getWishlistProducts()
        }
    }
}
