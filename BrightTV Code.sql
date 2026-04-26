SELECT 
       A.userid,
       
       -- Cleaned demographics
       COALESCE(NULLIF(TRIM(A.gender), ''), 'Unknown') AS gender,
       COALESCE(NULLIF(TRIM(A.race), ''), 'Unknown') AS race,
       COALESCE(NULLIF(TRIM(A.province), ''), 'Unknown') AS province,
       A.age,

       -- Age group
       CASE  
            WHEN A.age < 16 THEN 'Kids' 
            WHEN A.age BETWEEN 16 AND 17 THEN 'Teenagers'
            WHEN A.age BETWEEN 18 AND 35 THEN 'Youth'
            WHEN A.age BETWEEN 36 AND 44 THEN 'Young Adults'
            WHEN A.age BETWEEN 45 AND 54 THEN 'Adults'
            ELSE 'Elders'     
       END AS age_group,

       -- Viewership data
       B.Channel2 AS channel_name,

       -- Convert UTC to SA time properly
       from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg') AS SA_time,

       -- Date & Time split
       CAST(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg') AS DATE) AS date_field,
       date_format(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg'), 'HH:mm:ss') AS time_field,

       -- Time slots (based on SA time)
       CASE 
            WHEN hour(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) BETWEEN 5 AND 11 THEN 'Morning'
            WHEN hour(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN hour(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) BETWEEN 18 AND 23 THEN 'Night'
            ELSE 'Midnight'
       END AS time_slots,

       -- Day & Month
       DAYNAME(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) AS day_name,
       MONTHNAME(from_utc_timestamp(B.RecordDate2, 'Africa/Johannesburg')) AS month_name,

       -- Duration in minutes
       (HOUR(B.`Duration 2`) * 60 + MINUTE(B.`Duration 2`)) AS duration_minutes

FROM `workspace`.`default`.`user_profiles` AS A

LEFT JOIN `workspace`.`default`.`viewership` AS B
ON A.userid = B.UserID4;
