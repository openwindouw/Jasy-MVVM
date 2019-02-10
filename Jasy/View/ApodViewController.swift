//
//  ApodViewController.swift
//  Jasy
//
//  Created by Vladimir Espinola on 10/02/2019.
//  Copyright © 2019 Vladimir Espinola. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import Nuke
import RxNuke

class ApodViewController: UIViewController {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var disposeBag = DisposeBag()
    
    var apod: ApodModel!
    
    private lazy var webView: WKWebView! = {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: self.view.frame, configuration: webViewConfiguration)
        webView.backgroundColor = .black
        view.addSubview(webView)
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        binding()
    }
    
    deinit {
        print("deallocated apod viewController")
    }
    
    private func setup() {
        title = apod.title
        
        view.backgroundColor = .black
        
        picture.contentMode = .scaleAspectFit
        picture.backgroundColor = .black
        
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 7.0
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.black
    }
    
    private func binding() {
        let pipeline = ImagePipeline.shared
        
        if let lowUrl = apod.lowURL, let hdurl = apod.highURL {
            Observable.concat(pipeline.rx.loadImage(with: lowUrl).orEmpty,
                              pipeline.rx.loadImage(with: hdurl).orEmpty)
                .subscribe(onNext: { [weak self] in
                    self?.picture.image = $0.image
                })
                .disposed(by: disposeBag)
        } else {
            let myURL = URL(string: apod.url!)
            let videoRequest = URLRequest(url: myURL!)
            webView.load(videoRequest)
        }
    }
}

extension ApodViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return picture
    }
}
