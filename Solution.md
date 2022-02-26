# Tech stack and project description.
For this excercise I have used PostgreSQL and dbt with a PostgreSQL adapter.
The supplied .csv files have been ingested into the database using `dbt seed` command and the seed configuration details can be found in the *seed_properties.yml* file.
*Models* folder contains two subfolders:
* *base* - this layer includes setting up a surrogate key where none of the columns can be used as one
* *transform* - this layer contains one model combining all the information regarding purchases, whether orderd as "contest" or as "project".
Each of the subfolders includes a *schema.yml* file where unique and not_null tests are set for the primary keys.
All queries built to answer Part 1 and Part 2 questions can be found in the folder *analysis*.

# Data quality comments



# Part 1: SQL exercises solutions

## General assumptions

All the refunded purchases has been excluded from the analysis, assuming that client who had two purchases - one refunded and one not refunded - is not a returning client.
Appriopriate comments have been made in the code to indicate the exclusion.


## Question 1

> Who are the top 10 designers with the most repeat clients, and how many repeat clients do they have?

The

|  id    |   type   | time_purchased | time_completed | is_refunded |
|:------:|:--------:|:--------------:|:--------------:|:-----------:|
| 880744 |  contest |   1/2/19 1:31  |  1/6/19 17:36  |      0      |
| 880825 |  contest |   1/2/19 13:33 |  1/13/19 7:36  |      0      |
| 360743 |  project |  5/19/19 13:40 |                |      1      |


## Question 2
> What percentage of first purchases in top 3 categories (based on returning clients) have repeat work (in any category) after?


# Part 2: Analysis
> Let’s say we wanted to create an email campaign to encourage repeat relationships. Based on the included data, what advice would you give for the design of this campaign? (e.g when should we send these emails? What should be in them? Who should we send them to? Is this even a good idea at all?)
