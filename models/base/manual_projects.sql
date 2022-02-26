{{ config(
    materialized='table',
    tags=["projects"]  
) }}


SELECT *
FROM {{ref('projects')}}