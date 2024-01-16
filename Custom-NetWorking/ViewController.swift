//
//  ViewController.swift
//  Custom-NetWorking
//
//  Created by Dao Van Nha on 13/01/2024.
//

import UIKit
import DataSource

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Repository.shared.weather.getWeather { result in
            switch result {
            case .success(let success):
                print(success.data as WeatherModel)
            case .failure(let failure):
                print(failure)
            }
        }
    }


}

