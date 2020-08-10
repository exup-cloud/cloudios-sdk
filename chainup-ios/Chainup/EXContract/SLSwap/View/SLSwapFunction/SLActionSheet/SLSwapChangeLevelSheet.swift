//
//  SLSwapChangeLevelSheet.swift
//  Chainup
//
//  Created by KarlLichterVonRandoll on 2020/2/6.
//  Copyright © 2020 zewu wang. All rights reserved.
//

import UIKit

/// 调整杠杆
class SLSwapChangeLevelSheet: UIView {

    /// 调整杠杆回调
    var changeLevelCallback: ((Int) -> ())?
    
    /// 杠杆设置
    let titleLabel: UILabel = {
        let label = UILabel(text: "contract_change_level".localized(), font: UIFont.ThemeFont.HeadBold, textColor: UIColor.ThemeLabel.colorLite, alignment: .left)
        return label
    }()
    /// 取消
    lazy var cancelButton: UIButton = {
        let button = UIButton(buttonType: .custom, title: "common_text_btnCancel".localized(), titleFont: UIFont.ThemeFont.BodyRegular, titleColor: UIColor.ThemeLabel.colorMedium)
        button.extSetAddTarget(self, #selector(clickCancelButton))
        return button
    }()
//    /// 杠杆输入框
//    lazy var levelView: SLSwapChangeLevelInputView = {
//        let view = SLSwapChangeLevelInputView()
//
//        return view
//    }()
    /// 杠杆输入框
    lazy var levelTextField: EXStepField = {
        let text = EXStepField()
        text.extUseAutoLayout()
        text.input.keyboardType = UIKeyboardType.numberPad
        text.textfieldValueChangeBlock = {[weak self](str) in
            var value = BasicParameter.handleDouble(str)
            if value < 1 {
                value = 1
            } else if value > 100 {
                value = 100
            }
            self?.levelTextField.input.text = String(format: "%d", value)
            self?.levelSlider.updateSliderValue(value: Float(value))
        }
        text.minusBtn.removeTarget(self, action: nil, for: .allEvents)
        text.plusBtn.removeTarget(self, action: nil, for: .allEvents)
        text.minusBtn.extSetAddTarget(self, #selector(clickMinusButton))
        text.plusBtn.extSetAddTarget(self, #selector(clickPlusButton))
        return text
    }()
    /// 杠杆调整条
    lazy var levelSlider: SLSwapChangeLevelSlider = {
        let slider = SLSwapChangeLevelSlider()
        
        return slider
    }()
    
    /// 提示
    lazy var tipLabel: UILabel = {
        let label = UILabel(text: "contract_change_level_tip".localized(), font: UIFont.ThemeFont.SecondaryRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .left)
        label.numberOfLines = 2
        return label
    }()
    /// 确认
    lazy var confirmButton: EXButton = {
        let button = EXButton()
        button.setTitle("common_text_btnConfirm".localized(), for: .normal)
        button.addTarget(self, action: #selector(clickConfirmButton), for: .touchUpInside)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.ThemeView.bg
        
        self.addSubViews([titleLabel, cancelButton, levelTextField, levelSlider, tipLabel, confirmButton])
        
        roundCorners(corners: [.topLeft, .topRight], radius: 10)
        
        self.initLayout()
        
        self.levelSlider.valueChangedCallback = {[weak self] value in
            self?.levelTextField.input.text = String(format: "%d", value)
        }
        
        self.levelSlider.updateSliderValue(value: Float(10))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        let horMargin = 15
        self.titleLabel.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.top.equalTo(horMargin)
            make.height.equalTo(28)
        }
        self.cancelButton.snp_makeConstraints { (make) in
            make.right.equalTo(-horMargin)
            make.top.height.equalTo(self.titleLabel)
        }
        self.levelTextField.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.right.equalTo(-horMargin)
            make.top.equalTo(self.titleLabel.snp_bottom).offset(28)
            make.height.equalTo(44)
        }
        self.levelSlider.snp_makeConstraints { (make) in
            make.left.right.equalTo(self.levelTextField)
            make.top.equalTo(self.levelTextField.snp_bottom).offset(24)
            make.height.equalTo(40)
        }
        self.tipLabel.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.top.equalTo(self.levelSlider.snp_bottom).offset(20)
            make.right.equalTo(-horMargin)
        }
        self.confirmButton.snp_makeConstraints { (make) in
            make.left.equalTo(horMargin)
            make.right.equalTo(-horMargin)
            make.height.equalTo(44)
            make.top.equalTo(self.tipLabel.snp_bottom).offset(20)
            make.bottom.equalTo(-30)
        }
    }
}


// MARK: - Click Events

extension SLSwapChangeLevelSheet {
    /// 减少
    @objc func clickMinusButton() {
        var value = BasicParameter.handleDouble(self.levelTextField.input.text ?? "") - 1
        if value < 1 {
            value = 1
        }
        self.levelSlider.updateSliderValue(value: Float(value))
    }
    
