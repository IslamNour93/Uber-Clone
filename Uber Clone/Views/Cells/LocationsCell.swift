//
//  LocationsCell.swift
//  Uber
//
//  Created by Islam NourEldin on 03/10/2022.
//

import UIKit

class LocationsCell: UITableViewCell {
    
    static let identifier = String(describing: LocationsCell.self)

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }

}
