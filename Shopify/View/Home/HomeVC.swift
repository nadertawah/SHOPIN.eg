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
    
    @IBOutlet weak var adsPageControler: UIPageControl!
    
    
    //MARK: - Variable(s)
    var VM : HomeViewModel!
    
    //MARK: - Helper functions
    func setUI()
    {
        
        //set title
        title = "SHOPIN.eg"
        
        //set navbar wishlist and settings buttons
        setNavBarBtns()
        
        // Set Timer To Ads collectionView
        startTimer()
        
        //Set default currency
        setDefaultCurrency()
        
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
        VM.filtereBrandsList.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.brandsCollectionView.reloadData()
            }
        }
    }
    
    // Set Default Currency
    func setDefaultCurrency() {
        if UserDefaults.standard.string(forKey: "Currency") == nil {
            VM.dataPersistant.setCurrency(currency: "USD")
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
    
        @objc func scrollToNextCell(){

            let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
            let contentOffset = adsCollectionView.contentOffset;
            adsCollectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
            }

        func startTimer() {

            _ = Timer.scheduledTimer(timeInterval: 3.0,
            target: self,
            selector: #selector(scrollToNextCell),
            userInfo: nil,
            repeats: true)
        }
    
    @objc func navigateToWishlist()
    {
        let vc = WishlistVC()
        vc.VM = WishlistVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func navigateToShoppingCart() {
        let shopingCartVC = ShoppingCartVC()
        shopingCartVC.VM = ShoppingCartVM(dataPersistant: VM.dataPersistant)
        self.navigationController?.pushViewController(shopingCartVC, animated: true)
    }
    
}

//MARK: - CollectionView Datasource Methods
extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Set number of items in ads and brands collection views
        if collectionView == brandsCollectionView {
            return VM.filtereBrandsList.value?.count ?? 0
        } else {
            return VM.ads.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == brandsCollectionView {
            
            guard let cell = brandsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.brandCellReuseIdentifier, for: indexPath) as? BrandCell else { return UICollectionViewCell() }
            
            let brand = VM.filtereBrandsList.value?[indexPath.item]
            
            // Set brands using API
            cell.brandNameLabel.text = brand?.title
            cell.brandLogoImgView.sd_setImage(with: URL(string: brand?.image.src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
            
            return cell
            
        } else {
            
            guard let cell = adsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.adCellReuseIdentifier, for: indexPath) as? AdCell else { return UICollectionViewCell() }
            
            // TODO: Set Ads
            cell.adImgView.image = UIImage(named: VM.ads[indexPath.row])
            
            return cell
            
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == brandsCollectionView {
            
            let brand = VM.filtereBrandsList.value?[indexPath.item].title
            
            let destinationVC = ProductsVC()
            destinationVC.VM = ProductsViewModel(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant, brand: brand ?? "")
            navigationController?.pushViewController(destinationVC, animated: true)
            
        } else {
            
            // TODO: For Ads selection
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        if collectionView == adsCollectionView {
        adsPageControler.currentPage = indexPath.row
        }
    }
    
}

//MARK: - CollectionView FlowLayout Methods
extension HomeVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == brandsCollectionView {
            
            return CGSize(width: brandsCollectionView.frame.width/2, height: brandsCollectionView.frame.height/2)
            
        } else {
            
            return CGSize(width: adsCollectionView.frame.width, height: UIScreen.main.bounds.height/4)
            
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
        VM.searchBrands(searchStr: searchBar.text ?? "" )
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.brandsSearchBar.endEditing(true)
    }
}

