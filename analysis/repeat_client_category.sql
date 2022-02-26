WITH first_purchase_time AS (
   SELECT
       client_id
       ,MAX(time_purchased) AS first_purchase_time
   FROM "dev_ninety"."purchases_transformed"
   WHERE is_refunded = 0  -- only looking at not refunded purchases
   GROUP BY client_id
),
 
first_category AS (
   SELECT
       fp.*
       ,pt.category AS first_purchase_category
   FROM first_purchase_time fp
   LEFT JOIN "dev_ninety"."purchases_transformed" pt
   ON fp.client_id = pt.client_id
   AND fp.first_purchase_time = pt.time_purchased
),
 
purchases_with_f_cat AS (
   SELECT
       pt.*
       ,fc.first_purchase_category
   FROM "dev_ninety"."purchases_transformed" pt
   LEFT JOIN first_category fc
   ON pt.client_id = fc.client_id
   WHERE is_refunded = 0  -- only looking at not refunded purchases
),


repeated_client_purchases AS(
    SELECT
        first_purchase_category
        ,client_id
        ,COUNT(purchases_sk) AS count_of_purchases
    FROM purchases_with_f_cat
    GROUP BY client_id, first_purchase_category
    HAVING COUNT(purchases_sk) > 1
    ORDER BY first_purchase_category
),



repeated_clients_per_category AS (
    SELECT
       first_purchase_category
       ,COUNT(client_id) AS repeat_clients  
    FROM repeated_client_purchases
    GROUP BY first_purchase_category
),


all_clients_per_category AS (
    SELECT
       first_purchase_category
       ,COUNT(DISTINCT client_id) AS all_clients  
    FROM purchases_with_f_cat
    GROUP BY first_purchase_category
)


SELECT
    alc.first_purchase_category
    ,ROUND(CAST(repeat_clients AS DECIMAL) / all_clients  * 100) AS ptg_repeated_per_category
FROM  all_clients_per_category alc
LEFT JOIN repeated_clients_per_category rep
ON alc.first_purchase_category = rep.first_purchase_category
ORDER BY ptg_repeated_per_category DESC
LIMIT 3;


