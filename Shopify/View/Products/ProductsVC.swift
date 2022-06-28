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
    
    //MARK: - IBAction(s)
    @IBAction func priceSlider(_ sender: UISlider) {
        
        priceLabel.text = String(format: "%.0f", sender.value)
        
    }
    
    //MARK: - Variable(s)
    var VM: ProductsViewModel!
    
    //MARK: - Helper Function(s)
    func setUI()
    {
        
        // Setting Navigation Bar
        title = "Products"
        setNavBarBtns()
        
        // Registering CollectionView Cell
        productsCollectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: Constants.productCellReuseIdentifier)
        
        // Setting Products CollectionView Delegate and Datasource
        productsCollectionView.delegate = self
        productsCollectionView.dataSource = self

        //search bar delegate
        productsSearch.delegate = self
        
        // Fetching data from API and Updating Collection View
        VM.filteredProductList.bind({ [weak self] _ in
            DispatchQueue.main.async {
                self?.productsCollectionView.reloadData()
            }
        })
        
    }
    
    func setNavBarBtns() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3.decrease")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(filterProducts))
        
    }
    
    @objc func filterProducts() {
        //TODO: filter products by (price, best seller...)
        debugPrint("filterProducts")
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        productsCollectionView.reloadData()
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
        
        // Configure cell
        cell.VM = ProductsCellVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant, product: product ?? Product())
        cell.configureCellVM()
        
        cell.priceLabel.text = "\(product?.variants?[0].price ?? "N/A")$"
        cell.productNameLabel.text = product?.title
        cell.productImgView.sd_setImage(with: URL(string: product?.images?[0].src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
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
        VM.searchProducts(searchStr: searchBar.text ?? "" )
    }
}
