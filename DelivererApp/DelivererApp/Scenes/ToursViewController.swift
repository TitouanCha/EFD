//
//  ToursViewController.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 18/12/2025.
//

import UIKit

class ToursViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private var tours: [Tour] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchTours()
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self

        let nib = UINib(nibName: "TourCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TourCell")

        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTours()
    }

    private func fetchTours() {
        guard let token = SessionManager.shared.token else { return }

        AuthAPI.shared.getTours(token: token) { tours in
            DispatchQueue.main.async {
                self.tours = tours
                self.tableView.reloadData()
            }
        }
    }
}

extension ToursViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        tours.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TourCell",
            for: indexPath
        ) as! TourCell

        cell.configure(with: tours[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {

        let detailVC = TourDetailViewController(
            nibName: "TourDetailViewController",
            bundle: nil
        )
        detailVC.tour = tours[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
    }
}
