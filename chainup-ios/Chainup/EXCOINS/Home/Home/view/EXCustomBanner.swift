//
//  EXCustomBanner.swift
//  Chainup
//
//  Created by liuxuan on 2020/4/3.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit
import FSPagerView

let customCellIdentifier = "customBannerCellIdentifier"

let HEIGHT_SHORT = SCREEN_WIDTH / 375 * 60

class EXCustomBanner: UIView {
    
    lazy var banner : FSPagerView = {
        let view = FSPagerView.init()
        view.register(FSPagerViewCell.self, forCellWithReuseIdentifier: customCellIdentifier)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        banner.delegate = self
        banner.dataSource = self
        banner.isInfinite = true 
        self.addSubview(banner)
        banner.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.banner.reloadData()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EXCustomBanner : FSPagerViewDelegate,FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return EXCustomConfigVm.shared().customAds().count
    }

    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let models = EXCustomConfigVm.shared().customAds()
        let model = models[index]
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, at: index)
        if let imgV = cell.imageView {
            imgV.contentMode = .scaleAspectFit
            imgV.clipsToBounds = true
            imgV.yy_setImage(with: URL.init(string: model.img), placeholder: nil)
        }
        return cell
    }
    
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        let models = EXCustomConfigVm.shared().customAds()
        let model = models[index]
        HomeGOTO().gotoVC(self.yy_viewController, tnativeUrl: "", httpUrl: model.url)
    }
    
    
    
}
