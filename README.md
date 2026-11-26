# ecommerce_return_abuse_analysis
This is an analysis to find out if there is an association between the type of return abuse and product category and if this association varies per country

#Background and Dataset Description
The rapid growth of e-commerce has made flexible return policies essential for customer satisfaction and online shopping convenience. However, these policies also create opportunities for return abuse, increasing operational costs, reducing profitability, and undermining trust between retailers and consumers. This project aims to apply statistical methods to analyze relationship between product category and return abuse type. 

Tools
R, ggplot2

Approach
I loaded my data in R and filtered out legitimate returns. 
I then created a contingency table and checked for a relationship between the product category and return abuse type use Chi square test. 
I then checked for the strength of the relationship after the Chi square test proved there was a relationship between the 2 variables. 
I performed the same steps per country to check if the relationship differs per country. 

Key findings
There is indeed an association between product category and return abuse type. However the strength of this relationship is relatively weak. I did a residual standardization of the products and return abuse and realized wardrobing was most prevalent in Beauty, Clothing and Shoes and was barely present in Electronics. Both Fraudulent return and policy abusers shows were most prevalent in Electronics. 

Similarly the association was with the countries and the strength of the association was fairly similar in all the countries. Wardrobing was the highest and most prevalent among the product categories with the United states recording the highest residual standardization above the mean. 
