//
//  MyParcelsViewController.swift
//  UserApp
//
//  Created by Luca Guilliere on 18/12/2025.
//

import UIKit

final class MyParcelsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    private var parcels: [Parcel] = []

        override func viewDidLoad() {
            super.viewDidLoad()
            title = "Mes colis"

            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

            navigationItem.rightBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(didTapAdd)
            )

            loadParcels()
        }

        @objc private func didTapAdd() {
            navigationController?.pushViewController(CreateParcelViewController(), animated: true)
        }

        private func loadParcels() {
            Task {
                do {
                    let data = try await APIClient.shared.getMyParcels()
                    await MainActor.run {
                        self.parcels = data
                        self.tableView.reloadData()
                    }
                } catch {
                    print("getMyParcels error:", error)
                }
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            loadParcels()
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            parcels.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let p = parcels[indexPath.row]
            let status = p.status ?? ""
            cell.textLabel?.text = status.isEmpty ? p.trackingId : "\(p.trackingId) — \(status)"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
}

