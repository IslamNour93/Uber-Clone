


import UIKit
//import JGProgressHUD

extension UIViewController {
//    static let hud = JGProgressHUD(style: .light)
    
    func configureGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.gray.cgColor,UIColor.black.cgColor]
        gradient.locations = [0,1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
//    func showLoader(_ show: Bool) {
//        view.endEditing(true)
//        
//        if show {
//            UIViewController.hud.show(in: view)
//        } else {
//            UIViewController.hud.dismiss()
//        }
//    }
    
    func showMessage(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

//MARK: - UIView Extension

extension UIColor{
    static func rgb(red:CGFloat,green:CGFloat,blue:CGFloat)->UIColor{
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    static let backgroundColor = UIColor.rgb(red: 25, green: 25, blue: 25)
    static let blueTintColor = UIColor.rgb(red: 17, green: 145, blue: 237)
}

extension UIView {
    
    func addingShadow(shadowColor:CGColor,opacity:Float=0,offset:CGSize){
        layer.shadowColor = shadowColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func center(inView view: UIView, yConstant: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: yConstant!).isActive = true
    }
    
    func centerX(inView view: UIView, topAnchor: NSLayoutYAxisAnchor? = nil, paddingTop: CGFloat? = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        if let topAnchor = topAnchor {
            self.topAnchor.constraint(equalTo: topAnchor, constant: paddingTop!).isActive = true
        }
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        
        if let left = leftAnchor {
            anchor(left: left, paddingLeft: paddingLeft)
        }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func fillSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let view = superview else { return }
        anchor(top: view.topAnchor, left: view.leftAnchor,
               bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func containerView(imageName:String,textField:UITextField?=nil,segmentControl:UISegmentedControl?=nil)->UIView{
        let view = UIView()
        let imageView = UIImageView()
        imageView.image = UIImage(named: imageName)
        imageView.clipsToBounds = true
        imageView.alpha = 0.87
        view.addSubview(imageView)
        
        
        if let textField = textField {
            imageView.anchor(left:view.leftAnchor,paddingLeft: 8,width: 24,height: 24)
            imageView.centerY(inView: view)
            
            view.addSubview(textField)
            
            textField.centerY(inView: imageView)
            textField.anchor(left:imageView.rightAnchor,
                                  right: view.rightAnchor,
                                  paddingLeft: 8,
                                  paddingRight: 8)
        }
        
        if let segmentControl = segmentControl {
            view.addSubview(segmentControl)
            imageView.anchor(top:view.topAnchor,left: view.leftAnchor,paddingLeft: 8,width: 24,height: 24)
            segmentControl.anchor(top:imageView.bottomAnchor,left:view.leftAnchor,right: view.rightAnchor,paddingTop: 8,paddingLeft: 8,paddingRight: 8)
        }
        
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = .lightGray
        view.addSubview(seperatorView)
        seperatorView.anchor(left:view.leftAnchor,
                    bottom: view.bottomAnchor,
                    right: view.rightAnchor,
                    paddingLeft: 8,
                    height: 0.75)
        return view
    }
}
    
    //MARK: - TextFieldExtension

    extension UITextField{
        func customTextField(placeholder: String,isSecured:Bool,height:CGFloat,foregroundColor:UIColor,textColor:UIColor){
            borderStyle = .none
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor:foregroundColor])
            setHeight(height)
            self.textColor = textColor
            autocorrectionType = .no
            isSecureTextEntry = isSecured
            keyboardAppearance = .dark
        }
    }

    //MARK: - ButtonExtension

    extension UIButton{
        
        func attributedTitle(firstPart:String,secondPart:String,fontSize:CGFloat){
            
            let atts : [NSAttributedString.Key:Any] = [.foregroundColor:UIColor(red: 8, green: 8, blue: 8, alpha: 0.87),.font:UIFont.systemFont(ofSize: fontSize)]
            let attributedTittle = NSMutableAttributedString(string: "\(firstPart) ", attributes: atts)
            
            let boldAtts : [NSAttributedString.Key:Any] = [.foregroundColor:UIColor(red: 0, green: 0, blue: 240, alpha: 0.87),.font:UIFont.boldSystemFont(ofSize: fontSize)]
            attributedTittle.append(NSAttributedString(string: secondPart, attributes: boldAtts))
            
            setAttributedTitle(attributedTittle, for: .normal)
        }
}
    
