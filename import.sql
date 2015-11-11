09

CREATE TABLE jmeter_result_tmp (
  id                 BIGSERIAL NOT NULL,
  seconds_from_start BIGINT    NOT NULL,
  milis_from_start   BIGINT    NOT NULL,
  test_group         TEXT      NOT NULL,
  test_name          TEXT      NOT NULL,
  latency            INT4      NOT NULL,
  response_code      TEXT      NOT NULL,
  response_name      TEXT      NOT NULL,
  thread             TEXT      NOT NULL,
  data_type          TEXT      NOT NULL,
  success            BOOLEAN   NOT NULL,
  bytes              INT4      NOT NULL,
  number_1           INT4      NOT NULL,
  number_2           INT4      NOT NULL,
  number_3           INT4      NOT NULL,
  test_language      TEXT      NOT NULL,
  test_threads       INT4      NOT NULL,
  test_type          TEXT      NOT NULL
);

COPY jmeter_result_tmp (seconds_from_start, milis_from_start, test_group, test_name, latency, response_code, response_name, thread, data_type, success, bytes, number_1, number_2, number_3, test_language, test_threads, test_type)
FROM '/csv/jmeter.csv' DELIMITER ',' CSV;

CREATE TABLE jmeter_result_time_diff AS
  SELECT
    test_language,
    test_type,
    test_group,
    min(seconds_from_start) min_sec,
    min(milis_from_start)   min_milis
  FROM jmeter_result_tmp
  GROUP BY test_language, test_type, test_group;

CREATE INDEX tmp ON jmeter_result_time_diff (test_language, test_group, test_type);

CREATE TABLE jmeter_result_go_full AS
  SELECT
    id,
    (seconds_from_start - (SELECT td.min_sec
                           FROM jmeter_result_time_diff td
                           WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                                 j.test_group = td.test_group)) seconds_from_start,
    (milis_from_start - (SELECT td.min_milis
                         FROM jmeter_result_time_diff td
                         WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                               j.test_group = td.test_group))   milis_from_start,
    test_group,
    test_name,
    latency,
    response_code,
    response_name,
    thread,
    data_type,
    success,
    bytes,
    number_1,
    number_2,
    number_3,
    test_language,
    test_threads,
    test_type
  FROM jmeter_result_tmp j  WHERE j.test_language = 'GO' AND test_type = 'FULL';
CREATE TABLE jmeter_result_go_clean AS
  SELECT
    id,
    (seconds_from_start - (SELECT td.min_sec
                           FROM jmeter_result_time_diff td
                           WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                                 j.test_group = td.test_group)) seconds_from_start,
    (milis_from_start - (SELECT td.min_milis
                         FROM jmeter_result_time_diff td
                         WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                               j.test_group = td.test_group))   milis_from_start,
    test_group,
    test_name,
    latency,
    response_code,
    response_name,
    thread,
    data_type,
    success,
    bytes,
    number_1,
    number_2,
    number_3,
    test_language,
    test_threads,
    test_type
  FROM jmeter_result_tmp j
  WHERE j.test_language = 'GO' AND test_type = 'CLEAN';
CREATE TABLE jmeter_result_jetty_full AS
  SELECT
    id,
    (seconds_from_start - (SELECT td.min_sec
                           FROM jmeter_result_time_diff td
                           WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                                 j.test_group = td.test_group)) seconds_from_start,
    (milis_from_start - (SELECT td.min_milis
                         FROM jmeter_result_time_diff td
                         WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                               j.test_group = td.test_group))   milis_from_start,
    test_group,
    test_name,
    latency,
    response_code,
    response_name,
    thread,
    data_type,
    success,
    bytes,
    number_1,
    number_2,
    number_3,
    test_language,
    test_threads,
    test_type
  FROM jmeter_result_tmp j
  WHERE j.test_language = 'JETTY' AND test_type = 'FULL';
CREATE TABLE jmeter_result_jetty_clean AS
  SELECT
    id,
    (seconds_from_start - (SELECT td.min_sec
                           FROM jmeter_result_time_diff td
                           WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                                 j.test_group = td.test_group)) seconds_from_start,
    (milis_from_start - (SELECT td.min_milis
                         FROM jmeter_result_time_diff td
                         WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                               j.test_group = td.test_group))   milis_from_start,
    test_group,
    test_name,
    latency,
    response_code,
    response_name,
    thread,
    data_type,
    success,
    bytes,
    number_1,
    number_2,
    number_3,
    test_language,
    test_threads,
    test_type
  FROM jmeter_result_tmp j
  WHERE j.test_language = 'JETTY' AND test_type = 'CLEAN';
