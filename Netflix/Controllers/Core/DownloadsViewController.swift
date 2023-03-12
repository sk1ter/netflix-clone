//
//  DownloadsViewController.swift
//  Netflix
//
//  Created by Javlonbek Sharipov on 08/03/23.
//

import UIKit

class DownloadsViewController: UIViewController {
    private var titles: [TitleItem] = [TitleItem]()
    private let downloadsTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Downloads"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        view.addSubview(downloadsTable)
        downloadsTable.delegate = self
        downloadsTable.dataSource = self
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchData()
        }
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadsTable.frame = view.bounds
    }

    private func fetchData() {
        DataPersistenceManager.shared.fetchTitles { [weak self] result in
            switch result {
            case let .success(titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.downloadsTable.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }
}

extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
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

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            DataPersistenceManager.shared.deleteData(titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    self?.titles.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    print("OK")
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            break
        }
    }
}
