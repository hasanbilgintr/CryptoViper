//
//  Router.swift
//  CryptoViper
//
//  Created by hasan bilgin on 20.10.2023.
//

import Foundation
import UIKit



//Class , protocol
//EntryPoint (Giriş Noktası)

//2 prokol tanımlanamadığı için yapılıd
typealias EntryPoint = AnyView & UIViewController

//Any bir kuralı yok genelde yazılımcılar öle yazarlarmış
protocol AnyRouter {
    
    var entry : EntryPoint? {get}
    static func startExecution() -> AnyRouter
}

class CryptoRouter : AnyRouter {
    var entry: EntryPoint?
    
    
    static func startExecution() -> AnyRouter {
        let router = CryptoRouter()
        
        //verileri atadık
        var view : AnyView = CryptoViewController()
        var presenter : AnyPresenter = CryptoPresenter()
        var interactor : AnyInteractor = CryptoInteractor()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.router = router
        presenter.interactor = interactor
        
        interactor.presenter = presenter
        
        router.entry = view as? EntryPoint
        return router
    }
    
    
}



