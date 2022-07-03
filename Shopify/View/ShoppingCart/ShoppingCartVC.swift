//
//  ShoppingCartVC.swift
//  Shopify
//
//  Created by Mohamed Azooz on 21/06/2022.
//

import UIKit
import SDWebImage

class ShoppingCartVC: UIViewController
{
    //MARK: - IBOutlet(s)
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var proccedToChechoutBtn: UIButton!
    
    
    //MARK: - Var(s)
    var VM : ShoppingCartVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Title for Screen
        title = "Shopping Cart"
        
        //Confirm Delegate and DataSource Protocols
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        //Registration of Cart Cell
        cartTableView.register(UINib(nibName: "ShoppingCartCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        
        //CheckOut Btn Configrations
        proccedToChechoutBtn.shopifyBtn(title: "PROCCED TO CHECKOUT")
        
        //bind to VM
        VM.productList.bind
        { [weak self] _ in
            DispatchQueue.main.async
            {
                self?.cartTableView.reloadData()
            }
        }
        
        //bind sum label
        VM.priceSum.bind
        { [weak self] sum in
            DispatchQueue.main.async
            {
                let currency = UserDefaults.standard.string(forKey: "Currency") ?? ""
                let rate = Constants.rates[currency]
                let actualSum =  (sum ?? 0) * (rate ?? 0)
                self?.subTotalLabel.text = String(format: "%.2f", actualSum) + " " + currency
                self?.cartTableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        VM.getData()
    }
    
// MARK: - IBActions
    @IBAction func proccedToChechoutBtnPressed(_ sender: Any)
    {
        if VM.productList.value?.isEmpty == true
        {
            let alert = Alerts.instance.showAlert(title: "No Products", message: "Please Add Products To be able to check out")
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let checkOutVC = CheckoutVC()
            checkOutVC.checkOutVM = CheckOutVM(dataProvider: API(), total: "\(VM.priceSum.value ?? 0)", products: VM.productList)
            self.navigationController?.pushViewController(checkOutVC, animated: true)
        }
    }
}


// MARK: - ShoppingCartVC DataSource & Delegate Methods
extension ShoppingCartVC : UITableViewDelegate , UITableViewDataSource {
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VM.productList.value?.count ?? 0
    }
    //Cell For Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! ShoppingCartCell
        
        guard let product = VM.productList.value?[indexPath.row]
        else{return UITableViewCell()}
        
        cell.titleLabel.text = product.title
        let currency = UserDefaults.standard.string(forKey: "Currency") ?? ""
        let rate = Constants.rates[currency]
        let actualPrice = ((product.price ?? "") as NSString).floatValue * (rate ?? 0.0)
        cell.priceLabel.text = String(format: "%.2f", actualPrice) + " " + currency
        cell.productImageView.sd_setImage(with: URL(string: product.image ?? ""), placeholderImage: UIImage(named: "placeHolder"))
        cell.qtyLabel.text = "\(product.qty)"
        
        cell.minusBtn.tag = indexPath.row
        cell.plusBtn.tag = indexPath.row
        
        cell.plusBtn.addTarget(self, action: #selector(PlusBtnPressed), for: .touchUpInside)
        cell.minusBtn.addTarget(self, action: #selector(MinusBtnPressed), for: .touchUpInside)
        
        return cell
    }
    
    // Function For Adding Qty Btn's
    @objc func PlusBtnPressed(sender : UIButton)
    {
        VM.updateQty(isIncreasing: true, index: sender.tag)
    }
    // Function For Minus Qty Btn's
    @objc func MinusBtnPressed(sender : UIButton)
    {
        VM.updateQty(isIncreasing: false, index: sender.tag)
    }
    
    //Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // Delete Row Method
        internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete
            {
                VM.deleteProduct(index: indexPath.row)
            }
            
        }
}
