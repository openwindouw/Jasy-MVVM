//
//  PictureCollectionViewCell.swift
//  Jasy
//
//  Created by Vladimir Espinola on 2/8/18.
//  Copyright © 2018 Vladimir Espinola. All rights reserved.
//

import UIKit
import RxSwift
import RxNuke
import Nuke

class PictureCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
        picture.contentMode = .scaleAspectFill
        
        picture.layer.masksToBounds = true
    }
    
    func configure(for apod: ApodModel) {
        titleLabel.text = apod.title
        dateLabel.text = apod.prettyDate
        
        if apod.mediaType == "video" {
            picture.image = R.image.video()?.withRenderingMode(.alwaysTemplate).resize(width: 40, heigth: 40)?.tinted(with: .white)
        } else if let image = JFileManager.shared.getImageTo(path: apod.lowImageName) {
            picture.image = image
        } else {
            guard let urlString = apod.url else { return }
            guard let url = URL(string: urlString) else { return }
            
            ImagePipeline.shared.rx.loadImage(with: url)
                .subscribe(onSuccess: { [weak self] in
                    self?.picture.image = $0.image
                    
                    JFileManager.shared.writeImageTo(path: apod.lowImageName, image: $0.image)
                })
                .disposed(by: disposeBag)
        }
        
        picture.contentMode = apod.mediaType == "video" ? .center : .scaleToFill
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        disposeBag = DisposeBag()
        
        picture.image = nil
        titleLabel.isHidden = false
        dateLabel.isHidden = false
    }
}






