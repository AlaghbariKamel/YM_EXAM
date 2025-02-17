//
//  OrderVC.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//

import UIKit
import RxSwift
import RxCocoa

class OrderVC: UIViewController, UITableViewDelegate, UITableViewDataSource{

    private var oldLanguage =  SharedDefault.languageKey
    @IBOutlet weak var lbLastUserName: UILabel!
    @IBOutlet weak var lbFirstUserName: UILabel!
    private var  viewModel: OrderViewModel? = nil
    let disposeBag = DisposeBag()
    @IBOutlet weak var tableViewOrder: UITableView!
    @IBOutlet weak var emptyOrderView: UIView!
    @IBOutlet weak var segmnetOrders: CustomUISegmentedControl!
    private let refreshControl = UIRefreshControl()
    var userName : String? = nil
    private var deliveryBill: [DeliveryBillDB] = []
    
    @IBOutlet weak var img_logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: .languageChanged, object: nil)

        viewModel = OrderViewModel()
        
       
        subscribeToLoading()
        subscribeToErrorMessage()

        subscribeToResponse()
        setupTableView()
        fetchOrderData()
        
        if let userName = userName,!userName.isEmpty {
//            let filterUserName = userName.components(separatedBy: ":").first
            
            lbFirstUserName.text = userName.components(separatedBy: " ").first
          
            lbLastUserName.text = userName.components(separatedBy: " ").last
             
        }
        
        flipLogoImage()
        
    }
    
    @objc func languageChanged() {
        // تحديث جميع العناصر المخصصة
        updateLocalizationForAllControls()
    }

    func updateLocalization() {
       
    }
    func updateLocalizationForAllControls() {
        print(#file, #function)
        // تحديث النصوص
//        for subview in view.subviews {
//            if let localizableSubview = subview as?  UIButton {
//                if let title = localizableSubview.title(for: .normal) {
//                    localizableSubview.setTitle(title.localized, for: .normal)
//                }
//            }
//            if let localizableSubview = subview as? Localizable {
//                localizableSubview.updateLocalization()
//            }
//        }
        
        if self.viewIfLoaded?.window != nil {
            
            self.view.updateLocalizationKey()
        } else {
             print("The view is not loaded yet.")
        }

        // تحديث الاتجاهات
        let direction: UISemanticContentAttribute = (SharedDefault.languageKey == "ar") ? .forceRightToLeft : .forceLeftToRight
        print(direction.rawValue.description)

        // تحديث الـ appearance global
//        UIView.appearance().semanticContentAttribute = direction
//        UINavigationBar.appearance().semanticContentAttribute = direction
//        UITabBar.appearance().semanticContentAttribute = direction
//
//        // تحديث الـ ViewController
//        self.view.semanticContentAttribute = direction

        // إعادة تحميل الواجهة لتحديث العناصر
//        DispatchQueue.main.async {
//            self.view.setNeedsLayout()
//            self.view.layoutIfNeeded()
//            UIApplication.shared.windows.first?.semanticContentAttribute = direction

//        }

                    UIApplication.shared.getActiveMainKeyWindow?.reload()

       
    }

    override func viewDidLayoutSubviews() {
        
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: .languageChanged, object: nil)
    }
    
    func flipLogoImage()
    
    {
        if SharedDefault.languageKey == LocalizationManager.LanguageApp.Arabic.rawValue {
            img_logo.image = img_logo.image?.imageFlippedForRightToLeftLayoutDirection()
        }
          
    }
    
  
    private func setupTableView() {
       
        tableViewOrder.delegate = self
        tableViewOrder.dataSource = self
        tableViewOrder.register(UINib(nibName: "OrderTableViewCell", bundle: nil), forCellReuseIdentifier: "ReusableCell")
        refreshControl.addTarget(self, action: #selector(fetchOrderData), for: .valueChanged)
        tableViewOrder.refreshControl = refreshControl
        tableViewOrder.separatorStyle = .none
         
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        CheckAppLogout.sharedInstance.delegate = self
        LocalizationManager.shared.delegate = self
        AlertLanguage.sharedInstance.delegate = self
    }
    
    func subscribeToErrorMessage()
    {
        viewModel?.messageError.subscribe(onNext: {[weak self] errorMessage in
            guard let self = self else {return}
            DispatchQueue.main.async {
                
                self.displayMessage(titleMsg: "Error", message:  "\(errorMessage)" , messageStatus: .MessageError)
                
            }
            
        }).disposed(by: disposeBag)
    }
    
    func subscribeToLoading()
    {
        viewModel?.loadingBehavior.subscribe(onNext: {[weak self] isLoading in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if isLoading {
                    self.showLoadingDialog()
                } else {
                    
                    self.hideMyDialog()
                }
            }
        }).disposed(by: disposeBag)
    }

    
    
    func subscribeToResponse()
    {
        
        viewModel?.orderModelObservable.subscribe(onNext: {[weak self] result in
            
            guard let self = self else {return}
            DispatchQueue.main.async {
                
                self.refreshControl.endRefreshing()
                
                if let result = result,result.data.deliveryBills.count > 0
                {
                   
                    self.emptyOrderView.isHidden = true
                    self.tableViewOrder.isHidden = false
                    if self.segmnetOrders.selectedSegmentIndex == 0   {
                        self.deliveryBill = self.viewModel?.getNewOrderList() ?? []
                    }
                    else{
                        self.deliveryBill = self.viewModel?.getOtherOrderList() ?? []
                    }
                   
                    self.tableViewOrder.reloadData()
                    print(result)
                    
                }
                else {
                    self.tableViewOrder.isHidden = true
                    self.emptyOrderView.isHidden = false
 
                }
            }
            
        }).disposed(by: disposeBag)
    }
    
    
    
    @objc private func fetchOrderData() {
        
        if viewModel?.getOrderCount() == 0 {
            
            
            let orderValue = OrderValue(pDlvryNo: "1010", pLangNo: "1", pBillSrl: "", pPrcssdFlg: "")
            
            let orderRequest = OrderReuest(value: orderValue)
            
            if InternetConnectionManager.isConnectedToNetwork()
            {
                viewModel?.getOrders(orderReuest: orderRequest)
            }
            else
            {
                
                self.displayMessage(titleMsg: "Warning", message: "No Internet Connection", messageStatus: .MessageError)
            }
            
        }
        else{
            self.deliveryBill = self.viewModel?.getNewOrderList() ?? []
            tableViewOrder.reloadData()
        }
    }

    
    @IBAction func btnSetLanguage(_ sender: UIButton) {
        
        AlertLanguage.sharedInstance.showalertSetLanguage( self)
        
    }
    

    @IBAction func segmentOrders(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            
           
            
//            segmnetOrders.setTitleForgourndColor(.white)
//            segmnetOrders.selectedSegmentTintColor = UIColor.init(hexaString: "#004F62")
            
           
            self.deliveryBill = self.viewModel?.getNewOrderList() ?? []
            
        }
        else {
            self.deliveryBill = self.viewModel?.getOtherOrderList() ?? []
            
        }
        
        self.tableViewOrder.reloadData()
        
        if self.deliveryBill.count == 0 {
            self.fetchOrderData()
        }
    }
    

 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveryBill.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = deliveryBill [indexPath.row]
        
        if let  cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as? OrderTableViewCell
        {
            
            
            cell.varlbOrderId = data.billSrl
            cell.varlbDate = data.billDate
            cell.varlbTotalPrice = data.billAmt
            cell.varlbStatus = data.dlvryStatusFlg
            
            return cell
        }
        
        return UITableViewCell()
       
    }
    
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let post = deliveryBill[indexPath.row]
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
}



