//
//  ListCell.swift
//  LotteryTicketTool
//
//  Created by 成殿 on 14/11/2018.
//  Copyright © 2018 chengluffy. All rights reserved.
//

import UIKit
import SnapKit

class ListCell: UITableViewCell {

    lazy var firstLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLabel3: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLabel4: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLabel5: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var firstLabel6: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var secondLabel1: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var secondLabel2: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.lightGray
        label.textAlignment = .right
        return label
    }()
    
    var ticket: Ticket? {
        didSet {
            if ticket?.cate == 0 || ticket?.cate == 2 {
                secondLabel1.isHidden = false
                secondLabel1.text = "\(String(describing: ticket!.secondZoon![0]))"
                secondLabel2.text = "\(String(describing: ticket!.secondZoon![1]))"
                
                firstLabel1.text = "\(String(describing: ticket!.firstZoon![0]))"
                firstLabel2.text = "\(String(describing: ticket!.firstZoon![1]))"
                firstLabel3.text = "\(String(describing: ticket!.firstZoon![2]))"
                firstLabel4.text = "\(String(describing: ticket!.firstZoon![3]))"
                firstLabel5.text = "\(String(describing: ticket!.firstZoon![4]))"
                firstLabel6.isHidden = true
            } else {
                secondLabel1.isHidden = true
                secondLabel2.text = "\(String(describing: ticket!.secondZoon![0]))"
                
                firstLabel1.text = "\(String(describing: ticket!.firstZoon![0]))"
                firstLabel2.text = "\(String(describing: ticket!.firstZoon![1]))"
                firstLabel3.text = "\(String(describing: ticket!.firstZoon![2]))"
                firstLabel4.text = "\(String(describing: ticket!.firstZoon![3]))"
                firstLabel5.text = "\(String(describing: ticket!.firstZoon![4]))"
                firstLabel6.text = "\(String(describing: ticket!.firstZoon![5]))"
                firstLabel6.isHidden = false
            }
            
            let date = ticket!.date!
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:SS"
            let str = df.string(from: date)
            dateLabel.text = str
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configSubviews()
    }
    
    private func configSubviews() {
        contentView.addSubview(firstLabel1)
        contentView.addSubview(firstLabel2)
        contentView.addSubview(firstLabel3)
        contentView.addSubview(firstLabel4)
        contentView.addSubview(firstLabel5)
        contentView.addSubview(firstLabel6)
        
        contentView.addSubview(secondLabel1)
        contentView.addSubview(secondLabel2)
        
        contentView.addSubview(dateLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        firstLabel1.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-3)
            maker.left.equalTo(contentView.snp_leftMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        firstLabel2.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-3)
            maker.left.equalTo(firstLabel1.snp_rightMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        firstLabel3.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-3)
            maker.left.equalTo(firstLabel2.snp_rightMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        firstLabel4.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-3)
            maker.left.equalTo(firstLabel3.snp_rightMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        firstLabel5.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-3)
            maker.left.equalTo(firstLabel4.snp_rightMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        firstLabel6.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-3)
            maker.left.equalTo(firstLabel5.snp_rightMargin).offset(15)
            maker.width.height.equalTo(30)
        }
        
        secondLabel2.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-3)
            maker.right.equalTo(contentView.snp_rightMargin).offset(-15)
            maker.width.height.equalTo(30)
        }
        
        secondLabel1.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(contentView).offset(-3)
            maker.right.equalTo(secondLabel2.snp_leftMargin).offset(-15)
            maker.width.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView)
            maker.right.equalTo(contentView.snp_rightMargin).offset(-15)
        }
    }
    
}
