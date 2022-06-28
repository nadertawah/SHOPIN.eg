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
        
        let product = VM.wishlistProducts.value?[indexPath.item]
        
        // Configure cell
        cell.priceLabel.text = "\(product?.price ?? "")"
        cell.productNameLabel.text = product?.title
        cell.productImgView.sd_setImage(with: URL(string: product?.image ?? ""), placeholderImage: UIImage(named: "placeHolder"))
        return cell
    }
    
    
}
