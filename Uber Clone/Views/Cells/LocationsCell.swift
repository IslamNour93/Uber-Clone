//
//  LocationsCell.swift
//  Uber
//
//  Created by Islam NourEldin on 03/10/2022.
//

import UIKit

class LocationsCell: UITableViewCell {
    
    static let identifier = String(describing: LocationsCell.self)
    
    let titleLabel:UILabel={
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Coffe Hankasha"
        return label
    }()
    
    let addressLabel:UILabel={
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        label.text = "123 st Fayoum"
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.addSubview(titleLabel)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectionStyle = .none
    }

}
