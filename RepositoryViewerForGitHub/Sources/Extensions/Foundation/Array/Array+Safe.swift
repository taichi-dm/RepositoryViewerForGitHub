public extension Array {

    /// example:
    /// let array = [nil, 30, 14, nil, 60, 21]
    /// let element: Element? = array[safe: 3]
    subscript (safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
