// its not CLEAN, just CODE
File directory = new File('.')

List<File> files = directory.listFiles().collect().findAll { File f -> f.isFile() }.sort(false) { File file -> file.name }
files.remove(new File('./addColumns.groovy'))
println files

List<String> testGroups = ['API Validation', 'Key Validation', 'CRUD', 'ALL']

files.each { File oldCsv ->

    String fileName = oldCsv.name.replace('.csv', '')
    String lang = fileName.split('-')[0].toUpperCase()
    String test_type = fileName.split('-')[1].toUpperCase()
    String test_threads = fileName.split('-')[2]
    String server = fileName.split('-')[3]

    int testGroupIndex = 0
    File newCsv = new File(new File('./new'), "$fileName-new.csv")
    newCsv.text = ''
    println "lang = $lang"
    println "test_type = $test_type"
    println "test_threads = $test_threads"
    println "server = $server"

    oldCsv.eachWithIndex { String line, int i ->
        if (line.size() < 5) { // a bo tak
            testGroupIndex += 1
            println "i = $i\ttestGroupIndex = $testGroupIndex"
        } else {
            String testGroup = testGroups[testGroupIndex]

            def dstatDate = line.split(',').first()
            Date lineDate = Date.parse('yyy-dd-MM HH:mm:ss', "2015-$dstatDate")
            long milis = lineDate.time / 1000
            newCsv.append(line.replaceFirst(dstatDate, milis.toString()) + ",$lang,$test_type,$test_threads,$server,$testGroup\n")
        }
    }
    println ''
}
