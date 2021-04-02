//
//  TableViewController.swift
//  Table
//
//  Created by ADMIN on 01/01/2020.
//  Copyright © 2020 ADMIN. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import MobileCoreServices
import MapKit
import  LinkPresentation

class TableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UITabBarDelegate{
    var metadata: LPLinkMetadata?
    
    //var index: IndexPath!
    
    var fetchResultTableViewController: NSFetchedResultsController<Restaurant>!
    var searchController: UISearchController!
    var filreredResultArray: [Restaurant] = []
    var restaurants: [Restaurant] = []
    //        Restaurant(name: "Ogonёk Grill&Bar", type: "ресторан", location: "Уфа бульвар Хадии Давлетшиной 21", image: "ogonek.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00"),
    //        Restaurant(name: "Елу", type: "ресторан", location: "Ереван", image: "elu.jpg", isVisited: false, time: "Мы работаем с 15:00 до 23:00"),
    //        Restaurant(name: "Bonsai", type: "ресторан", location: "Уфа", image: "bonsai.jpg", isVisited: false, time: "Мы работаем с 8:00 до 23:00"),
    //        Restaurant(name: "Дастархан", type: "ресторан", location: "Уфа", image: "dastarhan.jpg", isVisited: false, time: "Мы работаем с 10:00 до 24:00"),
    //        Restaurant(name: "Индокитай", type: "ресторан", location: "Уфа", image: "indokitay.jpg", isVisited: false, time: "Мы работаем с 8:00 до 20:00"),
    //        Restaurant(name: "X.O", type: "ресторан-клуб", location: "Уфа", image: "x.o.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00"),
    //        Restaurant(name: "Балкан Гриль", type: "ресторан", location: "Уфа", image: "balkan.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00"),
    //        Restaurant(name: "Respublica", type: "ресторан", location: "Уфа", image: "respublika.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00"),
    //        Restaurant(name: "Speak Easy", type: "ресторанный комплекс", location: "Уфа", image: "speakeasy.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00"),
    //    Restaurant(name: "Morris Pub", type: "ресторан", location: "Уфа", image: "morris.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00"),
    //    Restaurant(name: "Вкусные истории", type: "ресторан", location: "Уфа", image: "istorii.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00"),
    //    Restaurant(name: "Классик", type: "ресторан", location: "Уфа", image: "klassik.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00"),
    //    Restaurant(name: "Love&Life", type: "ресторан", location: "Уфа", image: "love.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00"),
    //    Restaurant(name: "Шок", type: "ресторан", location: "Уфа", image: "shok.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00"),
    //    Restaurant(name: "Бочка", type: "ресторан", location:  "Уфа", image: "bochka.jpg", isVisited: false, time: "Мы работаем с 10:00 до 23:00")]
    
    
    @IBAction func close(segue: UIStoryboardSegue) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.hidesBarsOnSwipe = true
        
    }
    
    func filterContentFor(searchText text: String) {
        filreredResultArray = restaurants.filter{ (restaurant) -> Bool in
            return (restaurant.name?.lowercased().contains(text.lowercased()))!
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        definesPresentationContext = true
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        searchController.searchBar.tintColor = .white
        
        tableView.estimatedRowHeight = 98
        tableView.rowHeight = UITableView.automaticDimension
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        
        let fetchRequest: NSFetchRequest<Restaurant> = Restaurant.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        
        if let contex = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            fetchResultTableViewController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: contex, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultTableViewController.delegate = self
            
            do {
                try fetchResultTableViewController.performFetch()
                restaurants = fetchResultTableViewController.fetchedObjects!
                
            }catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let userDefaults = UserDefaults.standard
        let wasIntroWatched = userDefaults.bool(forKey: "wasIntroWatched")
        
        guard !wasIntroWatched else { return }
        
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil)
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert: guard let indexPath = newIndexPath else { break }
        tableView.insertRows(at: [indexPath], with: .fade)
        case .delete: guard let indexPath = indexPath else { break }
        tableView.deleteRows(at: [indexPath], with: .fade)
        case .update: guard let indexPath = indexPath else { break }
        tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            tableView.reloadData()
        }
        restaurants = controller.fetchedObjects as! [Restaurant]
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        super.viewWillAppear(animated)
    //
    //        let selectedIndexPath = IndexPath(row: 0, section: 0)
    //        tableView.selectRow(at: selectedIndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
    //
    //    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filreredResultArray.count
        }
        return restaurants.count
    }
    
    func  restaurantToDisplayAt(indexPath: IndexPath) -> Restaurant {
        let restaurant: Restaurant
        if searchController.isActive && searchController.searchBar.text != "" {
            restaurant = filreredResultArray[indexPath.row]
        }else {
            restaurant = restaurants[indexPath.row]
        }
        return restaurant
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        let restaurant = restaurantToDisplayAt(indexPath: indexPath)
        cell.imageCell?.image = UIImage(data: restaurant.image! as Data)
        cell.imageCell?.layer.cornerRadius = 32.5
        cell.imageCell?.clipsToBounds = true
        cell.label?.text = restaurant.name
        cell.locationLabel.text = restaurant.location
        cell.typeLabel.text = restaurant.type
        
        //        if self.restaurantIsVisited[indexPath.row] {
        //            cell.accessoryType = .checkmark
        //        } else {
        //            cell.accessoryType = .none
        //        }
        
        cell.accessoryType = restaurant.isVisited ? .checkmark: .none
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //
    //                let ac = UIAlertController(title: nil,
    //                message: "Выберите действие", preferredStyle: .actionSheet)
    //        let callAction = UIAlertAction(title: "Позвонить: +3749494949\(indexPath.row)", style: .default) {
    //            (action: UIAlertAction) -> Void in
    //
    //            let alertC = UIAlertController(title: nil, message: "Вызов не может быть совершен", preferredStyle: .alert)
    //            let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    //            alertC.addAction(ok)
    //            self.present(alertC, animated: true, completion: nil)
    //        }
    //        let isVisitedTitle = self.restaurantIsVisited[indexPath.row] ? "Я не был здесь": "Я был здесь"
    //
    //        let isVisited = UIAlertAction(title: isVisitedTitle, style: .default) { (action) in
    //            let cell = tableView.cellForRow(at: indexPath)
    //
    //            self.restaurantIsVisited[indexPath.row] = !self.restaurantIsVisited[indexPath.row]
    //            cell?.accessoryType = self.restaurantIsVisited[indexPath.row] ? .checkmark : .none
    //
    //
    //            //self.restaurantIsVisited[indexPath.row] = true
    //            //cell?.accessoryType = .checkmark
    //        }
    //        let cancle = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
    //        ac.addAction(cancle)
    //        ac.addAction(isVisited)
    //        ac.addAction(callAction)
    //        present(ac,animated: true, completion: nil)
    //
    //        tableView.deselectRow(at: indexPath, animated: true)
    //    }
    
    //    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //
    //        if editingStyle == .delete {
    //            self.restaurantImages.remove(at: indexPath.row)
    //            self.restaurantNames.remove(at: indexPath.row)
    //            self.restaurantIsVisited.remove(at: indexPath.row)
    //        }
    //       // tableView.reloadData()
    //        tableView.deleteRows(at: [indexPath], with: .fade)
    //    }
    
    // override func tableView(_ tableView: UITableView, editActionsForRowAt //indexPath: IndexPath) -> [UITableViewRowAction]? {
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let share = UIContextualAction(style: .normal, title: "Поделиться", handler: { (action, view, success) in
            success(true)
            let alert = UIAlertController(title: "Поделиться", message: "Выберите подходящий пункт", preferredStyle: .alert)
            let actionLocation = UIAlertAction(title: "Поделиться данными", style: .default) { (action: UIAlertAction) -> Void in
                let defaultText = "Я сейчас в " + self.restaurants[indexPath.row].name!
                let location = "Моя локация " + self.restaurants[indexPath.row].location!

                if let image = UIImage(data: self.restaurants[indexPath.row].image! as Data) {
                    let items: [Any] = [defaultText, location, image]
                    let vc = UIActivityViewController(activityItems: items, applicationActivities: nil)
                   // vc.previewNumberOfLines = 10
                    vc.popoverPresentationController?.sourceView = self.view
                    //presentActionSheet(vc, from: self.view)
                    self.present(vc, animated: true)
                    

                }
                
            
        
                
                
            }
            let action = UIAlertAction(title: "Отправить геолокацию", style: .default) { (action: UIAlertAction) -> Void in
                
                func shareLocation() {
                    let geocoder = CLGeocoder()
                    let loc = self.restaurants[indexPath.row].location!
                    geocoder.geocodeAddressString(loc) { (placemarks, error) in
                        if error != nil {
                            let alert = UIAlertController(title: "Ошибка местополежения", message: "Невозможно найти данный адрес который был указан", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Правильный вариант адреса", style: .default) {action in
                                
                                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 350))
                                imageView.center = CGPoint(x: 210, y: 285)
                                imageView.image = UIImage(named: "Preview")
                                self.view.addSubview(imageView)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                    imageView.isHidden = true
                                }
                            }
                            let actionTwo = UIAlertAction(title: "Отправить свое местоположение", style: .default, handler: nil)
                            let cancel = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
                            alert.addAction(action)
                            alert.addAction(actionTwo)
                            alert.addAction(cancel)
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                        guard let placemarks = placemarks else { return }
                        let placemark = placemarks.first
                        let annotation = MKPointAnnotation()
                        
                        guard let placemarkLocation = placemark?.location else { return }
                        annotation.coordinate = placemarkLocation.coordinate
                        let long = placemarkLocation.coordinate.longitude
                        let lat = placemarkLocation.coordinate.latitude
                        let title = "Локация заведения " + self.restaurants[indexPath.row].name!
                        let urlString = "https://maps.apple.com?ll=\(lat),\(long)"
                        guard let url = NSURL(string: urlString) else { return }
                        guard let vcard = [
                            "BEGIN:VCARD",
                            "VERSION:3.0",
                            "N:;\(title);;;",
                            "FN:\(title)",
                            "item1.URL;type=pref:\(urlString)",
                            "item1.X-ABLabel:map url",
                            "END:VCARD"
                            ].joined(separator: "\n").data(using: .utf8) else { return }
                        let activityItems = [
                            url,
                            NSItemProvider(item: vcard as NSSecureCoding, typeIdentifier: kUTTypeVCard as String),
                            title,
                            ] as [Any]
                        
                
                        let vc = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
                        vc.excludedActivityTypes = [UIActivity.ActivityType.message, UIActivity.ActivityType.mail]
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                
                
                shareLocation()
                
            }
  
            let actionCancel = UIAlertAction(title: "Отмена", style: .cancel) { (action: UIAlertAction) -> Void in
                
            }
            alert.addAction(action)
            alert.addAction(actionLocation)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
            
            func presentActionSheet(_ vc: VisualActivityViewController, from view: UIView) {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    vc.popoverPresentationController?.sourceView = view
                    vc.popoverPresentationController?.sourceRect = view.bounds
                    vc.popoverPresentationController?.permittedArrowDirections = [.right, .left]
                }
                
                self.present(vc, animated: true, completion: nil)
            }
            
        })
        let delete = UIContextualAction(style: .normal, title: "Удалить") { (action, view, success)  in
            success(true)
            self.tabBarController?.tabBar.isHidden = true
            let alert = UIAlertController(title: "Удалить?", message: "Это действие удалит данное заведение", preferredStyle: .actionSheet)
            let action = UIAlertAction(title: "Удалить", style: .default, handler: { (action: UIAlertAction) -> Void in
                self.tabBarController?.tabBar.isHidden = false
                self.restaurants.remove(at: indexPath.row)
                
                if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
                    
                    let objectToDelete = self.fetchResultTableViewController.object(at: indexPath)
                    context.delete(objectToDelete)
                    do{
                        try context.save()
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            })
            action.setValue(UIColor.red, forKey: "titleTextColor")
            let actionNO = UIAlertAction(title: "Отмена", style: .cancel, handler: {action in
                self.tabBarController?.tabBar.isHidden = false
            })
            
            alert.addAction(action)
            alert.addAction(actionNO)
            self.present(alert, animated: true, completion: nil)
            
        }
        

        
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        delete.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        return UISwipeActionsConfiguration(actions: [delete, share])
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                let dvc = segue.destination as! DetailViewController
                
                dvc.restaurant = restaurantToDisplayAt(indexPath: indexPath)
            }
        }
    }
  
}

extension TableViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData()
    }
}


extension TableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" || searchBar.showsCancelButton == true {
            navigationController?.hidesBarsOnSwipe = false
        }
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if filreredResultArray == [] {
            navigationController?.hidesBarsOnSwipe = false
        } 
        
    }
}










