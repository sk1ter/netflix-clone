//
//  SearchViewController.swift
//  Netflix
//
//  Created by Javlonbek Sharipov on 08/03/23.
//

import UIKit

class SearchViewController: UIViewController {
    private var titles: [Title] = [Title]()

    private let discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    private let searchController: UISearchController = {
       let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for the movie or tv show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
        
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = .white
        navigationItem.searchController = searchController
        view.addSubview(discoverTable)
        
        discoverTable.delegate = self
        discoverTable.dataSource = self
        
        fetchData()
        
        searchController.searchResultsUpdater = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        discoverTable.frame = view.bounds
    }
    
    func fetchData() {
        APICaller.shared.getDiscoveryMovies { [weak self] result in
            switch (result) {
            case let .success(titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        let text = titles[indexPath.row].original_name ?? titles[indexPath.row].original_title ?? "No title"
        cell.configure(with: TitleViewModel(posterURL: titles[indexPath.row].poster_path ?? "", titleName: text))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsViewController else {
            return
        }
       
        APICaller.shared.search(query: query) { result in
            DispatchQueue.main.async {
                switch(result) {
                case let .success(titles):
                    print("\(titles)")
                    resultController.titles = titles
                    resultController.searchResultsCollectionView.reloadData()
                case let .failure(error):
                    print(error)
                }
            }
        }
    }
}
