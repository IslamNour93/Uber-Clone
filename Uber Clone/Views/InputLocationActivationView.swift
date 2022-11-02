//
//  LocationInputActivationView.swift
//  Uber
//
//  Created by Islam NourEldin on 01/10/2022.
//

import UIKit

protocol LocationInputActivationViewDelegate:AnyObject{
    func presentLocationInputView()
}

class InputLocationActivationView: UIView {
    
    //MARK: - Properties
    
    weak var delegate:LocationInputActivationViewDelegate?
    
    private let dotView:UIView={
        let view = UIView()
        view.setDimensions(height: 6, width: 6)
        view.backgroundColor = .black
        return view
    }()
    
    private let placeholder:UILabel={
        let label = UILabel()
        label.text = "Where to?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    

    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        addingShadow(shadowColor: UIColor.black.cgColor,opacity: 0.45, offset: CGSize(width: 0.5, height: 0.5))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    private func configureView(){
        backgroundColor = .white
        addSubview(dotView)
        dotView.anchor(left:leftAnchor,paddingLeft: 16)
        dotView.centerY(inView: self)
        
        addSubview(placeholder)
        placeholder.anchor(left:dotView.rightAnchor,paddingLeft: 8)
        placeholder.centerY(inView: self)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePresentLocationInput))
        addGestureRecognizer(tap)
    }
    
    //MARK: - Actions
    
    @objc func handlePresentLocationInput(){
        delegate?.presentLocationInputView()
    }
    
}
