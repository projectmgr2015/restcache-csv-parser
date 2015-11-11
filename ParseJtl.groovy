import groovy.transform.Field

@Field String language = args[1].toUpperCase()
println "language = $language"

@Field String testType = args[2].toUpperCase()
println "testType = $testType"

@Field String threads = args[3]
println "threads = $threads"
println ''

@Field List<String> csvHeaders = [
        'SECONDS_FROM_START',
        'MILIS_FROM_START',
        'TEST_GROUP',
        'TEST_NAME',
        'LATENCY',
        'RESPONSE_CODE',
        'RESPONSE_NAME',
        'THREAD',
        'DATA_TYPE',
        'SUCCESS',
        'BYTES',
        'NUMBER_1',
        'NUMBER_2',
        'NUMBER_3',
        'TEST_LANGUAGE',
        'TEST_THREADS',
        'TEST_TYPE'
]

@Field File jtlFile = new File(args[0])
println "jtlFile = $jtlFile.name"

@Field File outputCsv = new File("${args[0]}.csv")
println "outputCsv = $outputCsv.name"
outputCsv.text = csvHeaders.join(',') + '\n'
println ''

// -------------------


@Field long startDate = jtlFile.collect { String line -> line.split(',').first().toLong() }.min()
println "startDate = $startDate"
//outputCsv.append(getCsvLine(jtlFile.readLines().first()) + '\n')
jtlFile.eachLine { String line ->
    outputCsv.append(getCsvLine(line) + '\n')
}

public getCsvLine(String line) {
    List<String> properties = line.split(',').toList()

    long timeDifference = properties[0].toLong() - startDate
    String label = properties[2]
    def csvLineMap = [
            secondsFromStart: (timeDifference / 1000).toLong(),
            milisFromStart  : properties[0].toLong() - startDate,
            testGroup       : "\"${label.split(" - ").first()}\"",
            testName        : "\"${label.split(" - ").last()}\"",
            latency         : "\"${properties[1]}\"",
            responseCode    : "\"${properties[3]}\"",
            responseName    : "\"${properties[4]}\"",
            thread          : "\"${properties[5]}\"",
            dataType        : "\"${properties[6]}\"",
            success         : properties[7].toUpperCase(),
            bytes           : properties[8],
            number_1        : properties[9],
            number_2        : properties[10],
            number_3        : properties[11],
            testLanguage    : "\"${language}\"",
            testThreads     : threads,
            testType        : "\"${testType}\"",
    ]
//    println csvLineMap
    return csvLineMap.values().join(',')
}