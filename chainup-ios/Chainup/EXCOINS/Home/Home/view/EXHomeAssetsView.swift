//
//  EXHomeAssetsView.swift
//  Chainup
//
//  Created by zewu wang on 2019/3/6.
//  Copyright © 2019 zewu wang. All rights reserved.
//  账户页面

import UIKit

class EXHomeAssetsView: UIView {
    
    //1 币币 2 otc 3 合约 4杠杆
    var assetArr : [HomeAssetsEntity] = [HomeAssetsEntity(),HomeAssetsEntity(),HomeAssetsEntity(),HomeAssetsEntity()]
    
    lazy var homeLoginAssetsView : EXHomeLoginAllAssetsView = {
        let view = EXHomeLoginAllAssetsView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var homeUnLoginAssetsView : EXHomeUnLoginAssetsView = {
        let view = EXHomeUnLoginAssetsView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var bottomV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeNav.bg
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.ThemeView.bg
        addSubViews([homeLoginAssetsView,homeUnLoginAssetsView,bottomV])
        homeLoginAssetsView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomV.snp.top)
        }
        homeUnLoginAssetsView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(bottomV.snp.top)
        }
        bottomV.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    func setView(){
        homeUnLoginAssetsView.isHidden = XUserDefault.getToken() != nil
        homeLoginAssetsView.isHidden = XUserDefault.getToken() == nil
        //如果登录
//        if XUserDefault.getToken() != nil{
//            var arr : [HomeAssetsEntity] = []
//            let coinentity = assetArr[0]
//            coinentity.name = LanguageTools.getString(key: "assets_text_exchange")
//            arr.append(coinentity)
//
//        if PublicInfoManager.sharedInstance.getLeverOpen(){
//            let otcentity = assetArr[3]
//            otcentity.name = LanguageTools.getString(key: "leverage_asset")
//            arr.append(otcentity)
//        }
//            if PublicInfoEntity.sharedInstance.haveOTC == "1"{
//                let otcentity = assetArr[1]
//                otcentity.name = LanguageTools.getString(key: "assets_text_otc")
//                arr.append(otcentity)
//            }
//
//            if PublicInfoEntity.sharedInstance.contractOpen == "1"{
//                let otcentity = assetArr[2]
//                otcentity.name = LanguageTools.getString(key: "assets_text_contract")
//                arr.append(otcentity)
//            }
//            homeLoginAssetsView.hiddenBtn.isSelected = XUserDefault.assetPrivacyIsOn()
//            homeLoginAssetsView.collectRowDatas = arr
//        }        
    }
    
    func setAsset(_ index : Int , entity : HomeAssetsEntity){
        if assetArr.count > index{
            assetArr[index] = entity
        }
        setView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

//已登录首页我的总资产
class EXHomeLoginAllAssetsView : UIView {
    
    //我的资产
    lazy var myassetLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.HeadBold
        label.textColor = UIColor.ThemeLabel.colorLite
        label.text = LanguageTools.getString(key: "home_text_assets")
        return label
    }()
    
    //隐藏按钮
    lazy var hiddenBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "hide"), for: UIControlState.selected)
        btn.setImage(UIImage.themeImageNamed(imageName: "visible"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickHiddenBtn(_:)))
        return btn
    }()
    
    lazy var hilineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    lazy var allBlanceLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorHighlight
        label.text = "assets_text_total".localized()
        label.font = UIFont.ThemeFont.SecondaryBold
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var rightImgV :UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "enter")
        return imgV
    }()
    
    lazy var assetsLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        return label
    }()
    
    lazy var equivalentLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.font = UIFont.ThemeFont.SecondaryBold
        return label
    }()
    
    lazy var iconImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: "home_assetentry")
        return imgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([myassetLabel,hiddenBtn,hilineV,allBlanceLabel,rightImgV,assetsLabel,equivalentLabel,iconImgV])
        hilineV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalToSuperview().offset(46)
        }
        myassetLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(22)
            make.right.equalTo(hiddenBtn.snp.left).offset(-10)
        }
        hiddenBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.lessThanOrEqualTo(16)
            make.width.equalTo(16)
            make.centerY.equalTo(myassetLabel)
        }
        allBlanceLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.height.equalTo(17)
            make.top.equalTo(hilineV.snp.bottom).offset(15)
        }
        rightImgV.snp.makeConstraints { (make) in
            make.left.equalTo(allBlanceLabel.snp.right).offset(3)
            make.height.width.equalTo(8.5)
            make.centerY.equalTo(allBlanceLabel)
        }
        assetsLabel.snp.makeConstraints { (make) in
            make.height.equalTo(19)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(iconImgV.snp.left).offset(-10)
            make.top.equalTo(allBlanceLabel.snp.bottom).offset(10)
        }
        equivalentLabel.snp.makeConstraints { (make) in
            make.height.equalTo(14)
            make.left.equalToSuperview().offset(15)
            make.right.equalTo(iconImgV.snp.left).offset(-10)
            make.top.equalTo(assetsLabel.snp.bottom).offset(3)
        }
        iconImgV.snp.makeConstraints { (make) in
            make.height.equalTo(94)
            make.width.equalTo(140)
            make.right.equalToSuperview()
            make.top.equalTo(hilineV.snp.bottom)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickView))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickView(){
        let action = "coin"
        EXNavigationHandler.sharedHandler.commandToAsset(action)
    }
    
    var model = EXHomeAssetModel()
    
    //点击隐藏
    @objc func clickHiddenBtn(_ btn : UIButton){
        btn.isSelected = !btn.isSelected
        XUserDefault.switchAssets(btn.isSelected)
        setView(self.model)
    }
    
    func setView(_ model : EXHomeAssetModel){
        self.model = model
        let bool = XUserDefault.assetPrivacyIsOn()
        hiddenBtn.isSelected = bool
        if bool {
            assetsLabel.text = String.privacyString()
            equivalentLabel.text =  String.privacyString()
        }else{
            assetsLabel.attributedText = model.assetsAtt
            equivalentLabel.text = model.rmb
        }
    }

    
}

