//
//  UpcomingViewController.swift
//  Netflix
//
//  Created by Javlonbek Sharipov on 08/03/23.
//

import UIKit

class UpcomingViewController: UIViewController {
    private var titles: [Title] = [Title]()

    private let upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always

        view.addSubview(upcomingTable)

        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }

    private func fetchData() {
        APICaller.shared.getUpcomingMovies { result in
            switch result {
            case let .success(titles):
                self.titles = titles
                DispatchQueue.main.async {
                    self.upcomingTable.reloadData()
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
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
