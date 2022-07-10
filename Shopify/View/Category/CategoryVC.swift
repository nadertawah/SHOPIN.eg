//
//  CategoryVC.swift
//  Shopify
//
//  Created by Moataz Hussein on 22/06/2022.
//

import UIKit

class CategoryVC: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        
    }
    
    //MARK: - IBOutlet(s)
    @IBOutlet weak var productSearch: UISearchBar!
    
    @IBOutlet weak var mainCategoriesCollectionView: UICollectionView!
    
    @IBOutlet weak var subCategoriesTableView: UITableView!
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    //MARK: - Variable(s)
    var VM : CategoryViewModel!
    
    //MARK: - Helper functions
    func setUI()
    {
        //set title
        title = "Category"
        

        //set navbar wishlist and settings buttons
        setNavBarBtns()

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
        
        productSearch.delegate = self
        
        // Fetching products from API and Updating Collection View
        let mainCategory = VM.mainCategoriesList.value?.custom_collections[VM.productsVM.selectedMainCategory].id
        let subCategory = VM.subCategoriesList[1]
        VM.productsVM.getProducts(with: subCategory, and: mainCategory)
        VM.filteredProducts.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.productsCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        productsCollectionView.reloadData()
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
    
    @objc func navigateToWishlist()
    {
        //Navigation to wishlist
        let vc = WishlistVC()
        vc.VM = WishlistVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func navigateToShoppingCart()
    {
        let shopingCartVC = ShoppingCartVC()
        shopingCartVC.VM = ShoppingCartVM(dataPersistant: VM.dataPersistant)
        self.navigationController?.pushViewController(shopingCartVC, animated: true)
    }
    
}

//MARK: - CollectionView Delegate and DataSource Methods
extension CategoryVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // Set number of items in mainCategories and products collection views
        if collectionView == mainCategoriesCollectionView {
            return VM.mainCategoriesList.value?.custom_collections.count ?? 0
        } else {
            return VM.filteredProducts.value?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == mainCategoriesCollectionView {
            
            guard let cell = mainCategoriesCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.mainCategoryCellReuseIdentifier, for: indexPath) as? MainCategoryCell else { return UICollectionViewCell() }
            
            // Select MEN mainCategory on first navigation to screen
            if indexPath.row == 2 {
                cell.underlineView.backgroundColor = .black
            }
            
            // Set main categories
            cell.mainCategoryLabel.text = VM.mainCategoriesList.value?.custom_collections[indexPath.item].title
            
            return cell
            
        } else {
            
            guard let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.productCellReuseIdentifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
            
            let product = VM.filteredProducts.value?[indexPath.item]
            if let price = product?.variants?[0].price {
                let priceFloat = (price as NSString).floatValue
                
                // Configure product cell
                cell.VM = ProductCellVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant, product: product ?? Product())
                cell.configureCellVM()
                
                cell.priceLabel.text = Helper.adjustAmount(amount: priceFloat)
                cell.productNameLabel.text = product?.title
                cell.productImgView.sd_setImage(with: URL(string: product?.images?[0].src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
            }
            
            return cell
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == mainCategoriesCollectionView {
            
            // Set selected subCategory
            VM.productsVM.selectedMainCategory = indexPath.item
            
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
            
            // View Products of this mainCategory and selected subCategory
            let subCategory = VM.subCategoriesList[VM.productsVM.selectedSubCategory]
            let mainCategoryID = VM.mainCategoriesList.value?.custom_collections[indexPath.item].id
            VM.productsVM.getProducts(with: subCategory, and: mainCategoryID)
            
        }
        else if collectionView == productsCollectionView
        {
            let product = VM.filteredProducts.value?[indexPath.item]
            let vc = ProductDetailsVC()
            vc.VM = ProductDetailsVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant, productID: "\(product?.id ?? 0)")
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: - CollectionView FlowLayout Methods
extension CategoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == mainCategoriesCollectionView
        {
            let title = VM.mainCategoriesList.value?.custom_collections[indexPath.row].title ?? ""
            let titleWidth = title.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)]).width + 25
            return CGSize(width: titleWidth, height: mainCategoriesCollectionView.frame.height)
            
        } else {
            
            return CGSize(width: productsCollectionView.frame.width/2, height: productsCollectionView.frame.height/4)
            
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
        return VM.subCategoriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = subCategoriesTableView.dequeueReusableCell(withIdentifier: Constants.subCategoryCellReuseIdentifier, for: indexPath) as? SubCategoryCell else { return UITableViewCell() }
        
        // Select SHOES subCategory on first navigation to screen
        if indexPath.row == 1 {
            cell.subCategoryLabel.backgroundColor = .black
            cell.subCategoryLabel.textColor = .white
        }
        
        // get subCategories from API
        cell.subCategoryLabel.text = VM.subCategoriesList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Set selected subCategory
        VM.productsVM.selectedSubCategory = indexPath.row
        
        // Deselect all cells
        for cell in tableView.visibleCells {
            if let cell = cell as? SubCategoryCell {
                cell.subCategoryLabel.backgroundColor = .systemGray6
                cell.subCategoryLabel.textColor = .black
            }
        }
        
        // Configure Selected Cell Design
        if let cell = tableView.cellForRow(at: indexPath) as? SubCategoryCell {
            cell.subCategoryLabel.backgroundColor = .black
            cell.subCategoryLabel.textColor = .white
        }
        
        // View Products of this subCategory and selected mainCategory
        let mainCategory = VM.mainCategoriesList.value?.custom_collections[VM.productsVM.selectedMainCategory].id
        VM.productsVM.getProducts(with: VM.subCategoriesList[indexPath.row], and: mainCategory)
        
        
    }
    
}


extension CategoryVC : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        VM.searchProducts(searchStr: searchBar.text ?? "")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.productSearch.endEditing(true)
    }
}
