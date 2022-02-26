{{ config(
    materialized='table',
    tags=["purchases"]  
) }}


SELECT *
FROM {{ref('purchases')}}