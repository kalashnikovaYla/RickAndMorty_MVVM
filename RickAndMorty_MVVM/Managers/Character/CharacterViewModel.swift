//
//  CharacterViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 13.01.2023.
//

import UIKit

protocol CharacterViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPath: [IndexPath])
    func didSelectCharacter(_ character: Character)
}

///View model to handle character list view logic

final class  CharacterViewModel: NSObject {
    
    public weak var delegate: CharacterViewModelDelegate?
    
    private var isLoadingMoreCharacters = false
    
    private var characters: [Character] = [] {
        didSet {
            for character in characters {
                let viewModel = CharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageUrl: URL(string: character.image)
                )
                // если не содержит эту viewModel тогда мы должны вставить ее 
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
            
        }
    }
    private var cellViewModels: [CharacterCollectionViewCellViewModel] = []
    private var apiInfo: GetCharactersResponse.Info? = nil 
    
    ///Fetch initial set of characters
    public func fetchCharacters () {
        NetworkService.shared.execute(.listCharactersRequest, expecting: GetCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
               
                self?.apiInfo = responseModel.info
                self?.characters = results
                
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
    
    ///Paginated if additional characters are needed
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else {
            return
        }
        isLoadingMoreCharacters = true
       
        guard let request = Request(url: url) else {
            isLoadingMoreCharacters = false
            return
        }
        NetworkService.shared.execute(request, expecting: GetCharactersResponse.self) { [weak self] result in
            
            guard let strongSelf = self else {return}
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                
                let startIndex = total - newCount
                let indexPathToAdd: [IndexPath] = Array(startIndex..<(startIndex+newCount)).compactMap {
                    return IndexPath(row: $0, section: 0)
                }
                
                strongSelf.characters.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathToAdd)
                }
                strongSelf.isLoadingMoreCharacters = false
            case .failure(let failure):
                print(String(describing: failure))
                self?.isLoadingMoreCharacters = false
            }
        }
    }
    
    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil  
    }
}

//MARK: Collection View

extension CharacterViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterCollectionViewCell.cellIdentifier,
            for: indexPath
        ) as? CharacterCollectionViewCell else {
            fatalError("Unsupported cell")
        }
        let viewModel = cellViewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30)/2
        return CGSize(
            width: width,
            height: width * 1.5
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectCharacter(character)
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



extension CharacterViewModel: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters, !cellViewModels.isEmpty,
              let nextUrlString = apiInfo?.next, let url = URL(string: nextUrlString)
        else {return }
        
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] t in
            // Собираемся вычислить, находимся ли мы внизу

            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalCharacters(url: url)
            }
            t.invalidate()
        }
    }
}
