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
    static let sidePadding: CGFloat = 10
    static let textFiledViewTintColor = UIColor.black.withAlphaComponent(0.5)
    static let backgroundColor = UIColor.white
    static let textViewSize = CGSize(width: 25, height: 25)
    static let cellHeight: CGFloat = 44
}

final class SJTextField: UITextField {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.isHidden = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderColor = UIColor.lightGray.cgColor
        tableView.layer.borderWidth = .borderWidth
        tableView.layer.cornerRadius = .cornerRadius
        tableView.register(ofType: UITableViewCell.self)
        return tableView
    }()

    private var keyboardMinY: CGFloat?
    var history: [String] = [] {
        didSet{
            tableView.reloadData()
        }
    }

    var historyTapHandler: ((String) -> Void)?

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
        addSubview(tableView)
        addKeyBoardObserver()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let minY = keyboardMinY {
            tableView.isHidden = false
            let y = bounds.maxY + Constants.sidePadding / 2
            let maxHeight = minY - frame.maxY
            let height = min(maxHeight, tableView.contentSize.height) - Constants.sidePadding
            tableView.frame = CGRect(x: 0, y: y , width: bounds.width, height: height)
        } else {
            tableView.isHidden = true
            tableView.frame = .zero
        }
    }

    private func addKeyBoardObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handle(keyboardHideNotification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc
    private func handle(keyboardShowNotification notification: Notification) {
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            keyboardMinY = keyboardRectangle.minY
            setNeedsLayout()
            tableView.reloadData()
        }
    }

    @objc
    private func handle(keyboardHideNotification notification: Notification) {
        keyboardMinY = nil
        setNeedsLayout()
        tableView.reloadData()
    }

    // MARK: UITextFieldViewMode
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += Constants.sidePadding
        return textRect
    }

    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.rightViewRect(forBounds: bounds)
        textRect.origin.x -= Constants.sidePadding
        return textRect
    }

    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: UIEdgeInsets(top: 0, left: Constants.sidePadding, bottom: 0, right: Constants.sidePadding)))
    }

    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: bounds.inset(by: UIEdgeInsets(top: 0, left: Constants.sidePadding, bottom: 0, right: Constants.sidePadding)))
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

extension SJTextField: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ofType: UITableViewCell.self, for: indexPath)
        cell.textLabel?.text = history[indexPath.row]
        cell.textLabel?.textColor = .lightGray
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        historyTapHandler?(history[indexPath.row])
    }
}


extension SJTextField {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if !tableView.isHidden {
            let height = Constants.sidePadding / 2 + tableView.frame.height
            return CGRect(x: 0, y:0, width: bounds.width, height: bounds.height + height).contains(point)
        }
        return super.point(inside: point, with: event)
    }
}