extension OrderVC : ICheckAppLogout
{
    func checkLogout(isLogout: Bool)
    {
        if isLogout
        {
 
            logoutApp()
        }
    }
    
    
}






extension OrderVC: LocalizationDelegate {
    
    func resetApp()
    {
       
        resetAppLanguage()
    }
    
    func resetAppLanguage()
    {
        
       
        if oldLanguage != LocalizationManager.shared.getLanguage()?.rawValue
        {
            
            oldLanguage = SharedDefault.languageKey
//            segmnetOrders.labelText = "new;others"
            flipLogoImage()
            deliveryBill.removeAll()
            fetchOrderData()
//            UIApplication.shared.getActiveMainKeyWindow?.reload()
            
            
            NotificationCenter.default.post(name: .languageChanged, object: nil)
            // تحديث الاتجاه بناءً على اللغة
    
           
//
           
        }
    }
}
   

extension OrderVC: IAlertDialogLanguage {

    
    func setLanguage(isLanguageUpdated: Bool) {
        if isLanguageUpdated {
            let currentLanguage = LocalizationManager.shared.getLanguage()
            
            if currentLanguage == .Arabic {
                LocalizationManager.shared.setLanguage(language: .English)
            } else {
                LocalizationManager.shared.setLanguage(language: .Arabic)
            }
            
          
        }
    }
}
