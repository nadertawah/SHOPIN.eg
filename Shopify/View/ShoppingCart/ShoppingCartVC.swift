//
//  ShoppingCartVC.swift
//  Shopify
//
//  Created by Mohamed Azooz on 21/06/2022.
//

import UIKit

class ShoppingCartVC: UIViewController {

    //OutLets
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var proccedToChechoutBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        //Registration of Cart Cell
        cartTableView.register(UINib(nibName: "ShoppingCartCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        
        //CheckOut Btn Configrations
        proccedToChechoutBtn.setBtn(tilte: "PROCCED TO CHECKOUT")
    }



    @IBAction func proccedToChechoutBtnPressed(_ sender: Any) {
        
    }
}


// MARK: - ShoppingCartVC DataSource & Delegate Methods
extension ShoppingCartVC : UITableViewDelegate , UITableViewDataSource {
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    //Cell For Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! ShoppingCartCell
        
        cell.productImageView.image = UIImage(named: "test")
        cell.titleLabel.text = "BLUTECH Canvas Red Waterproof,Laptop College School Bag for Boys with Combo of Watch"
        cell.priceLabel.text = "100 L.E"
        
        return cell
    }
    //Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
