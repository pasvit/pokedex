//
//  UITableView+extensions.swift
//  Pokedex
//
//  Created by Pasquale Vitulli on 03/05/21.
//

import UIKit

extension UITableView {
    func updateRow(row: Int, section: Int = 0) {
        let indexPath = IndexPath(row: row, section: section)
        self.beginUpdates()
        self.reloadRows(at: [indexPath], with: .fade)
        self.endUpdates()
    }
}
