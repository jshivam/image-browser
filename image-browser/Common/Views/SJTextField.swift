//
//  SJTextField.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit

enum TextFieldViewPosition {
    case left, right
}

enum TextFieldViewType {
    case loader
    case actionButton(iconName: String)
}

private struct Constants {
    static let leftViewSidePadding: CGFloat = 10
    static let rightViewSidePadding: CGFloat = 10

    static let textFiledViewTintColor = UIColor.black.withAlphaComponent(0.5)
    static let backgroundColor = UIColor.white

    static let textViewSize = CGSize(width: 25, height: 25)
}

final class SJTextField: UITextField {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        self.backgroundColor = Constants.backgroundColor
        self.textColor = UIColor.black
    }

    // MARK: UITextFieldViewMode
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += Constants.leftViewSidePadding
        return textRect
    }

    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= Constants.leftViewSidePadding
        return textRect
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: UIEdgeInsets(top: 0, left: Constants.leftViewSidePadding, bottom: 0, right: Constants.rightViewSidePadding)))
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: UIEdgeInsets(top: 0, left: Constants.leftViewSidePadding, bottom: 0, right: Constants.rightViewSidePadding)))
    }
}

extension SJTextField {
    func setTextFiledView(viewType: TextFieldViewType?,
                          position: TextFieldViewPosition,
                          tapHandler: ((TextFieldViewButton)->Void)? = nil)
    {
        if let type = viewType
        {
            var view: UIView

            switch type{
            case .actionButton(let iconName):
                    let button = TextFieldViewButton.init(type: .system)
                    button.frame = CGRect(x: 0, y: 0, width: Constants.textViewSize.width, height: Constants.textViewSize.height)
                    button.setImage(UIImage.init(named: iconName), for: .normal)
                    button.tintColor = Constants.textFiledViewTintColor
                    button.tapHandler = tapHandler
                    view = button

            case .loader:
                let spinner = UIActivityIndicatorView(style: .gray)
                spinner.startAnimating()
                view = spinner
            }

            switch position {
            case .left:
                leftViewMode = UITextField.ViewMode.always
                leftView = view
                view.tag = 0
            case .right:
                rightViewMode = UITextField.ViewMode.always
                rightView = view
                view.tag = 1
            }
        }
        else
        {
            switch position {
            case .left:
                leftViewMode = UITextField.ViewMode.never
                leftView = nil
            case .right:
                rightViewMode = UITextField.ViewMode.never
                rightView = nil
            }
        }
    }
}

final class TextFieldViewButton: UIButton {
    public var tapHandler: ((TextFieldViewButton)->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup(){
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped(_ sender: UIButton){
        tapHandler?(self)
    }
}

