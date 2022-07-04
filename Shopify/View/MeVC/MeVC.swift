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
    
    @IBOutlet weak var loginRegisterLogoutBtn: UIButton! {didSet{loginRegisterLogoutBtn.shopifyBtn(title: "LOGIN/REGISTER")}}
    
    @IBOutlet weak var moreOrdersBtn: UIButton!
    
    @IBOutlet weak var moreWishlistBtn: UIButton!
    
    @IBOutlet weak var ordersTableView: UITableView!
    
    @IBOutlet weak var wishlistTableView: UITableView!
        
    //MARK: - IBAction(s)
    
    @IBAction func moreOrdersBtnPressed(_ sender: Any)
    {
        let vc = OrdersHistoryVC()
        vc.VM = MeViewModel(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant)
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    @IBAction func loginRegisterBtnPressed(_ sender: Any)
    {
        if loginRegisterLogoutBtn.titleLabel?.text == "LOGOUT"
        {
            VM.logout()
        }
        else if loginRegisterLogoutBtn.titleLabel?.text == "LOGIN/REGISTER"
        {
            let vc = LoginRegisterVC()
            vc.VM = LoginRegisterVM(dataProvider: VM.dataProvider, dataPersistant: VM.dataPersistant)
            self.navigationController?.pushViewController(vc, animated: true)
        }
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
        ordersTableView.register(UINib(nibName: "OrderCell", bundle: nil), forCellReuseIdentifier: "orderCell")
        
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
            [weak self] products in
            DispatchQueue.main.async
            {
                if products?.count ?? 0 > 4
                {
                    self?.moreWishlistBtn.isEnabled = true
                }
                else
                {
                    self?.moreWishlistBtn.isEnabled = false
                }
                self?.wishlistTableView.reloadData()
            }
            
        }
        
        //bind orders history
        VM.ordersList.bind
        {
            [weak self] resultOrders in
            DispatchQueue.main.async {
                if (resultOrders?.count ?? 0) > 2
                {
                    self?.moreOrdersBtn.isEnabled = true
                }
                else
                {
                    self?.moreOrdersBtn.isEnabled = false
                }
                self?.ordersTableView.reloadData()
            }
        }
    }
    
   
    func updateUILoginRegisterState(isLoggedIn:Bool)
    {
        if isLoggedIn
        {
            UIView.animate(withDuration: 0.5)
            { [weak self] in
                self?.welcomeLabel.alpha = 1
                self?.loginRegisterLogoutBtn.shopifyBtn(title: "LOGOUT")
            }
        }
        else
        {
            UIView.animate(withDuration: 0.5)
            {
                [weak self] in
                self?.welcomeLabel.alpha = 0
                self?.loginRegisterLogoutBtn.shopifyBtn(title: "LOGIN/REGISTER")
                self?.moreOrdersBtn.isEnabled = false
                self?.moreWishlistBtn.isEnabled = false

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
        shopingCartVC.VM = ShoppingCartVM(dataPersistant: VM.dataPersistant)
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
        VM.getOrdersHistory()
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
                let count = VM.ordersList.value?.count ?? 0
                return count < 2 ? count : 2
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
            guard let cell = ordersTableView.dequeueReusableCell(withIdentifier: "orderCell") as? OrderCell else {return UITableViewCell()}
            
            var order = VM.ordersList.value?[0]

            switch indexPath.row
            {
            case 0:
                order = VM.ordersList.value?[0]
                break
            case 1:
                order = VM.ordersList.value?[1]
                break
            default:
                order = Order()
            }

            cell.orderIDLabel.text = "\(order?.id ?? 0)"
            cell.dateLabel.text = order?.closed_at
            cell.totalAmountLabel.text = order?.current_total_price
            
            return cell
        }
        else if tableView == wishlistTableView
        {
            guard let cell = wishlistTableView.dequeueReusableCell(withIdentifier: labelCellIdentfier) as? LabelTableViewCell else {return UITableViewCell()}
            let product = VM.wishlistProducts.value?[indexPath.row]
            let priceFloat = ((product?.price ?? "") as NSString).floatValue
            cell.label.text = "\(product?.title ?? "")\n" + Helper.adjustAmount(amount: priceFloat)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
            return nil
        }
}
