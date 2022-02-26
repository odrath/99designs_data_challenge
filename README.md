# Introduction
Hello! Welcome to the interview exercise for the 99designs lead data analyst position :) 
This exercise should take you around 2-3 hours to complete (though that’s a suggestion not a time limit, so there’s no need to time yourself). Our main goal here is to get an idea of how you think and test your SQL, analysis, and communication skills. 

Feel free to use any tools you’d like to answer the questions below – you’ll be judged based on your answers, and not on the tech stack used to get there.


# Background
For this exercise, we’ll be learning more about client-designer relationships on our platform. 99designs connects designers to clients looking for designs, primarily through contests and projects. A “contest” is a product where the client pays upfront and shares a design brief, many different designers submit designs based on that brief, and then the client chooses one or more winning designs to keep. In a “project”, the client and designer agree on a design brief and invoice amount, then work together one-on-one. 

The goal of these questions is to understand more about repeat relationships (i.e. cases where the same client-designer pair work together multiple times).


# Data
There are 3 data tables provided, showing data from Jan 2019 to June 2019 in the following categories: 'product-packaging-design', 'web-design', 'illustrations', 'postcard-flyer-design', 'product-label-design', 'book-cover-design', 't-shirt-design', 'social-media-pack', 'business-card-design', 'brochure-design', 'banner-ad-design'. 

Purchases: a record of sales (contests and projects) that happen on our platform

|  id    |   type   | time_purchased | time_completed | is_refunded |
|:------:|:--------:|:--------------:|:--------------:|:-----------:|
| 880744 |  contest |   1/2/19 1:31  |  1/6/19 17:36  |      0      |
| 880825 |  contest |   1/2/19 13:33 |  1/13/19 7:36  |      0      |
| 360743 |  project |  5/19/19 13:40 |                |      1      |

* id: The id of the contest or project. Can be used to join to the id field of the Contests or Projects table.
* type: Indicates whether this purchase was a contest or project
* time_purchased: The time that the client paid for the contest/project.
* time_completed: The time that the work was completed – i.e. when the client receives the design and the designer gets paid.
* is_refunded: indicates whether the purchase was later refunded (1) or not (0)


Contests: a record of designs that were purchased from a contest

|   id   | client_id | designer_id |        category       |
|:------:|:---------:|:-----------:|:---------------------:|
| 919757 |  3741782  |    324308   |  product-label-design |
| 904936 |  1186503  |    3591402  | postcard-flyer-design |
| 901814 |  901814   |    2896631  |     illustrations     |

* id: The id of the contest (joins to the id field of Purchases)
* client_id: The user_id of the client who purchased this contest
* designer_id: The user_id of the designer who completed the contest-winning design
* category: The category of the purchase (e.g. ‘illustrations’, ‘product-packaging-design’)


Projects: a record of purchased projects

|   id   | client_id | designer_id |        category       |
|:------:|:---------:|:-----------:|:---------------------:|
| 356693 |  1767161  |    1711419  |  business-card-design |
| 335834 |  2873843  |    1855967  |     t-shirt-design    |
| 345964 |  1929820  |    1855967  |   book-cover-design   |

* id: The id of the project (joins to the id field of Purchases)
* client_id: The user_id of the client who purchased this project
* designer_id: The user_id of the designer who has been commissioned for this project
* category: The category of the purchase (e.g. ‘illustrations’, ‘product-packaging-design’)


# Part 1: SQL exercises
Please answer each of the following with a SQL query. Note: you don’t need to actually create the data output, just write down the query you’d use to obtain it.
In a comment at the top of each query, please note which type of SQL you’re using, and any assumptions or interpretations that you’ve made in answering these questions.

1. When a designer works with the same client more than once, we call them a “repeat client” of that designer. Who are the top 10 designers with the most repeat clients, and how many repeat clients do they have?
2. Of the categories given, which 3 are the most likely to have repeat work after the initial purchase? What percentage of first purchases in these categories have repeat work (in any category) after?


# Part 2: Analysis
Let’s say we wanted to create an email campaign to encourage repeat relationships. Based on the included data, what advice would you give for the design of this campaign? (e.g. when should we send these emails? What should be in them? Who should we send them to? Is this even a good idea at all?) Give as much or as little input as you’d like -- we are NOT looking for a complete answer here (as that would take way too long!), so just focus on one or two aspects!
