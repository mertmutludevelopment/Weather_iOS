//
//  ViewController.swift
//  Weather
//
//  Created by MERT MUTLU on 28.04.2024.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var cityCard: UIView!
    @IBOutlet weak var lblCityName: UILabel!
    @IBOutlet weak var lblHumidity: UILabel!
    @IBOutlet weak var lblPressure: UILabel!
    @IBOutlet weak var lblTemp: UILabel!
    
    @IBOutlet weak var btnAnkara: UIButton!
    @IBOutlet weak var btnIstanbul: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cityCard.layer.cornerRadius = 10.0
        cityCard.layer.shadowColor = UIColor.gray.cgColor
        cityCard.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        cityCard.layer.shadowRadius = 12.0
        cityCard.layer.shadowOpacity = 0.7
        
        btnAnkara.setTitle("Ankara", for: .normal)
        btnAnkara.setTitleColor(UIColor.black, for: .normal)
        btnAnkara.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        btnAnkara.layer.cornerRadius = 10
        btnAnkara.clipsToBounds = true
        
        btnIstanbul.setTitle("İstanbul", for: .normal)
        btnIstanbul.setTitleColor(UIColor.black, for: .normal)
        btnIstanbul.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        btnIstanbul.layer.cornerRadius = 10
        btnIstanbul.clipsToBounds = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCity(cityName: "Ankara,TR")

    }
    
    
    
    func getCity(cityName: String){
            NetworkManager.instance.fetch(HTTPMethod.get, url: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName),TR&APPID=156f0ee8b5c15ebcfc6f0e5fffcaea76&units=metric" , requestModel: nil, model: CityResponse.self ) { response in
                
                switch(response)
                {
                    case .success(let model):
                        let cityModel = model as! CityResponse
                        print("JSON RESPONSE MODEL : \(String(describing: cityModel))")
                        self.lblTemp.text = " Temp : \(String(cityModel.main.temp))"
                        self.lblCityName.text = String(cityModel.name)
                        self.lblHumidity.text = " Humidity : \(String(cityModel.main.humidity))"
                        self.lblPressure.text = " Pressure :  \(String(cityModel.main.pressure))"
                    case .failure(_): break
                }
                
            }
        }

    @IBAction func actionBtnAnkara(_ sender: Any) {
        getCity(cityName: "Ankara,TR")

    }
    @IBAction func actionBtnIstanbul(_ sender: Any) {
        getCity(cityName: "Istanbul,TR")

    }
    
}

