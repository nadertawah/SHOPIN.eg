//
//  ProductsVC.swift
//  Shopify
//
//  Created by Moataz Hussein on 22/06/2022.
//

import UIKit

class ProductsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
    }

    //MARK: - IBOutlet(s)
    @IBOutlet weak var productsSearch: UISearchBar!
    
    @IBOutlet weak var priceFilterView: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    //MARK: - IBAction(s)
    @IBAction func priceSlider(_ sender: UISlider) {
        
        priceLabel.text = String(format: "%.0f", sender.value)
        
    }
    
    //MARK: - Variable(s)
    
    
    //MARK: - Helper Function(s)
    func setUI() {
        
        // Setting Navigation Bar
        title = "Products"
        setNavBarBtns()
        
        // Registering CollectionView Cell
        productsCollectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: Constants.productCellReuseIdentifier)
        
        // Setting Products CollectionView Delegate and Datasource
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self

        
        // Setting Products CollectionView layouts
        productsCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        //TODO: Fetching data from API and Updating Collection View
        
    }
    
    func setNavBarBtns() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(filterProducts))
        
    }
    
    @objc func filterProducts() {
        //TODO: filter products by (price, best seller...)
        debugPrint("filterProducts")
    }
    
}

//MARK: - CollectionView Delegate and DataSource Methods
extension ProductsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //TODO: Set number of products
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.productCellReuseIdentifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        
        //TODO: Configure cell
        cell.priceLabel.text = "100.00"
        cell.currencyLabel.text = "USD"
        cell.productImgView.image = UIImage(named: "test")
        
        return cell
    }
}

//MARK: - CollectionView UICollectionViewFlowLayout Methods
extension ProductsVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width/3, height: collectionView.frame.height/5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