//已登录首页我的资产
class EXHomeLoginAssetsView : UIView ,UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectRowDatas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entity = collectRowDatas[indexPath.row]
        let cell : EXHomeLoginAssetsDetailCC = collectionView.dequeueReusableCell(withReuseIdentifier: "EXHomeLoginAssetsDetailCC", for: indexPath) as! EXHomeLoginAssetsDetailCC
        cell.setCell(entity)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if collectRowDatas.count > index{
            let name = collectRowDatas[index].name
            var action = "coin"
            if name == LanguageTools.getString(key: "assets_text_otc"){
                action = "otc"
            }else if name == LanguageTools.getString(key: "assets_text_contract"){
                action = "contract"
            }else if name == "leverage_asset".localized(){
                action = "leverage"
            }
            EXNavigationHandler.sharedHandler.commandToAsset(action)
        }
    }
    
    var collectRowDatas : [HomeAssetsEntity] = []
    {
        didSet{
            setView(collectRowDatas)
        }
    }
    
    //我的资产
    lazy var myassetLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.HeadBold
        label.textColor = UIColor.ThemeLabel.colorLite
        label.text = LanguageTools.getString(key: "home_text_assets")
        return label
    }()
    
    //隐藏按钮
    lazy var hiddenBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "hide"), for: UIControlState.selected)
        btn.setImage(UIImage.themeImageNamed(imageName: "visible"), for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickHiddenBtn(_:)))
        return btn
    }()
    
    lazy var hilineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    lazy var collectionV : UICollectionView = {
        let collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: 46, width: SCREEN_WIDTH, height: 180) , collectionViewLayout: getCollectionLayout())
        collectionV.showsHorizontalScrollIndicator = false
        collectionV.showsVerticalScrollIndicator = false
        collectionV.register(EXHomeLoginAssetsDetailCC.classForCoder(), forCellWithReuseIdentifier: "EXHomeLoginAssetsDetailCC")
        collectionV.delegate = self
        collectionV.dataSource = self
        collectionV.backgroundColor = UIColor.ThemeView.bg
        return collectionV
    }()
    
    func getCollectionLayout() -> UICollectionViewFlowLayout{
        let width = SCREEN_WIDTH / 2
        let collectionLayout = UICollectionViewFlowLayout.init()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.minimumLineSpacing = 0
        collectionLayout.minimumInteritemSpacing = 0
        collectionLayout.itemSize = CGSize.init(width: width, height: 90)
        return collectionLayout
    }
    
    lazy var hlineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    lazy var vLineV : UIView = {
        let view = UIView()
        view.extUseAutoLayout()
        view.backgroundColor = UIColor.ThemeView.seperator
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([myassetLabel,hiddenBtn,collectionV,hilineV,hlineV,vLineV])
        hilineV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalToSuperview().offset(46)
        }
        myassetLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(12)
            make.height.equalTo(22)
            make.right.equalTo(hiddenBtn.snp.left).offset(-10)
        }
        hiddenBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-15)
            make.height.lessThanOrEqualTo(16)
            make.width.equalTo(16)
            make.centerY.equalTo(myassetLabel)
        }
        vLineV.snp.makeConstraints { (make) in
            make.centerX.bottom.equalToSuperview()
            make.top.equalTo(hilineV.snp.bottom)
            make.width.equalTo(0.5)
        }
        hlineV.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.centerY.equalTo(collectionV)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //点击隐藏
    @objc func clickHiddenBtn(_ btn : UIButton){
        btn.isSelected = !btn.isSelected
        XUserDefault.switchAssets(btn.isSelected)
        collectionV.reloadData()
    }
    
    func setView(_ arr : [Any]){
        if arr.count < 3{
            collectionV.frame = CGRect.init(x: 0, y: 46, width: SCREEN_WIDTH, height: 90)
            hlineV.isHidden = true
        }else{
            collectionV.frame = CGRect.init(x: 0, y: 46, width: SCREEN_WIDTH, height: 180)
            hlineV.isHidden = false
        }
        collectionV.reloadData()
    }
}

