//
//  TourCell.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 18/12/2025.
//

import UIKit

class TourCell: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var parcelsLabel: UILabel!

    func configure(with tour: Tour) {
        dateLabel.text = "\(tour.date)"
        parcelsLabel.text = "Colis : \(tour.parcelCount)"

        if tour.status == "COMPLETED" {
            statusLabel.text = "Terminée"
            statusLabel.textColor = .systemGreen
        } else {
            statusLabel.text = "En cours"
            statusLabel.textColor = .brown
        }
    }
}

