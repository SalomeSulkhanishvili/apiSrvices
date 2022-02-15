//
//  ViewController.swift
//  GetJsonData
//
//  Created by Salome Sulkhanishvili on 14.02.22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //http://covid-restrictions-api.noxtton.com/v1/vaccine
        DispatchQueue.main.async {
            APIServicies.getVaccines(completion: { result in
                switch result {
                case .success(let vaccines):
                    print(vaccines.data)
                case .failure(let error):
                    print(error)
                }
                
            })
        }
        
        DispatchQueue.main.async {
            APIServicies.getNations(completion: { result in
                switch result {
                case .success(let nations):
                    print(nations.data)
                case .failure(let error):
                    print(error)
                }
                
            })
        }
        
        DispatchQueue.main.async {
            APIServicies.getAirports(completion: { result in
                switch result {
                case .success(let airports):
                    print(airports.data)
                case .failure(let error):
                    print(error)
                }
                
            })
        }
        
        DispatchQueue.main.async {
            APIServicies.getRestrictionsInfo(from: "german",
                                             to: "RIX",
                                             with: "sinovac", completion: {result in
                switch result {
                case .success(let restrictions):
                    print(restrictions)
                case .failure(let error):
                    print(error)
                }
                
            })

        }
        
        
    }
    
    

}

