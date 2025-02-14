//
//  SearchController.swift
//  image-browser
//
//  Created by Shivam Jaiswal on 22/05/20.
//  Copyright © 2020 Shivam Jaiswal. All rights reserved.
//

import UIKit
import Stevia

private struct Constants {
    static let topPadding: CGFloat = 100
    static let textfieldSize = CGSize(width: 280, height: 44)
    static let searchIconName = "search"
    static let placeholder = "Search Images"
}

class SearchController: BaseController {
    private let viewModel: SearchViewModelProtocol
    private let textField = SJTextField()

    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addSubViews()
        adjustSubViews()
        setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar(animated: animated)
        textField.becomeFirstResponder()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBar(animated: animated)
    }

    private func addSubViews() {
        view.subviews(textField)
    }

    private func adjustSubViews() {
        textField.style {
            $0.delegate = self
            $0.returnKeyType = .search
            $0.borderStyle = .roundedRect
            $0.placeholder = Constants.placeholder
            $0.setTextFiledView(viewType: .actionButton(iconName: Constants.searchIconName), position: .left, tapHandler: nil)
            $0.historyTapHandler = { [weak self] keyword in self?.handleHistoryTap(keyword: keyword) }
        }
    }

    private func setupConstraints() {
        textField.top(Constants.topPadding).width(Constants.textfieldSize.width).height(Constants.textfieldSize.height).centerHorizontally()
    }

    private func showTextFieldLoader() {
        textField.setTextFiledView(viewType: .loader, position: .right, tapHandler: nil)
        textField.isUserInteractionEnabled = false
    }

    private func hideTextFieldLoader() {
        textField.setTextFiledView(viewType: nil, position: .right, tapHandler: nil)
        textField.isUserInteractionEnabled = true
    }

    private func fetchImages(keyword: String) {
        showTextFieldLoader()
        viewModel.fetchImages(keyword: keyword) { [weak self] status in
            guard let `self` = self else { return }
            self.hideTextFieldLoader()
            switch status {
            case .error(let error):
                self.view.showToast(error.localizedDescription)
            case .fetched:
                self.pushResultsController(keyword: keyword, images: self.viewModel.images)
            }
        }
    }

    private func pushResultsController(keyword: String, images: [ImageItem]) {
        let viewModel = SearchResultsViewModel(images: images, keyword: keyword)
        let controller = SearchResultsController(viewModel: viewModel)
        navigationController?.pushViewController(controller, animated: true)
    }

    private func handleHistoryTap(keyword: String) {
        textField.text = keyword
        textField.endEditing(true)
        fetchImages(keyword: keyword)
    }
}

extension SearchController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let keyword = textField.text, !keyword.isEmpty else { return true }
        textField.endEditing(true)
        fetchImages(keyword: keyword)
        return true
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textField.history = viewModel.keywordHistory()
        return true
    }
}
