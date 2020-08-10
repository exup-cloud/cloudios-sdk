//
//  EXMarketDetailSectionHeader.swift
//  Chainup
//
//  Created by liuxuan on 2019/3/20.
//  Copyright © 2019 zewu wang. All rights reserved.
//

import UIKit


enum TransactionDetailsType {
    case depth//深度
    case deal//成交
    case introduce //简介
}


class EXMarketDetailSectionHeader: NibBaseView {
//    @IBOutlet var klineDepthView: EXKlineDepthView!
    typealias SectionHeaderBlock = (TransactionDetailsType)->()
    var headerActionCallback :SectionHeaderBlock?
//    @IBOutlet var stacks: UIStackView!
    @IBOutlet var depthLabel: DepthMenuLabel!
    @IBOutlet var orderLabel: DepthMenuLabel!
    @IBOutlet var introduceLabel: DepthMenuLabel!
//    @IBOutlet var cellMenuContainer: UIView!
    @IBOutlet var topMenuView: UIView!
//    @IBOutlet var klineContainer: UIView!
//    @IBOutlet var seperator: UIView!
    
    
    let dealcellMenu:TransactionDetailsV = TransactionDetailsV.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 36))
    let depthMenu = TransactionDepthTV.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 36))

    var type :TransactionDetailsType = .depth {
        didSet {
            self.depthTitleSelected(type: type)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func onCreate() {
        depthLabel.headBold()
        orderLabel.headBold()
        introduceLabel.headBold()
        depthLabel.text = "kline_action_depth".localized()
        orderLabel.text = "kline_action_dealHistory".localized()
        introduceLabel.text = "market_text_coinInfo".localized()
//        self.cellMenuContainer .addSubview(dealcellMenu)
//        self.cellMenuContainer .addSubview(depthMenu)
        self.type = .depth
    }
    
    func hideIntroduce() {
        introduceLabel.isHidden = true
    }
    
    func showIntroduce() {
        introduceLabel.isHidden = false
    }
    
    func depthTitleSelected(type:TransactionDetailsType) {
//        klineContainer.isHidden = false
//        cellMenuContainer.isHidden = false
        depthMenu.isHidden = true
        dealcellMenu.isHidden = true
        
        depthLabel.indicatorColor = .clear
        orderLabel.indicatorColor = .clear
        introduceLabel.indicatorColor = .clear
        depthLabel.textColor = UIColor.ThemeLabel.colorMedium
        orderLabel.textColor = UIColor.ThemeLabel.colorMedium
        introduceLabel.textColor = UIColor.ThemeLabel.colorMedium
        switch type  {
        case .deal:
            orderLabel.textColor = UIColor.ThemeLabel.colorLite
            orderLabel.indicatorColor = UIColor.ThemeView.highlight
            dealcellMenu.isHidden = false
        case .depth:
            depthLabel.textColor = UIColor.ThemeLabel.colorLite
            depthLabel.indicatorColor = UIColor.ThemeView.highlight
            depthMenu.isHidden = false
        case .introduce:
            introduceLabel.textColor = UIColor.ThemeLabel.colorLite
            introduceLabel.indicatorColor = UIColor.ThemeView.highlight
        }
    }
    
    @IBAction func depthLabelTapped(_ sender: UITapGestureRecognizer) {
        if self.type == .depth {
            return
        }
        self.type = .depth
        self.headerActionCallback?(.depth)
//        klineContainer.isHidden = false
        
//        self.stacks.insertArrangedSubview(self.klineDepthView, at: 1)
    }
    
    @IBAction func recordLabelTapped(_ sender: UITapGestureRecognizer) {
        if self.type == .deal {
            return
        }
//        cellMenuContainer.isHidden = false
        self.type = .deal
        self.headerActionCallback?(.deal)
//        klineContainer.isHidden = true
//        self.stacks.removeArrangedSubview(self.klineDepthView)
    }
    
    @IBAction func introduceLabelTapped(_ sender: UITapGestureRecognizer) {
        if self.type == .introduce {
            return
        }
//        cellMenuContainer.isHidden = true
//        klineContainer.isHidden = true
        self.type = .introduce
        self.headerActionCallback?(.introduce)
//        self.stacks.removeArrangedSubview(self.klineDepthView)
    }
}



class DepthMenuLabel :UILabel {
    
    @IBInspectable var topInset: CGFloat = 0
    @IBInspectable var bottomInset: CGFloat = 0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    private let indicatorWidth :CGFloat = 15
    private let indicatorHeight :CGFloat = 3

    var indicatorColor = UIColor.clear{
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath.init(rect: CGRect(x: (self.width - indicatorWidth) / 2 , y:self.height - indicatorHeight, width: indicatorWidth, height: indicatorHeight))
        self.indicatorColor.setFill()
        path.fill()
        super.drawText(in: rect)
    }
    
    override func drawText(in rect: CGRect) {
        let labelInset = UIEdgeInsetsMake(0, leftInset, 0, 0)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, labelInset))
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
}


