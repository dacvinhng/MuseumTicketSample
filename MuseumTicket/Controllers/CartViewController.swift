//
//  CartViewController.swift
//  MuseumTicket
//
//  Created by Vinh Nguyen on 20/10/2021.
//

import UIKit

class CartViewController: UIViewController {
    
    @IBOutlet weak var orderLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var priceTotalLabel: UILabel!
    
    var alertView: UIView!
    
    var showList = [[Order]]()
    var indexPathCell:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CartTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "CartTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        for everyItem in Cart.shared.items {
            let newId = everyItem.groupId!
            if (showList.count <= 0) {
                var firstArray = [Order]()
                firstArray.append(everyItem)
                showList.append(firstArray)
            }
            else {
                var currentIndex = 0
                for everyArray in showList {
                    if (everyArray[0].groupId == newId) {
                        showList[currentIndex].append(everyItem)
                        continue
                    }
                    if (currentIndex == showList.count - 1) {
                        var nextArray = [Order]()
                        nextArray.append(everyItem)
                        showList.append(nextArray)
                    }
                    currentIndex += 1
                }
            }
            
        }
       
        Cart.shared.orderAll = showList
        orderLabel.text = String(Cart.shared.totalItemsAll)
        let floatTotalPrice = Float(Cart.shared.cartTotalAll)
        priceTotalLabel.text = String(format: "%@ %.2f", "$", floatTotalPrice)
    }


   
    @IBAction func confirmButtonSelected(_ sender: Any) {
        let checkoutVC = CheckOutSuccessViewController()
        checkoutVC.modalPresentationStyle = .fullScreen
        self.present(checkoutVC, animated: false, completion: nil)
    }
    
    func showAlertView() {
        alertView = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 150))
        alertView.backgroundColor = .white
        alertView.layer.masksToBounds = false
        alertView.layer.borderWidth = 3.0
        alertView.layer.borderColor = UIColor.white.cgColor
        alertView.layer.cornerRadius = 5.0
        alertView.layer.shadowColor = UIColor.black.cgColor
        alertView.layer.shadowOpacity = 1.0
        alertView.layer.shadowOffset = CGSize(width: 3, height: 3)
        alertView.layer.shadowRadius = 4.0
        alertView.center = self.view.center
        self.view.addSubview(alertView)
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        titleLabel.text = "Are you sure you want to remove this product"
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        titleLabel.font = .boldSystemFont(ofSize: 15)
        titleLabel.textAlignment = .left
        alertView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 5).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        let cancelBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        cancelBtn.backgroundColor = .init(red: 18/255, green: 50/255, blue: 98/255, alpha: 1)
        cancelBtn.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = 5.0
        cancelBtn.setTitle("Cancel", for: .normal)
        cancelBtn.tag = 2000
        cancelBtn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        cancelBtn.setTitleColor(.init(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        cancelBtn.addTarget(self, action: #selector(alertBtnSelected), for: .touchUpInside)
        alertView.addSubview(cancelBtn)
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        cancelBtn.rightAnchor.constraint(equalTo: alertView.rightAnchor, constant: -10).isActive = true
        cancelBtn.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10).isActive = true
        cancelBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        cancelBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        let removeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        removeBtn.backgroundColor = .init(red: 18/255, green: 50/255, blue: 98/255, alpha: 1)
        removeBtn.layer.masksToBounds = true
        removeBtn.layer.cornerRadius = 5.0
        removeBtn.setTitle("Remove", for: .normal)
        removeBtn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        removeBtn.tag = 2001
        removeBtn.setTitleColor(.init(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        removeBtn.addTarget(self, action: #selector(alertBtnSelected), for: .touchUpInside)
        alertView.addSubview(removeBtn)
        removeBtn.translatesAutoresizingMaskIntoConstraints = false
        removeBtn.leftAnchor.constraint(equalTo: alertView.leftAnchor, constant: 10).isActive = true
        removeBtn.bottomAnchor.constraint(equalTo: alertView.bottomAnchor, constant: -10).isActive = true
        removeBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        removeBtn.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    @objc func alertBtnSelected(sender: UIButton) {
        if (sender.tag == 2001) {
            Cart.shared.orderAll[indexPathCell.section].remove(at: indexPathCell.row)
            tableView.reloadData()
            orderLabel.text = String(Cart.shared.totalItemsAll)
            let floatTotalPrice = Float(Cart.shared.cartTotalAll)
            priceTotalLabel.text = String(format: "%@ %.2f", "$", floatTotalPrice)
        }
        alertView.removeFromSuperview()
    }
    
}

extension CartViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Cart.shared.orderAll.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cart.shared.orderAll[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (Cart.shared.orderAll[section].count > 0) {
            return 40
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (Cart.shared.orderAll[section].count > 0) {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40))
            
            let titleSection = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            titleSection.text = Cart.shared.orderAll[section][0].groupName
            titleSection.numberOfLines = 0
            titleSection.textColor = .black
            titleSection.font = .boldSystemFont(ofSize: 20)
            titleSection.textAlignment = .left
            titleSection.sizeToFit()
            headerView.addSubview(titleSection)
            titleSection.translatesAutoresizingMaskIntoConstraints = false
            titleSection.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 0).isActive = true
            titleSection.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 6).isActive = true
            
            let lineView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
            lineView.backgroundColor = .init(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
            headerView.addSubview(lineView)
            lineView.translatesAutoresizingMaskIntoConstraints = false
            lineView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -1).isActive = true
            lineView.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 0).isActive = true
            lineView.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: 0).isActive = true
            lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
            
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CartTableViewCell") as? CartTableViewCell {
            cell.delegate = self as CartCellDelegate
            cell.titleLabel.text = Cart.shared.orderAll[indexPath.section][indexPath.row].title
            cell.dateLabel.text = String(format: "%@ %@", "Date of Visit", Cart.shared.orderAll[indexPath.section][indexPath.row].date!)
            cell.countLabel.text = String(Cart.shared.orderAll[indexPath.section][indexPath.row].quantity!)
            let price = Cart.shared.orderAll[indexPath.section][indexPath.row].price!
            if (price == 0) {
                cell.priceLabel.text = "Free"
            }
            else {
                let floatPrice = Float(price)
                cell.priceLabel.text = String(format: "%@ %.2f", "$", floatPrice)
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (Cart.shared.orderAll[section].count > 0) {
            return Cart.shared.orderAll[section][0].groupName
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120;
    }
    

    
}

extension CartViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}

extension CartViewController: CartCellDelegate {
    func updateCartItem(cell: CartTableViewCell, calculate: Int) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let itemCount = Cart.shared.orderAll[indexPath.section][indexPath.row].quantity
        let itemRemain = itemCount! + calculate
        
        if (itemRemain != 0) {
            Cart.shared.orderAll[indexPath.section][indexPath.row].quantity = itemRemain
            cell.countLabel.text = String(itemRemain)
            
            orderLabel.text = String(Cart.shared.totalItemsAll)
            let floatTotalPrice = Float(Cart.shared.cartTotalAll)
            priceTotalLabel.text = String(format: "%@ %.2f", "$", floatTotalPrice)
        }
        else {
            indexPathCell = indexPath
            showAlertView()
        }
    }
}

