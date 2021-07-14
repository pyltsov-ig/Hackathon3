//
//  ViewController.swift
//  Hackathon3
//
//  Created by ИГОРЬ on 25/06/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import MBProgressHUD

typealias GetComplete = () -> ()  // сбегающее замыкание для асинхронной обработки

class ViewController: UIViewController {
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photosModel = [PhotoModel]()
    var layoutType: LayoutType = .grid


    override func viewDidLoad() {
        super.viewDidLoad()
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
    }
    
    
    @IBAction func segmentControlSelect(_ sender: UISegmentedControl) {
        
        guard let layoutType = LayoutType(rawValue: sender.selectedSegmentIndex) else { return }
        
        self.layoutType = layoutType
        self.photoCollectionView.reloadData()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let imageDetailViewController = segue.destination as? ImageDetailsViewController,
           let indexPath = photoCollectionView.indexPathsForSelectedItems?.first {
            imageDetailViewController.photo = photosModel[indexPath.row]
        }
    }
}

// Networking
extension ViewController {
    
    //  метод fetchFlickrPhotos с использованием библиотеки Alamofire. Этот метод не вызывается в этой версии приложения, но оставлен на память, в учебных целях. В этой версии приложения вызывается метод getFlickrPhotos, от идет следом.
    
    func fetchFlickrPhotos(complition: @escaping GetComplete) {
        
        if parameterText == "" {
            return
        }
        parameters["text"] = parameterText
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        

        AF.request(baseUrl, method: .get, parameters: parameters ).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let unwrResponse = response.value else {return}
                let json = JSON(unwrResponse)["photos"]["photo"]
                for i in 0..<json.count {
                    let photo = PhotoModel(photosDictionary: json[i])
                    self.photosModel.append(photo)
                }
                complition()
            case .failure(let error):
                print(error)
            }
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    // с использованием URLSession only
    func getFlickrPhotos(complition: @escaping GetComplete) {
        
        if parameterText == "" {
            return
        }
        parameters["text"] = parameterText
        
        // индикатор старт
        MBProgressHUD.showAdded(to: self.view, animated: true)
       
        var components = URLComponents(string: baseUrl)!
        components.queryItems = parameters.map{ (key, value) in
            URLQueryItem(name: key, value: value)
        }
        
        let request = URLRequest(url: components.url!)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  (200..<300) ~= response.statusCode,
                  error == nil
            else { return }
            
            let responseObject = (try? JSONSerialization.jsonObject(with: data)) as? [String:Any]
        
        guard let unwrResponse = responseObject else {return}
            
            let json = JSON(unwrResponse)["photos"]["photo"]
            for i in 0..<json.count {
                let photo = PhotoModel(photosDictionary: json[i])
                self.photosModel.append(photo)
            }
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: false)
                complition()
            }
        }
        task.resume()
    }

    
}

// CollectionView
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! ImageCollectionViewCell
        let photo = photosModel[indexPath.row]
        cell.imageURL = layoutType == .grid ? photo.url_q : photo.url_z
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView = UICollectionReusableView()

        if kind == UICollectionView.elementKindSectionHeader{
            reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeader", for: indexPath)
        }
        return reusableView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == photosModel.count-1 {
            parameterPage += 1
            parameters["page"] = String(parameterPage)
            getFlickrPhotos {
                self.photoCollectionView.reloadData()
            }
        }
    }
}

// CollectionView Layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    
    enum LayoutType: Int {
        case grid
        case list
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if layoutType == .grid {
            let itemWidth = collectionView.bounds.width / 3
            return CGSize(width: itemWidth, height: itemWidth)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 200)
        }
    }
}


// SearchBar
extension ViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        photosModel.removeAll()
        self.photoCollectionView.reloadData()
        parameterPage = 1
        parameters["page"] = String(parameterPage)
        searchBar.resignFirstResponder()
        parameterText = searchBar.text ?? ""
        getFlickrPhotos {
            self.photoCollectionView.reloadData()
        }
    }
}




