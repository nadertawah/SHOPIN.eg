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
    
    override func viewWillAppear(_ animated: Bool)
    {
        setPrice()
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
            addToShoppingCartBtn.shopifyBtn(title: "ADD TO SHOPPING CART")
        }
    }
    
    @IBOutlet weak var moreReviewsBtn: UIButton!
    {
        didSet
        {
            moreReviewsBtn.shopifyBtn(title: "MORE REVIEWS")
        }
    }
    
    @IBOutlet weak var toggleWishlistBtn: UIButton!
    
    //MARK: - IBAction(s)
    @IBAction func toggleWishListBtnPressed(_ sender: Any)
    {
        if Helper.getCustomerID() == 0
        {
            let alert = Alerts.instance.showAlert(title: "", message: "You must login first!")
            self.present(alert, animated: true)
        }
        else
        {
            VM.toggleWishlist()
        }
    }
    
    @IBAction func addToShoppingCartBtnPressed(_ sender: Any)
    {
        if Helper.getCustomerID() == 0
        {
            let alert = Alerts.instance.showAlert(title: "", message: "You must login first!")
            self.present(alert, animated: true)
        }
        else
        {
            let shopingCartVC = ShoppingCartVC()
            shopingCartVC.VM = ShoppingCartVM(dataPersistant: VM.dataPersistant,product: VM.product.value ?? Product(), sizeOption: sizeSegmentControl.titleForSegment(at: sizeSegmentControl.selectedSegmentIndex) ?? "")
            self.navigationController?.pushViewController(shopingCartVC, animated: true)
        }
    }
    @IBAction func moreReviewsBtnPressed(_ sender: Any)
    {
        let reviewsVC = ReviewsVC.init(nibName: "ReviewsVC", bundle: nil)
        self.navigationController?.pushViewController(reviewsVC, animated: true)
    }
    
    //MARK: - Var(s)
    private let productsCellReuseIdentifier = "ImageCollectionViewCell"
    var VM : ProductDetailsVM!
    
    //MARK: - Helper Funcs
    func setUI()
    {
        //Set title
        title = "Product Details"
        
        //set review stars value
        setRatingView()
        
        // Register cell
        productImgCollectionView.register(UINib(nibName: productsCellReuseIdentifier, bundle: nil), forCellWithReuseIdentifier: productsCellReuseIdentifier)
        
        //set coll view delegates
        productImgCollectionView.dataSource = self
        productImgCollectionView.delegate = self
        
        
        //bind to VM
        VM.product.bind
        {
            [weak self] product in
            guard let self = self , let product = product else {return}
            
            DispatchQueue.main.async
            {
                //set number of pages of the page control
                self.imgPageControl.numberOfPages = product.images?.count ?? 1
                
                //set sizes segment control
                self.setSizesSegmentedControl()
                
                //reload coll view data
                self.productImgCollectionView.reloadData()
                
                //set title
                self.productNameLabel.text = product.title
                
                //set description
                self.descriptionLabel.text = product.body_html
                
                //set price
                self.setPrice()
            
            }
        }
        
        //bind wishlist button image
        VM.isAddedToWishlist.bind
        {
            [weak self] isAddedToWishlist in
            DispatchQueue.main.async
            {
                if isAddedToWishlist == true
                {
                    self?.toggleWishlistBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
                }
                else if isAddedToWishlist == false
                {
                    self?.toggleWishlistBtn.setImage(UIImage(systemName: "heart"), for: .normal)
                }
            }
           
        }
        
    }
    
    func setPrice() {
        let product = self.VM.product.value
        if let price = product?.variants?[0].price, let currency = UserDefaults.standard.string(forKey: "Currency") {
            let rate = Constants.rates[currency]
            let actualPrice = ( price as NSString).floatValue * (rate ?? 0.0)
            priceLabel.text = String(format: "%.2f", actualPrice) + " " + currency
        }
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
    
    func setSizesSegmentedControl()
    {
        let product = self.VM.product.value

        if let productSizeOption = product?.options?.first(where: {Option in Option.name == "Size"})
        {
            if let productSizes = productSizeOption.values
            {
                self.sizeSegmentControl.removeAllSegments()
                self.sizeSegmentControl.isHidden = false

                for i in 0..<productSizes.count
                {
                    self.sizeSegmentControl.insertSegment(withTitle: productSizes[i], at: i, animated: true)
                }
                self.sizeSegmentControl.selectedSegmentIndex = 0
            }
            else
            {
                self.sizeSegmentControl.isHidden = true
            }
        }
    }
}

extension ProductDetailsVC : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return VM.product.value?.images?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = productImgCollectionView.dequeueReusableCell(withReuseIdentifier: productsCellReuseIdentifier, for: indexPath) as? ImageCollectionViewCell
        else {return UICollectionViewCell()}
        
        cell.imgView.sd_setImage(with: URL(string: VM.product.value?.images?[indexPath.row].src ?? ""), placeholderImage: UIImage(named: "placeHolder"))
        
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
        return productImgCollectionView.frame.size
    }
    
}
