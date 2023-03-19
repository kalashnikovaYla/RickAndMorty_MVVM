//
//  SearchViewController.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 22.01.2023.
//

import UIKit

//Dynamic search option view
//Render results
//Render no results 
//Searching / API Call

///Configurable controller to search 
final class SearchViewController: UIViewController {

    ///Configuration for our search session
    struct Config {
        
        enum TypeInfo {
            case character //name, status, gender
            case location //name, type
            case episode // name
            
            
            var title: String {
                switch self {
                case .character:
                    return "Search Characters"
                case .episode:
                    return "Search Episodes"
                case .location:
                    return "Search Locations"
                }
            }
            
            var endpoint: EndPoint {
                switch self {
                case .episode: return .episode
                case .location: return .location
                case .character: return .character
                }
            }
        }
        let type: TypeInfo
    }
    
   
    private let searchView: SearchView
    let viewModel: SearchViewModel
    
    //MARK: - Init
    
    init(config: Config) {
        let viewModel = SearchViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = SearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubviews(searchView)
        addConstraints()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: .done, target: self, action: #selector(didTapExecuteSearch))
        
        searchView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchView.presentKeyboard()
    }
    
    
    @objc func didTapExecuteSearch() {
        viewModel.executeSearch()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor)
        ])
    }
}


//MARK: - SearchViewDelegate

extension SearchViewController: SearchViewDelegate {
    
    func searchView(_ searchView: SearchView, didSelectOption option: SearchInputViewModel.DynamicOption) {
        let vc = SearchOptionPickerViewController(option: option) { [weak self] selection in
            
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true 
        present(vc, animated: true)
    }
    
    func searchView(_ searchView: SearchView, didSelectLocation location: Location) {
        let vc = LocationDetailViewController(location: location)
        navigationController?.pushViewController(vc, animated: true)
    }

}
