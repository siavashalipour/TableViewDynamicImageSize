//
//  ViewController.swift
//  TableViewDynamicImageSize
//
//  Created by Siavash on 4/6/17.
//  Copyright © 2017 Siavash. All rights reserved.
//

import UIKit
import SDWebImage
import SnapKit

class ViewController: UIViewController {

  
  @IBOutlet weak var tableView: UITableView!
  var images: [UIImage] = []
  var heightCache: [String: CGFloat] = [:]
  var dataSource: [DataSource] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let urls: [String] = ["https://cdn.pixabay.com/photo/2013/10/15/09/20/flower-195897_150.jpg",
                          "https://pixabay.com/get/e83cb40721f31c2ad65a5854e3494297eb71e1c818b5184790f4c970a0eb_640.jpged3cb00e2ff71c2ad65a5854e3494297eb71e1c818b5184790f4c970a0eb_640.jpg",
                          "https://cdn.pixabay.com/photo/2014/10/16/13/33/sun-flower-491173_150.jpg",
                          "https://pixabay.com/get/ed3cb00e2ff71c2ad65a5854e3494297eb71e1c818b5184790f4c970a0eb_640.jpg"]
    for str in urls {
      let item = DataSource.init(imageURL: str, desc: str)
      dataSource.append(item)
    }
    tableView.dataSource = self
    tableView.delegate = self
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

}
extension ViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: CustomCell
    if let aCell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell {
      cell = aCell
    } else {
      cell = CustomCell()
    }
    cell.desLabel.text = dataSource[indexPath.row].desc
    cell.spinner.isHidden = false
    cell.spinner.startAnimating()

    cell.imageHolder.sd_setImage(with: URL.init(string: dataSource[indexPath.row].imageURL),placeholderImage: #imageLiteral(resourceName: "placeholder"),options: []) { (img, error, type, url) in
      if error == nil {
        if let image = img {
          cell.spinner.stopAnimating()
          if self.heightCache[url?.absoluteString ?? ""] ?? 0 < CGFloat(1) {
            self.heightCache[url?.absoluteString ?? ""] = image.size.height + (self.dataSource[indexPath.row].desc.height(withConstrainedWidth: self.tableView.bounds.width - 52, font: UIFont.systemFont(ofSize: 17))) + 40
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
            tableView.endUpdates()
          }
          
        }
      }
    }

    return cell
  }
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource.count
  }
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return heightCache[dataSource[indexPath.row].imageURL] ?? (self.dataSource[indexPath.row].desc.height(withConstrainedWidth: self.tableView.bounds.width - 52, font: UIFont.systemFont(ofSize: 17))) + 80
    
  }
}
extension String {
  func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
    let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
    let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
    
    return boundingBox.height
  }
}
class CustomCell: UITableViewCell {
  
  @IBOutlet weak var imageHolder: UIImageView!
  @IBOutlet weak var spinner: UIActivityIndicatorView!
  @IBOutlet weak var desLabel: UILabel!
  
  func config(with data: DataSource) {

  }
}

struct DataSource {
  let imageURL: String
  let desc: String
  
}
