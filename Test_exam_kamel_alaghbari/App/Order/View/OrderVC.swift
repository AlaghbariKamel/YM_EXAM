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
        updateLocalizationForAllControls()
    }

   
    func updateLocalizationForAllControls() {

        
        if self.viewIfLoaded?.window != nil {
            
            self.view.updateLocalizationKey()
        } else {
             print("The view is not loaded yet.")
        }

       
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
        tableViewOrder.backgroundColor = .clear
         
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
             
                if  result > 0
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
                    
                    
                }
                else {
                    self.tableViewOrder.isHidden = true
                    self.emptyOrderView.isHidden = false
 
                }
            }
            
        }).disposed(by: disposeBag)
    }
    
    
    
    @objc private func fetchOrderData()
    {
        
        if viewModel?.getOrderCount() == 0
        {
            
            
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
        else
        {
            
           
            
            if self.segmnetOrders.selectedSegmentIndex == 0   {
                self.deliveryBill = self.viewModel?.getNewOrderList() ?? []
            }
            else{
                self.deliveryBill = self.viewModel?.getOtherOrderList() ?? []
            }
       
            tableViewOrder.reloadData()
        }
    }

    
    @IBAction func btnSetLanguage(_ sender: UIButton) {
        
        AlertLanguage.sharedInstance.showalertSetLanguage( self)
        
    }
    

    @IBAction func segmentOrders(_ sender: UISegmentedControl) {
       
        fetchOrderData()
         
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
            
            let index = segmnetOrders.selectedSegmentIndex
            
            flipLogoImage()
            deliveryBill.removeAll()
            tableViewOrder.reloadData()
            UIApplication.shared.getActiveMainKeyWindow?.reload()
            segmnetOrders.selectedSegmentIndex = index
            fetchOrderData()
            
            NotificationCenter.default.post(name: .languageChanged, object: nil)

           
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
