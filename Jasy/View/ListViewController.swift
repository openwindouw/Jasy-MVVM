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
    
    private var viewModel: ListViewModel!
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configure()
        bindViewModel()
    }
    
    private func configure() {
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 10, bottom: 10, right: 10)
        // Set the PinterestLayout delegate
        if let layout = collectionView?.collectionViewLayout as? CustomLayout {
            layout.delegate = self
        }
    }
    
    private func bindViewModel() {
        viewModel = ListViewModel(apodService: ApodService())
        
        let output = viewModel.transform()
        
        output.sections
            .asDriverOnErrorJustComplete()
            .drive(collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
    
    lazy private var dataSource = RxCollectionViewSectionedAnimatedDataSource<Section>(configureCell: { [unowned self] dataSource, collectionView, indexPath, item -> UICollectionViewCell in
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.pictureCellID.identifier, for: indexPath) as! PictureCollectionViewCell
        
        return cell
        
    })

}




extension ListViewController : CustomLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        return .leastNormalMagnitude//photos[indexPath.item].image.size.height
    }
    
}
