//
//  ViewController.swift
//  MuseumTicket
//
//  Created by Vinh Nguyen on 19/10/2021.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var museumNameLabel: UILabel!
    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var orderLabel: UILabel!
    
    
    var pageViewController = UIPageViewController()
    var selectedTabView = UIView()
    
    //MARK:- View Model
    var pageCollection = PageCollection()
    
    var tabNameList : [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callApi()
        setUpMenuBar()
        setUpPagingViewController()
//        setUpListView()
    }
    override func viewDidAppear(_ animated: Bool) {
        if (Cart.shared.totalItems > 0) {
            orderLabel.isHidden = false
            orderLabel.text = String(Cart.shared.totalItems)
        }
        else {
            orderLabel.isHidden = true
        }
    }
    
    func callApi() {
        guard let url = URL(string: "https://app-stg.vouch.sg/json-mock/ticketing/categories") else { return }
             let task = URLSession.shared.dataTask(with: url) { data, response, error in

                 guard let data = data, error == nil else { return }
                
                 do {
                    self.tabNameList = try JSONDecoder().decode([Category].self, from: data)
                    DispatchQueue.main.async {
                        self.setUpListView()
                        self.tabBarCollectionView.reloadData()
                    }
                 } catch let error as NSError {
                     print("Failed to load: \(error.localizedDescription)")
                 }

             }
             task.resume()
    }
    
    func setUpMenuBar() {
        let layout = tabBarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.estimatedItemSize = CGSize(width: 100, height: 50)
        
        tabBarCollectionView.register(UINib(nibName: "MenuBarCollectionViewCell", bundle: nil),
                                      forCellWithReuseIdentifier: "MenuBarCollectionViewCell")
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.delegate = self
        
        setupSelectedTabView()
    }

    func setupSelectedTabView() {
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        label.text = ""
        label.sizeToFit()
        var width = label.intrinsicContentSize.width
        width = width + 20
        
        selectedTabView.frame = CGRect(x: 20, y: 55, width: width, height: 5)
        selectedTabView.backgroundColor = UIColor(red: 18/255, green: 50/255, blue: 98/255, alpha: 1)
        tabBarCollectionView.addSubview(selectedTabView)
    }
    
    func setUpPagingViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    func setUpListView() {
        for subTabCount in 0..<tabNameList.count {
            let contentVC = ContentViewController()
            contentVC.groupId = tabNameList[subTabCount].id!
            contentVC.groupName = tabNameList[subTabCount].name!
            
            let displayName = tabNameList[subTabCount].name!
            let page = Page(with: displayName, _vc: contentVC)
            pageCollection.pages.append(page)
        }
        
        let initialPage = 0
        pageViewController.setViewControllers([pageCollection.pages[initialPage].vc],
                                                  direction: .forward,
                                                  animated: true,
                                                  completion: nil)
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        contentView.addSubview(pageViewController.view)
        
        //set size and anchor of PageViewController same with contentView
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    @IBAction func cartSelected(_ sender: Any) {
        let cartVC = CartViewController()
        cartVC.modalPresentationStyle = .fullScreen
        self.present(cartVC, animated: false, completion: nil)
    }
    
    func setBottomPagingView(toPageWithAtIndex index: Int, andNavigationDirection navigationDirection: UIPageViewController.NavigationDirection) {
        pageViewController.setViewControllers([pageCollection.pages[index].vc],
                                                  direction: navigationDirection,
                                                  animated: true,
                                                  completion: nil)
    }
    
    func scrollSelectedTabView(toIndexPath indexPath: IndexPath, shouldAnimate: Bool = true) {
        UIView.animate(withDuration: 0.3) {
            if let cell = self.tabBarCollectionView.cellForItem(at: indexPath) {
                self.selectedTabView.frame.size.width = cell.frame.width - 20
                self.selectedTabView.frame.origin.x = cell.frame.origin.x + 10
            }
        }
    }
    
}

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pageCollection.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let menuCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuBarCollectionViewCell", for: indexPath) as? MenuBarCollectionViewCell {
            
            menuCell.tabLabel.text = pageCollection.pages[indexPath.row].name
            return menuCell
        }
        
        return UICollectionViewCell()
    }
    
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == pageCollection.selectedPageIndex {
            return
        }
        
        var direction: UIPageViewController.NavigationDirection
        
        if indexPath.item > pageCollection.selectedPageIndex {
            direction = .forward
        }
        else {
            direction = .reverse
        }
        
        pageCollection.selectedPageIndex = indexPath.item
        tabBarCollectionView.scrollToItem(at: indexPath,
                                          at: .centeredHorizontally,
                                          animated: true)
        
        scrollSelectedTabView(toIndexPath: indexPath)
        setBottomPagingView(toPageWithAtIndex: indexPath.item, andNavigationDirection: direction)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
}

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (1..<pageCollection.pages.count).contains(currentViewControllerIndex) {
                // go to previous page in array
                return pageCollection.pages[currentViewControllerIndex - 1].vc
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            if (0..<(pageCollection.pages.count - 1)).contains(currentViewControllerIndex) {
                // go to next page in array
                return pageCollection.pages[currentViewControllerIndex + 1].vc
            }
        }
        return nil
    }
}

extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed else { return }
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        guard let currentVCIndex = pageCollection.pages.firstIndex(where: { $0.vc == currentVC }) else { return }
        
        let indexPathAtCollectionView = IndexPath(item: currentVCIndex, section: 0)
        scrollSelectedTabView(toIndexPath: indexPathAtCollectionView)
        tabBarCollectionView.scrollToItem(at: indexPathAtCollectionView,
                                          at: .centeredHorizontally,
                                          animated: true)
    }
}
