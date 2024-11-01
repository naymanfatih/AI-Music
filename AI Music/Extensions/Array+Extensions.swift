//
//  Array+Extensions.swift
//  AI Music
//
//  Created by Fatih Ömirtay Kara on 1.11.2024.
//

extension Array where Element: Hashable {
    var unique: [Element] {
        var seen = Set<Element>()
        return self.filter { element in
            guard !seen.contains(element) else { return false }
            seen.insert(element)
            return true
        }
    }
}
