//
//  CustomUi.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//
import UIKit

class MyCustomView: UIView {
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadiusShadow: CGFloat = 12.0
    //    private var fillColor: UIColor = .lightGray // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    
    @IBInspectable var setAsCircle: Bool = false {
        didSet
        {
            if setAsCircle
            {
                asCircle()
            }
            
        }
    }
    @IBInspectable var hasShadow: Bool = false
    
    func setShadowLayer()
    {
        
        if shadowLayer == nil
        {
            shadowLayer = CAShapeLayer()
            
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadiusShadow).cgPath
            shadowLayer.fillColor = UIColor.white.cgColor
            
            shadowLayer.shadowColor = UIColor.lightGray.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = cornerRadiusShadow //3
            layer.insertSublayer(shadowLayer, at: 0)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
      
        if hasShadow
        {
            setShadowLayer()
        }
        
        if setAsCircle
        {
             
            layer.borderColor = UIColor.systemRed.cgColor
             
        }
    }
    
    func asCircle()
    {
        self.layer.cornerRadius = self.frame.width / 2;
        self.layer.masksToBounds = true
        
    }
    
     
    
}
 

class RoundShadowView: UIView
{
    
    let containerView = UIView()
    let varCornerRadius: CGFloat = 12.0
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView.isUserInteractionEnabled = true
        //        layoutView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        containerView.isUserInteractionEnabled = true
    }
    
    
    //corners: UIRectCorner, radius: CGFloat
    
    func layoutView() {
        
        // set the shadow of the view's layer
        layer.backgroundColor = UIColor.white.cgColor
        layer.shadowColor = UIColor.label.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
        layer.cornerRadius = varCornerRadius
       
        containerView.layer.cornerRadius = varCornerRadius
        containerView.layer.masksToBounds = true
        containerView.isUserInteractionEnabled = true
        
        
        addSubview(containerView)
        sendSubviewToBack(containerView)
 
        // add constraints
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        // pin the containerView to the edges to the view
        containerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutView()
    }
}


extension UIView {
    @IBInspectable dynamic var cornerRadius: CGFloat
        {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    @IBInspectable dynamic var borderWidth: CGFloat
        {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    @IBInspectable dynamic var borderColor: UIColor?
        {
        set{ self.layer.borderColor = newValue?.cgColor }
        get{ return UIColor(cgColor: self.layer.borderColor!) }
    }
    
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
         let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
         let mask = CAShapeLayer()
         mask.path = path.cgPath
         layer.mask = mask
     }
}


extension UIApplication {
    
    
    static func topViewControllerInNavigationStack(controller: UIViewController? = UIApplication.shared.connectedScenes.filter({$0.activationState == .foregroundActive})
                                            .compactMap({$0 as? UIWindowScene}).first?.windows
                                            .filter({$0.isKeyWindow}).first?.rootViewController) -> UIViewController?
    {
        if let navigationController = controller as? UINavigationController {
            return topViewControllerInNavigationStack(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewControllerInNavigationStack(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewControllerInNavigationStack(controller: presented)
        }
        return controller
    }
    
    
}


extension UIAlertController {
    static func dismissPresentedAlertViewController() {
        let viewController = UIApplication.topViewControllerInNavigationStack()
        guard let isKindOf = viewController?.isKind(of: UIAlertController.classForCoder()), isKindOf else {
            return
        }
        viewController?.dismiss(animated: false, completion: nil)
        
        guard let isKindOf1 = viewController?.isKind(of: UIPresentationController.classForCoder()), isKindOf1 else {
            return
        }
    }
}
 


extension UIViewController {
    
    
    func logoutApp()
    {
        UIAlertController.dismissPresentedAlertViewController()
        
        let className = NSStringFromClass(LoginVC().classForCoder)
        
        
        
        let foundPermessionIndex = navigationController?.viewControllers.firstIndex(where: {NSStringFromClass($0.classForCoder) == className}) ?? -1
        if foundPermessionIndex > 0
        {
            
            let login = navigationController?.viewControllers[foundPermessionIndex]
            
            self.navigationController?.popToViewController(login!, animated: true)
        }
        else
        {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    func startApp(vc :UIViewController = LoginVC.instantiate(fromAppStoryboard: .Login))
    {
        guard let window = self.view.window else { return }
        
 
        
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationController?.navigationBar.tintColor = .white
        vc.navigationController?.navigationBar.isTranslucent = true
         
        
        
        let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize:  17),.foregroundColor: UIColor.white]
        vc.navigationController?.navigationBar.titleTextAttributes =  attributes
        let appearance = UINavigationBarAppearance()
           appearance.configureWithTransparentBackground()
        vc.navigationController?.navigationBar.standardAppearance = appearance
        vc.navigationController?.navigationBar.update(backroundColor: .white, titleColor: .white)
         view.window?.rootViewController = nav

        
        let options: UIView.AnimationOptions = .transitionCrossDissolve
        let duration: TimeInterval = 0.3
        UIView.transition(with:window, duration: duration, options: options, animations: nil, completion: nil)
 
      
        
    }
}


extension UINavigationBar {
 
    func update(backroundColor: UIColor? = .clear, titleColor: UIColor? = .white) {
       
        if #available(iOS 15, *)
        {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
           
         
            if let backroundColor = backroundColor {
                appearance.backgroundColor = backroundColor
            }
            if let titleColor = titleColor {
                
                appearance.titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16 ),NSAttributedString.Key.foregroundColor: titleColor]
                
            }
            standardAppearance = appearance
            scrollEdgeAppearance = appearance
            
        } else {
            barStyle = .default
            if let backroundColor = backroundColor {
                barTintColor = backroundColor
            }
            if let titleColor = titleColor {
                
                    titleTextAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 16),NSAttributedString.Key.foregroundColor: titleColor]
            }
            
        }
    }
    
    
}

