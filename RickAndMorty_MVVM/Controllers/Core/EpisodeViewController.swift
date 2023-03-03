//
//  EpisodeViewController.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 10.01.2023.
//

import UIKit

///Controller to show and search for  episode   
class EpisodeViewController: UIViewController, EpisodeListViewDelegate {
    
    private let episodeListView = EpisodeListView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setupView()
        addSearchButton()
    }
    
    private func setupView() {
        
        episodeListView.delegate = self
        
        view.addSubview(episodeListView)
        
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            episodeListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    //MARK: EpisodeListViewDelegate
    
    func episodeView(_ episodeView: EpisodeListView, didSelectedEpisode episode: Episode) {
        //Open detail controller for that episode
        
        let detailVC = EpisodeDetailViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc func didTapSearch() {
        let vc = SearchViewController(config: .init(type: .episode))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
