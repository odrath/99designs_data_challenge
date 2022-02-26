{{ config(
    materialized='table',
    tags=["contests"]  
) }}

/*This data has duplicated rows. This issue should be solved at the source (while generating the CSV extract).
   A hot fix solution has been applied by taking only DISTINCT rows */

SELECT DISTINCT
     c.*
     ,CONCAT(id,'_',designer_id) AS contests_sk
FROM {{ref('contests')}} c