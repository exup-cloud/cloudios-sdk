//
//  EXActionSheetView.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/8.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class EXActionSheetView: NibBaseView {
    
    let ButtonStyleHeight = 60
    let TextFieldStyleHeight = 87
    
    typealias ActionCallback = (Int) -> ()
    typealias formCallback = (Dictionary<String, String>) -> ()
    typealias CancelCallback = () -> ()
    typealias BtnCallback = (String) -> ()

    var actionIdxCallback : ActionCallback?//选择类型,index回调
    var actionFormCallback : formCallback?//输入类型,表单回调
    var actionCancelCallback : CancelCallback?//取消回调
    var itemBtnCallback : BtnCallback?//取消回调
    var selectedIdx:Int?
    
    private var models:[EXInputSheetModel] = []
    private var maxHeight = CONTENTVIEW_HEIGHT
    
    @IBOutlet var actionTitle: UILabel!
    @IBOutlet var cancelBtn: UIButton!
    @IBOutlet var contentStacks: UIStackView!
    @IBOutlet var scrollContainer: UIScrollView!
    @IBOutlet var footerView: UIView!
    @IBOutlet var footerCancelBtn: EXButton!
    @IBOutlet var sheetTitleConstraint: NSLayoutConstraint!
    @IBOutlet var sheetFooterHeight: NSLayoutConstraint!
    @IBOutlet var seperator: UIView!
    
    private var inputSheetMode :Bool = false
    var autoDismiss:Bool = true
    
    func keyboardHeight() -> Observable<CGFloat> {
        return Observable
            .from([
                NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillShow)
                    .map { notification -> CGFloat in
                        (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0
                },
                NotificationCenter.default.rx.notification(NSNotification.Name.UIKeyboardWillHide)
                    .map { _ -> CGFloat in
                        0
                }
                ])
            .merge()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    
    override func onCreate() {
        actionTitle.font = UIFont.ThemeFont.HeadBold
        cancelBtn.setTitleColor(UIColor.ThemeLabel.colorMedium, for: .normal)
        cancelBtn.setEnlargeEdgeWithTop(10, left: 20, bottom: 10, right: 20)
        footerCancelBtn.titleLabel?.font = UIFont.ThemeFont.HeadRegular
        self.inputSheetFooterStyle(inputStyle: false)
    }
    
    func inputSheetFooterStyle(inputStyle:Bool) {
        seperator.isHidden = inputStyle
        if inputStyle {
            sheetFooterHeight.constant = 104
            footerCancelBtn.setTitle("common_text_btnConfirm".localized(), for: .normal)
            footerCancelBtn.color = UIColor.ThemeView.highlight
            footerCancelBtn.setTitleColor(UIColor.white, for: .normal)
        }else {
            sheetFooterHeight.constant = 60
            footerCancelBtn.color = UIColor.clear
            footerCancelBtn.highlightedColor = UIColor.clear
            footerCancelBtn.setTitle("common_text_btnCancel".localized(), for: .normal)
            footerCancelBtn.setTitleColor(UIColor.ThemeLabel.colorLite, for: .normal)
        }
    }
    
    func configTextfields(title: String?, itemModels: Array<EXInputSheetModel>) {
        if itemModels.count < 0 {
            return
        }
        inputSheetMode = true
        self.inputSheetFooterStyle(inputStyle: true)
        if title != nil {
            actionTitle.text = title!
            cancelBtn.setTitle("common_text_btnCancel".localized(), for: .normal)
        }else {
            sheetTitleConstraint.constant = 0
        }
        
        var index = 0
        var contentHeight:CGFloat = 0

        var inputsAry:[Observable<String>] = []
        for item in itemModels {
            let textinput = EXInputFieldsSheet.init()
            textinput.configItemModel(model: item)
            textinput.sheetTapCallback = {[weak self] key in
                self?.itemBtnCallback?(key)
            }
            contentStacks.addArrangedSubview(textinput)

            if item.title.count > 0 {
                contentHeight += 54 + 20
                textinput.snp.makeConstraints { (make) in
                    make.height.equalTo(74)
                }
            }else {
                contentHeight += 32 + 20
                textinput.snp.makeConstraints { (make) in
                    make.height.equalTo(52)
                }
            }

            textinput.tag = index
            index = index + 1
            if let item = textinput.rxField {
                inputsAry.append(item.rx.text.orEmpty.asObservable())
            }
        }
        
        Observable.combineLatest(inputsAry).distinctUntilChanged()
            .map({ strary in
                var count = 0
                for str in strary {
                    if str.count > 0 {
                        count += 1
                    }
                }
                return (count == inputsAry.count)
            })
            .bind(to:footerCancelBtn.rx.isEnabled)
            .disposed(by: self.disposeBag)
    
        let totalHeight = contentHeight + sheetFooterHeight.constant + sheetTitleConstraint.constant + CGFloat(itemModels.count - 1) * 10 + (isiPhoneX ? 34 : 0 )
        
        if totalHeight >= maxHeight {
            self.snp.updateConstraints { (make) in
                make.height.equalTo(maxHeight)
            }
        }else{
            self.snp.updateConstraints { (make) in
                make.height.equalTo(totalHeight)
            }
        }
    }
    
    func configButtonTitles(buttons:Array<String>,selectedIdx:Int = -1) {
        self.configButtonTitles(title: nil, buttons: buttons,selectedIdx:selectedIdx)
    }
    
    func configButtonTitles(title: String?, buttons: Array<String>,selectedIdx:Int = -1) {
        if buttons.count == 0 {
            return
        }
        inputSheetMode = false
        if title != nil {
            actionTitle.text = title!
            cancelBtn.setTitle("common_text_btnCancel".localized(), for: .normal)
        }else {
            sheetTitleConstraint.constant = 0
        }
        
        var index = 0
        for btnTitle in buttons {
            let item = EXActionSheetButtonItem.init()
            item.actionBtn .setTitle(btnTitle, for: .normal)
            contentStacks.addArrangedSubview(item)
            item.actionBtn.tag = index
            item.actionBtn.addTarget(self, action: #selector(onClickAction(sender:)), for: UIControlEvents.touchUpInside)
            if selectedIdx >= 0, selectedIdx < buttons.count, selectedIdx == index{
                item.actionBtn.isSelected = true
            }
            if item.actionBtn.isSelected == true{
                item.actionBtn.titleLabel?.font = UIFont.ThemeFont.HeadMedium
            }else{
                item.actionBtn.titleLabel?.font = UIFont.ThemeFont.HeadRegular
            }
            index = index + 1
        }
        contentStacks.spacing = 0
        
        let contentHeight = CGFloat(buttons.count * ButtonStyleHeight)
        let totalHeight = contentHeight + sheetFooterHeight.constant + sheetTitleConstraint.constant + (isiPhoneX ? 34 : 0 )

        if totalHeight >= maxHeight {
            self.snp.updateConstraints { (make) in
                make.height.equalTo(maxHeight)
            }
        }else{
            self.snp.updateConstraints { (make) in
                make.height.equalTo(totalHeight)
            }
        }
    }
    
    @objc func onClickAction(sender: UIButton) {
        self.dismiss()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.actionIdxCallback?(sender.tag)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss()
        self.actionCancelCallback?()
    }
    
    @IBAction func confirmAction(_ sender: Any) {
        if self.inputSheetMode {
            var allItems = [String:String]()
            for itemView in self.contentStacks.arrangedSubviews {
                if itemView.isKind(of: EXInputFieldsSheet.self) {
                    let field = itemView as! EXInputFieldsSheet
                    if let value = field.modelValue, let key = field.modelKey {
                        allItems .updateValue(value, forKey: key)
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                self.actionFormCallback?(allItems)
            }
        }else {
            self.actionCancelCallback?()
        }
        if autoDismiss {
            self.dismiss()
        }
    }
    
    func dismiss(){
        EXAlert.dismiss()
    }
    
}