extension UIColor {
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        self.init(hexa: UInt(hexaString.dropFirst(), radix: 16) ?? 0, alpha: alpha)
    }
    convenience init(hexa: UInt, alpha: CGFloat = 1) {
        self.init(red:   .init((hexa & 0xff0000) >> 16) / 255,
                  green: .init((hexa & 0xff00  ) >>  8) / 255,
                  blue:  .init( hexa & 0xff    )        / 255,
                  alpha: alpha)
    }
}

extension UIColor {
    public convenience init?(hex: String) {
        let r, g, b, a: CGFloat
        
        if hex.hasPrefix("#") {
            let start = hex.index(hex.startIndex, offsetBy: 1)
            let hexColor = String(hex[start...])
            
            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0
                
                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255
                    
                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }
        }
        
        return nil
    }
    
}



extension String {
    func format2D(number:Int)-> String
    {
        return String(format: "%02d", number)
    }

  
    func roundedDouble(value:Double) -> String
    {
        return String(format: "%.2f", value)
    }
}


extension StringProtocol {
    
    var double: Double? { Double(self) }
    
}



class CustomUISegmentedControl: UISegmentedControl
{
    
    @IBInspectable var labelText: String? = "" {
        didSet {
            
            let str = labelText?.components(separatedBy: ";")
            
            if (str?.count)! > 0
            {
                for i in 0..<str!.count
                {
                    
                    if str?[i].trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
                    {
                     
                        
                        setTitle(str![i].localized, forSegmentAt: i)
                    }
                    
                }
            }
            
        }
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        //        super.willMove(toSuperview: newSuperview)
        
        guard newSuperview != nil else {
            return
        }
        
        
        if #available(iOS 13.0, *) {
            let font = UIFont.systemFont(ofSize: 16, weight: .bold)
            self.setTitleTextAttributes([NSAttributedString.Key.font: font as Any], for: .normal)
//            if(self.isSelected)
//            {
                backgroundColor = .white
                setTitleForgourndColor(.white)
                selectedSegmentTintColor = UIColor.init(hexaString: "#004F62")
//            }
//            else{
//                backgroundColor = .white
//                setTitleForgourndColor(UIColor.init(hexaString: "#004F62"))
//                selectedSegmentTintColor = UIColor.init(hexaString: "#004F62")//#004F62
//            }
          
           
            
            
        }
        
    }
   
}


extension UISegmentedControl {
    
    func setTitleBackgroundColor(_ color: UIColor, state: UIControl.State = .normal)
    {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.strokeColor] = color
        
        self.setTitleTextAttributes(attributes, for: state)
    }
    func setTitleForgourndColor(_ color: UIColor, state: UIControl.State = .normal)
    {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.foregroundColor] = color
        
        self.setTitleTextAttributes(attributes, for: state)
    }
    func setTitleFont(_ font: UIFont, state: UIControl.State = .normal) {
        var attributes = self.titleTextAttributes(for: state) ?? [:]
        attributes[.font] = font
        self.setTitleTextAttributes(attributes, for: state)
    }
    
}


extension  UIApplication {
    
    var getActiveMainKeyWindow: UIWindow? {
        if #available(iOS 13, tvOS 13, *) {
            let activeScenes = connectedScenes.filter({$0.activationState == UIScene.ActivationState.foregroundActive})
            return (activeScenes.count > 0 ? activeScenes : connectedScenes)
                .flatMap {  ($0 as? UIWindowScene)?.windows ?? [] }
                .first { $0.isKeyWindow }
        } else {
            return keyWindow
        }
        
 
    }
    
    
}

public extension UIWindow {

    /// Unload all views and add them back
    /// Used for applying `UIAppearance` changes to existing views
    func reload() {
        subviews.forEach { view in
            view.removeFromSuperview()
            addSubview(view)
        }
    }
}



