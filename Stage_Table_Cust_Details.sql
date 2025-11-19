CREATE OR REPLACE TABLE cust_stag_ds.cust_stag_ds (
  user_id STRING,
  age STRING,
  gender STRING,
  occupation STRING,
  zip_code STRING,
  description STRING
);


bq load --source_format=CSV --skip_leading_rows=1 --autodetect ust_stag_ds.ust_stag_ds gs://new_dis_bucket/customer_details.csv

bq load --source_format=CSV --skip_leading_rows=1 --autodetect cust_stag_ds.cust_stag_ds gs://new_dis_bucket/customer_details.csv