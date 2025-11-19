-- Login into Gcloud and Initialize gcloud 
gcloud init
gcloud auth login
-- Create Bucket using SDK 
gsutil mb -l -c gs://batch11/usecase/data/
-- create history table using schema 
bq mk -t cust_hist_ds.cust_hist_ds \
user_id:INT, \
age:INT, \
gender:STRING, \
occupation:STRING, \
zip_code:INT
--- Another Method to Cerate Table 
CREATE OR REPLACE TABLE cust_history_ds.cust_history_ds (
    user_id INT64,
    age INT64,
    gender STRING,
    occupation STRING,
    zip_code INT64
);
-- GPT Suggested Query 
bq query --use_legacy_sql=false 'CREATE OR REPLACE TABLE cust_history_ds.cust_history_ds (user_id INT64, age INT64, gender STRING, occupation STRING, zip_code INT64)'
--- Insert data into History Table
INSERT INTO cust_hist_ds.cust_hist_ds
select SAFE_CAST(user_id as INT64) as USER_ID,
SAFE_CAST(age as INT64) as AGE,
SAFE_CAST(gender as STRING) as GENDER,
occupation,
SAFE_CAST(zip_code as INT) as ZIP_CODE 
FROM cust_stag_ds.cust_stag_ds
-- GPT Suggested Query 
bq query --use_legacy_sql=false '
INSERT INTO cust_history_ds.cust_history_ds
SELECT 
  SAFE_CAST(user_id AS INT64) AS USER_ID,
  SAFE_CAST(age AS INT64) AS AGE,
  SAFE_CAST(gender AS STRING) AS GENDER,
  occupation,
  SAFE_CAST(zip_code AS INT64) AS ZIP_CODE
FROM cust_stag_ds.cust_stag_ds;
'


