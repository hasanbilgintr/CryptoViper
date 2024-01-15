
/*
 
 VİPER  & Protocol
 VİPER => View - Interactor - Presenter - Entity - Router
 
 -View  yada View Controller görünümdür, kullanıcın gördüğü arayüzdür diyebiliriz
 -Router - 5 yapı içinde gezinmesini sağlayan bir sınıftır,kontrolünü yada orkestra etmektir, ilk açılım da dahil ,
 -Presenter Gösterici manasına gelir. İinteragtordan aldığı verileri hem görünüm tarafında hemde routerden aldığı  bilgilerle veya yönlendirmelerle görünüm tarafına iletme ve bu bu olayları koordine etme görevini üstleniyor
 -Interactor etkileşime geçme sınıfıdır. Business Layer dır. MVVM deki viewModelin eşleniği diyebiliriz ama tam anlamaıyla değil. Hem kullanıcıdan etkileşim varsa  ele alan (handle)  hemde networking service ve coredata ile konuştuğumuz  yer burasıdır
 -Entitiy ise bizim modelimizdir. Database..
 Linkte bıraktım incelenebilir https://medium.com/cr8resume/viper-architecture-for-ios-project-with-simple-demo-example-7a07321dbd29
 router
 ok
 |
 View <-> view controller- <> presenter <-> core data service  <-> entity
 <-> networking service <—————----->
 
 Viper herşey kod ile yapılcak görünüm dahil olduğu için viewcontroller sildik.Viper ile çalışırken modül modül çalışılır 5 ekran varsa diyelim 5 entity , 5 interactor, 5 view ,5 presenter, 5 router olur
 
 -Main.storyboard silince yapılması gerekenler => info.plist tıklanır kapalı olan tüm seçenekeler açılır Storyboard Name değeri zaten Maindir direk ona gelip silme tuşuna basılabilir , command + F ilede aratılıp bulunabilir . Ana Klasöre tıklayıp General -> targets te  seçili Deployment infoda yer alan Main İnterface Main silinir yalnız bizde o alan yoktu info sekmesine alımnmış Main storyboard file base -> Main olan satırı direk sildik
 
 */

import Foundation
import UIKit

// Talks to - >  presenter
// Class , protocol
// Viewcontroller

protocol AnyView {
    var presenter : AnyPresenter? {get set}
    
    //with bununla birlikte güncelleştir anlamına gelir
    func update(with cryptos: [Crypto])
    func update(with error: String)
}

class CryptoViewController : UIViewController , AnyView,UITableViewDelegate, UITableViewDataSource {
    var presenter: AnyPresenter?
    
    
    var cryptos : [Crypto] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow
        //görünümleri bu şekilde ekliyoruz
        view.addSubview(tableView)
        view.addSubview(messageLabel)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //storyboard olmadığı için kodla herşeyi yarattık ondan bu function viewve eklenmesini sağlıcak
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //ekran ne ise tam olarak yayılmasını sağlar
        tableView.frame = view.bounds
        //labelide tam ortaya getirmiş olduk
        messageLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 50, width: 200, height: 50)
        
    }
    
    //mesaj Label oluşturmak için
    private let messageLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Downloading..."
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black //.black ile aynı
        label.textAlignment = NSTextAlignment.center //.center da aynı
        return label
    }()
    
    //tableView oluştuurcaz burda
    private let tableView : UITableView = {
        let table = UITableView()
        //custom bir sınıf yaparsanız  onu koyabiliyoruz
        table.register(UITableViewCell.self,forCellReuseIdentifier: "cell")
        //boş tableview göstermek istemediğimiz için gizledik veri gelince açıcaz
        table.isHidden = true
        return table
    }()
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = cryptos[indexPath.row].currency
        content.secondaryText = cryptos[indexPath.row].price
        cell.contentConfiguration = content
        cell.backgroundColor = .yellow
        return cell
    }
    
    
    func update(with cryptos: [Crypto]) {
        DispatchQueue.main.async {
            self.cryptos = cryptos
            self.messageLabel.isHidden = true
            self.tableView.reloadData()
            self.tableView.isHidden = false
        }
    }
    
    func update(with error: String) {
        DispatchQueue.main.async {
            self.cryptos = []
            self.tableView.isHidden = true
            self.messageLabel.text = error
            self.messageLabel.isHidden = false
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detayVC = DetailViewController()
        detayVC .currency = cryptos[indexPath.row].currency
        detayVC .price = cryptos[indexPath.row].price
        self.present(detayVC,animated: true)
    }
}


//viper olmadan diğer mesela başka bir ekranda para birimi ve fiyatı gösterebiliriz
class DetailViewController :  UIViewController {
    var currency : String = ""
    var price : String = ""
    
    private let currencyLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Currency Label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black //.black ile aynı
        label.textAlignment = NSTextAlignment.center //.center da aynı
        return label
    }()
    
    private let priceLabel : UILabel = {
        let label = UILabel()
        label.isHidden = false
        label.text = "Pice Label"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black //.black ile aynı
        label.textAlignment = NSTextAlignment.center //.center da aynı
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        view.addSubview(currencyLabel)
        view.addSubview(priceLabel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        currencyLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 25, width: 200, height: 50)
        priceLabel.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 + 50, width: 200, height: 50)
        
        currencyLabel.text = currency
        priceLabel.text = price
        
        currencyLabel.isHidden = false
        priceLabel.isHidden = false
    }
    
    
}
