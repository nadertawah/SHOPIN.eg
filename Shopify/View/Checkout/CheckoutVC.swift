//
//  CheckoutVC.swift
//  Shopify
//
//  Created by Mohamed Azooz on 22/06/2022.
//

import UIKit

class CheckoutVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let subTotal = Float(checkOutVM?.subTotal ?? "0") ?? 0
        subTotalLabel.text = Helper.adjustAmount(amount: subTotal)
        shippingFeesLabel.text = Helper.adjustAmount(amount: Float(shippingFees))
        discountLabel.text = Helper.adjustAmount(amount: Float(discount))
        let total = subTotal + Float(shippingFees) + Float(discount)
        totalLabel.text = Helper.adjustAmount(amount: total)
    }
    
    
    //MARK: - IBOutlet(s)
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var shippingFeesLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var couponTF: UITextField!
    @IBOutlet weak var applyCouponBtn: UIButton!
    @IBOutlet weak var paymentMethodTabelView: UITableView!
    @IBOutlet weak var placeOrderBtn: UIButton!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addShippingAddress: UIButton!
    
    //MARK: - Variable(s)
    var checkOutVM : CheckOutVM!
    var discountList = [PriceRule]()
    var shippingFees: Float = 0
    var discount: Float = 0
    var counntry = ""
    var PaymentMethodArrText = ["Cash On Delivery" , "Credit/Debit Cart"]
    var PaymentMethodArrIcon = ["cash","online"]
    var selectedPaymentOptionIndex = -1
    
    // MARK: - IBActions
    @IBAction func applyCopounBtnPressed(_ sender: Any) {

        var discountCodeindex = -1
        for i in 0..<discountList.count {
            if couponTF.text == discountList[i].title {
                discountCodeindex = i
                break
            }
        }
        if discountCodeindex != -1 {
            discount = (discountList[discountCodeindex].value! as NSString).floatValue
            let subTotal = Float(checkOutVM?.subTotal ?? "0") ?? 0
            discountLabel.text = Helper.adjustAmount(amount: discount)
            totalLabel.text = Helper.adjustAmount(amount: (subTotal + shippingFees + discount))
        }
        else
        {
            let alert = Alerts.instance.showAlert(title: "Invalid Code", message: "Please Enter Correct Discount Code to Get Your Discount")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func placeOrderBtnPressed(_ sender: Any) {
        
        if selectedPaymentOptionIndex != -1 {
            if selectedPaymentOptionIndex == 1 {
                let alert = Alerts.instance.showAlert(title: "Online Payment", message: "This Service is Not Available right now!")
                self.present(alert, animated: true, completion: nil)
            } else {
                // Place a new order
                checkOutVM.postOrder
                { [weak self] resultMessage in
                    
                    DispatchQueue.main.async
                    {
                        [weak self] in
                        let alert = Alerts.instance.showAlert(title: "", message: resultMessage)
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            let alert = Alerts.instance.showAlert(title: "Payment Failed", message: "Please check yout payment method and try again!")
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addShippingAdress(_ sender: UIButton) {
        let VC = AddAddressVC()
        VC.VM = AddAddressVM(dataProvider: API(), editeAddress: false)
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //MARK: - Helper functions
    func setUI () {
        
        //Load Discount Codes
        getDiscountCodes()
        
        //Title for Screen
        title = "Check Out"
        
        //Hide Btn
        addShippingAddress.isHidden = true
        
        // Confirm DataSource & Delegate for TableView
        paymentMethodTabelView.dataSource = self
        paymentMethodTabelView.delegate = self
        
        // Registration of Payment Method Cell
        paymentMethodTabelView.register(UINib(nibName: "PaymentMethodCell", bundle: nil), forCellReuseIdentifier: "PaymentMethodCell")
        

        // label configrations
        subTotalLabel.text = checkOutVM.subTotal
        discountLabel.text = "0"
        

        // Configration Of Buttons
        placeOrderBtn.shopifyBtn(title: "PLACE ORDER")
        applyCouponBtn.shopifyBtn(title: "APPLY")
        addShippingAddress.shopifyBtn(title: "Add Shipping Address")
        
        // Configration Of TextField
        couponTF.shopifyTF(placeholder: "Apply Coupon")
        
        // Address
        checkOutVM.BindingParsingclosure = { [weak self] in
            DispatchQueue.main.sync {
                if self?.checkOutVM.country.isEmpty ?? false {
                    self?.countryLabel.isHidden = true
                    self?.cityLabel.isHidden = true
                    self?.addressLabel.isHidden = true
                    self?.addShippingAddress.isHidden = false
                } else {
                    self?.countryLabel.text = self?.checkOutVM.country[0]
                    self?.cityLabel.text =  self?.checkOutVM.city[0]
                    self?.addressLabel.text = self?.checkOutVM.addresss[0]
                    self?.counntry = self?.checkOutVM.country[0] ?? ""
                    self?.addShippingAddress.isHidden = true
                }
                let subTotal = Float(self?.checkOutVM?.subTotal ?? "0") ?? 0
                if self?.counntry == "Egypt" {
                    self?.shippingFees = 0
                    self?.shippingFeesLabel.text = Helper.adjustAmount(amount: Float(self?.shippingFees ?? 0))
                    self?.totalLabel.text = Helper.adjustAmount(amount: (subTotal + (self?.shippingFees ?? 0) + (self?.discount ?? 0)))

                } else {
                    self?.shippingFees = 100
                    self?.shippingFeesLabel.text = Helper.adjustAmount(amount: Float(self?.shippingFees ?? 0))
                    self?.totalLabel.text = Helper.adjustAmount(amount: (subTotal + (self?.shippingFees ?? 0) + (self?.discount ?? 0)))

                }
                
            }
            
        }
        
    }
        
    @objc func paymentMethodButtonPressed(sender:UIButton)
    {
        selectedPaymentOptionIndex = sender.tag
        paymentMethodTabelView.reloadData()
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
        cell.checkPaymentBtn.tag = indexPath.row
        cell.checkPaymentBtn.addTarget(self, action: #selector(paymentMethodButtonPressed(sender:)), for: .touchUpInside)
        return cell
        
    }
    //Did Select Cell
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
            }
        }
        checkOutVM.getDiscountCodes()
    }
}
