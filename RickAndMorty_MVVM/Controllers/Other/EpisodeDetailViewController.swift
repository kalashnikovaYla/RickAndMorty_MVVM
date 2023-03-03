//
//  EpisodeDetailViewController.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 21.01.2023.
//

import UIKit

/// VC to show details about single episode
final class EpisodeDetailViewController: UIViewController, EpisodeDetailViewModelDelegate, EpisodeDetailViewDelegate {
    
    
    private let url: URL?
    private let viewModel: EpisodeDetailViewModel
    private let detailView = EpisodeDetailView()
    
    //MARK: Init
    init(url: URL?) {
        self.url = url
        self.viewModel = EpisodeDetailViewModel(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Episode"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        addConstraints()
        
        viewModel.delegate = self
        detailView.delegate = self
        viewModel.fetchEpisodeData() 
    }
    
    @objc func didTapShare() {
        
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    //MARK: - ViewModel delegate
    
    func didFetchEpisodeDetails() {
        detailView.configure(with: viewModel)
    }
    
    //MARK: - View delegate
     
    func episodeDetailView(_ detailView: EpisodeDetailView, didSelectedCharacter: Character) {
        let vc = CharacterDetailViewController(viewModel: .init(character: didSelectedCharacter))
        vc.title = didSelectedCharacter.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
