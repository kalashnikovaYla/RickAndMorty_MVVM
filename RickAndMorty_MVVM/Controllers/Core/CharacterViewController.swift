//
//  CharacterViewController.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 10.01.2023.
//

import UIKit

///Controller to show and search for  characters 
final class CharacterViewController: UIViewController, CharacterViewDelegate {
   

    private let characterView = CharacterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupView()
        addSearchButton()
    }
    
    private func setupView() {
        
        characterView.delegate = self
        view.addSubview(characterView)
        
        NSLayoutConstraint.activate([
            characterView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            characterView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            characterView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc func didTapSearch() {
        let vc = SearchViewController(config: .init(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: CharacterViewDelegate
    
    func characterView(_ characterView: CharacterView, didSelectedCharacter character: Character) {
        //Open detail controller for that character
        let viewModel = CharacterDetailViewModel(character: character)
        let detailVC = CharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }

}
