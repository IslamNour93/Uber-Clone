//
//  ConfirmTripView.swift
//  Uber Clone
//
//  Created by Islam on 06/12/2022.
//

import UIKit
import MapKit


protocol ConfirmTripDelegate:AnyObject{
    func confirmTrip(_ confirmTripView:ConfirmTripView)
}
class ConfirmTripView: UIView {

    //MARK: - Properties

    var selectedPlacemark:MKPlacemark?{
        didSet{
            placemarkTitle.text = selectedPlacemark?.name
            placemarkAddress.text = selectedPlacemark?.address
        }
    }
    
    weak var delegate:ConfirmTripDelegate?
    
    private let placemarkTitle:UILabel={
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Fayoum Cafe"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let placemarkAddress:UILabel={
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "123 khalifa st"
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var uberxView:UIView={
       let view = UIView()
        view.setDimensions(height: 60, width: 60)
        view.backgroundColor = .black
        view.layer.cornerRadius = 60/2
        
        let label = UILabel()
        label.textColor = .white
        label.text = "X"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        view.addSubview(label)
        label.centerX(inView: view)
        label.centerY(inView: view)
        return view
    }()
    
    private let uberXlabel:UILabel={
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Uber X"
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let seperatorView:UIView={
       let view = UIView()
        view.setHeight(0.5)
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var confirmButton:UIButton={
        let button = UIButton(type: .system)
        button.backgroundColor = .black
        button.setTitle("Confirm UberX", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleTripConfirmation), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        let stack = UIStackView(arrangedSubviews: [placemarkTitle,placemarkAddress])
        
        stack.spacing = 4
        stack.axis = .vertical
        stack.distribution = .fillEqually
        
        addSubview(stack)
        
        stack.anchor(top:topAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 16,paddingLeft: 16,paddingRight: 16,height: 50)
        addingShadow(shadowColor: UIColor.black.cgColor, opacity: 0.3, offset: .zero)
        
        addSubview(uberxView)
        
        uberxView.anchor(top:stack.bottomAnchor,paddingTop: 16)
        uberxView.centerX(inView: self)
        
        addSubview(uberXlabel)
        uberXlabel.anchor(top:uberxView.bottomAnchor,paddingTop: 8)
        uberXlabel.centerX(inView: uberxView)
        
        addSubview(seperatorView)
        
        seperatorView.anchor(top:uberXlabel.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 2)
        
        addSubview(confirmButton)
        confirmButton.anchor(top:seperatorView.bottomAnchor,left: leftAnchor,right: rightAnchor,paddingTop: 16,paddingLeft: 16,paddingRight: 16,height: 50)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleTripConfirmation(){
        delegate?.confirmTrip(self)
    }
}
