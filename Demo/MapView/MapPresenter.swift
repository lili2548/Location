

import Foundation

protocol MapPresenterDelegate: AnyObject{
    func onResultInfo(_ model: ISSModel)
}

class MapPresenter {
    
    var presenterDelegate: MapPresenterDelegate?
    
    func setupPresenterDelegate(_ delegate: MapPresenterDelegate){
        self.presenterDelegate = delegate
    }
    
    func callToGetPosition(){
        APIServerManager.shared.request(with: "http://api.open-notify.org/iss-now.json", type: ISSModel.self, .get) { (result) in
            switch result {
            case .success(let data):
                DataBaseManager.sharedInstance.writeDataInRealm(data: data)
                self.presenterDelegate?.onResultInfo(data)
            case .failure(_):
                break
            }
        }
    }
}
