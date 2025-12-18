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
        tableView.separatorStyle = .none

        let nib = UINib(nibName: "TourCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TourCell")
    }

    private func fetchTours() {
        AuthAPI.shared.getMyTours { tours in
            DispatchQueue.main.async {
                self.tours = tours
                self.tableView.reloadData()
            }
        }
    }
}

extension ToursViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = TourDetailViewController(
            nibName: "TourDetailViewController",
            bundle: nil
        )
        vc.tour = tours[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

