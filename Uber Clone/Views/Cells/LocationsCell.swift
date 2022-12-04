//
//  LocationsCell.swift
//  Uber
//
//  Created by Islam NourEldin on 03/10/2022.
//

import UIKit
import MapKit

class LocationsCell: UITableViewCell {
    
    static let identifier = String(describing: LocationsCell.self)
    
    var placemark:MKPlacemark?{
        didSet{
            titleLabel.text = placemark?.name
            addressLabel.text = placemark?.address
        }
    }
    
    let titleLabel:UILabel={
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    let addressLabel:UILabel={
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel,addressLabel])
        stackView.distribution = .fillEqually
        stackView.spacing = 4
        stackView.axis = .vertical
        
        addSubview(stackView)
        stackView.centerY(inView: self,leftAnchor: self.leftAnchor,paddingLeft: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        selectionStyle = .none
    }

}
