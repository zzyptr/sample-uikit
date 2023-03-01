struct Division: Decodable {
    let code: Int
    let name: String
    let children: [Division]?

    var subdivisions: [Division] {
        return children ?? []
    }
}
