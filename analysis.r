df <- read.csv("C:/Users/745/Desktop/Data Sets/ecommerce_return_abuse_dataset.csv")
library(tidyverse)
View(df)

#Product category vs return abuse type

#A table without legitimate retuns
abusive <- df %>% filter(abuse_type != 'Legitimate')   # adjust to how your label is coded
tab <- table(category = abusive$product_category, abuse_type = abusive$abuse_type)
prop.table(tab, margin = 1)
View(tab)

#Chi test for df, x-squared and p-value
chisq.test(tab)$expected #expectation
chisq.test(tab) #returns the x-squared, degree of freedom and the p-value
#since the p-value is less than the significance level, I will reject the Null-hypothesis 

#CramerV calculated manually 
n <- sum(tab)
chi <- unname(chisq.test(tab)$statistic)
v <- sqrt(chi / (n * min(nrow(tab)-1, ncol(tab)-1)))
v
#CramersV = 0.1862 which means there is a weak association between the product category and the return abuse type.
# I will then standardize the standard error from the expected proportion
#to show which category was abnormal 
test <- chisq.test(tab)
test$stdres #standardization




#Second part of the question, per country 
tab_country <- table(country = abusive$country, category = abusive$product_category, abuse_type = abusive$abuse_type)
View(tab_country)

#Check if expection meets the chi-test requirements 
countries <- unique(abusive$country)

expected_list <- lapply(countries, function(c) {
  country_data <- abusive %>% filter(country == c)
  country_table <- table(country_data$product_category,
                         country_data$abuse_type)
  
  chisq.test(country_table)$expected
})

names(expected_list) <- countries
sapply(expected_list, min)


#To calculate the chi square, degree of freedom and p-value for all countries.
chi_results <- lapply(countries, function(c) {
  country_data <- abusive %>% filter(country == c)
  
  country_table <- table(
    country_data$product_category,
    country_data$abuse_type
  )
  
  chisq.test(country_table)
})

names(chi_results) <- countries

lapply(chi_results, function(x) {
  c(
    Chi_squared = unname(x$statistic),
    df = unname(x$parameter),
    p_value = x$p.value
  )
})


#Calculate cramerv for all countries 

cramer_results <- lapply(countries, function(c) {
  country_data <- abusive %>% filter(country == c)
  
  country_table <- table(
    country_data$product_category,
    country_data$abuse_type
  )
  
  chi <- chisq.test(country_table)$statistic
  n <- sum(country_table)
  
  sqrt(chi / (n * min(nrow(country_table) - 1,
                      ncol(country_table) - 1)))
})

names(cramer_results) <- countries

unlist(cramer_results)



#Residual results
residual_results <- lapply(countries, function(c) {
  country_data <- abusive %>% filter(country == c)
  
  country_table <- table(
    country_data$product_category,
    country_data$abuse_type
  )
  
  chisq.test(country_table)$stdres
})

names(residual_results) <- countries

residual_results
 

#HEAT MAP NOW 
resid_df <- as.data.frame(as.table(test$stdres)) %>%
  rename(category = category, abuse_type = abuse_type, residual = Freq)

order_cats <- resid_df %>%
  group_by(category) %>%
  summarise(contrib = sum(residual^2)) %>%
  arrange(desc(contrib)) %>%
  pull(category)

resid_df <- resid_df %>%
  mutate(category = factor(category, levels = rev(order_cats)),
         notable  = abs(residual) > 3)

ggplot(resid_df, aes(x = abuse_type, y = category, fill = residual)) +
  geom_tile(color = "white", linewidth = 0.8) +
  geom_text(aes(label = sprintf("%.1f", residual),
                fontface = ifelse(notable, "bold", "plain")), size = 4) +
  scale_fill_gradient2(low = "#2166AC", mid = "white", high = "#B2182B",
                       midpoint = 0, limits = c(-18, 18),
                       name = "Adjusted\nstandardized\nresidual") +
  labs(title = "Return abuse type by product category",
       subtitle = "Red = more cases than expected; blue = fewer. Bold = |residual| > 3",
       x = NULL, y = NULL) +
  theme_minimal(base_size = 13) +
  theme(panel.grid = element_blank())

