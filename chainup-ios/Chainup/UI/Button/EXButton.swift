//
//  EXButton.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/7.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit

@IBDesignable
class EXButton: UIButton,LoadingAnimation {
    
    var activityIndicator: LoadingView  { get {return self.loading}}
    var loading = LoadingView.init(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
    var storedTitleColor:UIColor?

    //默认高亮按钮,须使用customtype
    public enum EXColors {
        public static var color = UIColor.ThemeLabel.colorHighlight
        public static var highlightedColor =  UIColor.ThemeLabel.colorHighlight.overlayWhite()
        public static var selectedColor =  UIColor.ThemeLabel.colorHighlight
        public static var disabledColor = UIColor.ThemeBtn.disable
        public static var cornerRadius: CGFloat = 1.5
    }
    
    public var color: UIColor = UIColor.ThemeLabel.colorHighlight {
        didSet {
            self.updateBackgroundImages()
            setNeedsDisplay()
        }
    }
    
    public var highlightedColor: UIColor = UIColor.ThemeLabel.colorHighlight.overlayWhite() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var selectedColor: UIColor = UIColor.ThemeLabel.colorHighlight {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var disabledColor: UIColor = UIColor.ThemeBtn.disable {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 1.5 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public func clearColors() {
        self.color = UIColor.clear
        self.highlightedColor = UIColor.clear
        self.disabledColor = UIColor.clear
        self.selectedColor = UIColor.clear
    }
    
    @IBInspectable
    public var ibcolor :String = "" {
        didSet {
            if !ibcolor.isEmpty {
                color = UIColor.themeColor(keyPath: ibcolor)
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable
    public var ibHighlight:String = "" {
        didSet {
            highlightedColor = UIColor.themeColor(keyPath: ibHighlight)
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    public var ibselected :String = "" {
        didSet {
            if !ibselected.isEmpty {
                selectedColor = UIColor.themeColor(keyPath: ibselected)
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable
    public var ibdisable :String = "" {
        didSet {
            if !ibdisable.isEmpty {
                disabledColor = UIColor.themeColor(keyPath: ibdisable)
                setNeedsDisplay()
            }
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        setNeedsDisplay()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
        setNeedsDisplay()
    }
    
    override func setTitleColor(_ color: UIColor?, for state: UIControlState) {
        if self.storedTitleColor == nil {
            self.storedTitleColor = color
        }
        super.setTitleColor(color, for: state)
    }
    
    override open func draw(_ rect: CGRect) {
        updateBackgroundImages()
        super.draw(rect)
    }
    
    fileprivate func configure() {
        setFont()
        adjustsImageWhenDisabled = false
        adjustsImageWhenHighlighted = false
    }
    
    fileprivate func updateBackgroundImages() {
        
        let normalImage = ButtonStyles.buttonImage(color: color, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius)
        let highlightedImage = ButtonStyles.highlightedButtonImage(color: highlightedColor, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius, buttonPressDepth: 0)
        let selectedImage = ButtonStyles.buttonImage(color: selectedColor, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius)
        let disabledImage = ButtonStyles.buttonImage(color: disabledColor, shadowHeight: 0, shadowColor: .clear, cornerRadius: cornerRadius)
        
        setBackgroundImage(normalImage, for: .normal)
        setBackgroundImage(highlightedImage, for: .highlighted)
        setBackgroundImage(selectedImage, for: .selected)
        setBackgroundImage(disabledImage, for: .disabled)
    }
    
    func setFont(_ font : UIFont = UIFont.ThemeFont.HeadBold){
        self.titleLabel?.font = font
    }
    
    func isAnimating() {
        self.setTitleColor(UIColor.clear, for: .normal)
    }
    
    func animationStopped() {
        if let titlec = self.storedTitleColor {
            self.setTitleColor(titlec, for: .normal)
        }
    }
}