class EXHomeLoginAssetsDetailCC : UICollectionViewCell{
    
    lazy var nameBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.isUserInteractionEnabled = false
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryBold
        btn.setTitleColor(UIColor.ThemeBtn.highlight, for: UIControlState.normal)
        return btn
    }()
    
    lazy var rightBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.isUserInteractionEnabled = false
        btn.setImage(UIImage.themeImageNamed(imageName: "home_enter"), for: UIControlState.normal)
        return btn
    }()
    
    lazy var moneyLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ThemeLabel.colorLite
        label.extUseAutoLayout()
        label.isUserInteractionEnabled = false
        return label
    }()
    
    lazy var rmbLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.isUserInteractionEnabled = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = UIColor.ThemeView.bg
        contentView.addSubViews([nameBtn,rightBtn,moneyLabel,rmbLabel])
        nameBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(14)
            make.width.lessThanOrEqualTo(SCREEN_WIDTH / 2 - 30)
            make.height.equalTo(17)
        }
        rightBtn.snp.makeConstraints { (make) in
            make.height.width.equalTo(8.5)
            make.centerY.equalTo(nameBtn)
            make.left.equalTo(nameBtn.snp.right).offset(5)
        }
        moneyLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameBtn)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(19)
            make.top.equalTo(nameBtn.snp.bottom).offset(10)
        }
        rmbLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(moneyLabel)
            make.height.equalTo(14)
            make.top.equalTo(moneyLabel.snp.bottom).offset(2)
        }
    }
    
    func setHidden(_ entity : HomeAssetsEntity){
        let bool = XUserDefault.assetPrivacyIsOn()
        if bool {
            moneyLabel.text = String.privacyString()
            rmbLabel.text =  String.privacyString()
        }else{
            moneyLabel.attributedText = entity.assetsAtt
            rmbLabel.text = entity.rmb
        }
    }
    
    func setCell(_ entity : HomeAssetsEntity){
        nameBtn.setTitle(entity.name, for: UIControlState.normal)
        setHidden(entity)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//未登录首页我的资产
class EXHomeUnLoginAssetsView : UIView{
    
    lazy var assetsLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.HeadBold
        label.textColor = UIColor.ThemeLabel.colorLite
        label.text = LanguageTools.getString(key: "home_text_assets")
        return label
    }()
    
    lazy var promptLoginLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.textColor = UIColor.ThemeLabel.colorMedium
        label.text = LanguageTools.getString(key: "home_action_notLogin")
        return label
    }()
    
    lazy var loginBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.extSetCornerRadius(1.5)
        btn.setTitle(LanguageTools.getString(key: "login_action_login"), for: UIControlState.normal)
        btn.extSetBorderWidth(0.5, color: UIColor.ThemeView.border.withAlphaComponent(0.5))
        btn.backgroundColor = UIColor.ThemeTab.bg.withAlphaComponent(0.5)
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryBold
        btn.setTitleColor(UIColor.ThemeBtn.highlight, for: UIControlState.normal)
        btn.extSetAddTarget(self, #selector(clickLoginBtn))
        return btn
    }()
    
    lazy var imgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.themeImageNamed(imageName: EXHomeViewModel.getHomeNoLoginDefaultImage())
        return imgV
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([assetsLabel,promptLoginLabel,loginBtn,imgV])
        assetsLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalToSuperview().offset(15)
            make.height.equalTo(22)
            make.right.equalTo(imgV.snp.left).offset(-10)
        }
        promptLoginLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(assetsLabel.snp.bottom).offset(2)
            make.height.equalTo(17)
            make.right.equalTo(imgV.snp.left).offset(-10)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.top.equalTo(promptLoginLabel.snp.bottom).offset(15)
            make.height.equalTo(30)
            make.width.equalTo(110)
        }
        imgV.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(116)
        }
    }
    
    //点击登录按钮
    @objc func clickLoginBtn(){
        BusinessTools.modalLoginVC()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EXHomeBannerAssetView : UIView{
    
    lazy var noLoginView : EXHomeBannerAssetNoLoginView = {
        let view = EXHomeBannerAssetNoLoginView()
        view.extUseAutoLayout()
        return view
    }()
    
    lazy var loginView : EXHomeBannerAssetLoginView = {
        let view = EXHomeBannerAssetLoginView()
        view.extUseAutoLayout()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([noLoginView,loginView])
        noLoginView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        loginView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    func setView(_ totalAccountBlance : String){
        noLoginView.isHidden = XUserDefault.getToken() != nil
        loginView.isHidden = XUserDefault.getToken() == nil
        loginView.setView(totalAccountBlance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EXHomeBannerAssetNoLoginView : UIView{
    
    lazy var imgBack : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.init(named: "assets_logo")
        return imgV
    }()
    
    lazy var assetLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.text = "home_text_assets".localized()
        label.textColor = UIColor.ThemeLabel.white
        label.font = UIFont.ThemeFont.H3Bold
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var assetDetailLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.text = "home_action_notLogin".localized()
        label.textColor = UIColor.ThemePageControl.bannerSelect
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var loginBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setTitle("login_action_login".localized(), for: UIControlState.normal)
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        btn.titleLabel?.font = UIFont.ThemeFont.SecondaryRegular
        btn.extSetCornerRadius(2)
        btn.extSetBorderWidth(0.5, color: UIColor.white)
        btn.extSetAddTarget(self, #selector(clickLoginBtn))
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([imgBack,assetLabel,assetDetailLabel,loginBtn])
        imgBack.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if isiPhoneX == true{
            assetLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(30)
                make.top.equalToSuperview().offset(85 * HEIGHT_PROPORTION)
                make.height.equalTo(28)
            }
        }else{
            assetLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(30)
                make.top.equalToSuperview().offset(96 * HEIGHT_PROPORTION)
                make.height.equalTo(28)
            }
        }
        assetDetailLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(17)
            make.top.equalTo(assetLabel.snp.bottom).offset(2)
        }
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(assetDetailLabel.snp.bottom).offset(20)
            make.height.equalTo(30)
            make.width.equalTo(110)
            make.left.equalToSuperview().offset(30)
        }
    }
    
    //点击登录按钮
    @objc func clickLoginBtn(){
        BusinessTools.modalLoginVC()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EXHomeBannerAssetLoginView : UIView{
    
    lazy var imgBackV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.init(named: "assets")
        return imgV
    }()
    
    lazy var totalAssetsLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.text = "assets_text_total".localized()
        label.textColor = UIColor.ThemePageControl.bannerSelect
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var totalAssetsImgV : UIImageView = {
        let imgV = UIImageView()
        imgV.extUseAutoLayout()
        imgV.image = UIImage.init(named: "home_enter")
        return imgV
    }()
    
    lazy var totalBtcAssetLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemeLabel.white
        label.font = UIFont.ThemeFont.H2Medium
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var reducedLabel : UILabel = {
        let label = UILabel()
        label.extUseAutoLayout()
        label.textColor = UIColor.ThemePageControl.bannerSelect
        label.font = UIFont.ThemeFont.SecondaryRegular
        label.layoutIfNeeded()
        return label
    }()
    
    lazy var hideBtn : UIButton = {
        let btn = UIButton()
        btn.extUseAutoLayout()
        btn.setImage(UIImage.themeImageNamed(imageName: "visible_japan"), for: UIControlState.normal)
        btn.setImage(UIImage.themeImageNamed(imageName: "Invisible_japan"), for: UIControlState.selected)
        btn.extSetAddTarget(self, #selector(clickHideBtn))
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubViews([imgBackV,totalAssetsLabel,totalBtcAssetLabel,totalAssetsImgV,reducedLabel,hideBtn])
        imgBackV.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        if isiPhoneX == true{
            totalAssetsLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(30)
                make.top.equalToSuperview().offset(85 * HEIGHT_PROPORTION)
                make.height.equalTo(17)
            }
        }else{
            totalAssetsLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().offset(30)
                make.top.equalToSuperview().offset(96 * HEIGHT_PROPORTION)
                make.height.equalTo(17)
            }
        }
        totalAssetsImgV.snp.makeConstraints { (make) in
            make.height.width.equalTo(8.5)
            make.centerY.equalTo(totalAssetsLabel)
            make.left.equalTo(totalAssetsLabel.snp.right).offset(5)
        }
        totalBtcAssetLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.top.equalTo(totalAssetsLabel.snp.bottom).offset(15)
            make.height.equalTo(28)
        }
        reducedLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(30)
            make.height.equalTo(14)
            make.top.equalTo(totalBtcAssetLabel.snp.bottom).offset(8)
        }
        hideBtn.snp.makeConstraints { (make) in
            make.height.equalTo(17)
            make.width.equalTo(17)
            make.right.equalToSuperview().offset(-15)
            make.centerY.equalTo(totalAssetsLabel)
        }
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickView))
        self.addGestureRecognizer(tap)
    }
    
    var balance = ""
    
    func setView(_ balance : String){
        if XUserDefault.assetPrivacyIsOn() == false{
            if balance != ""{
                self.balance = balance
            }else{
                self.balance = "0"
            }
            let btc = PublicInfoManager.sharedInstance.getCoinExchangeRate("BTC")
            totalBtcAssetLabel.text = (self.balance.decimalNumberWithDouble() as NSString).decimalString1(btc.2)
            if let str = NSString.init(string: self.balance).multiplying(by: btc.1, decimals: btc.2){
                reducedLabel.text = "≈" + btc.0 + str
            }
            hideBtn.isSelected = false
        }else{
            hideBtn.isSelected = true
            totalBtcAssetLabel.text = "****"
            reducedLabel.text = "****"
        }
    }
    
    @objc func clickHideBtn(){
        hideBtn.isSelected = !hideBtn.isSelected
        XUserDefault.switchAssets(hideBtn.isSelected)
        setView(self.balance)
    }
    
    @objc func clickView(){
        let action = "coin"
        EXNavigationHandler.sharedHandler.commandToAsset(action)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
