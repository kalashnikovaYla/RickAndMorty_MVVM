//
//  CharacterInfoCollectionViewCellViewModel.swift
//  RickAndMorty_MVVM
//
//  Created by sss on 19.01.2023.
//

import UIKit

final class CharacterInfoCollectionViewCellViewModel {
    
    private let type: TypeInfo
    public let value: String
    
    public var title: String {
        self.type.displayTitle
    }
    
    public var displayValue: String {
        if value.isEmpty {
            return "None"
        }
        
        if let date = Self.dateFormatter.date(from: value), type == .created {
            return Self.shortDateFormatter.string(from: date)
        }
        return value
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZ"
        formatter.timeZone = .current
        return formatter
    }()
    
    static let shortDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()
    
    public var iconImage: UIImage? {
        return type.iconImage
    }
    
    public var tintColor: UIColor {
        return type.tintColor
    }
    
    enum TypeInfo: String {
        case status
        case gender
        case type
        case species
        case origin
        case created
        case location
        case episodeCount
        
        var iconImage: UIImage? {
            switch self {
            case .status:
                return UIImage(systemName: "bell")
            case .gender:
                return UIImage(systemName: "bell")
            case .type:
                return UIImage(systemName: "bell")
            case .species:
                return UIImage(systemName: "bell")
            case .origin:
                return UIImage(systemName: "bell")
            case .created:
                return UIImage(systemName: "bell")
            case .location:
                return UIImage(systemName: "bell")
            case .episodeCount:
                return UIImage(systemName: "bell")
            }
        }
        
        var displayTitle: String {
            switch self {
            case .status, .gender, .type, .species, .origin, .created, .location:
                return rawValue.uppercased()
            case .episodeCount:
                return "Episode count"
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .status:
                return .systemBlue
            case .gender:
                return .systemBlue
            case .type:
                return .systemBlue
            case .species:
                return .systemBlue
            case .origin:
                return .systemBlue
            case .created:
                return .systemBlue
            case .location:
                return .systemBlue
            case .episodeCount:
                return .systemBlue
            }
        }
    }
    
    
    init(type: TypeInfo, value: String) {
        self.value = value
        self.type = type
    }
    
}
