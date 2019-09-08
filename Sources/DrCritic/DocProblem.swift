import DrDecipher

public enum DocProblem {
    case unrecognizedParameter(DocString.Parameter)
    case missingParameter(String)
}
