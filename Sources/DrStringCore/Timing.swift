#if canImport(Darwin)
import Darwin
#else
import Glibc
#endif

func getTime() -> timeval {
    var time = timeval()
    gettimeofday(&time, nil)
    return time
}

func readableDiff(from: timeval, to: timeval) -> String {
    var numericDifference = Double(to.tv_sec) + Double(to.tv_usec) / 1_000_000
        - (Double(from.tv_sec) + Double(from.tv_usec) / 1_000_000)
    var result = [String]()
    if numericDifference > 3600 {
        let hour = Int(numericDifference / 3600)
        result.append("\(hour)h")
        numericDifference -= Double(hour * 3600)
    }

    if numericDifference > 60 {
        let minute = Int(numericDifference / 60)
        result.append("\(minute)m")
        numericDifference -= Double(minute * 60)
    }

    if numericDifference != 0 {
        let seconds = Int(floor(numericDifference))
        result.append("\(seconds)s")
        numericDifference -= Double(seconds)
    }

    if numericDifference != 0 {
        let milliseconds = Int(numericDifference * 1000)
        result.append("\(milliseconds)ms")
    }

    return result.joined(separator: " ")
}
