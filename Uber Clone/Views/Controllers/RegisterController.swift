//
//  RegisterController.swift
//  Uber
//
//  Created by Islam NourEldin on 22/09/2022.
//

import UIKit

class RegisterController: UIViewController {

    //MARK: - Properties
    
    private var viewModel = AuthenticationViewModel()
    
    private let location = LocationHandler.shared.locationManager.location
    
    weak var delegate:AuthenticationProtocol!
    
    private let logoLabel:UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Optima", size: 36)
        label.textColor = .gray
        return label
    }()
    
    private lazy var emailContainerView:UIView = {
        let view = UIView().containerView(imageName: "ic_mail_outline_white_2x", textField: emailTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var fullnameContainerView:UIView = {
        let view = UIView().containerView(imageName: "ic_person_outline_white_2x", textField: fullnameTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private let fullnameTextField:UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: "Fullname", isSecured: false, height: 50,foregroundColor: UIColor(white: 1, alpha: 0.7),textColor: .white)
        return tf
    }()
    
    private lazy var passwordContainerView:UIView = {
        let view = UIView().containerView(imageName: "ic_lock_outline_white_2x", textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return view
    }()
    
    private lazy var accoutTypeContainerView:UIView={
        let view = UIView().containerView(imageName: "ic_account_box_white_2x",segmentControl: accountTypeSegmentControl)
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    
    private let emailTextField:UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: "Email", isSecured: false, height: 50,foregroundColor: UIColor(white: 1, alpha: 0.7),textColor: .white)
        return tf
    }()
    
    private let passwordTextField:UITextField = {
        let tf = UITextField()
        tf.customTextField(placeholder: "Password", isSecured: true, height: 50,foregroundColor: UIColor(white: 1, alpha: 0.7),textColor: .white)
        return tf
    }()
    
    private let accountTypeSegmentControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Rider","Driver"])
        sc.backgroundColor = .backgroundColor
        sc.selectedSegmentTintColor = .blueTintColor
        sc.tintColor = UIColor(white: 1, alpha: 0.87)
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    private lazy var signUpButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .blueTintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.setHeight(50)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveanAccountButton:UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign up", fontSize: 15)
        button.addTarget(self, action: #selector(handleNavigateToLogin), for: .touchUpInside)
        return button
    }()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    //MARK: - Actions
    
    @objc func handleNavigateToLogin(){
        navigationController?.popViewController(animated: false)
    }
    
    @objc func handleSignUp(){
        print("did press sign up button")
        
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullnameTextField.text else {return}
        
        let type = accountTypeSegmentControl.selectedSegmentIndex
        var userType:UserType
        if type == 0{
            userType = .passenger
        }else{
            userType = .driver
        }
        let credential = Credentials(email: email, fullname: fullname, password: password, userType: type)
        
        configureTextFields()
        guard let location = location else {
            return
        }
        viewModel.signup(withCredential: credential,userType: .driver,driverLocation: location) { [weak self] error in
            
            if let error = error {
                self?.showMessage(withTitle: "Can't sign up", message: error.localizedDescription)
                return
            }
            self?.viewModel.signUserIn(withEmail: email, password: password) { authData, error in
                if authData != nil {
                    DispatchQueue.main.async {
                        self?.delegate.didCompleteSignup()
                    }
                }
            }
        }
        
    }
    //MARK: - Helpers
    
    private func configureUI(){
        view.backgroundColor = .backgroundColor
        view.addSubview(logoLabel)
        logoLabel.centerX(inView: view)
        logoLabel.anchor(top:view.topAnchor,paddingTop: 64)
        
        view.addSubview(emailContainerView)
        view.addSubview(passwordContainerView)
        view.addSubview(accoutTypeContainerView)
        view.addSubview(signUpButton)
        view.addSubview(alreadyHaveanAccountButton)
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,fullnameContainerView,accoutTypeContainerView,signUpButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillProportionally
        
        view.addSubview(stack)
        
        stack.anchor(top:logoLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 48,paddingLeft: 16,paddingRight: 16)
        
        alreadyHaveanAccountButton.centerX(inView: view)
        alreadyHaveanAccountButton.anchor(bottom:view.bottomAnchor,paddingBottom: 24)
    }
    
    private func configureTextFields(){
        if emailTextField.text == nil || emailTextField.text == ""{
            showMessage(withTitle: "Empty Feild!!", message: "You must fill your email")
        }else if passwordTextField.text == nil || passwordTextField.text == ""{
            showMessage(withTitle: "Empty Feild!!", message: "You must fill your password")
        }
        else if fullnameTextField.text == nil || fullnameTextField.text == ""{
            showMessage(withTitle: "Empty Feild!!", message: "You must fill your fullname")
        }
    }

}
