//
//  LocationViewController.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 10.01.2023.
//

import UIKit

///Controller to show and search for  location 
class LocationViewController: UIViewController, LocationViewModelDelegate, LocationViewDelegate {
    
    private let viewModel = LocationViewModel()
    private let primaryView = LocationView()
    
    
    //MARK: Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        primaryView.delegate = self
        view.addSubviews(primaryView)
        
        title = "Location"
        view.backgroundColor = .systemBackground
        addSearchButton()
        addConstraints()
        viewModel.delegate = self 
        viewModel.fetchLocations()
    }
    
    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc func didTapSearch() {
        let vc = SearchViewController(config: .init(type: .location))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            primaryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            primaryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            primaryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            primaryView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    //MARK: - LocationViewModelDelegate
    
    func didFetchInitialLocations() {
        primaryView.configure(with: viewModel)
    }
    
    //MARK: - LocationViewDelegate
    
    func locationView(_ locationView: LocationView, didSelect location: Location) {
        let vc = LocationDetailViewController(location: location)
        navigationController?.pushViewController(vc, animated: true)
        vc.navigationItem.largeTitleDisplayMode = .never
    }
}
