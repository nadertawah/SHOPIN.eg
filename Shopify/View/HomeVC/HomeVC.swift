//
//  HomeVC.swift
//  Shopify
//
//  Created by Nader Said on 20/06/2022.
//

import UIKit
import SDWebImage

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
    }

    //MARK: - IBAction(s)
    @IBAction func wishListBtn(_ sender: UIButton) {
        
        // TODO: Set Navigation to wishlist
        debugPrint("WishList Button Pressed!")
        
    }
    
    @IBAction func shoppingCartBtn(_ sender: UIButton) {
        
        // TODO: Set Navigation to shopping cart
        debugPrint("ShoppingCart Button Pressed!")
        
    }
    
    @IBAction func adsPageControl(_ sender: UIPageControl) {
        
        // TODO: Connect adsPageControl with adsCollectionView
        debugPrint("AdsPageControl Changed Value!")
        
    }
    
    //MARK: - IBOutlet(s)
    @IBOutlet weak var brandsSearchBar: UISearchBar!
    
    @IBOutlet weak var adsCollectionView: UICollectionView!
    
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    //MARK: - Variable(s)
    private let brandCellReuseIdentifier = "brandCell"
    private let adCellReuseIdentifier = "adCell"
    
    //MARK: - Helper functions
    func setUI()
    {
        
        // Registering CollectionViews' Cells
        brandsCollectionView.register(UINib(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: brandCellReuseIdentifier)
        
        adsCollectionView.register(UINib(nibName: "AdCell", bundle: nil), forCellWithReuseIdentifier: adCellReuseIdentifier)
        
        // Setting CollectionViews' Delegates and Datasources
        brandsCollectionView.delegate = self
        brandsCollectionView.dataSource = self
        
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
        
        // Setting CollectionViews' layouts
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        brandsCollectionView.collectionViewLayout = layout
        adsCollectionView.collectionViewLayout = layout

    }

}

//MARK: - CollectionView Datasource Methods
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // TODO: Set number of items in ads and brands collection views
        if collectionView == adsCollectionView {
            return 3
        } else {
            return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == brandsCollectionView {
            
            guard let cell = brandsCollectionView.dequeueReusableCell(withReuseIdentifier: brandCellReuseIdentifier, for: indexPath) as? BrandCell else { return UICollectionViewCell() }
            
            // TODO: Set brands using API
            cell.brandNameLabel.text = "Brand"
            cell.brandLogoImgView.sd_setImage(with: URL(string: "https://www.pngkey.com/png/detail/233-2332677_image-500580-placeholder-transparent.png"), placeholderImage: UIImage(named: "placeHolder"))
            
            return cell
            
        } else {
            
            guard let cell = adsCollectionView.dequeueReusableCell(withReuseIdentifier: adCellReuseIdentifier, for: indexPath) as? AdCell else { return UICollectionViewCell() }
            
            // TODO: Set Ads
            cell.adImgView.sd_setImage(with: URL(string: "https://www.pngkey.com/png/detail/233-2332677_image-500580-placeholder-transparent.png"), placeholderImage: UIImage(named: "placeHolder"))
            
            return cell
            
        }

    }
    
}

//MARK: - CollectionView FlowLayout Methods
extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    // TODO: Fix the flaw in layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == brandsCollectionView {
            
            return CGSize(width: brandsCollectionView.frame.width/2.0, height: brandsCollectionView.frame.width/2.0)
            
        } else {
            
            return CGSize(width: adsCollectionView.frame.width, height: adsCollectionView.frame.height)
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

