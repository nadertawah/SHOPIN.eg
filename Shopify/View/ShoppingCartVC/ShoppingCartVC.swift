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
    //OutLets
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var proccedToChechoutBtn: UIButton!
    
    var shoppingcartVM : ShoppingCartVM?
    var products = [CoreDataProdutc]()
    
    var sum : Int = 0
    
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sum = 0
        products.removeAll()
        products = ShoppingCartVM.instance.getData()
        for product in products {
            sum += (product.qty ?? 0) * (product.price! as NSString).integerValue
        }
        subTotalLabel.text = "\(sum)"
        cartTableView.reloadData()
    }
    
// MARK: - IBActions
    @IBAction func proccedToChechoutBtnPressed(_ sender: Any)
    {
        if sum == 0 {
        
        let alert = Alerts.instance.showAlert(title: "No Products", message: "Please Add Products To be able to check out")
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
        let checkOutVC = CheckoutVC()
        checkOutVC.checkOutViewModel = CheckOutVM(total: "\(sum)")
        self.navigationController?.pushViewController(checkOutVC, animated: true)
        }
    }
}


// MARK: - ShoppingCartVC DataSource & Delegate Methods
extension ShoppingCartVC : UITableViewDelegate , UITableViewDataSource {
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    //Cell For Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! ShoppingCartCell
        
        cell.titleLabel.text = products[indexPath.row].title
        cell.priceLabel.text = products[indexPath.row].price
        cell.productImageView.sd_setImage(with: URL(string: products[indexPath.row].image ?? ""), placeholderImage: UIImage(named: "placeHolder"))
        cell.qtyLabel.text = "\(products[indexPath.row].qty!)"
        
        cell.minusBtn.tag = indexPath.row
        cell.plusBtn.tag = indexPath.row
        
        cell.plusBtn.addTarget(self, action: #selector(PlusBtnPressed), for: .touchUpInside)
        cell.minusBtn.addTarget(self, action: #selector(MinusBtnPressed), for: .touchUpInside)
        
        return cell
    }
    
    // Function For Adding Qty Btn's
    @objc func PlusBtnPressed(sender : UIButton) {
        let buttonRow = sender.tag
        let qty = products[buttonRow].qty!
        let id = products[buttonRow].id!
        ShoppingCartVM.instance.updateData(qty: qty + 1, id: id)
        products = ShoppingCartVM.instance.getData()
        let intPrice = (products[buttonRow].price! as NSString).integerValue
        sum += intPrice
        subTotalLabel.text = "\(sum)"
        cartTableView.reloadData()
    }
    // Function For Minus Qty Btn's
    @objc func MinusBtnPressed(sender : UIButton) {
        let buttonRow = sender.tag
        var qty = products[buttonRow].qty!
        let id = products[buttonRow].id!
        if qty == 0 {
            return
        }
        qty -= 1
        ShoppingCartVM.instance.updateData(qty: qty, id: id)
        products = ShoppingCartVM.instance.getData()
        let intPrice = (products[buttonRow].price! as NSString).integerValue
        sum -= intPrice
        subTotalLabel.text = "\(sum)"
        
        cartTableView.reloadData()
    }
    
    //Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    // Delete Row Method
        internal func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                print("Delete")
            }
            ShoppingCartVM.instance.deletLeague(index: indexPath.row)
            products.remove(at: indexPath.row)
            self.cartTableView.deleteRows(at: [indexPath], with: .right)
            self.cartTableView.reloadData()
        }
}
