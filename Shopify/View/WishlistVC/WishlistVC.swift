//
//  WishlistVC.swift
//  Shopify
//
//  Created by Nader Said on 28/06/2022.
//

import UIKit

class WishlistVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUI()
    }

    //MARK: - IBOutlet(s)
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    
    
    //MARK: - IBAction(s)
    
    
    //MARK: - Var(s)
    var VM : WishlistVM!

    
    //MARK: - Helper Funcs
    func setUI()
    {
        
        // Set title
        title = "Wishlist"
        
        // Registering CollectionView Cell
        wishlistCollectionView.register(UINib(nibName: "ProductCell", bundle: nil), forCellWithReuseIdentifier: Constants.productCellReuseIdentifier)
        
        // Setting Products CollectionView Delegate and Datasource
        wishlistCollectionView.delegate = self
        wishlistCollectionView.dataSource = self

        // Fetching data from API and Updating Collection View
        VM.wishlistProducts.bind({ [weak self] _ in
            DispatchQueue.main.async {
                self?.wishlistCollectionView.reloadData()
            }
        })
        
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        VM.getWishlistProducts()
    }
}

//MARK: - CollectionView Delegate and DataSource Methods
extension WishlistVC: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return VM.wishlistProducts.value?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = wishlistCollectionView.dequeueReusableCell(withReuseIdentifier: Constants.productCellReuseIdentifier, for: indexPath) as? ProductCell else { return UICollectionViewCell() }
        
        let coreDataProduct = VM.wishlistProducts.value?[indexPath.item]
        let image = Image(src: coreDataProduct?.image ?? "")
        let varients = [Variant(price: coreDataProduct?.price ?? "")]
        
        let product = Product(id: coreDataProduct?.id ?? 0  , title: coreDataProduct?.title ?? "", variants: varients,image: image)
        if let price = product.variants?[0].price, let currency = UserDefaults.standard.string(forKey: "Currency") {
            let rate = Constants.rates[currency]
            let actualPrice = ( price as NSString).floatValue * (rate ?? 0.0)
        // Configure cell
        
        cell.VM = ProductCellVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant, product: product)
        cell.configureCellVM()
        
        cell.priceLabel.text = String(format: "%.2f", actualPrice) + " " + currency
        cell.productNameLabel.text = coreDataProduct?.title
        cell.productImgView.sd_setImage(with: URL(string: coreDataProduct?.image ?? ""), placeholderImage: UIImage(named: "placeHolder"))
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let coreDataProduct = VM.wishlistProducts.value?[indexPath.item]

        let vc = ProductDetailsVC()
        vc.VM = ProductDetailsVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant, productID: "\(coreDataProduct?.id ?? 0)")
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WishlistVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let collFrameWidth = wishlistCollectionView.frame.width
        return CGSize(width: collFrameWidth / 2, height: collFrameWidth / 2)
    }
}
