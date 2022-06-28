//
//  MeVC.swift
//  Shopify
//
//  Created by Nader Said on 21/06/2022.
//

import UIKit

class MeVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        setUI()
    }


    //MARK: - IBOutlet(s)
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var loginRegisterBtn: UIButton! {didSet{loginRegisterBtn.shopifyBtn(title: "LOGIN/REGISTER")}}
    
    @IBOutlet weak var moreOrdersBtn: UIButton!
    
    @IBOutlet weak var moreWishlistBtn: UIButton!
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    @IBOutlet weak var wishlistTableView: UITableView!
    
    @IBOutlet weak var logoutBtn: UIButton!{didSet{logoutBtn.shopifyBtn(title: "LOGOUT")}}
    
    
    //MARK: - IBAction(s)
    
    @IBAction func moreOrdersBtnPressed(_ sender: Any)
    {
        
    }
    
    @IBAction func moreWishlistBtnPressed(_ sender: Any)
    {
        let vc = WishlistVC()
        vc.VM = WishlistVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func logoutBtnPressed(_ sender: Any)
    {
        VM.logout()
    }
    
    //MARK: - Var(s)
    var VM : MeViewModel!
    private let labelCellIdentfier = "LabelTableViewCell"
    
    //MARK: - Helper Funcs
    func setUI()
    {
        //set title
        title = "Me"
        
        //set delegates
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        
        wishlistTableView.delegate = self
        wishlistTableView.dataSource = self
        
        //register cell
        ordersTableView.register(UINib(nibName: labelCellIdentfier, bundle: nil), forCellReuseIdentifier: labelCellIdentfier)
        
        wishlistTableView.register(UINib(nibName: labelCellIdentfier, bundle: nil), forCellReuseIdentifier: labelCellIdentfier)
        
        //set navbar wishlist and settings buttons
        setNavBarBtns()
        
        //show/hide login or register and logout buttons
        VM.isLoggedIn.bind
        { [weak self] isLoggedIn in
            DispatchQueue.main.async
            {
                self?.updateUILoginRegisterState(isLoggedIn: isLoggedIn ?? false)
                self?.wishlistTableView.reloadData()
                self?.ordersTableView.reloadData()
            }
        }
        
        // bind customer data
        VM.customer.bind { [weak self] customer in
            DispatchQueue.main.async
            {
                self?.welcomeLabel.text = "Welcome, \(customer?.first_name ?? "")"
            }
        }
        
        //bind wishlist products
        VM.wishlistProducts.bind
        {
            [weak self] in
            if $0?.count ?? 0 > 4
            {
                self?.moreWishlistBtn.isEnabled = true
            }
            else
            {
                self?.moreWishlistBtn.isEnabled = false
            }
            self?.wishlistTableView.reloadData()
        }
        
        //TODO: - get wishlist items (if > 4, enable more btn)
        //TODO: - get order history (if > 2, enable more btn)
    }
    
    @IBAction func loginRegisterBtnPressed(_ sender: Any)
    {
        let vc = LoginRegisterVC()
        vc.VM = LoginRegisterVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func updateUILoginRegisterState(isLoggedIn:Bool)
    {
        if isLoggedIn
        {
            UIView.animate(withDuration: 0.5)
            { [weak self] in
                self?.welcomeLabel.alpha = 1
                self?.logoutBtn.alpha = 1
                self?.loginRegisterBtn.alpha = 0
                
            }
            
        }
        else
        {
            UIView.animate(withDuration: 0.5)
            {
                [weak self] in
                self?.welcomeLabel.alpha = 0
                self?.logoutBtn.alpha = 0
                self?.loginRegisterBtn.alpha = 1
            }
        }
    }
    
    func setNavBarBtns()
    {
        let cartNavBtn = UIBarButtonItem(image: UIImage(systemName: "cart")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(navigateToShoppingCart))
        
        
        let settingsNavBtn = UIBarButtonItem(image: UIImage(systemName: "gearshape")?.withTintColor(.black, renderingMode: .alwaysOriginal), style: .done, target: self, action: #selector(navigateToSettings))
        
        self.navigationController?.navigationBar.topItem?.setRightBarButtonItems([settingsNavBtn,cartNavBtn], animated: true)
    }
    
    @objc func navigateToShoppingCart()
    {
        let shopingCartVC = ShoppingCartVC()
        self.navigationController?.pushViewController(shopingCartVC, animated: true)
    }
    
    @objc func navigateToSettings()
    {
        let settingVc = SettingVC()
        self.navigationController?.pushViewController(settingVc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        VM.getLoginState()
        VM.getWishlistProducts()
    }
}

//MARK: - table view delegates
extension MeVC : UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if VM.isLoggedIn.value == true
        {
            if tableView == ordersTableView
            {
                return 2
            }
            else if tableView == wishlistTableView
            {
                let count = VM.wishlistProducts.value?.count ?? 0
                return count < 4 ? count : 4
            }
                
        }
        else {return 0}
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if tableView == ordersTableView
        {
            guard let cell = ordersTableView.dequeueReusableCell(withIdentifier: labelCellIdentfier) as? LabelTableViewCell else {return UITableViewCell()}
            
            switch indexPath.row
            {
                case 0 :
                    cell.label.text = "Price: 555\nCreated At: \(Date())"
                    break
                
                    
                case 1 :
                    cell.label.text = "Price: 444\nCreated At: \(Date())"
                    break
                
                default:
                    break
            }
            return cell
        }
        else if tableView == wishlistTableView
        {
            guard let cell = wishlistTableView.dequeueReusableCell(withIdentifier: labelCellIdentfier) as? LabelTableViewCell else {return UITableViewCell()}
            let product = VM.wishlistProducts.value?[indexPath.row]
            cell.label.text = "\(product?.title ?? "")\n\(product?.price ?? "")"
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
