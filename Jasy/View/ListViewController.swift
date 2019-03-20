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
import FirebaseAnalytics

class ListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    private var dataSource: RxCollectionViewSectionedAnimatedDataSource<Section>!
    private var viewModel: ListViewModel!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var searchBarButtonItem: UIBarButtonItem!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.tintColor = .primary
        return activity
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        return control
    }()
    
    private lazy var values: [ApodModel]! = {
        return dataSource[0].items
    }()
    
    private lazy var calendarButton: UIBarButtonItem = {
        let calendarImage = R.image.calendar()?
            .withRenderingMode(.alwaysTemplate)
            .resize(width: 23, heigth: 23)?
            .tinted(with: .white)
        
        return UIBarButtonItem(image: calendarImage, style: .plain, target: self, action: nil)
    }()
    
    private var sortedValues: [ApodModel]!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController

            if let navigationbar = self.navigationController?.navigationBar {
                navigationbar.barTintColor = UIColor.primary
            }
            
            navigationItem.searchController = searchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            let searchImage = R.image.lupa()?.withRenderingMode(.alwaysTemplate).tinted(with: .white)
            searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchBarButtonAction))
            navigationItem.rightBarButtonItem = searchBarButtonItem
        }
        
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        
        navigationItem.leftBarButtonItem = calendarButton
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityIndicator)
        
        collectionView.refreshControl = refreshControl
    }
    
    private func bindViewModel() {
        
        dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(configureCell: { dataSource, collectionView, indexPath, item -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.pictureCellID, for: indexPath)!
            cell.configure(for: item)
            return cell
        })
        
        viewModel = ListViewModel(apodService: ApodService())
        
        let input = ListViewModel.Input(searchObservable: searchController.searchBar.rx.text.asObservable())
        let output = viewModel.transform(with: input)
        
        output.sections
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(ApodModel.self)
            .asDriver()
            .drive(onNext: { [unowned self] apodModel in
                let apodViewController = R.storyboard.main.apod()!
                apodViewController.apod = apodModel
                self.navigationController?.pushViewController(apodViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        calendarButton.rx.tap.asDriver()
            .throttle(0.3)
            .drive(onNext: { [unowned self] in
                let calendarViewController = R.storyboard.main.calendar()!
                _ = calendarViewController.selectedYearsObservable?.subscribe(onNext: { dates in
                    JFileManager.shared.deleteAll()
                    
                    let userDefaults = UserDefaults.standard
                    
                    userDefaults.set(dates.start.formattedDate, forKey: JUserDefaultsKeys.selectedStartDate)
                    userDefaults.set(dates.end.formattedDate, forKey: JUserDefaultsKeys.selectedEndDate)
                    
                    userDefaults.synchronize()
                    
                    output.startDateSubject.onNext(dates.start.formattedDate)
                    output.endDateSubject.onNext(dates.end.formattedDate)
                })
                
                Analytics.logEvent(AnalyticsKeys.goToDetail, parameters: nil)
                
                self.navigationController?.pushViewController(calendarViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .asDriver()
            .drive(onNext: { [weak self] in
                let currentDate = Date()
                let firstDateOfMonth = currentDate.startOfMonth()!
                
                let userDefaults = UserDefaults.standard
                
                userDefaults.set(firstDateOfMonth.formattedDate, forKey: JUserDefaultsKeys.selectedStartDate)
                userDefaults.set(currentDate.formattedDate, forKey: JUserDefaultsKeys.selectedEndDate)
                
                userDefaults.synchronize()
                
                output.startDateSubject.onNext(firstDateOfMonth.formattedDate)
                output.endDateSubject.onNext(currentDate.formattedDate)
                
                self?.refreshControl.endRefreshing()
            })
            .disposed(by: disposeBag)
        
        output.fetching
            .drive(activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
    
    @objc func searchBarButtonAction(sender: UIBarButtonItem) {
        showSearch()
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        guard searchBarButtonItem != nil else { return }
        hideSearch()
    }
}

extension ListViewController {
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
