public struct DocString: Equatable {
    public struct Parameter: Equatable {
        public let name: String
        public let description: [String]

        public init(name: String, description: [String]) {
            self.name = name
            self.description = description
        }
    }

    public let description: [String]
    public let parameters: [Parameter]
    public let returns: [String]
    public let `throws`: [String]
    public let maxParameterWidth: Int

    public init(description: [String], parameters: [Parameter], returns: [String], throws: [String]) {
        self.description = description
        self.parameters = parameters
        self.returns = returns
        self.throws = `throws`
        self.maxParameterWidth = parameters.reduce(0) { max($0, $1.name.count) }
    }
}

/*
 public struct DocString: Equatable {

     public struct Parameter: Equatable {
         public let name: String
         /// Each line of description, including the whitespace before the content.
         public let description: [StringLeadByWhitespace]

         public init(name: String, description: [StringLeadByWhitespace]) {
             self.name = name
             self.description = description
         }
     }

     public let description: [String]
     public let parameters: [Parameter]
     public let returns: [String]
     public let `throws`: [String]
     public let maxParameterWidth: Int

     public init(description: [String], parameters: [Parameter], returns: [String], throws: [String]) {
         self.description = description
         self.parameters = parameters
         self.returns = returns
         self.throws = `throws`
         self.maxParameterWidth = parameters.reduce(0) { max($0, $1.name.count) }
     }
 }
 */
