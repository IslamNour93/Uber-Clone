//
//  LocationInputView.swift
//  Uber
//
//  Created by Islam NourEldin on 01/10/2022.
//

import UIKit

protocol InputLocationViewDelegate:AnyObject{
    func dismissInputLocationView()
}


class InputLocationView: UIView {

    //MARK: - Properties
    
    weak var delegate:InputLocationViewDelegate?
    
    private let backButton:UIButton={
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "baseline_arrow_back_black_36dp")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
    let titleLabel:UILabel={
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let startPointView:UIView={
        let view = UIView()
        view.setDimensions(height: 4, width: 4)
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let destinationLineView:UIView={
        let view = UIView()
        view.setWidth(2)
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let endPointView:UIView={
        let view = UIView()
        view.setDimensions(height: 6, width: 6)
        view.backgroundColor = .black
        return view
    }()
    
    private let currentLocationTextField:UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: " Current Location", isSecured: false, height: 30,foregroundColor: .lightGray,textColor: .white)
        tf.backgroundColor = .groupTableViewBackground
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.isEnabled = false
        return tf
    }()
    
    private let destinationTextField:UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: " Enter a destination", isSecured: false, height: 30,foregroundColor: .gray,textColor: .white)
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.backgroundColor = .lightGray
        tf.returnKeyType = .search
        return tf
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
        
        addSubview(backButton)
        
        backButton.anchor(top:topAnchor,left: leftAnchor,paddingTop: 48,paddingLeft: 8,width: 22,height: 22)
        
        addSubview(titleLabel)
        titleLabel.centerX(inView: self)
        titleLabel.centerY(inView: backButton)
        
        addSubview(startPointView)
        startPointView.anchor(top:backButton.bottomAnchor,left:leftAnchor,paddingTop: 32,paddingLeft: 16)
        
        addSubview(destinationLineView)
        destinationLineView.anchor(top:startPointView.bottomAnchor,paddingTop: 4,height: 40)
        destinationLineView.centerX(inView: startPointView)
        
        addSubview(endPointView)
        endPointView.anchor(top:destinationLineView.bottomAnchor)
        endPointView.centerX(inView: startPointView)
        
        addSubview(currentLocationTextField)
        currentLocationTextField.centerY(inView: startPointView)
        currentLocationTextField.anchor(left:startPointView.rightAnchor,right: rightAnchor,paddingLeft: 8,paddingRight: 32)
        
        addSubview(destinationTextField)
        destinationTextField.centerY(inView: endPointView)
        destinationTextField.anchor(left:endPointView.rightAnchor,right: rightAnchor,paddingLeft: 8,paddingRight: 32)
    }
    
    //MARK: - Actions
    
    @objc func handleBackTapped(){
        delegate?.dismissInputLocationView()
    }
}
