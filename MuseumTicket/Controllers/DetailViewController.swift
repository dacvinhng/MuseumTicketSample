//
//  DetailViewController.swift
//  MuseumTicket
//
//  Created by Vinh Nguyen on 20/10/2021.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var ticketTitleLabel: UILabel!
    @IBOutlet weak var ticketPriceLabel: UILabel!
    @IBOutlet weak var ticketDescriptionLabel: UILabel!
    @IBOutlet weak var orderLabel: UILabel!
    
    var centerView: UIView!
    var upperView: UIView!
    var optionView: UIView!
    var singaporeBtn: UIButton!
    var foreignerBtn: UIButton!
    var countLabel: UILabel!
    var datePicker = UIDatePicker()
    
    var orderCount:Int! = 1
    var ticket:Ticket?
    var groupName:String?
    var groupId:Int?
    var dateSelected:String?
    var nationality:String! = "Singaporean"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ticketTitleLabel.text = ticket?.title
        ticketDescriptionLabel.text = ticket?.description
        let price = ticket?.price
        if (price == 0) {
            ticketPriceLabel.text = "Free"
        }
        else {
            let floatPrice = Float(price!)
            ticketPriceLabel.text = String(format: "%@ %.2f", "$", floatPrice)
        }
        if (Cart.shared.totalItems > 0) {
            orderLabel.isHidden = false
            orderLabel.text = String(Cart.shared.totalItems)
        }
        else {
            orderLabel.isHidden = true
        }
    }

    @IBAction func addToCartSelected(_ sender: Any) {
        showCalendarView()
    }
    
    @IBAction func cartSelected(_ sender: Any) {
        let cartVC = CartViewController()
        cartVC.modalPresentationStyle = .fullScreen
        self.present(cartVC, animated: false, completion: nil)
    }
    
    @IBAction func backButtonSelected(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    func showCalendarView() {
        upperView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        upperView.backgroundColor = .init(red: 219/255, green: 219/255, blue: 219/255, alpha: 0.4)
        UIView.animate(withDuration: 0.2) {
            self.upperView.backgroundColor = .init(red: 219/255, green: 219/255, blue: 219/255, alpha: 0.86)
            self.contentView.addSubview(self.upperView)
        }
                
        centerView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        centerView.backgroundColor = .white
        centerView.layer.masksToBounds = true
        centerView.layer.cornerRadius = 10.0
        centerView.layer.shadowOpacity = 15.0
        self.view.addSubview(centerView)
        centerView.center = self.view.center
        
        let titleCalendar = UILabel(frame: CGRect(x: 0, y: 0, width: centerView.bounds.size.width - 80, height: 30))
        titleCalendar.text = "Select Date of Visit"
        titleCalendar.textColor = .black
        titleCalendar.font = .boldSystemFont(ofSize: 17)
        titleCalendar.sizeToFit()
        centerView.addSubview(titleCalendar)
        titleCalendar.translatesAutoresizingMaskIntoConstraints = false
        titleCalendar.leftAnchor.constraint(equalTo: centerView.leftAnchor, constant: 20).isActive = true
        titleCalendar.topAnchor.constraint(equalTo: centerView.topAnchor, constant: 20).isActive = true
        
        let closeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        closeBtn.contentMode = .scaleAspectFill
        closeBtn.setImage(UIImage(named: "close_icon"), for: .normal)
        closeBtn.imageView?.contentMode = .scaleAspectFit
        closeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 10, right: 10);
        closeBtn.addTarget(self, action: #selector(closeBtnSelected), for: .touchUpInside)
        centerView.addSubview(closeBtn)
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        closeBtn.rightAnchor.constraint(equalTo: centerView.rightAnchor, constant: -5).isActive = true
        closeBtn.topAnchor.constraint(equalTo: centerView.topAnchor, constant: 5).isActive = true
        
        let lineView = UIView(frame: CGRect(x: 10, y: 0, width: self.view.bounds.size.width - 20, height: 1))
        lineView.backgroundColor = .init(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        centerView.addSubview(lineView)
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.leftAnchor.constraint(equalTo: self.centerView.leftAnchor, constant: 20).isActive = true
        lineView.rightAnchor.constraint(equalTo: self.centerView.rightAnchor, constant: -20).isActive = true
        lineView.topAnchor.constraint(equalTo: titleCalendar.bottomAnchor, constant: 10).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(datePickerSelected), for: .touchDown)
        centerView.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leftAnchor.constraint(equalTo: centerView.leftAnchor, constant: 10).isActive = true
        datePicker.rightAnchor.constraint(equalTo: centerView.rightAnchor, constant: -10).isActive = true
        datePicker.topAnchor.constraint(equalTo: centerView.topAnchor, constant: 50).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: centerView.bottomAnchor, constant: 70).isActive = true

        let selectBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        selectBtn.contentMode = .scaleAspectFill
        selectBtn.backgroundColor = .init(red: 231/255, green: 242/255, blue: 254/255, alpha: 1)
        selectBtn.layer.masksToBounds = true
        selectBtn.layer.cornerRadius = 10.0
        selectBtn.setTitle("Select", for: .normal)
        selectBtn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        selectBtn.setTitleColor(.init(red: 18/255, green: 50/255, blue: 98/255, alpha: 1), for: .normal)
        selectBtn.addTarget(self, action: #selector(selectBtnSelected), for: .touchUpInside)
        centerView.addSubview(selectBtn)
        selectBtn.translatesAutoresizingMaskIntoConstraints = false
        selectBtn.leftAnchor.constraint(equalTo: centerView.leftAnchor, constant: 10).isActive = true
        selectBtn.rightAnchor.constraint(equalTo: centerView.rightAnchor, constant: -10).isActive = true
        selectBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        selectBtn.bottomAnchor.constraint(equalTo: centerView.bottomAnchor, constant: -5).isActive = true
    }
    
    @objc func closeBtnSelected() {
        self.centerView.removeFromSuperview()
        self.upperView.removeFromSuperview()
    }
    
    @objc func datePickerSelected(sender: UIDatePicker) {
    }
    
    @objc func selectBtnSelected(sender: UIButton) {
        self.centerView.removeFromSuperview()
        showBuyOption()
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateSelected = dateFormatter.string(from: datePicker.date)
    }
    
    func showBuyOption() {
        optionView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 400))
        optionView.backgroundColor = .white
        self.view.addSubview(optionView)
        optionView.translatesAutoresizingMaskIntoConstraints = false
        optionView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        optionView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        optionView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        optionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
        let previewImgV = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        previewImgV.image = UIImage(named: "preview_image")
        previewImgV.contentMode = .scaleAspectFill
        optionView.addSubview(previewImgV)
        previewImgV.translatesAutoresizingMaskIntoConstraints = false
        previewImgV.leftAnchor.constraint(equalTo: self.optionView.leftAnchor, constant: 20).isActive = true
        previewImgV.topAnchor.constraint(equalTo: self.optionView.topAnchor, constant: 15).isActive = true
        previewImgV.heightAnchor.constraint(equalToConstant: 60).isActive = true
        previewImgV.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        let closeOptionBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        closeOptionBtn.contentMode = .scaleAspectFill
        closeOptionBtn.setImage(UIImage(named: "close_icon"), for: .normal)
        closeOptionBtn.imageView?.contentMode = .scaleAspectFit
        closeOptionBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 20, bottom: 20, right: 15);
        closeOptionBtn.addTarget(self, action: #selector(closeOptionBtnSelected), for: .touchUpInside)
        optionView.addSubview(closeOptionBtn)
        closeOptionBtn.translatesAutoresizingMaskIntoConstraints = false
        closeOptionBtn.rightAnchor.constraint(equalTo: optionView.rightAnchor, constant: -10).isActive = true
        closeOptionBtn.topAnchor.constraint(equalTo: optionView.topAnchor, constant: 5).isActive = true
        
        let titleTicket = UILabel(frame: CGRect(x: 0, y: 0, width: centerView.bounds.size.width - 180, height: 30))
        titleTicket.text = ticket?.title
        titleTicket.textColor = .black
        titleTicket.font = .boldSystemFont(ofSize: 15)
        titleTicket.sizeToFit()
        optionView.addSubview(titleTicket)
        titleTicket.translatesAutoresizingMaskIntoConstraints = false
        titleTicket.leftAnchor.constraint(equalTo: previewImgV.rightAnchor, constant: 15).isActive = true
        titleTicket.topAnchor.constraint(equalTo: optionView.topAnchor, constant: 15).isActive = true
        
        let priceTicket = UILabel(frame: CGRect(x: 0, y: 0, width: centerView.bounds.size.width - 180, height: 30))
        let price = ticket?.price
        if (price == 0) {
            priceTicket.text = "Free"
        }
        else {
            let floatPrice = Float(price!)
            priceTicket.text = String(format: "%@ %.2f", "$", floatPrice)
        }
        priceTicket.textColor = .init(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        priceTicket.font = .systemFont(ofSize: 14)
        priceTicket.sizeToFit()
        optionView.addSubview(priceTicket)
        priceTicket.translatesAutoresizingMaskIntoConstraints = false
        priceTicket.leftAnchor.constraint(equalTo: previewImgV.rightAnchor, constant: 15).isActive = true
        priceTicket.topAnchor.constraint(equalTo: titleTicket.bottomAnchor, constant: 10).isActive = true
        
        let lineV = UIView(frame: CGRect(x: 10, y: 0, width: self.view.bounds.size.width - 20, height: 1))
        lineV.backgroundColor = .init(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        optionView.addSubview(lineV)
        lineV.translatesAutoresizingMaskIntoConstraints = false
        lineV.leftAnchor.constraint(equalTo: self.optionView.leftAnchor, constant: 20).isActive = true
        lineV.rightAnchor.constraint(equalTo: self.optionView.rightAnchor, constant: -20).isActive = true
        lineV.topAnchor.constraint(equalTo: previewImgV.bottomAnchor, constant: 15).isActive = true
        lineV.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let nationalLabel = UILabel(frame: CGRect(x: 0, y: 0, width: centerView.bounds.size.width - 180, height: 30))
        nationalLabel.text = "Nationality"
        nationalLabel.textColor = .black
        nationalLabel.font = .boldSystemFont(ofSize: 13)
        nationalLabel.sizeToFit()
        optionView.addSubview(nationalLabel)
        nationalLabel.translatesAutoresizingMaskIntoConstraints = false
        nationalLabel.leftAnchor.constraint(equalTo: previewImgV.leftAnchor, constant: 0).isActive = true
        nationalLabel.topAnchor.constraint(equalTo: lineV.bottomAnchor, constant: 8).isActive = true
        
        singaporeBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        singaporeBtn.backgroundColor = .init(red: 105/255, green: 105/255, blue: 105/255, alpha: 0.3)
        singaporeBtn.layer.masksToBounds = true
        singaporeBtn.layer.cornerRadius = 10.0
        singaporeBtn.layer.borderColor = .init(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        singaporeBtn.setTitle("Singaporean/PR", for: .normal)
        singaporeBtn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        singaporeBtn.setTitleColor(.init(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        singaporeBtn.tag = 2000
        singaporeBtn.addTarget(self, action: #selector(nationalSelected), for: .touchUpInside)
        singaporeBtn.sizeToFit()
        optionView.addSubview(singaporeBtn)
        singaporeBtn.translatesAutoresizingMaskIntoConstraints = false
        singaporeBtn.leftAnchor.constraint(equalTo: nationalLabel.leftAnchor, constant: 0).isActive = true
        singaporeBtn.topAnchor.constraint(equalTo: nationalLabel.bottomAnchor, constant: 15).isActive = true
        
        foreignerBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        foreignerBtn.backgroundColor = .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        foreignerBtn.layer.masksToBounds = true
        foreignerBtn.layer.cornerRadius = 10.0
        foreignerBtn.layer.borderColor = .init(red: 165/255, green: 165/255, blue: 165/255, alpha: 1)
        foreignerBtn.setTitle("Foreigner", for: .normal)
        foreignerBtn.titleLabel?.font = .boldSystemFont(ofSize: 13)
        foreignerBtn.setTitleColor(.init(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        foreignerBtn.tag = 2001
        foreignerBtn.addTarget(self, action: #selector(nationalSelected), for: .touchUpInside)
        foreignerBtn.sizeToFit()
        optionView.addSubview(foreignerBtn)
        foreignerBtn.translatesAutoresizingMaskIntoConstraints = false
        foreignerBtn.leftAnchor.constraint(equalTo: singaporeBtn.rightAnchor, constant: 15).isActive = true
        foreignerBtn.topAnchor.constraint(equalTo: nationalLabel.bottomAnchor, constant: 15).isActive = true
        
        let lineSecondV = UIView(frame: CGRect(x: 10, y: 0, width: self.view.bounds.size.width - 20, height: 1))
        lineSecondV.backgroundColor = .init(red: 222/255, green: 222/255, blue: 222/255, alpha: 1)
        optionView.addSubview(lineSecondV)
        lineSecondV.translatesAutoresizingMaskIntoConstraints = false
        lineSecondV.leftAnchor.constraint(equalTo: self.optionView.leftAnchor, constant: 20).isActive = true
        lineSecondV.rightAnchor.constraint(equalTo: self.optionView.rightAnchor, constant: -20).isActive = true
        lineSecondV.topAnchor.constraint(equalTo: singaporeBtn.bottomAnchor, constant: 15).isActive = true
        lineSecondV.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let quantityLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        quantityLabel.text = "Quantity"
        quantityLabel.textColor = .black
        quantityLabel.font = .systemFont(ofSize: 13)
        quantityLabel.sizeToFit()
        optionView.addSubview(quantityLabel)
        quantityLabel.translatesAutoresizingMaskIntoConstraints = false
        quantityLabel.leftAnchor.constraint(equalTo: previewImgV.leftAnchor, constant: 0).isActive = true
        quantityLabel.topAnchor.constraint(equalTo: lineSecondV.bottomAnchor, constant: 8).isActive = true
        
        let quantityView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        quantityView.layer.masksToBounds = true
        quantityView.layer.cornerRadius = 10.0
        quantityView.layer.borderWidth = 1.0
        quantityView.layer.borderColor = .init(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)
        optionView.addSubview(quantityView)
        quantityView.translatesAutoresizingMaskIntoConstraints = false
        quantityView.leftAnchor.constraint(equalTo: previewImgV.leftAnchor, constant: 0).isActive = true
        quantityView.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor, constant: 10).isActive = true
        quantityView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        quantityView.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        let quantityStackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 120, height: 50))
        quantityView.addSubview(quantityStackView)
        quantityStackView.translatesAutoresizingMaskIntoConstraints = false
        quantityStackView.leftAnchor.constraint(equalTo: quantityView.leftAnchor, constant: 0).isActive = true
        quantityStackView.rightAnchor.constraint(equalTo: quantityView.rightAnchor, constant: 0).isActive = true
        quantityStackView.topAnchor.constraint(equalTo: quantityView.topAnchor, constant: 0).isActive = true
        quantityStackView.bottomAnchor.constraint(equalTo: quantityView.bottomAnchor, constant: 0).isActive = true
        
        let plusBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        plusBtn.backgroundColor = .init(red: 105/255, green: 105/255, blue: 105/255, alpha: 0.1)
        plusBtn.setTitle("+", for: .normal)
        plusBtn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        plusBtn.setTitleColor(.init(red: 196/255, green: 196/255, blue: 196/255, alpha: 1), for: .normal)
        plusBtn.addTarget(self, action: #selector(plusBtnSelected), for: .touchUpInside)
        quantityStackView.addSubview(plusBtn)
        plusBtn.translatesAutoresizingMaskIntoConstraints = false
        plusBtn.rightAnchor.constraint(equalTo: quantityStackView.rightAnchor, constant: 0).isActive = true
        plusBtn.topAnchor.constraint(equalTo: quantityStackView.topAnchor, constant: 0).isActive = true
        plusBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        plusBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        let minusBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        minusBtn.backgroundColor = .init(red: 196/255, green: 196/255, blue: 196/255, alpha: 0.5)
        minusBtn.setTitle("-", for: .normal)
        minusBtn.titleLabel?.font = .boldSystemFont(ofSize: 20)
        minusBtn.setTitleColor(.init(red: 196/255, green: 196/255, blue: 196/255, alpha: 1), for: .normal)
        minusBtn.addTarget(self, action: #selector(minusBtnSelected), for: .touchUpInside)
        quantityStackView.addSubview(minusBtn)
        minusBtn.translatesAutoresizingMaskIntoConstraints = false
        minusBtn.leftAnchor.constraint(equalTo: quantityStackView.leftAnchor, constant: 0).isActive = true
        minusBtn.topAnchor.constraint(equalTo: quantityStackView.topAnchor, constant: 0).isActive = true
        minusBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        minusBtn.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        countLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        countLabel.text = "1"
        countLabel.textColor = .black
        countLabel.textAlignment = .center
        countLabel.font = .systemFont(ofSize: 20)
        quantityStackView.addSubview(countLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        countLabel.leftAnchor.constraint(equalTo: minusBtn.rightAnchor, constant: 0).isActive = true
        countLabel.topAnchor.constraint(equalTo: quantityStackView.topAnchor, constant: 0).isActive = true
        countLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        countLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
        
        let cartOptionBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        cartOptionBtn.backgroundColor = .init(red: 18/255, green: 50/255, blue: 98/255, alpha: 1)
        cartOptionBtn.layer.masksToBounds = true
        cartOptionBtn.layer.cornerRadius = 5.0
        cartOptionBtn.setTitle("Add to Card", for: .normal)
        cartOptionBtn.titleLabel?.font = .boldSystemFont(ofSize: 16)
        cartOptionBtn.setTitleColor(.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1), for: .normal)
        cartOptionBtn.addTarget(self, action: #selector(cartOptionSelected), for: .touchUpInside)
        optionView.addSubview(cartOptionBtn)
        cartOptionBtn.translatesAutoresizingMaskIntoConstraints = false
        cartOptionBtn.rightAnchor.constraint(equalTo: self.optionView.rightAnchor, constant: -20).isActive = true
        cartOptionBtn.centerYAnchor.constraint(equalTo: quantityView.centerYAnchor, constant: 0).isActive = true
        cartOptionBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cartOptionBtn.widthAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    @objc func nationalSelected(sender: UIButton) {
        let tag = sender.tag
        if (tag == 2000) {
            nationality = "Singaporean"
            singaporeBtn.backgroundColor = .init(red: 105/255, green: 105/255, blue: 105/255, alpha: 0.3)
            foreignerBtn.backgroundColor = .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        }
        else {
            nationality = "Foreigner"
            singaporeBtn.backgroundColor = .init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
            foreignerBtn.backgroundColor = .init(red: 105/255, green: 105/255, blue: 105/255, alpha: 0.3)
        }
    }
    
    @objc func closeOptionBtnSelected() {
        self.upperView.removeFromSuperview()
        self.optionView.removeFromSuperview()
        
       
    }
    
    @objc func cartOptionSelected() {
        self.upperView.removeFromSuperview()
        self.optionView.removeFromSuperview()
        
        let newOrder = Order.init(groupId: groupId!, groupName: groupName!, id: (ticket?.id)!, title: (ticket?.title)!, price: (ticket?.price)!, description: (ticket?.description)!, quantity: orderCount, date: dateSelected!, nationality: nationality!)
        Cart.shared.addItem(newOrder)
        
        if (Cart.shared.totalItems > 0) {
            orderLabel.isHidden = false
            orderLabel.text = String(Cart.shared.totalItems)
        }
    }
    
    @objc func plusBtnSelected() {
        orderCount += 1
        countLabel.text = String(orderCount)
    }
    
    @objc func minusBtnSelected() {
        orderCount -= 1
        countLabel.text = String(orderCount)
    }
}
