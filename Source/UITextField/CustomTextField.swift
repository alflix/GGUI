//
//  CustomTextField.swift
//  GGUI
//
//  Created by John on 2019/3/27.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import UIKit

@IBDesignable
open class CustomTextField: UITextField {
    /// 点击清除按钮 Block
    public var backKeyPressed: VoidBlock?
    /// 点击显示查看密码的图标，设置的话就会显示，且点击显示密码，再次点击显示为密码点
    @IBInspectable public var checkPasswordImage: UIImage?
    /// 查看密码显示图标
    @IBInspectable public var checkPasswordSelectedImage: UIImage?
    /// 左间距
    @IBInspectable public var leftInset: CGFloat = 0.0 {
        didSet { layoutSubviews() }
    }
    /// 右间距
    @IBInspectable public var rightInset: CGFloat = 0.0 {
        didSet { layoutSubviews() }
    }
    /// 底部横线的高度，设置了才会显示，横线颜色 bottomLineColor
    @IBInspectable public var bottomLineHeight: CGFloat = 0 {
        didSet { layoutSubviews() }
    }
    /// placeholder 颜色，可在 GGUI-CustomTextField-placeholderColor 统一设置
    @IBInspectable public var placeholderColor: UIColor = Config.CustomTextField.placeholderColor {
        didSet { layoutSubviews() }
    }
    /// 底部横线颜色
    @IBInspectable public var bottomLineColor: UIColor = Config.LineView.color {
        didSet { layoutSubviews() }
    }

    private var lineView: SingleLineView?
    private var checkPasswordButton: UIButton?
    private var isShowLineView: Bool { return bottomLineHeight > 0 }
    private var isCheckPassword: Bool { return checkPasswordImage != nil }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if let placeholder = placeholder {
            attributedPlaceholder = placeholder.attributedString(font: font!, color: placeholderColor)
        }
        if isShowLineView {
            if lineView?.superview == nil {
                lineView = SingleLineView(frame: CGRect.zero)
                addSubview(lineView!)
            }
            lineView!.frame = CGRect(x: 0, y: bounds.height-bottomLineHeight, width: bounds.width, height: bottomLineHeight)
            lineView!.lineColor = bottomLineColor
        } else {
            lineView?.safeRemoveFromSuperview()
        }

        if isCheckPassword {
            if checkPasswordButton?.superview ==  nil {
                checkPasswordButton = UIButton(type: .custom)
                checkPasswordButton!.setImage(checkPasswordImage, for: .normal)
                if let image = checkPasswordSelectedImage {
                    checkPasswordButton!.setImage(image, for: .selected)
                }
                checkPasswordButton!.sizeToFit()
                _ = checkPasswordButton!.on(.touchUpInside, invokeHandler: { [weak self] (_) in
                    guard let self = self else { return }
                    self.checkPasswordButton!.isSelected = !self.checkPasswordButton!.isSelected
                    self.isSecureTextEntry = !self.checkPasswordButton!.isSelected
                })
            }
            if let checkPasswordButton = checkPasswordButton {
                checkPasswordButton.frame = CGRect(x: bounds.width - checkPasswordButton.bounds.width - rightInset,
                                                   y: (bounds.height - checkPasswordButton.bounds.height)/2,
                                                   width: checkPasswordButton.bounds.width, height: checkPasswordButton.bounds.height)
            }
        } else {
            checkPasswordButton?.safeRemoveFromSuperview()
        }

        if leftInset > 0 {
            leftViewMode = .always
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftInset, height: bounds.height))
        }
        if rightInset > 0 || isCheckPassword {
            rightViewMode = .always
            if isCheckPassword {
                rightView = checkPasswordButton
            } else {
                rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightInset, height: bounds.height))
            }
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        autocorrectionType = .no
    }

    required override public init(frame: CGRect) {
        super.init(frame: frame)
        autocorrectionType = .no
    }

    public override func deleteBackward() {
        super.deleteBackward()
        backKeyPressed?()
    }
}