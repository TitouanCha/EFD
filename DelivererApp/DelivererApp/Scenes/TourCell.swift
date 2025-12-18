//
//  TourCell.swift
//  DelivererApp
//
//  Created by Hugo Miesch on 18/12/2025.
//

import UIKit

final class TourCell: UITableViewCell {

    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var parcelsLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor(red: 0xED/255, green: 0xE8/255, blue: 0xD0/255, alpha: 1) // beige
        selectionStyle = .none
    }

    func configure(with tour: Tour) {
        dateLabel.text = "Date : \(tour.date)"
        parcelsLabel.text = "Colis : \(tour.parcelIds.count)"

        switch tour.status {
        case "ASSIGNED":
            statusLabel.text = "Assignée"
            statusLabel.textColor = .systemOrange
        case "IN_PROGRESS":
            statusLabel.text = "En cours"
            statusLabel.textColor = .systemGreen
        case "COMPLETED":
            statusLabel.text = "Terminée"
            statusLabel.textColor = .systemGray
        default:
            statusLabel.text = tour.status
            statusLabel.textColor = .brown
        }
    }
}