public protocol FilePathConvertible {
    var url: URL { get }
    var path: String { get }
}

extension FilePathConvertible {
    var isEmptyPath: Bool {
        return path.isEmpty
    }
}

extension String: FilePathConvertible {
    public var url: URL {
        return URL(fileURLWithPath: self)
    }

    public var path: String {
        return self
    }
}

extension URL: FilePathConvertible {
    public var url: URL {
        return self
    }
}



@IBDesignable
class CustomButton: UIButton {

    @IBInspectable
    var flippedForRightToLeftLayoutDirection: Bool = false {
        didSet {
            if flippedForRightToLeftLayoutDirection {
                let flippedImage = self.currentImage?.imageFlippedForRightToLeftLayoutDirection()
                self.setImage(flippedImage, for: .normal)
            }
        }
    }
    
    @IBInspectable var localize: String? = "" {
        didSet {
            guard let localize = localize, !localize.isEmpty else { return }
            let localizedText = localize.localized
            setTitle(localizedText, for: .normal)
            setTitle(localizedText, for: .disabled)
            if changeFontSize {
                updateAttributedTitle(with: localizedText)
            }
        }
    }

    @IBInspectable var changeFontSize: Bool = false {
        didSet {
            if let text = localize, !text.isEmpty {
                updateAttributedTitle(with: text.localized)
            }
        }
    }

    private func updateAttributedTitle(with text: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
        ]
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        self.setAttributedTitle(attributedText, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        guard newSuperview != nil else { return }
        configureLayerProperties()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if borderWidth > 0 {
            configureLayerProperties()
        }
        configureImageAndTitleLayout()
    }
    
    private func configureLayerProperties() {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor?.cgColor
    }

    @IBInspectable var alignImageToLeft: Bool = false
    @IBInspectable var alignImageToLeftCheckBox: Bool = false

    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let isRTL = SharedDefault.languageKey == LocalizationManager.LanguageApp.Arabic.rawValue
        let imageRect = super.imageRect(forContentRect: contentRect)
        let offset = isRTL ? (alignImageToLeftCheckBox ? contentRect.maxX - imageRect.maxX + 5 : contentRect.minX - imageRect.minX + 6)
                           : (alignImageToLeftCheckBox ? contentRect.minX - imageRect.minX - 5 : contentRect.maxX - imageRect.maxX - 6)
        return imageRect.offsetBy(dx: offset, dy: 0.0)
    }

    private func configureImageAndTitleLayout() {
        if alignImageToLeft {
            self.imageView?.layer.transform = CATransform3DMakeScale(1.3, 1.3, 1.3)
            let isRTL = SharedDefault.languageKey == LocalizationManager.LanguageApp.Arabic.rawValue
            semanticContentAttribute = isRTL ? .forceRightToLeft : .forceLeftToRight
            contentHorizontalAlignment = isRTL ? .right : .left
            
            let availableSpace = bounds.inset(by: contentEdgeInsets)
            let imageWidth = imageView?.frame.width ?? 0
            let titleWidth = titleLabel?.frame.width ?? 0
            let availableWidth = availableSpace.width - imageEdgeInsets.left - imageWidth - titleWidth
            
            titleEdgeInsets = isRTL
                ? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (availableWidth / 2) - (imageWidth / 2))
                : UIEdgeInsets(top: 0, left: (availableWidth / 2) - (imageWidth / 2), bottom: 0, right: 0)
        }
    }
}


@IBDesignable
class CustomTextField: UITextField {
    
    var img :UIImageView? = UIImageView()
    weak var imgTintColor:UIColor? = UIColor.clear
    
    
    @IBInspectable var localizedTxt: String? = "" {
        didSet
        {
            guard let localizedTxt = localizedTxt,!localizedTxt.isEmpty else{return}
            text = localizedTxt.localized
        }
    }
    @IBInspectable var localizedPlaceholder: String? = "" {
        didSet
        {
            guard let localizedPlaceholder = localizedPlaceholder,!localizedPlaceholder.isEmpty else{return}
            attributedPlaceholder = NSAttributedString(string: localizedPlaceholder.localized, attributes: [NSAttributedString.Key.foregroundColor :UIColor.lightGray])
        }
    
    }
    
