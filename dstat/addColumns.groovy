import groovy.transform.Field

// its not CLEAN, just CODE
File directory = new File('.')

List<File> files = directory.listFiles().collect().findAll { File f -> f.isFile() }.sort(false) { File file -> file.name }
//List<File> files = [new File('./tomcat-clean-100th-mongo.csv')]
files.remove(new File('./addColumns.groovy'))
files.remove(new File('./import_dstat.sql'))
println files.join('\n')
println ''
List<String> testGroups = ['API Validation', 'Key Validation', 'CRUD', 'ALL']
File destinationDirectory = new File('./new')
destinationDirectory.listFiles()*.delete()
files.each { File oldCsv ->

    String fileName = oldCsv.name.replace('.csv', '')
    println "fileName = $fileName"
    String lang = fileName.split('-')[0].toUpperCase()
    String test_type = fileName.split('-')[1].toUpperCase()
    String test_threads = fileName.split('-')[2]
    String server = fileName.split('-')[3]

    int testGroupIndex = 0
    File newCsv = new File(destinationDirectory, "$fileName-new.csv")
    newCsv.text = ''
    println "lang = $lang"
    println "test_type = $test_type"
    println "test_threads = $test_threads"
    println "server = $server"

    String firstDstatDate = oldCsv.readLines().first().split(',').first()
    long firstDate = Date.parse('yyy-dd-MM HH:mm:ss', "2015-$firstDstatDate").time / 1000

    oldCsv.eachWithIndex { String line, int index ->
        if (line.size() < 5) { // a bo tak
            testGroupIndex += 1
            println "$index: ${testGroups[testGroupIndex]}"
        } else {
            String testGroup = testGroups[testGroupIndex]
            def dstatDate = line.split(',').first()
            Date lineDate = Date.parse('yyy-dd-MM HH:mm:ss', "2015-$dstatDate")
            long seconds = (lineDate.time / 1000) - firstDate
            newCsv.append(line.replaceFirst(dstatDate, seconds.toString()) + ",$lang,$test_type,$test_threads,$server,$testGroup\n")
        }
    }
    assert testGroupIndex == 3
    println ''
}
