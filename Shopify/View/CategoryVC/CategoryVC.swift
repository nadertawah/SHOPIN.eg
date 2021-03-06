//
//  CategoryVC.swift
//  Shopify
//
//  Created by Moataz Hussein on 22/06/2022.
//

import UIKit

class CategoryVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()

    }

    //MARK: - IBOutlet(s)
    @IBOutlet weak var productSearch: UISearchBar!
    
    @IBOutlet weak var mainCategoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var subCategoriesTableView: UITableView!
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    //MARK: - IBAction(s)
    @IBAction func shoppingCartBtn(_ sender: UIButton) {
        
        let shopingCartVC = ShoppingCartVC()
        self.navigationController?.pushViewController(shopingCartVC, animated: true)
    }
    
    @IBAction func wishListBtn(_ sender: UIButton) {
        
        // TODO: Set Navigation to wishlist
        debugPrint("WishList Button Pressed!")

    }
    
    //MARK: - Variable(s)
    

    //MARK: - Helper functions
    func setUI()
    {
        
        // Hide BaseNAvBar
        self.navigationController?.navigationBar.isHidden = true
        
        // Registering Cells
        mainCategoriesCollectionView.register(UINib(nibName: "MainCategoryCell", bundle: nil), forCellWithReuseIdentifier: Constants.mainCategoryCellReuseIdentifier)
        
        subCategoriesTableView.register(UINib(nibName: "SubCategoryCell", bundle: nil), forCellReuseIdentifier: Constants.subCategoryCellReuseIdentifier)
        
        productsCollectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: Constants.productCellReuseIdentifier)
        
        // Setting Delegates and Datasources
        mainCategoriesCollectionView.delegate = self
        mainCategoriesCollectionView.dataSource = self
        
        subCategoriesTableView.delegate = self
        subCategoriesTableView.dataSource = self
        
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self
        
        // Setting CollectionViews' layouts
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        mainCategoriesCollectionView.collectionViewLayout = layout
        productsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()

    }
    
    
    
    
}

//MARK: - CollectionView Delegate and DataSource Methods
extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // TODO: Set number of items in mainCategories and products collection views
        if collectionView == mainCategoriesCollectionView {
            return 4
        } else {
            return 40
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mainCategoriesCollectionView {
            
            guard let cell = mainCategoriesCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.mainCategoryCellReuseIdentifier, for: indexPath) as? MainCategoryCell else { return UICollectionViewCell() }
            
            // TODO: Get main categories from API
            cell.mainCategoryLabel.text = "Category"
            
            return cell
            
        } else {
            
            guard let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.productCellReuseIdentifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
            
            // TODO: Configure product cell
            cell.priceLabel.text = "100.00"
            cell.currencyLabel.text = "USD"
            cell.productImgView.image = UIImage(named: "test")
            
            return cell
            
        }
        
    }
    
    
}

//MARK: - CollectionView FlowLayout Methods
extension CategoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mainCategoriesCollectionView {
            
            return CGSize(width: mainCategoriesCollectionView.frame.width/4, height: mainCategoriesCollectionView.frame.height)
            
        } else {
            
            return CGSize(width: productsCollectionView.frame.width/2, height: productsCollectionView.frame.height/5)
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

//MARK: - TableView Delegate and DataSource Methods
extension CategoryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = subCategoriesTableView.dequeueReusableCell(withIdentifier: Constants.subCategoryCellReuseIdentifier, for: indexPath) as? SubCategoryCell else { return UITableViewCell() }
        
        // TODO: get subCategories from API
        cell.subCategoryLabel.text = "Sub Category"
        
        return cell
    }
    
    
}
