//
//  DetailViewController.swift
//  WeatherForecast
//
//  Created by Phil Chang on 2022/7/11.
//  Copyright © 2022 Phil. All rights reserved.
//

import UIKit

protocol ImageDownloadDelegate: AnyObject {
    func imageDownloadedForObject(object: Forecast?)
}

class DetailViewController: UIViewController {

    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var downloadImageButton: UIButton!

    weak var delegate: ImageDownloadDelegate?
    var object: Forecast?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configureView()
    }

    func configureView() {
        self.forecastLabel.text = (self.object?.descriptionStr )
        self.sunriseLabel.text = "\(self.object?.sunrise! ?? 0) seconds"
        self.sunsetLabel.text = "\(self.object?.sunset! ?? 0) seconds"
        self.highLabel.text = "\(self.object?.high! ?? 0)ºC"
        self.lowLabel.text = "\(self.object?.low! ?? 0)ºC"
        self.chanceOfRainLabel.text = "\(self.object?.chance_rain! ?? 0)%"
    }

    @IBAction func downloadImage(_ sender: Any) {
        guard let object = object,
              let image = object.image,
              let forecastUrl = URL(string: image),
              object.image_downloaded != true else { return }
        let imageDownloadSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        imageDownloadSession.dataTask(with: forecastUrl, completionHandler: { (data, response, error) in
            guard let data = data else { return }
            self.imageView.image = UIImage(data: data)
            object.image_downloaded = true
            self.downloadImageButton.isHidden = true
            self.delegate!.imageDownloadedForObject(object: self.object)
        }).resume()
    }
}