CREATE TABLE jmeter_result_tomcat_full AS
  SELECT
    id,
    (seconds_from_start - (SELECT td.min_sec
                           FROM jmeter_result_time_diff td
                           WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                                 j.test_group = td.test_group)) seconds_from_start,
    (milis_from_start - (SELECT td.min_milis
                         FROM jmeter_result_time_diff td
                         WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                               j.test_group = td.test_group))   milis_from_start,
    test_group,
    test_name,
    latency,
    response_code,
    response_name,
    thread,
    data_type,
    success,
    bytes,
    number_1,
    number_2,
    number_3,
    test_language,
    test_threads,
    test_type
  FROM jmeter_result_tmp j
  WHERE j.test_language = 'TOMCAT' AND test_type = 'FULL';
CREATE TABLE jmeter_result_tomcat_clean AS
  SELECT
    id,
    (seconds_from_start - (SELECT td.min_sec
                           FROM jmeter_result_time_diff td
                           WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                                 j.test_group = td.test_group)) seconds_from_start,
    (milis_from_start - (SELECT td.min_milis
                         FROM jmeter_result_time_diff td
                         WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                               j.test_group = td.test_group))   milis_from_start,
    test_group,
    test_name,
    latency,
    response_code,
    response_name,
    thread,
    data_type,
    success,
    bytes,
    number_1,
    number_2,
    number_3,
    test_language,
    test_threads,
    test_type
  FROM jmeter_result_tmp j
  WHERE j.test_language = 'TOMCAT' AND test_type = 'CLEAN';
-- DROP TABLE jmeter_result_time_diff CASCADE;

CREATE INDEX gc_seconds_from_start_idx ON jmeter_result_go_clean (seconds_from_start);
CREATE INDEX gc_milis_from_start_idx ON jmeter_result_go_clean (milis_from_start);
CREATE INDEX gc_test_threads_idx ON jmeter_result_go_clean (test_threads);

CREATE INDEX gf_seconds_from_start_idx ON jmeter_result_go_full (seconds_from_start);
CREATE INDEX gf_milis_from_start_idx ON jmeter_result_go_full (milis_from_start);
CREATE INDEX gf_test_threads_idx ON jmeter_result_go_full (test_threads);

CREATE INDEX jc_seconds_from_start_idx ON jmeter_result_jetty_clean (seconds_from_start);
CREATE INDEX jc_milis_from_start_idx ON jmeter_result_jetty_clean (milis_from_start);
CREATE INDEX jc_test_threads_idx ON jmeter_result_jetty_clean (test_threads);

CREATE INDEX jf_seconds_from_start_idx ON jmeter_result_jetty_full (seconds_from_start);
CREATE INDEX jf_milis_from_start_idx ON jmeter_result_jetty_full (milis_from_start);
CREATE INDEX jf_test_threads_idx ON jmeter_result_jetty_full (test_threads);

CREATE INDEX tc_seconds_from_start_idx ON jmeter_result_tomcat_clean (seconds_from_start);
CREATE INDEX tc_milis_from_start_idx ON jmeter_result_tomcat_clean (milis_from_start);
CREATE INDEX tc_test_threads_idx ON jmeter_result_tomcat_clean (test_threads);

CREATE INDEX tf_seconds_from_start_idx ON jmeter_result_tomcat_full (seconds_from_start);
CREATE INDEX tf_milis_from_start_idx ON jmeter_result_tomcat_full (milis_from_start);
CREATE INDEX tf_test_threads_idx ON jmeter_result_tomcat_full (test_threads);

CREATE TABLE jmeter_result_go_full_tmp (
  id                 BIGSERIAL NOT NULL,
  seconds_from_start BIGINT    NOT NULL,
  milis_from_start   BIGINT    NOT NULL,
  test_group         TEXT      NOT NULL,
  test_name          TEXT      NOT NULL,
  latency            INT4      NOT NULL,
  response_code      INT4      NOT NULL,
  response_name      TEXT      NOT NULL,
  thread             TEXT      NOT NULL,
  data_type          TEXT      NOT NULL,
  success            BOOLEAN   NOT NULL,
  bytes              INT4      NOT NULL,
  number_1           INT4      NOT NULL,
  number_2           INT4      NOT NULL,
  number_3           INT4      NOT NULL,
  test_language      TEXT      NOT NULL,
  test_threads       INT4      NOT NULL,
  test_type          TEXT      NOT NULL
);

