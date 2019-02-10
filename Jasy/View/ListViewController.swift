//
//  ListViewController.swift
//  Jasy
//
//  Created by Vladimir Espinola on 9/14/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class ListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    private var dataSource: RxCollectionViewSectionedAnimatedDataSource<Section>!
    private var viewModel: ListViewModel!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarButtonItem: UIBarButtonItem!
    
    private var values: [ApodModel]!
    private var sortedValues: [ApodModel]!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configure()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        collectionView.collectionViewLayout.invalidateLayout()
        super.viewDidLayoutSubviews()
    }
    
    private func configure() {
        title = "APOD"
        
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        
        let searchImage = R.image.lupa()?.withRenderingMode(.alwaysTemplate).tinted(with: .white)
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController

            if let textfield = searchController.searchBar.value(forKey: "searchField") as? UITextField {
                if let backgroundview = textfield.subviews.first {
                    backgroundview.layer.cornerRadius = 10
                    backgroundview.clipsToBounds = true
                }
            }

            if let navigationbar = self.navigationController?.navigationBar {
                navigationbar.barTintColor = UIColor.primary
            }
            
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchBarButtonAction))
            navigationItem.rightBarButtonItem = searchBarButtonItem
        }
        
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.pictureCellID.identifier, for: indexPath) as! PictureCollectionViewCell
            cell.configure(for: item)
            return cell
        })
    }
    
    private func bindViewModel() {
        viewModel = ListViewModel(apodService: ApodService())
        
        let output = viewModel.transform()
        
        output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    @objc func searchBarButtonAction(sender: UIBarButtonItem) {
        showSearch()
    }
}

extension ListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard searchController.isActive, let query = self.searchController.searchBar.text?.trimmed, !query.isEmpty else {
            sortedValues = values
            collectionView.reloadData()
            return
        }
        
        sortedValues = filter(list: values ?? dataSource[0].items, with: query)
        collectionView.reloadData()
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard searchBarButtonItem != nil else { return }
        hideSearch()
    }
}

extension ListViewController {
    private func filter(list: [ApodModel], with query: String) -> [ApodModel] {
        let parts = query.components(separatedBy: " ").filter { !$0.isEmpty }
        
        let result = list.filter { currentApod in
            let matches = parts.filter { part in
                let part = part.lowercased()
                let result = currentApod.explanation?.lowercased().contains(part) ?? false
                    || currentApod.title?.contains(part) ?? false
                    || currentApod.date?.contains(part) ?? false
                
                return result
            }
            
            return matches.count == parts.count
        }
        
        return result
    }
    
    private func hideSearch() {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.navigationItem.titleView?.alpha = 0
            }, completion: { [weak self] completed in
                guard let strongSelf = self else { return }
                strongSelf.addTitleView()
                strongSelf.navigationItem.setHidesBackButton(false, animated: true)
                strongSelf.navigationItem.setRightBarButton(strongSelf.searchBarButtonItem, animated: true)
        })
    }
    
    private func showSearch() {
        navigationItem.titleView = self.searchController.searchBar
        searchController.searchBar.alpha = 0
        searchController.searchBar.showsCancelButton = true
        navigationItem.setRightBarButton(nil, animated: true)
        
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.searchController.searchBar.alpha = 1
        })
        searchController.searchBar.becomeFirstResponder()
    }
    
    private func addTitleView(){
        let button = UIButton(type: .custom)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("APOD", for: .normal)
        button.addTarget(self, action: #selector(searchBarButtonAction), for: .touchUpInside)
        navigationItem.titleView = button
    }
}
