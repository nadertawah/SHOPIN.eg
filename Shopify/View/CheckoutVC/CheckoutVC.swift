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
    
    private let checkOutVM = CheckOutVM()
    var discountList = [PriceRule]()
    
    var subtotal = 100
    var shippingFees = 50
    var discount = 25
    var total = 0
    
    var PaymentMethodArrText = ["Cash On Delivery" , "Credit/Debit Cart"]
    var PaymentMethodArrIcon = ["cash","online"]
    var selectedPaymentOptionIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getDiscountCodes()
        
        // Confirm DataSource & Delegate for TableView
        paymentMethodTabelView.dataSource = self
        paymentMethodTabelView.delegate = self
        
        // Registration of Payment Method Cell
        paymentMethodTabelView.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodCell")
        
        
        subTotalLabel.text = "L.E \(subtotal)"
        shippingFeesLabel.text = "L.E \(shippingFees)"
        discountLabel.text = "L.E \(discount)"
        totalLabel.text = "L.E \((subtotal + shippingFees) - discount )"
        
        // Configration Of Buttons
        placeOrderBtn.shopifyBtn(title: "PLACE ORDER")
        applyCouponBtn.shopifyBtn(title: "APPLY")
        
        // Configration Of TextField
        couponTF.shopifyTF(placeholder: "Apply Coupon")

        
    }
    
    

// MARK: - IBActions
    @IBAction func applyCopounBtnPressed(_ sender: Any) {
        for discountCode in discountList {
            if couponTF.text == discountCode.title {
                print(discountCode.value)
            }
        }
    }
    
    @IBAction func placeOrderBtnPressed(_ sender: Any) {
    }
    
}

// MARK: - CheckoutVC DataSource & Delegate Methods
extension CheckoutVC : UITableViewDelegate , UITableViewDataSource {
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PaymentMethodArrText.count
    }
    // Cell for Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentMethodTabelView.dequeueReusableCell(withIdentifier: "PaymentMethodCell", for: indexPath) as! PaymentMethodCell
        
        cell.paymentLabel.text = PaymentMethodArrText[indexPath.row]
        cell.PaymentImage.image = UIImage(named: PaymentMethodArrIcon[indexPath.row])

        if selectedPaymentOptionIndex == indexPath.row {
            cell.checkPaymentBtn.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .normal)
        }
        else
        {
            cell.checkPaymentBtn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedPaymentOptionIndex = indexPath.row
        
        print(PaymentMethodArrText[selectedPaymentOptionIndex]) 
        
        paymentMethodTabelView.reloadData()
    }
    
}

// MARK: - Load Data Methods
extension CheckoutVC {
    // Get Discount Codes Function
    func getDiscountCodes() {
        checkOutVM.BindingParsingclouser = { [weak self] in
            DispatchQueue.main.async {
                self?.discountList = self?.checkOutVM.discountList ?? []
                print(self?.discountList[0].title)
                print(self?.discountList[0].value)
            }
        }
        checkOutVM.getDiscountCodes()
    }
}
