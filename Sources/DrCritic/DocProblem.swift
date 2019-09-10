import DrDecipher

public enum DocProblem {
    case redundantParameter(DocString.Parameter)
    case missingParameter(String, String)
}
