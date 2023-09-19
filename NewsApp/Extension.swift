//
//  Extension.swift
//  NewsApp
//
//  Created by Khumbongmayum Tonny on 08/09/23.
//

import Foundation
import UIKit

// MARK: - DATE Extension
extension Date {
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func timeAgoSinceDate() -> String {
        // From Time
        let fromDate = self
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "min ago" : "\(interval)" + " " + "mins ago"
        }
        
        // Second
        if let interval = Calendar.current.dateComponents([.second], from: fromDate, to: toDate).second, interval > 0 {
            return interval == 1 ? "\(interval)" + " " + "second ago" : "\(interval)" + " " + "seconds ago"
        }
        return "NA"
    }
}


// MARK: - STRING Extension
extension String {
    
    // From String to Date
    func toDate(withFormat format: String = "yyyy-MM-dd'T'HH:mm:ss'Z'")-> Date?{ //yyyy-MM-ddTHH:mm:ssZ //2021-04-23T08:29:00Z
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        return date
    }
}


// MARK: - UIView Extension
extension UIView {
    func addShadow() {
        self.layer.shadowColor = UIColor.systemGray2.cgColor
        self.layer.shadowOffset = CGSize(width: 0.1, height: 0.1)
        self.layer.shadowOpacity = 0.5
    }
    
    func addGradient() {
       let gradentLayer = CAGradientLayer()
        gradentLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradentLayer.locations = [0, 1]
        
        layer.addSublayer(gradentLayer)
        gradentLayer.frame = self.bounds
    }
    
}
