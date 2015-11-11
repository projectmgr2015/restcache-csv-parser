DROP TABLE IF EXISTS dstat_tmp CASCADE;
DROP TABLE IF EXISTS dstat_time_diff CASCADE;
CREATE TABLE dstat_tmp (
  seconds_from_start BIGINT    NOT NULL,
  cpu_usr            FLOAT     NOT NULL,
  cpu_sys            FLOAT     NOT NULL,
  cpu_idl            FLOAT     NOT NULL,
  cpu_wai            FLOAT     NOT NULL,
  cpu_hiq            FLOAT     NOT NULL,
  cpu_siq            FLOAT     NOT NULL,
  disk_read          FLOAT     NOT NULL,
  disk_write         FLOAT     NOT NULL,
  net_recv           FLOAT     NOT NULL,
  net_send           FLOAT     NOT NULL,
  paging_in          FLOAT     NOT NULL,
  paging_out         FLOAT     NOT NULL,
  system_int         FLOAT     NOT NULL,
  system_csw         FLOAT     NOT NULL,
  memory_used        FLOAT     NOT NULL,
  memory_buff        FLOAT     NOT NULL,
  memory_cache       FLOAT     NOT NULL,
  memory_free        FLOAT     NOT NULL,
  test_language      TEXT      NOT NULL,
  test_type          TEXT      NOT NULL,
  test_threads       TEXT      NOT NULL,
  test_server        TEXT      NOT NULL,
  test_group         TEXT      NOT NULL
);

COPY dstat_tmp (seconds_from_start, cpu_usr, cpu_sys, cpu_idl, cpu_wai, cpu_hiq, cpu_siq, disk_read, disk_write, net_recv, net_send, paging_in, paging_out, system_int, system_csw, memory_used, memory_buff, memory_cache, memory_free, test_language, test_type, test_threads, test_server, test_group)
FROM '/csv/ALL.csv' DELIMITER ',' CSV;

DROP TABLE IF EXISTS dstat_time_diff CASCADE;
CREATE TABLE dstat_time_diff AS
  SELECT
    test_language,
    test_type,
    test_group,
    test_server,
    min(seconds_from_start) min_sec
  FROM dstat_tmp
  GROUP BY test_language, test_type, test_group, test_server;

DROP TABLE dstat CASCADE;
CREATE TABLE dstat AS
  SELECT
    (seconds_from_start - (SELECT td.min_sec
                           FROM dstat_time_diff td
                           WHERE d.test_language = td.test_language AND d.test_type = td.test_type AND
                                 d.test_group = td.test_group AND td.test_server = d.test_server)) seconds_from_start,

    cpu_usr,
    cpu_sys,
    cpu_idl,
    cpu_wai,
    cpu_hiq,
    cpu_siq,
    disk_read,
    disk_write,
    net_recv,
    net_send,
    paging_in,
    paging_out,
    system_int,
    system_csw,
    memory_used,
    memory_buff,
    memory_cache,
    memory_free,
    test_language,
    test_type,
    substring(test_threads from 1 for 3)::INT as test_threads,
    upper(test_server)                                                                             test_server,
    test_group :: test_group
  FROM dstat_tmp d;

SELECT
  test_language,
  test_type,
  test_group,
  test_server,
  test_threads,
  min(seconds_from_start),
  max(seconds_from_start),
  count(*)
FROM dstat
GROUP BY test_language, test_group, test_type, test_threads, test_server
ORDER BY test_language, test_type, test_group, test_threads, test_server;

