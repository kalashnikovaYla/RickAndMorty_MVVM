//
//  SearchInputView.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 01.02.2023.
//

import UIKit

protocol SearchInputViewDelegate: AnyObject {
    func searchInputView(_ inputView: SearchInputView, didSelectOption option: SearchInputViewModel.DynamicOption)
    func searchInputView(_ inputView: SearchInputView, didChangeSearchText text: String )
    func searchInputViewDidTapSearchKeyboardButton(_ inputView: SearchInputView)
}

/// View for top part of search screen with search bar
final class SearchInputView: UIView {

    weak var delegate: SearchInputViewDelegate?
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private var viewModel: SearchInputViewModel? {
        didSet {
            guard let viewModel = viewModel, viewModel.hasDynamicOptions else {
                return
            }
            let options = viewModel.options
            createSelectionViews(options: options)
        }
    }
    
    private var stack: UIStackView?
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(searchBar)
        addConstraint()
        searchBar.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private func
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leftAnchor.constraint(equalTo: leftAnchor ),
            searchBar.rightAnchor.constraint(equalTo: rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 58)
        ])
    }
    
    
    private func createStackView() -> UIStackView{
        let stack = UIStackView()
        self.stack = stack
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.alignment = .center
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)
        
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        return stack
    }
    
    
    private func createSelectionViews(options: [SearchInputViewModel.DynamicOption]) {
        
        let stack = createStackView()
    
        for i in 0..<options.count {
            let option = options[i]
            let button = createButton(with: option, tag: i)
            stack.addArrangedSubview(button)
        }
    }
    
    @objc
    private func didTapButton(_ sender: UIButton) {
        guard let options = viewModel?.options else {return}
        let tag = sender.tag
        let selected = options[tag]
        
        delegate?.searchInputView(self, didSelectOption: selected)
    }
    
    private func createButton(with option: SearchInputViewModel.DynamicOption, tag: Int) -> UIButton {
        let button = UIButton()
        
        button.setTitle(option.rawValue, for: .normal)
        button.setAttributedTitle(
            NSAttributedString(string: option.rawValue,
                               attributes: [
                                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                                .foregroundColor: UIColor.label]
            ),
            for: .normal
        )
        button.backgroundColor = .secondarySystemFill
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.tag = tag
        button.layer.cornerRadius = 6
        return button
    }
    
    //MARK: - Public
    
    public func configure(with viewModel: SearchInputViewModel) {
        searchBar.placeholder = viewModel.searchPlaceholderText
        self.viewModel = viewModel
    }
    
    public func presentKeyboard() {
        searchBar.becomeFirstResponder()
    }
    
    public func update(option: SearchInputViewModel.DynamicOption, value: String) {
        guard let buttons = stack?.arrangedSubviews as? [UIButton],
              let allOptions = viewModel?.options,
              let index = allOptions.firstIndex(of: option)
        else {return }
        
        let button: UIButton = buttons[index]
        button.setTitle(option.rawValue, for: .normal)
        button.setAttributedTitle(
            NSAttributedString(string: value.uppercased(),
                               attributes: [
                                .font: UIFont.systemFont(ofSize: 18, weight: .medium),
                                .foregroundColor: UIColor.link]
            ),
            for: .normal
        )
       
    }
}

//MARK: - UISearchBarDelegate

extension SearchInputView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //Notify delegate of change text
        print(searchText)
        delegate?.searchInputView(self, didChangeSearchText: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Notify that search button was tapped
        
        searchBar.resignFirstResponder()
        delegate?.searchInputViewDidTapSearchKeyboardButton(self)
    }
}
