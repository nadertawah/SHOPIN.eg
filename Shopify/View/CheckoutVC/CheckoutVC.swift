//
//  CheckoutVC.swift
//  Shopify
//
//  Created by Mohamed Azooz on 22/06/2022.
//

import UIKit

class CheckoutVC: UIViewController {
    
    //OutLets
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var shippingFeesLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var couponTF: UITextField!
    @IBOutlet weak var applyCouponBtn: UIButton!
    @IBOutlet weak var paymentMethodTabelView: UITableView!
    @IBOutlet weak var placeOrderBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Confirm DataSource & Delegate for TableView
        paymentMethodTabelView.dataSource = self
        paymentMethodTabelView.delegate = self
        
        // Registration of Payment Method Cell
        paymentMethodTabelView.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodCell")
        
        
        subTotalLabel.text = "L.E 100"
        shippingFeesLabel.text = "L.E 50"
        discountLabel.text = "L.E 25"
        totalLabel.text = "L.E 125"
        
        // Configration Of Buttons
        placeOrderBtn.shopifyBtn(title: "PLACE ORDER")
        applyCouponBtn.shopifyBtn(title: "APPLY")
        
        // Configration Of TextField
        couponTF.shopifyTF(placeholder: "Apply Coupon")

    }

// MARK: - IBActions
    @IBAction func applyCopounBtnPressed(_ sender: Any) {
    }
    
    @IBAction func placeOrderBtnPressed(_ sender: Any) {
    }
    
}

// MARK: - CheckoutVC DataSource & Delegate Methods
extension CheckoutVC : UITableViewDelegate , UITableViewDataSource {
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    // Cell for Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentMethodTabelView.dequeueReusableCell(withIdentifier: "PaymentMethodCell", for: indexPath) as! PaymentMethodCell
        
        // Cash Payment
        if indexPath.row == 0 {
        
            cell.paymentLabel.text = "Cash On Delivery"
            cell.PaymentImage.image = UIImage(named: "cash")
            return cell
        
        }
        // Online Payment
        else
        {
            
            cell.paymentLabel.text = "Credit/Debit Cart"
            cell.PaymentImage.image = UIImage(named: "online")
            cell.checkPaymentBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
            return cell
            
        }
    }
}
