//
//  SearchResultView.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 19.03.2023.
//

import UIKit

protocol SearchResultsViewDelegate: AnyObject {
    func searchResultsView(_ resultsView: SearchResultView, didTapLocationAt index: Int)
}


///Show search result UI (table or collection as needed)
final class SearchResultView: UIView {

    private var viewModel: SearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }
    
    weak var delegate: SearchResultsViewDelegate?
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(LocationTableViewCell.self, forCellReuseIdentifier: LocationTableViewCell.idintifier)
        table.isHidden = true
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private let collectionView: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)

            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collectionView.isHidden = true
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.register(CharacterCollectionViewCell.self,
                                    forCellWithReuseIdentifier: CharacterCollectionViewCell.cellIdentifier)
            collectionView.register(CharacterEpisodeCollectionViewCell.self,
                                    forCellWithReuseIdentifier: CharacterEpisodeCollectionViewCell.cellIdentifier)
            collectionView.register(FooterLoadingCollectionReusableView.self,
                                    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                    withReuseIdentifier: FooterLoadingCollectionReusableView.identifier)
            return collectionView
        }()
    
    private var locationCellViewModels: [LocationTableViewCellViewModel] = []
    private var collectionViewCellViewModels: [any Hashable] = []
    
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubviews(tableView, collectionView)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func processViewModel() {
        guard let viewModel = viewModel else {
            return
        }
        switch viewModel {
        case .characters(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView(viewModels: viewModels)
        case .episodes(let viewModels):
            self.collectionViewCellViewModels = viewModels
            setUpCollectionView()
        }
    }
    
    private func setUpCollectionView() {
        self.tableView.isHidden = true
        self.collectionView.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
    }

    private func setUpTableView(viewModels: [LocationTableViewCellViewModel]) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        collectionView.isHidden = true
        self.locationCellViewModels = viewModels
        tableView.reloadData()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    public func configure(with viewModel: SearchResultViewModel) {
        self.viewModel = viewModel
    }
    
}


// MARK: - TableView
extension SearchResultView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.idintifier,
                                                       for: indexPath) as? LocationTableViewCell else {
            fatalError("Failed to dequeue LocationTableViewCell")
        }
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.searchResultsView(self, didTapLocationAt: indexPath.row)
    }
}


// MARK: - CollectionView
extension SearchResultView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionViewCellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if let characterVM = currentViewModel as? CharacterCollectionViewCellViewModel {
            // Character cell
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier,
                for: indexPath
            ) as? CharacterCollectionViewCell else {
                fatalError()
            }

            cell.configure(with: characterVM)
            return cell
        }

        // Episode
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? CharacterEpisodeCollectionViewCell else {
            fatalError()
        }
        if let episodeVM = currentViewModel as? CharacterEpisodeCollectionViewCellViewModel {
            cell.configure(with: episodeVM)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        // Handle cell tap
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]

        let bounds = collectionView.bounds

        if currentViewModel is CharacterCollectionViewCellViewModel {
            // Character size
            let width = (bounds.width-30)/2
            return CGSize(
                width: width,
                height: width * 1.5
            )
        }

        // Episode
        let width = bounds.width-20
        return CGSize(
            width: width,
            height: 100
        )
    }
}
