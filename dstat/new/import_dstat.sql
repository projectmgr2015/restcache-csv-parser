drop table if EXISTS  dstat_tmp CASCADE ;
CREATE TABLE dstat_tmp (
  id                 BIGSERIAL NOT NULL,
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

CREATE TABLE dstat_time_diff AS
  SELECT
    test_language,
    test_type,
    test_group,
    test_server,
    min(seconds_from_start) min_sec,
  FROM jmeter_result_tmp
  GROUP BY test_language, test_type, test_group, test_server;

