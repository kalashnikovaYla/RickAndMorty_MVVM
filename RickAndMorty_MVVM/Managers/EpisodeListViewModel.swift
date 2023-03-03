//
//  EpisodeListViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 22.01.2023.
//

import Foundation

import UIKit

protocol EpisodeListViewModelDelegate: AnyObject {
    func didLoadInitialEpisodes()
    func didLoadMoreEpisodes(with newIndexPath: [IndexPath])
    func didSelectEpisode(_ episode: Episode)
}

///View model to handle episode list view logic

final class  EpisodeListViewModel: NSObject {
    
    public weak var delegate: EpisodeListViewModelDelegate?
    
    private var isLoadingMoreEpisodes = false
    
    private let borderColors: [UIColor] = [
        .systemBlue,
        .systemPurple,
        .systemRed,
        .systemGreen,
        .systemOrange,
        .systemPink,
        .systemYellow,
        .systemIndigo,
        .systemMint
    ]
    
    private var episodes: [Episode] = [] {
        didSet {
            for episode in episodes {
                let viewModel = CharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: episode.url), borderColor: borderColors.randomElement() ?? .systemBlue)
                
                
                // если не содержит эту viewModel тогда мы должны вставить ее
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
            
        }
    }
    private var cellViewModels: [CharacterEpisodeCollectionViewCellViewModel] = []
    private var apiInfo: GetEpisodesResponse.Info? = nil
    
    ///Fetch initial set of episodes (20)
    public func fetchEpisodes () {
        NetworkService.shared.execute(.listEpisodesRequest, expecting: GetEpisodesResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                //let info = responseModel.info
                self?.apiInfo = responseModel.info
                self?.episodes = results
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialEpisodes()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    ///Paginated if additional episodes are needed
    public func fetchAdditionalEpisodes(url: URL) {
       
        guard !isLoadingMoreEpisodes else {
            return
        }
        isLoadingMoreEpisodes = true
       
        guard let request = Request(url: url) else {
            isLoadingMoreEpisodes = false
            print("Failed to create request")
            return
        }
        NetworkService.shared.execute(request, expecting: GetEpisodesResponse.self) { [weak self] result in
            
            guard let strongSelf = self else {return}
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                
                let originalCount = strongSelf.episodes.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                
                let startIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startIndex..<(startIndex+newCount)).compactMap {
                    return IndexPath(row: $0, section: 0)
                }
                
                strongSelf.episodes.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreEpisodes(with: indexPathToAdd)
                }
                strongSelf.isLoadingMoreEpisodes = false
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreEpisodes = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }
}

//MARK: Collection View

extension EpisodeListViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? CharacterEpisodeCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
        let bounds = collectionView.bounds
        let width = bounds.width - 20
        return CGSize(
            width: width,
            height: 100
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let episode = episodes[indexPath.row]
        delegate?.didSelectEpisode(episode)
    }
    
    //MARK:  Нужно указать размер нижнего колонтитула а также функцию, которая удалит сам нижний колонтитул из очереди
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        guard kind == UICollectionView.elementKindSectionFooter, shouldShowLoadMoreIndicator, let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: FooterLoadingCollectionReusableView.identifier,
            for: indexPath
        ) as? FooterLoadingCollectionReusableView else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else {return .zero}
        return CGSize(width: collectionView.frame.width,
                      height: 100)
    }
    
}

//MARK: UIScrollViewDelegate



extension EpisodeListViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreEpisodes, !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString)
        else {return }
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            // Собираемся вычислить, находимся ли мы внизу
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalEpisodes(url: url)
            }
            t.invalidate()
        }
    }
}
