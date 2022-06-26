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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        //Registration of Cart Cell
        cartTableView.register(UINib(nibName: "ShoppingCartCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        
        //CheckOut Btn Configrations
        proccedToChechoutBtn.shopifyBtn(title: "PROCCED TO CHECKOUT")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        products.removeAll()
        products = ShoppingCartVM.instance.getData()
        cartTableView.reloadData()
    }

    @IBAction func proccedToChechoutBtnPressed(_ sender: Any)
    {
        
    }
}


// MARK: - ShoppingCartVC DataSource & Delegate Methods
extension ShoppingCartVC : UITableViewDelegate , UITableViewDataSource {
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count ?? 0
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
        
        subTotalLabel.text = cell.priceLabel.text
        
        return cell
    }
    
    // Function For Adding Minus Qty Btn's
    @objc func PlusBtnPressed(sender : UIButton) {
        let buttonRow = sender.tag
        var qty = products[buttonRow].qty!
        let id = products[buttonRow].id!
        ShoppingCartVM.instance.updateData(qty: qty, id: id)
        products = ShoppingCartVM.instance.getData()
        cartTableView.reloadData()
    }
    
    @objc func MinusBtnPressed(sender : UIButton) {
        let buttonRow = sender.tag
        var qty = products[buttonRow].qty!
        let id = products[buttonRow].id!
        qty -= 2
        ShoppingCartVM.instance.updateData(qty: qty, id: id)
        products = ShoppingCartVM.instance.getData()
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
