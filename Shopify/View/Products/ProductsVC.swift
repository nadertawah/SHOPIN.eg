//
//  ProductsVC.swift
//  Shopify
//
//  Created by Moataz Hussein on 22/06/2022.
//

import UIKit
import SDWebImage

class ProductsVC: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        
    }

    //MARK: - IBOutlet(s)
    @IBOutlet weak var productsSearch: UISearchBar!
    
    @IBOutlet weak var priceFilterView: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    
    @IBOutlet weak var priceSlider: UISlider!
    
    //MARK: - IBAction(s)
    @IBAction func priceSlider(_ sender: UISlider)
    {
        let price = String(format: "%.0f", sender.value)
        priceLabel.text = price
        VM.filterProducts(price: priceSlider.value, searchStr: productsSearch.text ?? "")
        
    }
    
    //MARK: - Variable(s)
    var VM: ProductsViewModel!
    
    //MARK: - Helper Function(s)
    func setUI()
    {
        // Setting Navigation Bar
        title = "Products"
        
        // Registering CollectionView Cell
        productsCollectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: Constants.productCellReuseIdentifier)
        
        // Setting Products CollectionView Delegate and Datasource
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self

        //search bar delegate
        productsSearch.delegate = self
        
        // Fetching data from API and Updating Collection View
        VM.filteredProductList.bind({ [weak self] products in
            DispatchQueue.main.async {
                guard let self = self else{return}
                self.productsCollectionView.reloadData()
            }
        })
        
        //bind price slider
        VM.maxPriceWithCurrentCurrency.bind
        {[weak self] maxPrice in
            DispatchQueue.main.async
            {
                guard let maxPrice = maxPrice else {return}
                self?.priceSlider.maximumValue =  maxPrice
                self?.priceSlider.value = maxPrice
                let price = String(format: "%.0f", maxPrice)
                self?.priceLabel.text = price
            }
        }
    }
    override func viewWillAppear(_ animated: Bool)
    {
        productsCollectionView.reloadData()
        VM.getMaxPriceWithCurrentCurrency()
    }
}

//MARK: - CollectionView Delegate and DataSource Methods
extension ProductsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Set number of products
        return VM.filteredProductList.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = productsCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.productCellReuseIdentifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        
        let product = VM.filteredProductList.value?[indexPath.item]
        if let price = product?.variants?[0].price, let currency = UserDefaults.standard.string(forKey: "Currency") {
            let rate = Constants.rates[currency]
            let actualPrice = ( price as NSString).floatValue * (rate ?? 0.0)
        
        // Configure cell
        cell.VM = ProductCellVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant, product: product ?? Product())
        cell.configureCellVM()
        
        cell.priceLabel.text = String(format: "%.2f", actualPrice) + " " + currency
        cell.productNameLabel.text = product?.title
        cell.productImgView.sd_setImage(with: URL(string: product?.images?[0].src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let product = VM.filteredProductList.value?[indexPath.item]
        let vc = ProductDetailsVC()
        vc.VM = ProductDetailsVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant, productID: "\(product?.id ?? 0)")
        
        self.navigationController?.pushViewController(vc, animated: true)

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



//MARK: - search bar callbacks
extension ProductsVC : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        VM.filterProducts(price: priceSlider.value, searchStr: searchBar.text ?? "")
    }
}
