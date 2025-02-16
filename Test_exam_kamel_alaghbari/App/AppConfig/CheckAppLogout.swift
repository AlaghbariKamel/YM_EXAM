//
//  CheckAppLogout.swift
//  Test_exam_kamel_alaghbari
//
//  Created by Kamel Alaghbari on 05/02/2025.
//


class CheckAppLogout {
    
    weak var delegate:ICheckAppLogout?
    static let sharedInstance: CheckAppLogout = CheckAppLogout()
    
    init() {}
    
    func checkIsLogout()  {
        self.delegate?.checkLogout(isLogout: true)
    }
    
}


protocol ICheckAppLogout : AnyObject {

    func checkLogout(isLogout:Bool)
    
}
