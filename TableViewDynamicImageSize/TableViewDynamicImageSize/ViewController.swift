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
    let urls: [String] = ["https://i.ytimg.com/vi/0speIS4LUSA/hqdefault.jpg",
                          "https://i.ytimg.com/vi/XLsJoTD1oI0/hqdefault.jpg",
                          "https://i.ytimg.com/vi/ZRzWAIs0Vxs/hqdefault.jpg",
                          "https://i.ytimg.com/vi/pqxqXiJqEq8/hqdefault.jpg",
                          "https://i.ytimg.com/vi/5Vvvfggbe7A/hqdefault.jpg",
                          "https://i.ytimg.com/vi/1xzHHbzPTwE/hqdefault.jpg",
                          "https://i.ytimg.com/vi/mUraX_DUFX0/hqdefault.jpg",
                          "https://i.ytimg.com/vi/mheDX2tBzq0/hqdefault.jpg",
                          "https://i.ytimg.com/vi/mheDX2tBzq0/hqdefault.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/e35/18014020_137818996759109_5258095883718754304_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/e35/17662936_276100486193210_4162516758063742976_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/e35/17934180_246131935860536_3712811752069529600_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/17882378_702189843298794_6125471830590357504_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/e35/17818686_611247545735820_5670987187420659712_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/e35/17819212_1858621431043944_5977630792744960000_n.jpg",
                          "https://i.ytimg.com/vi/-304HavXfVw/hqdefault.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/e35/c2.0.465.465/17661957_664604777074941_6482378656495697920_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/e35/c2.0.593.593/17587164_419981581685369_7154006392200757248_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/c180.0.720.720/17334237_1349139325129868_2582871075570319360_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/e35/c257.0.565.565/17268225_1785385098456115_720624666783252480_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/c0.29.744.744/16228781_1682501608714558_8734191136039501824_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/e35/c127.0.498.498/16464279_1886102308331717_8247244932478140416_n.jpg",
                          "https://scontent.cdninstagram.com/t51.2885-15/s640x640/sh0.08/e35/c0.77.747.747/16464727_409510502720441_9181544613079416832_n.jpg"]
    for str in urls {
      let item = DataSource.init(imageURL: str, desc: str + str)
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
                let aspectRatioImg = image.size.height / image.size.width
            
                let a =  tableView.bounds.width - 32 + aspectRatioImg
             self.heightCache[url?.absoluteString ?? ""] = a + (self.dataSource[indexPath.row].desc.height(withConstrainedWidth: self.tableView.bounds.width - 52, font: UIFont.systemFont(ofSize: 17))) + 40
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
    return heightCache[dataSource[indexPath.row].imageURL] ?? (self.dataSource[indexPath.row].desc.height(withConstrainedWidth: self.tableView.bounds.width - 52, font: UIFont.systemFont(ofSize: 17))) + 40
    
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