    var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: 0, left: paddingValue, bottom: 0, right: paddingValue)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    
    //    var sidePadding = CGFloat(10) // Needed padding, add property observers
    
    override func sizeToFit() {
        super.sizeToFit()
        bounds.size.width += 2 * paddingValue
    }
    
    override func drawText(in rect: CGRect) {
      
        super.drawText(in: rect.insetBy(dx: paddingValue, dy: 0))
        invalidateIntrinsicContentSize()
    }
    
    @IBInspectable var paddingValue: CGFloat = 0
    
    
    @IBInspectable var toggelImage: UIImage? {
        didSet {
            guard let toggelImage = toggelImage else
            {
                return
            }
            
            img?.image = toggelImage
            
            
        }
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    override func draw(_ rect: CGRect) {
        self.layer.cornerRadius = self.cornerRadius
        self.layer.borderWidth = self.borderWidth
        self.layer.borderColor = self.borderColor?.cgColor
        
        if img?.image != nil
        {
            let leftVeiwView = UIView(frame: CGRect(x: 10, y: 0, width: 40, height: 40))
            
            leftView = leftVeiwView
            leftViewMode = .always
            
            var iconImage = UIImageView(frame: CGRect(x: 0, y: 5, width: 40, height: 40))
            
            if self.semanticContentAttribute == .forceLeftToRight
            {
                iconImage = UIImageView(frame: CGRect(x: 7, y: 5, width: 40, height: 40))
            }
            iconImage.image = img?.image
            
            leftVeiwView.addSubview(iconImage)
        }
        
    }
}



@IBDesignable
class CustomLabel: UILabel {
    
    @IBInspectable var localize: String? = "" {
        didSet {
            if let labelText = localize,!labelText.isEmpty
            {
                self.text = labelText.localized
            }
            
        }
    }
    
    
    var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: 0, left: paddingValue, bottom: 0, right: paddingValue)
        }
    }
    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        
        return bounds.inset(by: padding)
    }
    
    
    //    var sidePadding = CGFloat(10) // Needed padding, add property observers
    
    override func sizeToFit() {
        super.sizeToFit()
        bounds.size.width += 2 * paddingValue
    }
    
    override func drawText(in rect: CGRect) {
      
        super.drawText(in: rect.insetBy(dx: paddingValue, dy: 0))
        invalidateIntrinsicContentSize()
    }
    
    @IBInspectable var paddingValue: CGFloat = 0
    
    @IBInspectable var reportAlignment : Bool = false
    {
        didSet {
            if textAlignment != .center ,!self.reportAlignment
            {
                

                if  SharedDefault.languageKey == LocalizationManager.LanguageApp.English.rawValue
                {
                    self.textAlignment = .left

                }
                else
                {
                    self.textAlignment = .right
                }
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        
        
        guard newSuperview != nil else {
            return
        }
        
        
        
        if #available(iOS 13.0, *)
        {
            
            self.layer.cornerRadius = self.cornerRadius
            self.layer.borderWidth = self.borderWidth
            self.layer.borderColor = self.borderColor?.cgColor
            
            
            
        }
        
        
    }
}





extension UIImageView {
    @IBInspectable
    var changeColor: UIColor? {
        get {
            let color = UIColor(cgColor: layer.borderColor!);
            return color
        }
        set {
            let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
            self.image = templateImage
            self.tintColor = newValue
        }
    }
    
//    let flippedImage = originalImage.withHorizontallyFlippedOrientation()
    // @IBInspectable var localize: String? = "" {
    
    
    func fixedOrientation() -> UIImage?
    {
        
        guard self.image?.imageOrientation != UIImage.Orientation.up else {
            //This is default orientation, don't need to do anything
            return self.copy() as? UIImage
        }
        
        guard let cgImage = self.image?.cgImage else {
            //CGImage is not available
            return nil
        }
        
        guard let colorSpace = cgImage.colorSpace, let ctx = CGContext(data: nil, width: Int((self.image?.size.width)!), height: Int((self.image?.size.height)!), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            return nil //Not able to create CGContext
        }
        
        var transform: CGAffineTransform = CGAffineTransform.identity
        
        switch self.image?.imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: (self.image?.size.width)!, y: (self.image?.size.height)!)
            transform = transform.rotated(by: CGFloat.pi)
            break
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: (self.image?.size.width)!, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2.0)
            break
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: (self.image?.size.height)!)
            transform = transform.rotated(by: CGFloat.pi / -2.0)
            break
        case .up, .upMirrored:
            break
        case .none:
           break
        case .some(_):
            break
        }
        
        //Flip image one more time if needed to, this is to prevent flipped image
        switch self.image?.imageOrientation  {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: (self.image?.size.width)!, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: (self.image?.size.height)!, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        case .none:
            break
        case .some(_):
            break
        }
        
        ctx.concatenate(transform)
        
        switch self.image?.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            ctx.draw((self.image?.cgImage)!, in: CGRect(x: 0, y: 0, width: (self.image?.size.height)!, height: (self.image?.size.width)!))
        default:
            ctx.draw((self.image?.cgImage)!, in: CGRect(x: 0, y: 0, width: (self.image?.size.width)!, height: (self.image?.size.height)!))
            break
        }
        
        guard let newCGImage = ctx.makeImage() else { return nil }
        return UIImage.init(cgImage: newCGImage, scale: 1, orientation: .up)
    }
}
