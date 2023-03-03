//
//  LocationDetailViewController.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 01.02.2023.
//

import UIKit

/// VC to show details about single location
final class LocationDetailViewController: UIViewController, LocationDetailViewModelDelegate, LocationDetailViewDelegate {
    
    private let viewModel: LocationDetailViewModel
    private let detailView = LocationDetailView()
    
    //MARK: Init
    init(location: Location) {
        let url = URL(string: location.url)
        self.viewModel = LocationDetailViewModel(url: url)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        addConstraints()
        
        viewModel.delegate = self
        detailView.delegate = self
        viewModel.fetchLocationData()
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
    
    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
    
    //MARK: - View delegate
     
    func locationDetailView(_ detailView: LocationDetailView, didSelectedCharacter: Character) {
        let vc = CharacterDetailViewController(viewModel: .init(character: didSelectedCharacter))
        vc.title = didSelectedCharacter.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

}
