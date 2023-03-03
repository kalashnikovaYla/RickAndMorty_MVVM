//
//  SearchView.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 01.02.2023.
//

import UIKit

protocol SearchViewDelegate: AnyObject {
    func searchView(_ searchView: SearchView, didSelectOption option: SearchInputViewModel.DynamicOption)
}

final class SearchView: UIView {
    
    private let viewModel: SearchViewModel
    
    weak var delegate: SearchViewDelegate?
    
    
    //MARK: - Subviews
    
    //SearchInputView (bar, selection buttons)
    private let searchInputView = SearchInputView()
    
    //No results view
    
    private let noResultsView = NoSearchResultsView()
    
    //Results collection view
    
    
    
    //MARK: - Init
    
    init(frame: CGRect, viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView)
        addConstraints()
        
        searchInputView.configure(with: SearchInputViewModel(type: viewModel.config.type))
        
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        
        viewModel.registerSearchResultHandler { result in
            print(result)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            //Search input view
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            //No results
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    public func presentKeyboard() {
        searchInputView.presentKeyboard()
        searchInputView.delegate = self
    }
}

//MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
    }
}

//MARK: - SearchInputViewDelegate

extension SearchView: SearchInputViewDelegate {
    
    func searchInputViewDidTapSearchKeyboardButton(_ inputView: SearchInputView) {
        viewModel.executeSearch()
    }
    
    func searchInputView(_ inputView: SearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func searchInputView(_ inputView: SearchInputView, didSelectOption option: SearchInputViewModel.DynamicOption) {
        delegate?.searchView(self, didSelectOption: option)
    }
}
