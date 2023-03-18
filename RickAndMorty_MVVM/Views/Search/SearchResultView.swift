//
//  SearchResultView.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 19.03.2023.
//

import UIKit

///Show search result UI (table or collection as needed)
final class SearchResultView: UIView {

    private var viewModel: SearchResultViewModel? {
        didSet {
            
        }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.idintifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        switch viewModel {
        case .characters(let viewModels):
            setupCollectionView()
        case .locations(let viewModels):
            break
        case .episodes(let viewModels):
            setupCollectionView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        
        backgroundColor = .red
        
        translatesAutoresizingMaskIntoConstraints = false
        addConstraint()
        
        addSubviews(tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(with viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
    }
    
    private func addConstraint() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        tableView.backgroundColor = .yellow
    }
    private func setupCollectionView() {
        
    }
    
    private func setUpTableView() {
        tableView.isHidden = false 
    }
}
