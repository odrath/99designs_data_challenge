# Tech stack and project description.
For this excercise I have used PostgreSQL and dbt with a PostgreSQL adapter.
The supplied .csv files have been ingested into the database using `dbt seed` command and the seed configuration details can be found in the *seed_properties.yml* file.

*Models* folder contains two subfolders:
* *base* - this layer includes setting up a surrogate key where none of the original columns can be used as a primary key. Each model has a 'manual_' prefix to indicate that the data is coming from a manual extract.
* *transform* - this layer contains one model combining all the information regarding purchases, whether ordered as a "contest" or as a "project".

Each of the subfolders includes a *schema.yml* file where unique and not_null tests are set for the primary keys.
All queries built to answer Part 1 and Part 2 questions can be found in the folder *analysis*.

# Data quality comments

File *contests* has duplicated rows. This issue should be solved at the source (while generating the CSV extract) but, for the purpose of this excercise, `SELECT DISTINCT` has been included in the *manual_contests* model.

Some of the purchase IDs from the *purchases* table cannot be found neither in the *contests* nor in the *projects* table, *i.g.* do not have client_id and designer_id assigned. There have been excluded from the *purchases_transformed* model.

# Part 1: SQL exercises solutions

## General assumptions and comments

All the refunded purchases has been excluded from the analysis, assuming that client who had two purchases - one refunded and one not refunded - is not a returning client. Appropriate comments have been made in the code to indicate the exclusion.

The SQL queries were written to include as many intermittent steps as possible to showcase the thinking.


## Question 1

> Who are the top 10 designers with the most repeat clients, and how many repeat clients do they have?


The query answering this question has been saved as *repeat_client_designer.sql* in the *analysis* model. 


## Question 2
> What percentage of first purchases in top 3 categories (based on returning clients) have repeat work (in any category) after?

The query answering this question has been saved as *repeat_client_category.sql* in the *analysis* model. 

# Part 2: Analysis
> Let’s say we wanted to create an email campaign to encourage repeat relationships. Based on the included data, what advice would you give for the design of this campaign? (e.g when should we send these emails? What should be in them? Who should we send them to? Is this even a good idea at all?)


The supplied data cannot be enough to understand the reasons behind why people choose to use the 99designs platform again. Before making any campaign decisions it would be good to understand more about the clients demographic to see if there are any patterns. It would be also helpful to ask the clients themselves about what makes them choose the platform or the designer again (and what makes them leave after the first purchase). Additionally, it would be useful to look at purchase history over the larger period of time to see not only more specific habits but also general seasonality, for example if the end of financial year makes people order more banner ads or flyers etc

However, I have explored a few hypothesis based on the supplied datasets. I started with the outcome of the Q 2 as a base of the analysis:

|  category             |  percentage of repeated clients  | 
|:---------------------:|:--------------------------------:|
| banner-ad-design      |  53 | 
| postcard-flyer-design |  38 |
| illustrations         |  36 | 

I wanted to understand better:
* whether people are making a second purchase in the same category (and what could this mean)?
* how quickly do people make a second purchase?

Firstly I ranked all the clients purchases:
```
with ranked AS (
    SELECT
        client_id
       ,purchases_sk
       ,CAST(time_purchased AS DATE)
       ,category
       ,RANK() OVER (
        PARTITION BY client_id
        ORDER BY CAST(time_purchased AS DATE) ASC
       ) purchase_rank
    
   FROM "dev_ninety"."purchases_transformed"
   WHERE is_refunded = 0 
   ORDER BY client_id
),

```

Secondly, I looked into what was the 'next purchase' category and when did the second purchase take place.

> Comment: If the second purchase was processed before the first design was delivered, it might be better to effectively treat the third (forth... ect) purchase as the second. For the purpose of this excercise I have ignored this, as well as did not look at the third and the following purchases.

```
next AS (

SELECT
       client_id
       ,purchases_sk
       ,time_purchased
       ,category
       ,purchase_rank
       ,LEAD(category,1) OVER (
           PARTITION BY client_id
           ORDER BY purchase_rank
       ) next_category
       ,LEAD(time_purchased,1) OVER (
           PARTITION BY client_id
           ORDER BY purchase_rank
       ) next_time_purchased
FROM ranked
),
```
Thirdly I have created two subsets of data, where the second purchase was the same category and where the second purchase was in a different category. 

```
same_category AS (
SELECT
       client_id
       ,purchases_sk
       ,category
       ,DATE_PART('day', next_time_purchased::timestamp - time_purchased::timestamp) AS days_difference

FROM next
WHERE purchase_rank = 1 
  AND next_category IS NOT NULL
  AND category = next_category

),


different_category AS (
SELECT
       client_id
       ,purchases_sk
       ,category
       ,next_category
FROM next
WHERE purchase_rank = 1 
  AND next_category IS NOT NULL
  AND category != next_category
)
```

For the repeated purchases in the same category I have looked at the average and maximum number of days between the first and second purchase.

```
SELECT 
    category
    ,MAX( days_difference) AS max_to_next_purchase
    ,ROUND(AVG( days_difference)) AS avg_to_next_purchase
FROM same_category
GROUP BY category
```

The results were as below:

|  category                |  max_to_next_purchase | avg_to_next_purchase |
|:------------------------:|:---------------------:|:--------------------:|
| banner-ad-design         | 108                   |  16 |
| book-cover-design        | 146                   |  26 |
| brochure-design          | 136                   |  21 |
| business-card-design     | 125                   |  22 |
| illustrations            | 111                   |  18 |
| postcard-flyer-design    | 144                   |  19 |
| product-label-design     | 134	               |  25 |
| product-packaging-design | 148	               |  23 |
| social-media-pack        | 133                   |  11 |
| t-shirt-design           | 133                   |  11 |
| web-design               | 138                   |  24 |

Based on these results one idea would be to send one email within first 2 - 4 weeks and another one within first 3 to 6 months after the purchase encouraging a purchase of the second design in the same category.


For the repeated purchases in a different category I looked at what were the most popular pairs of category.

```
SELECT
     category
     ,next_category
     ,COUNT(purchases_sk) AS count_of_snd_purchases
FROM different_category
GROUP BY category, next_category
ORDER BY category, COUNT(purchases_sk) DESC
```

Some examples of popular 1st & 2nd purchase pairs are:

* banner-ad-design &	postcard-flyer-design

* book-cover-design &	illustrations

* brochure-design	 & postcard-flyer-design

* business-card-design &	postcard-flyer-design

* postcard-flyer-design &	brochure-design

* product-label-design &	product-packaging-design

* product-packaging-design & product-label-design


Based on these results it might be a good idea to, for example, email a client who purchased a business-card-design to encourage them to also order a postcard-flyer-design, if they haven't already done so. 


In terms of clients returning to the same designer, I believe that more data might be needed to understand why they decide to come back, whether it's the quality of the design or price or a combination of a few factors (which would be my suspicion). Knowing the percentage of returning clients for each designer could be definitely a great help in advertising them to a new client (" 80% of clients of the designer ABC decide to make another purchase"), however my hypothesis is that it might not have an effect on the client who has already seen the results of their first purchase and formed an opinion whether they liked them or not. One idea could be looking at which categories does the designer offer and send an email saying "if you liked a flyer from this designer you might also look into their t-shirt and brochure designs".