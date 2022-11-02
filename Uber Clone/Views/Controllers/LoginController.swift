//
//  LoginController.swift
//  Uber
//
//  Created by Islam NourEldin on 11/09/2022.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Properties
    
    private var viewModel=AuthenticationViewModel()
    
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
    
    private lazy var passwordContainerView:UIView = {
        let view = UIView().containerView(imageName: "ic_lock_outline_white_2x", textField: passwordTextField)
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
    
    private lazy var loginButton:UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = .blueTintColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        button.setHeight(50)
        button.addTarget(self, action: #selector(handlesignIn), for: .touchUpInside)
        return button
    }()
    
    private lazy var dontHaveanAccountButton:UIButton = {
        let button = UIButton(type: .system)
        button.attributedTitle(firstPart: "Don't have an account?", secondPart: "Sign up", fontSize: 15)
        button.addTarget(self, action: #selector(handleNavigateToSignup), for: .touchUpInside)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    //MARK: - Actions
    
    @objc func handlesignIn(){
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        viewModel.signUserIn(withEmail: email, password: password) {[weak self] result, error in
            if let error = error {
                self?.showMessage(withTitle: "Can't sign in", message: error.localizedDescription)
                return
            }
            if result != nil{
            self?.delegate.didCompleteSignup()
            }
        }
    }
    
    
    @objc func handleNavigateToSignup(){
        print("Did press Don't have an account")
        let controller = RegisterController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: false)
    }
    

    //MARK: - Helpers
    
    private func configureUI(){
        configureNavigationBar()
        view.backgroundColor = .backgroundColor
        view.addSubview(logoLabel)
        logoLabel.centerX(inView: view)
        logoLabel.anchor(top:view.topAnchor,paddingTop: 64)
        
        view.addSubview(emailContainerView)
        view.addSubview(passwordContainerView)
        view.addSubview(loginButton)
        view.addSubview(dontHaveanAccountButton)
        
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,passwordContainerView,loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        
        stack.anchor(top:logoLabel.bottomAnchor,left: view.leftAnchor,right: view.rightAnchor,paddingTop: 48,paddingLeft: 16,paddingRight: 16)
    
        dontHaveanAccountButton.centerX(inView: view)
        dontHaveanAccountButton.anchor(bottom:view.bottomAnchor,paddingBottom: 24)
    }
  
    private func configureNavigationBar(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }

}
