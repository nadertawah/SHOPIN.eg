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
        
        // TODO: Set Navigation to shopping cart
        debugPrint("Shopping Cart Button Pressed!")

    }
    
    @IBAction func wishListBtn(_ sender: UIButton) {
        
        // TODO: Set Navigation to wishlist
        debugPrint("WishList Button Pressed!")

    }
    
    //MARK: - Variable(s)
    let categoryVM = CategoryViewModel(dataProvider: API())

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
        
        // Fetching all products from API and Updating Collection View
        categoryVM.productsVM.getProducts()
        categoryVM.productsVM.productsList.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.productsCollectionView.reloadData()
            }
        }
        
    }
    
    
}

//MARK: - CollectionView Delegate and DataSource Methods
extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // TODO: Set number of items in mainCategories and products collection views
        if collectionView == mainCategoriesCollectionView {
            return categoryVM.mainCategoriesList.count
        } else {
            return categoryVM.productsVM.productsList.value?.products.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mainCategoriesCollectionView {
            
            guard let cell = mainCategoriesCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.mainCategoryCellReuseIdentifier, for: indexPath) as? MainCategoryCell else { return UICollectionViewCell() }
            
            // Set main categories
            cell.mainCategoryLabel.text = categoryVM.mainCategoriesList[indexPath.item]
            
            return cell
            
        } else {
            
            guard let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.productCellReuseIdentifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
            
            let product = categoryVM.productsVM.productsList.value?.products[indexPath.item]
            
            //TODO: Configure product cell
            cell.priceLabel.text = "\(product?.variants?[0].price ?? "0.00")$"
            cell.productImgView.sd_setImage(with: URL(string: product?.images?[0].src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == mainCategoriesCollectionView {
            
            // Deselect all cells
            for cell in collectionView.visibleCells {
                if let cell = cell as? MainCategoryCell {
                    cell.underlineView.backgroundColor = .white
                }
            }
            
            // Configure Selected Cell Design
            if let cell = collectionView.cellForItem(at: indexPath) as? MainCategoryCell {
                cell.underlineView.backgroundColor = .black
            }
        }
    }
    
    
}

//MARK: - CollectionView FlowLayout Methods
extension CategoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mainCategoriesCollectionView {
            
            return CGSize(width: mainCategoriesCollectionView.frame.width/4, height: mainCategoriesCollectionView.frame.height)
            
        } else {
            
            return CGSize(width: productsCollectionView.frame.width/3, height: productsCollectionView.frame.height/5)
            
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
        return categoryVM.subCategoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = subCategoriesTableView.dequeueReusableCell(withIdentifier: Constants.subCategoryCellReuseIdentifier, for: indexPath) as? SubCategoryCell else { return UITableViewCell() }
        
        // TODO: get subCategories from API
        cell.subCategoryLabel.text = categoryVM.subCategoriesList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Deselect all cells
        for cell in tableView.visibleCells {
            if let cell = cell as? SubCategoryCell {
                cell.subCategoryLabel.backgroundColor = .systemGray6
                cell.subCategoryLabel.textColor = .black
            }
        }
        tableView.reloadData()
        
        // Configure Selected Cell Design
        if let cell = tableView.cellForRow(at: indexPath) as? SubCategoryCell {
            cell.subCategoryLabel.backgroundColor = .black
            cell.subCategoryLabel.textColor = .white
        }
        
        //TODO: View Products of this subCategory
        categoryVM.productsVM.getProducts(using: categoryVM.subCategoriesList[indexPath.row])
        categoryVM.productsVM.productsList.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.productsCollectionView.reloadData()
            }
        }
    }
    
}
