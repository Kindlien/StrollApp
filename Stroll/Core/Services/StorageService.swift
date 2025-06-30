//
//  StorageService.swift
//  Stroll
//
//  Created by William Kindlien Gunawan on 29/06/25.
//

import Foundation

class StorageService {
    enum StorageType {
        case userDefaults
        case fileSystem
    }

    func save<T: Encodable>(_ object: T, forKey key: String, storage: StorageType = .userDefaults) {
        guard let data = try? JSONEncoder().encode(object) else { return }

        switch storage {
        case .userDefaults:
            UserDefaults.standard.set(data, forKey: key)
        case .fileSystem:
            let url = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(key)
            try? data.write(to: url)
        }
    }

    func load<T: Decodable>(forKey key: String, storage: StorageType = .userDefaults) -> T? {
        let data: Data?

        switch storage {
        case .userDefaults:
            data = UserDefaults.standard.data(forKey: key)
        case .fileSystem:
            let url = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(key)
            data = try? Data(contentsOf: url)
        }

        guard let data = data else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func delete(forKey key: String, storage: StorageType = .userDefaults) {
        switch storage {
        case .userDefaults:
            UserDefaults.standard.removeObject(forKey: key)
        case .fileSystem:
            let url = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent(key)
            try? FileManager.default.removeItem(at: url)
        }
    }
}
