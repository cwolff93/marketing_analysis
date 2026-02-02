# marketing_analysis
Technical test with dummy data

# SITUATION

This project sought to understand which campaigns and sources had the most success based on sales for a dummy company.

# TASK

Main objectives:

1️⃣ Find the overall conversion rate for the campaigns.

2️⃣ Find the most frequent source and the conversion rates for the sources.

3️⃣ Extract actionable insights to improve sales through analysis of successful campaigns.

# ACTIONS 

The data was extracted, transformed and loaded (ETL) on Google Big Query. Initial analysis was made to assess what sort of data was being worked on, making data cleaning one of the most important steps of the process in order to further understand what was being presented. The tables were joined with a LEFT JOIN, since not every lead becomes a customer.

# RESULTS

There are 1274 leads and 157 sales, with an overall conversion rate of 12,32% amongst 26 distinct campaigns. The most frequent source used is instagram, totaling almost 44% of results, though the highest conversion rate happens when the source is the 'portal' (16%). The other two biggest sources aren't far behind, with 'instagram' in second place (15%) and 'e-mail' in third (12%). That being said, instagram had the most succesful campaign within the platform having completed 53 sales out of 77 sales.

The campaign 'Lead Source F3' had the lowest conversion rate, with zero sales in two of its three sources utilized. 

There are lines in which columns have divergent information between leads and sales tables, which might be an error during data collection. Further evidences of errors during this stage are happen in other situations, such as: sales registered before a lead date for the same user e-mail, pointing to a possible data overwrite that can mask results, leading to mistakes during analysis; rows with null information on campaign, meduim and source accounting for the second most sales; and distinct campaigns that become a singular campaign between tables.

# INSIGHTS

1️⃣ Check data sources to fix possible funnel, label or collection mistakes to minimize errors and null information.

2️⃣ Analyze which campaigns should be cut from the roster or possibly improved on in order to save costs based on their conversion rates.

3️⃣ Improve conversion rate by creating a date_lost and a web page drop out column to verify when and at what stage did leads give up on completing the sale. Improving the website may be a key factor in completing the sales funnel.

4️⃣ Run tests to check for possible statistical significance between user e-mail domains, since spam filters may be impacting the reach of campaigns.
