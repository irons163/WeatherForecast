//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Phil Chang on 2022/7/11.
//  Copyright © 2022 Phil. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    @IBOutlet var sortingControl: UISegmentedControl!

    var objects = [Forecast]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NetworkService.shared.fetchForecast(searchText: "") { (forecasts) in
            self.objects = forecasts
            let data = try! NSKeyedArchiver.archivedData(withRootObject: forecasts, requiringSecureCoding: false)
            UserDefaults.standard.set(data, forKey: UserDefaults.backupForecastKey)
            self.tableView.reloadData()
        }
    }

    func setupViews() {
        self.tableView.tableHeaderView = self.sortingControl
        self.sortingControl.addTarget(self, action: #selector(self.sortingControlAction(_:)), for: .touchUpInside)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.delegate = self
                controller.object = object
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                controller.title = "Day \(object.day!)"
            }
        }
    }

    @objc func sortingControlAction(_ segmentedControl: UISegmentedControl) {
        defer {
            self.tableView.reloadData()
        }
        guard segmentedControl.selectedSegmentIndex == 1 else {
            objects.sort { (object1, object2) -> Bool in
                return (object1.day! ) < (object2.day! )
            }
            return
        }

        objects.sort { (object1, object2) -> Bool in
            return object1.high! > object2.high!
        }

        var tempObjects = objects
        for i in 0..<objects.count {
            if (objects[i].chance_rain! ) > 0.5 {
                tempObjects.removeAll { (object) -> Bool in
                    return object.chance_rain! == objects[i].chance_rain!
                }
            }
        }
        objects = tempObjects
    }
}

extension ViewController: ImageDownloadDelegate {
    func imageDownloadedForObject(object: Forecast?) {
        let i = self.objects.firstIndex { (comparedObject) -> Bool in
            return comparedObject.day == object?.day
        }!
        self.objects[i] = object!
        self.tableView.reloadData()
    }
}

extension ViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let object = objects[indexPath.row]
        cell.textLabel?.text = "Day \(object.day!): \(object.descriptionStr!)"
        if object.image_downloaded == true {
            cell.textLabel?.textColor = .gray
        }
        return cell
    }
}
