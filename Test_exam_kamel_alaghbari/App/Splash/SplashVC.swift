//
//  SplashVC.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//

import UIKit

class SplashVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
      
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { [weak self]   in
           guard let self = self else {return}
 
           self.startApp()
 
            
        })
        
    }
     

}



