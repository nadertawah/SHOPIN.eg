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

    @IBAction func adsPageControl(_ sender: UIPageControl) {
        
        // TODO: Connect adsPageControl with adsCollectionView
        debugPrint("AdsPageControl Changed Value!")
        
    }
    
    //MARK: - IBOutlet(s)
    @IBOutlet weak var brandsSearchBar: UISearchBar!
    
    @IBOutlet weak var adsCollectionView: UICollectionView!
    
    @IBOutlet weak var brandsCollectionView: UICollectionView!
    
    //MARK: - Variable(s)
    private let homeViewModel = HomeViewModel(dataProvider: API())
    
    //MARK: - Helper functions
    func setUI()
    {
        
        //set title
        title = "SHOPIN.eg"
        
        //set navbar wishlist and settings buttons
        setNavBarBtns()
        
        // Registering CollectionViews' Cells
        brandsCollectionView.register(UINib(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: Constants.brandCellReuseIdentifier)
        
        adsCollectionView.register(UINib(nibName: "AdCell", bundle: nil), forCellWithReuseIdentifier: Constants.adCellReuseIdentifier)
        
        // Setting CollectionViews' Delegates and Datasources
        brandsCollectionView.delegate = self
        brandsCollectionView.dataSource = self
        
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
        
        //set search bar delegate
        brandsSearchBar.delegate = self
        
        // Fetching data from API and Updating Collection View
        homeViewModel.filtereBrandsList.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.brandsCollectionView.reloadData()
            }
        }
    }
    
    // Setting Navigation Bar Buttons
    func setNavBarBtns() {
        
        // Left Button - Navigation to WishList
        let wishlistNavBtn = UIBarButtonItem(image: UIImage(systemName: "heart")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(navigateToWishlist))
        self.navigationController?.navigationBar.topItem?.setLeftBarButtonItems([wishlistNavBtn], animated: true)
        
        // Right Button - Navigation to ShoppingCart
        let shoppingCartNavBtn = UIBarButtonItem(image: UIImage(systemName: "cart")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(navigateToShoppingCart))
        self.navigationController?.navigationBar.topItem?.setRightBarButtonItems([shoppingCartNavBtn], animated: true)
        
        
    }
    
    @objc func navigateToWishlist() {
        //TODO: Navigate to wishList
        debugPrint("navigateToWishlist")
    }
    
    @objc func navigateToShoppingCart() {
        let shopingCartVC = ShoppingCartVC()
        self.navigationController?.pushViewController(shopingCartVC, animated: true)
    }
    
}

//MARK: - CollectionView Datasource Methods
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Set number of items in ads and brands collection views
        if collectionView == brandsCollectionView {
            return homeViewModel.filtereBrandsList.value?.count ?? 0
        } else {
            //TODO: set number of ads
            return 3
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == brandsCollectionView {
            
            guard let cell = brandsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.brandCellReuseIdentifier, for: indexPath) as? BrandCell else { return UICollectionViewCell() }
            
            let brand = homeViewModel.filtereBrandsList.value?[indexPath.item]
            
            // Set brands using API
            cell.brandNameLabel.text = brand?.title
            cell.brandLogoImgView.sd_setImage(with: URL(string: brand?.image.src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
            
            return cell
            
        } else {
            
            guard let cell = adsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.adCellReuseIdentifier, for: indexPath) as? AdCell else { return UICollectionViewCell() }
            
            // TODO: Set Ads
            cell.adImgView.sd_setImage(with: URL(string: "https://www.pngkey.com/png/detail/233-2332677_image-500580-placeholder-transparent.png"), placeholderImage: UIImage(named: "placeHolder"))
            
            return cell
            
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == brandsCollectionView {
            
            let brand = homeViewModel.filtereBrandsList.value?[indexPath.item].title
            
            let destinationVC = ProductsVC()
            destinationVC.productsVM = ProductsViewModel(dataProvider: API(), brand: brand ?? "")
            navigationController?.pushViewController(destinationVC, animated: true)
            
        } else {
            
            // TODO: For Ads selection
            
        }
        
    }
    
}

//MARK: - CollectionView FlowLayout Methods
extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == brandsCollectionView {
            
            return CGSize(width: brandsCollectionView.frame.width/2, height: brandsCollectionView.frame.height/2)
            
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

//MARK: - search bar callbacks
extension HomeVC : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        homeViewModel.searchBrands(searchStr: searchBar.text ?? "" )
    }
}
