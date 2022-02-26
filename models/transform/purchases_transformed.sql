{{ config(
    materialized='table',
    tags=["purchases"]  
) }}

/*
[projects] table has the same granularity as [purchases] table, where one row corresponds to a unique purchase [ID].

[contests] table has a different granularity from [purchases] table, where one row corresponds to a unique purchase-designer pair, 
 hence the same purchase [ID] can appear in multiple rows. 

For clarity, two types of purchases were joined separately and unioned.

Caveat: Some purchases which don't have recorded designer/client ids will not be included in this table.

*/



WITH purchased_from_projects AS (
    SELECT
        CONCAT(pur.id,'_',p.designer_id) AS purchases_sk
        ,pur.*
        ,p.designer_id
        ,p.client_id
        ,p.category
    FROM {{ref('manual_projects')}} p
    LEFT JOIN {{ref('manual_purchases')}} pur
    ON p.id = pur.id
),


purchased_from_contests AS (
    SELECT 
         contests_sk AS purchases_sk
        ,pur.*
        ,c.designer_id
        ,c.client_id
        ,c.category
   
    FROM {{ref('manual_contests')}} c
    LEFT JOIN {{ref('manual_purchases')}} pur
ON c.id = pur.id
)



SELECT *
FROM purchased_from_projects

UNION ALL

SELECT *
FROM purchased_from_contests