    /// 增加
    @objc func clickPlusButton() {
        var value = BasicParameter.handleDouble(self.levelTextField.input.text ?? "") + 1
        if value > 100 {
            value = 100
        }
        self.levelSlider.updateSliderValue(value: Float(value))
    }
    
    /// 点击取消
    @objc func clickCancelButton() {
        EXAlert.dismiss()
    }
    
    /// 点击确认
    @objc func clickConfirmButton() {
        if (self.levelTextField.input.text?.count ?? 0) > 0 {
            if let level = Int(self.levelTextField.input.text!) {
                self.changeLevelCallback?(level)
                EXAlert.dismiss()
            }
        }
    }
}


class SLSwapChangeLevelSlider: UIControl {
    
    var valueChangedCallback: ((Int) -> ())?
    
    /// 滑块大小
    let thumbWH = 20
    
    /// 节点数量
    let numberOfPart = 5
    
    /// 滑块 frame
    var thumbRect: CGRect = CGRect(x: 0, y: 0, width: 20, height: 20)
    
    /// slider frame
    var sliderRect: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    /// 节点 frame 数组
    var partRectArray: [CGRect] = []
    
    var partViewArray: [UIButton] = []
    
    private var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.value = 100
        slider.backgroundColor = UIColor.clear
        slider.isContinuous = true
        slider.setThumbImage(UIImage.themeImageNamed(imageName: "contract_slider_glide"), for: .normal)
        slider.setMinimumTrackImage(UIImage.yy_image(with: UIColor.clear), for: .normal)
        slider.setMaximumTrackImage(UIImage.yy_image(with: UIColor.clear), for: .normal)
        return slider
    }()
    
    /// 滑动条
    private lazy var sliderMaskView: UIStackView = {
        let view = UIStackView()
        let normalView = UIView()
        normalView.backgroundColor = UIColor.ThemeBtn.disable
        let selectView = UIView()
        selectView.backgroundColor = UIColor.ThemeBtn.highlight
        view.addSubViews([normalView, selectView])
        
        normalView.snp_makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(2)
            make.centerY.equalToSuperview()
        }
        selectView.snp_makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.centerY.equalTo(normalView)
            make.width.equalTo(0)
        }
        
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .fill
        return view
    }()
    
    /// 滑块
    private lazy var thumbImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.themeImageNamed(imageName: "contract_slider_glide"))
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: thumbWH, height: thumbWH)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubViews([self.sliderMaskView, self.slider])
        
        let textArr = ["1%", "25%", "50%", "75%", "100%"]
        
        for index in 0..<numberOfPart {
            let button = UIButton(buttonType: .custom, image: UIImage.themeImageNamed(imageName: "contract_slider_default"))
            button.setImage(UIImage.themeImageNamed(imageName: "contract_slider_selection"), for: .selected)
            button.frame = CGRect(x: 0, y: 0, width: 9, height: 14)
            self.sliderMaskView.addArrangedSubview(button)
            
            self.partViewArray.append(button)
            
            let label = UILabel(text: textArr[index], font: UIFont.ThemeFont.MinimumRegular, textColor: UIColor.ThemeLabel.colorMedium, alignment: .center)
            self.sliderMaskView.addSubview(label)
            label.snp_remakeConstraints { (make) in
                make.centerX.equalTo(button)
                make.top.equalTo(button.snp_bottom).offset(0)
            }
        }
        
        self.slider.addTarget(self, action: #selector(sliderValueChanged(slider:)), for: .valueChanged)
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(recognizer:)))
        self.addGestureRecognizer(tap)
        
