//
//  ContentViewController.swift
//  MuseumTicket
//
//  Created by Vinh Nguyen on 20/10/2021.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var groupId: Int = 0
    var groupName:String?
    var itemList: [Ticket] = []
    
    override func viewWillAppear(_ animated: Bool) {
        callApi()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ItemTableViewCell", bundle: nil),
                           forCellReuseIdentifier: "ItemTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
   
    //load all tickets on every category
    func callApi() {
        guard let url = URL(string: "https://app-stg.vouch.sg/json-mock/ticketing/categories/\(groupId)") else { return }

             let task = URLSession.shared.dataTask(with: url) { data, response, error in

                 guard let data = data, error == nil else { return }
                
                 do {
                    self.itemList = try JSONDecoder().decode([Ticket].self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                 } catch let error as NSError {
                     print("Failed to load: \(error.localizedDescription)")
                 }

             }
             task.resume()
    }
}
extension ContentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ItemTableViewCell") as? ItemTableViewCell {
            
            cell.titleLabel.text = itemList[indexPath.row].title
            cell.descriptionLabel.text = itemList[indexPath.row].description
            
            let price = itemList[indexPath.row].price!
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120;
    }
    
}

extension ContentViewController:UITableViewDelegate {
    //view detail of ticket when user select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController()
        detailVC.ticket = itemList[indexPath.row]
        detailVC.groupName = groupName
        detailVC.groupId = groupId
        detailVC.modalPresentationStyle = .fullScreen
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        self.present(detailVC, animated: false, completion: nil)

    }
}

