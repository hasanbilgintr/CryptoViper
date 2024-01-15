//
//  Interactor.swift
//  CryptoViper
//
//  Created by hasan bilgin on 20.10.2023.
//

import Foundation

// Class , protocol
// talks to - > presenter

protocol AnyInteractor {
    var presenter : AnyPresenter? {get set}
    
    //liste burda inicek
    func downloadCryptos()
}

class CryptoInteractor : AnyInteractor {
    var presenter: AnyPresenter?
    
    func downloadCryptos() {
        guard let url = URL(string:"\(Constants.url)/master/crypto.json") else {
            return
        }
        
        //[weak self]  konuyla alakası yoktur ama bilgi zayıf referans demek -> görünüm değiştirğinde gereksiz hafızada kalan bilgiyi yok eder
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            //eğer gelen data dataya aktarılabilip ve error nil ise do ya geçer depğilse sistemi durdurur
            guard let data = data , error == nil else {
                self?.presenter?.interactorDidDownloadCrypto(result: .failure(NetworkError.NetwokFailed))
                return
            }
            
            do {
                let cryptos = try JSONDecoder().decode([Crypto].self, from: data)
                self?.presenter?.interactorDidDownloadCrypto(result: .success(cryptos))
            }catch{
                self?.presenter?.interactorDidDownloadCrypto(result: .failure(NetworkError.ParsingFailed))
            }
        }
        task.resume()
    }
    
    
}
