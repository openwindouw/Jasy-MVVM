//
//  PictureCollectionViewCell.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/8/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class PictureCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var disposeBag = DisposeBag()
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
    var itemWidth = CGFloat.leastNormalMagnitude
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        [titleLabel, dateLabel].forEach {
            $0?.lineBreakMode = .byClipping
            $0?.numberOfLines = 0
            $0?.textColor = .white
            $0?.textAlignment = .center
        }
        
        titleLabel.adjustsFontSizeToFitWidth = true
        
//        dateLabel.font = JFont.verySmall
//        titleLabel.font = JFont.smallMedium

        picture.contentMode = .scaleAspectFill
        
        picture.layer.masksToBounds = true
//        picture.layer.cornerRadius = JMetric.cornerRadius
        activityIndicator.type = .lineScalePulseOutRapid
        activityIndicator.padding = 30
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    }
    
    func configure(for apod: ApodModel) {
//        URLSession.shared.rx
//            .response(imageURL)
//            // subscribe on main thread
//            .subscribeOn(MainScheduler.sharedInstance)
//            .subscribe(onNext: { [weak self] data in
//                // Update Image
//                self?.imageView.image = UIImage(data: data)
//                }, onError: {
//                    // Log error
//            }, onCompleted: {
//                // animate image view alpha
//                UIView.animateWithDuration(0.3) {
//                    self.imageView.alpha = 1
//                }
//            }).addDisposableTo(disposeBag)
        
        titleLabel.text = apod.title
        dateLabel.text = apod.date
        
        guard let urlString = apod.url else { return }
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.rx
            .response(request: URLRequest(url: url))
            .asDriverOnErrorJustComplete()
            .drive(onNext: { [weak self] response, data in
//                Utils.performUIUpdatesOnMain {
                    self?.picture.image = UIImage(data: data)
//                }
            }, onCompleted: {
                UIView.animate(withDuration: 0.3) { [weak self] in
//                    Utils.performUIUpdatesOnMain {
                        self?.picture.alpha = 1
//                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        picture.image = nil
        titleLabel.isHidden = false
        dateLabel.isHidden = false
        activityIndicator.isHidden = true
    }
}

extension PictureCollectionViewCell {
    func showActivityIndicator() {
        
//        if !activityIndicator.isAnimating {
//            performUIUpdatesOnMain {
//                self.activityIndicator.startAnimating()
//            }
//        }
        
    }
    
    func hideActivityIndicator() {
//        performUIUpdatesOnMain {
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.isHidden = true
//        }
    }
}