//        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGesture(recognizer:)))
//        self.addGestureRecognizer(pan)
        
        self.initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func initLayout() {
        self.slider.snp_makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.right.equalTo(0)
            make.height.equalTo(26)
        }
        self.sliderMaskView.snp_makeConstraints { (make) in
            make.top.height.equalTo(self.slider)
            make.left.equalTo(Double(thumbWH/2)-4.5)
            make.right.equalTo(Double(-thumbWH/2)+4.5)
        }
    }
    
    @objc func sliderValueChanged(slider: UISlider) {
        let value = slider.value
        self.updateSliderValue(value: round(value))
    }
    
    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        let point = recognizer.location(in: self.slider)
        let percent = Float(point.x / self.slider.width)
        let value = round((self.slider.maximumValue - self.slider.minimumValue) * percent)
        self.updateSliderValue(value: value)
    }
    
//    @objc func handlePanGesture(recognizer: UIPanGestureRecognizer) {
//        let point = recognizer.location(in: self.slider)
//        let percent = Float(point.x / self.slider.width)
//        let value = round((self.slider.maximumValue - self.slider.minimumValue) * percent)
//        self.updateSliderValue(value: value)
//    }
    
    func updateSliderValue(value: Float) {
        var value = value
        if (value < self.slider.minimumValue) {
            value = self.slider.minimumValue
        }
        if (value > self.slider.maximumValue) {
            value = self.slider.maximumValue
        }
        self.slider.setValue(value, animated: true)
        let normalView = self.sliderMaskView.subviews.first!
        let selectView = self.sliderMaskView.subviews[1]
        let scale = self.slider.value / (self.slider.maximumValue - self.slider.minimumValue)
        selectView.snp_remakeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.centerY.equalTo(normalView)
            make.width.equalToSuperview().multipliedBy(scale)
        }
        
        let maxValue = self.slider.maximumValue - self.slider.minimumValue
        let maxPart = Float(self.numberOfPart - 1)
        var count = 0
        if value >= maxValue {
            count = self.partViewArray.count
        } else if value >= (maxValue * ((maxPart-1)/maxPart)) {
            count = 4
        } else if value >= (maxValue * ((maxPart-2)/maxPart)) {
            count = 3
        } else if value >= (maxValue * ((maxPart-3)/maxPart)) {
            count = 2
        } else {
            count = 1
        }
        for index in 0..<count {
            self.partViewArray[index].isSelected = true
        }
        for index in count..<self.partViewArray.count {
            self.partViewArray[index].isSelected = false
        }
        
        self.valueChangedCallback?(Int(ceil(value)))
    }
}

//class SLSwapChangeLevelInputView: UIView {
//    lazy var textField: UITextField = {
//        let tf = UITextField()
//        tf.keyboardType = .numberPad
//        tf.font = UIFont.ThemeFont.HeadMedium
//        tf.textColor = UIColor.ThemeLabel.colorLite
//        return tf
//    }()
//    lazy var reduceButton: UIButton = {
//        let button = UIButton(buttonType: .custom, image: UIImage.themeImageNamed(imageName: ""))
//        button.imageView?.contentMode = .scaleAspectFit
//        return button
//    }()
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