COPY jmeter_result_go_full_tmp (seconds_from_start, milis_from_start, test_group, test_name, latency, response_code, response_name, thread, data_type, success, bytes, number_1, number_2, number_3, test_language, test_threads, test_type)
FROM '/csv/go.csv' DELIMITER ',' CSV;

insert into jmeter_result_time_diff
  SELECT
    test_language,
    test_type,
    test_group,
    min(seconds_from_start) min_sec,
    min(milis_from_start)   min_milis
  FROM jmeter_result_go_full_tmp
  GROUP BY test_language, test_type, test_group;
--

CREATE TABLE jmeter_result_go_full AS
  SELECT
    id,
    (seconds_from_start - (SELECT td.min_sec
                           FROM jmeter_result_time_diff td
                           WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                                 j.test_group = td.test_group)) seconds_from_start,
    (milis_from_start - (SELECT td.min_milis
                         FROM jmeter_result_time_diff td
                         WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                               j.test_group = td.test_group))   milis_from_start,
    test_group::test_group,
    test_name::test_name,
    latency,
    response_code,
    response_name,
    thread,
    data_type,
    success,
    bytes,
    number_1,
    number_2,
    number_3,
    test_language,
    test_threads,
    test_type
  FROM jmeter_result_go_full_tmp j ;
CREATE TABLE jmeter_result_go_clean AS
  SELECT
    id,
    (seconds_from_start - (SELECT td.min_sec
                           FROM jmeter_result_time_diff td
                           WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                                 j.test_group = td.test_group)) seconds_from_start,
    (milis_from_start - (SELECT td.min_milis
                         FROM jmeter_result_time_diff td
                         WHERE j.test_language = td.test_language AND j.test_type = td.test_type AND
                               j.test_group = td.test_group))   milis_from_start,
    test_group::test_group,
    test_name::test_name,
    latency,
    response_code,
    response_name,
    thread,
    data_type,
    success,
    bytes,
    number_1,
    number_2,
    number_3,
    test_language,
    test_threads,
    test_type
  FROM jmeter_result_go_clean_tmp j;
--

alter TABLE jmeter_result_go_clean RENAME COLUMN number_3 to response_time;
alter TABLE jmeter_result_go_full RENAME COLUMN number_3 to response_time;
alter TABLE jmeter_result_jetty_clean RENAME COLUMN number_3 to response_time;
alter TABLE jmeter_result_jetty_full RENAME COLUMN number_3 to response_time;
alter TABLE jmeter_result_tomcat_clean RENAME COLUMN number_3 to response_time;
alter TABLE jmeter_result_tomcat_full RENAME COLUMN number_3 to response_time;


CREATE INDEX tf_response_time_idx ON jmeter_result_tomcat_full (response_time);
CREATE INDEX tc_response_time_idx ON jmeter_result_tomcat_clean (response_time);
CREATE INDEX jf_response_time_idx ON jmeter_result_jetty_full (response_time);
CREATE INDEX jc_response_time_idx ON jmeter_result_jetty_clean (response_time);
CREATE INDEX gf_response_time_idx ON jmeter_result_go_full (response_time);
CREATE INDEX gc_response_time_idx ON jmeter_result_go_clean (response_time);

CREATE INDEX tf_test_group_idx ON jmeter_result_tomcat_full (test_group);
CREATE INDEX tc_test_group_idx ON jmeter_result_tomcat_clean (test_group);
CREATE INDEX jf_test_group_idx ON jmeter_result_jetty_full (test_group);
CREATE INDEX jc_test_group_idx ON jmeter_result_jetty_clean (test_group);
CREATE INDEX jf_test_group_idx ON jmeter_result_go_full (test_group);
CREATE INDEX jc_test_group_idx ON jmeter_result_go_clean (test_group);

CREATE INDEX tf_test_name_idx ON jmeter_result_tomcat_full (test_name);
CREATE INDEX tc_test_name_idx ON jmeter_result_tomcat_clean (test_name);
CREATE INDEX jf_test_name_idx ON jmeter_result_jetty_full (test_name);
CREATE INDEX jc_test_name_idx ON jmeter_result_jetty_clean (test_name);
CREATE INDEX jf_test_name_idx ON jmeter_result_go_full (test_name);
CREATE INDEX jc_test_name_idx ON jmeter_result_go_clean (test_name);
