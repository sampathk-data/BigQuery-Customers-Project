--load Transaction table into BQ
--Landing Zone 
file_name = /Users/sampath/Downloads/transactions.ndjson
schema_file = /Users/sampath/Downloads/transactions_schema.json
--Create Bucket in GCS
gsutil mb -l asia-south1 -c standard gs://transactions_data_b43
--Copy File to GCS
gsutil cp /Users/sampath/Downloads/transactions.ndjson gs://transactions_data_b43
gsutil cp /Users/sampath/Downloads/transactions_schema.json gs://transactions_data_b43
--Create dataset and Table 
bq mk -d transactions_stag_ds
bq mk -d transactions_hist_ds
bq mk -d transactions_views_ds

-- Create Table 
bq mk -t transactions_stag_ds.transactions_stag_ds
bq mk -t transactions_hist_ds.transactions_hist_ds
bq mk -t transactions_views_ds.transactions_views_ds

-- Create Table using SQL Query in BQ
CREATE TABLE students_data.students_data as (
    select 1 as rollno struct()
)


-- Load the Files to Staging table
bq load \
  --source_format=NEWLINE_DELIMITED_JSON \
  --schema=transactions_schema.json \
  transactions_stag_ds.transactions_stag_ds \
  gs://transactions_data_b43/transactions.ndjson
-- Load into Stage : Schema file should be local but not from GCS
bq load \
  --source_format=NEWLINE_DELIMITED_JSON \
  transactions_stag_ds.transactions_stag_ds \
  gs://transactions_data_b43/transactions.ndjson \
  transactions_schema.json
-- Inser into History 
bq query --use_legacy_sql=false '
INSERT INTO transactions_hist_ds.transactions_hist_ds
SELECT 
  SAFE_CAST(transaction_id AS INT64) AS TRAN_ID,
  SAFE_CAST(user_id  AS INT64) AS USER_ID,
  amount,
  occupation,
  SAFE_CAST(zip_code AS INT64) AS ZIP_CODE
FROM cust_stag_ds.cust_stag_ds;
'

--Load with trnasformations into history 

bq query --use_legacy_sql=false '
INSERT INTO transactions_hist_ds.transactions_hist_ds
SELECT
  transaction_id,
  user_id,
  amount,
  DATE(transaction_date) AS transaction_day,
  EXTRACT(YEAR FROM transaction_date) AS year,
  EXTRACT(MONTH FROM transaction_date) AS month,
  EXTRACT(DAYOFWEEK FROM transaction_date) AS day_of_week
FROM transactions_stag_ds.transactions_stag_ds;

