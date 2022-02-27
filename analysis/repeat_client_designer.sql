
-- Let's see which clients bought more than once from the same designer

WITH repeated_client_purchases AS(
   SELECT
       designer_id
       ,client_id
       ,COUNT(purchases_sk) AS count_of_purchases
   FROM dev_ninety.purchases_transformed
   WHERE is_refunded = 0  -- only looking at not refunded purchases
   GROUP BY designer_id, client_id
   HAVING COUNT(purchases_sk) > 1
   ORDER BY designer_id
)
 
 -- Let's count the number of repeat clients for each designer and find the top 10 designers
 
SELECT
   designer_id
   ,COUNT(client_id) AS repeat_clients  
FROM repeated_client_purchases
GROUP BY designer_id
ORDER BY COUNT(client_id) DESC
LIMIT 10;