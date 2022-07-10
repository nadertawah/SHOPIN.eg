//
//  SettingVC.swift
//  Shopify
//
//  Created by Mohamed Azooz on 28/06/2022.
//

import UIKit

class SettingVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        settingTableView.reloadData()
    }
    
    //MARK: - IBOutlet(s)
    @IBOutlet weak var settingTableView: UITableView!
    
    
    //MARK: - Variable(s)
    var setting : [String] = []
    
    
    //MARK: - Helper functions
    func setUI()
    {
        // Confirm DataSource & Delegate for TableView
        settingTableView.dataSource = self
        settingTableView.delegate = self
        
        // Registration of setting Cell
        settingTableView.register(UINib(nibName: "SettingCell", bundle: nil), forCellReuseIdentifier: "SettingCell")
        
        // Setting Parameters
        setting = [ "Address" , "Currency" , "About us" , "Contact us" ]
        
        
    }
    
}



// MARK: - SettingVC DataSource & Delegate Methods
extension SettingVC: UITableViewDelegate , UITableViewDataSource {
    //Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return setting.count
    }
    //Cell for Row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingCell
        if indexPath.row == 1 {
            if let currency = UserDefaults.standard.string(forKey: "Currency") {
                cell.settingLabel.text = "\(setting[indexPath.row]):  \(currency)"
            }
        } else {
            cell.settingLabel.text = setting[indexPath.row]
        }
        
        return cell
    }
    //Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //Did select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        switch indexPath.row {
        case 0:
            if Helper.getCustomerID() != 0
            {
                let vc = AddressVC()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let alert = Alerts.instance.showAlert(title: "", message: "You must login first!")
                self.present(alert, animated: true)
            }
        case 1:
            let vc = CurrenciesTableView()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = AboutUsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = ContactUsVC()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            return
        }
    }
}
