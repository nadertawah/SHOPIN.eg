//
//  ShoppingCartVC.swift
//  Shopify
//
//  Created by Mohamed Azooz on 21/06/2022.
//

import UIKit

class ShoppingCartVC: UIViewController {

    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var proccedToChechoutBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        cartTableView.register(UINib(nibName: "ShoppingCartCell", bundle: nil), forCellReuseIdentifier: "cartCell")
        
        proccedToChechoutBtn.setBtn(tilte: "PROCCED TO CHECHOUT")
    }



    @IBAction func proccedToChechoutBtnPressed(_ sender: Any) {
    }
}

extension ShoppingCartVC : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cartTableView.dequeueReusableCell(withIdentifier: "cartCell", for: indexPath) as! ShoppingCartCell
        
        return cell
    }
    
    
}
