//
//  Presenter.swift
//  CryptoViper
//
//  Created by hasan bilgin on 20.10.2023.
//

import Foundation

// Class, protocol
// talks to -> interactor, router, view

enum NetworkError : Error {
    case NetwokFailed
    case ParsingFailed
}

protocol AnyPresenter {
    //protocollerin illa get mi get set mi olucak diye sorucaktır
    //sadece okuncaksa get yeterlidr. okunup ve güncellenicekse get set şart
    //    var router : AnyRouter? {get}
    var router : AnyRouter? {get set}
    var interactor : AnyInteractor? {get set}
    var view : AnyView? {get set}
    
    //datalar listesi yenilendiğini  viewe sölemek için
    func interactorDidDownloadCrypto(result : Result<[Crypto],Error>)
}

class CryptoPresenter : AnyPresenter{
    var router: AnyRouter?
    
    var interactor: AnyInteractor? {
        //atama işlemi yapıldığında download çalışçak
        didSet{
            interactor?.downloadCryptos()
        }
    }
    
    var view: AnyView?
    
    func interactorDidDownloadCrypto(result: Result<[Crypto], Error>) {
        switch result {
        case .success(let cryptos):
            //view update
            view?.update(with: cryptos)
            //        case .failure(let error): aynı gibi
        case .failure(_):
            view?.update(with: "Try again later")
        }
    }
    
    
}
