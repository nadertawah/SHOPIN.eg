//
//  ProductDetailsVC.swift
//  Shopify
//
//  Created by Nader Said on 20/06/2022.
//

import UIKit
import HCSStarRatingView
import SDWebImage

class ProductDetailsVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUI()
    }
    
    //MARK: - IBOutlet(s)
    @IBOutlet weak var productImgCollectionView: UICollectionView!
    
    @IBOutlet weak var imgPageControl: UIPageControl!
    
    @IBOutlet weak var productNameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var sizeSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var rateView: HCSStarRatingView!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var addToShoppingCartBtn: UIButton!
    {
        didSet
        {
            addToShoppingCartBtn.layer.shadowColor = UIColor.black.cgColor
            addToShoppingCartBtn.layer.shadowRadius = 5
            addToShoppingCartBtn.layer.shadowOffset = CGSize(width: 0, height: 3)
            addToShoppingCartBtn.layer.shadowOpacity = 0.6
            addToShoppingCartBtn.layer.cornerRadius = 5
        }
    }
    
    //MARK: - IBAction(s)
    @IBAction func toggleWishListBtn(_ sender: Any)
    {
        
    }
    
    @IBAction func addToShoppingCartBtnPressed(_ sender: Any)
    {
        
    }
    
    //MARK: - Var(s)
    private let productsCellReuseIdentifier = "ImageCollectionViewCell"
    
    //MARK: - Helper Funcs
    func setUI()
    {
        //set review stars value
        setRatingView()
        
        // Register cell
        productImgCollectionView.register(UINib(nibName: productsCellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: productsCellReuseIdentifier)
        
        //set coll view delegates
        productImgCollectionView.dataSource = self
        
        //TODO: - bind to VM
            //TODO: - set page control count, size segment control, rating, wishlist
        
        
    }
    
    func setRatingView()
    {
        rateView.maximumValue = 5
        rateView.minimumValue = 0
        rateView.value = 3.5
        rateView.allowsHalfStars = true
        rateView.tintColor = .black
        rateView.isUserInteractionEnabled = false
    }
}

extension ProductDetailsVC : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = productImgCollectionView.dequeueReusableCell(withReuseIdentifier: productsCellReuseIdentifier, for: indexPath) as? ImageCollectionViewCell
        else {return UICollectionViewCell()}
        
        //TODO: - set image
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        imgPageControl.currentPage = indexPath.row
    }
    
}

extension ProductDetailsVC : UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: productImgCollectionView.frame.width, height: productImgCollectionView.frame.height)
    }
    
}
