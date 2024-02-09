## Project Description

## Power BI Report

### 1. Data Imports
Each of the tables *Orders*, *Products*, *Stores*, and *Customers* is imported into the Power BI project from a different source.

- The *Orders* table is imported from the Azure SQL Database using import mode. 

- The *Produts* table is imported from a local csv file.
- The *Stores* table is imported via an Azure Blob Sorage url. 
- The *Customers* table is imported by from a local folder containing three csv files which are combined into a single query. 

### 2. Data Transformations
The Power Query Editor is used to transform elements of each table before loading. 
#### Orders table:
- Each of the columns *Order Date* and *Shipping Date*, which initially contain both date and time, are split into two columns to separate date and time. 
- Missing values are removed from *Order Date* 

#### Products table:
- Initally the *Weight* column contains both weight value and unit, with a variety of unit types. Several steps are implemented to convert all values to unit kilograms, and retain only numeric characters. 

#### Stores table:
- Initially, the *World Region* column contains varied entries for the same region, for example "Europe" and "eeEurope" and "America" and "eeAmerica". \
The "ee" prefix is removed from rows using the *Replace Vales* function.  

#### Customers table:
- The column *Full Name* is created by combining *First Name* and *Last Name*.
- The column *Source.Name* is removed.

\
Across all tables column headings are adjusted for consistency and to fit Power BI naming conventions. 

### 3. Model Construction
Several steps are implemented to build out the data model for effective analysis.

#### Dates table:
- The table *Dates* is created with a continuous *Date* column using DAX: \
Dates = CALENDAR(DATE(YEAR(MIN(Orders[Order Date])), 1, 1),\
DATE(YEAR(MAX(Orders[Order Date])), 12, 31))

- The table *Dates* is built out with columns for *Day of Week*, *Month Number*, *Month Name*, *Quarter*, *Year*, *Start of Year*, *Start of Quarter*, *Start of Month* and *Start of Week*.

#### Table relationships:
The following many to one (left to right) relationships were created between tables:

- Orders[Product Code] to Products[Product Code]

- Orders[Store Code] to Stores[Store Code]
- Orders[User ID] to Customers[User UUID]
- Orders[Order Date] to Date[Date]
- Orders[Shipping Date] to Date[Date]

Between the last two relationaships indicates above, Orders[Order Date] to Date[Date] was marked as the active relationaship. 

A screenshot of the data model star schema can be seen below \
\
![Images/star_schema.png](Images/star_schema.png)

#### Measures table

A separate *Measures table* was created in the Power Query Editor.
\
Several key measures were calculated using DAX:

- Total Orders = COUNT(Orders[User ID])

- Total Customers = DISTINCTCOUNT(Orders[User ID])
- Total Quantity = SUM(Orders[Product Quantity])
- Total Revenue = SUMX(Orders, Orders[Product Quantity] * RELATED('Products'[Sale Price]))
- Total Profit = SUMX(Orders, Orders[Product Quantity] * (RELATED('Products'[Sale Price]) - RELATED('Products'[Cost Price])))
- Revenue YTD = TOTALYTD([Total Revenue], Dates[Date])
- Profit YTD = TOTALYTD([Total Profit], Dates[Date])

#### Date and geography hierarchies

The following date hierarchy was created:\
Start of Year > Start of Quarter > Start of Month > Start of Week > Date

The following geography hierarchy was created:\
World Region (Continent) > Country > Country Region


### 4. Report Construction

Four blank pages were created as the basis of the report - *Executive Summary*, *Customer Detail*, *Product Detail* and *Stores Map*

#### Customer Detail page 

The *Customer Detail* page is populated with several visuals to illustrate:
- Count of unique customers and revenue per customer (cards)

- Total customers by country (doughnut chart)
- Total customers by product category (column chart)
- Name of the customer with the highest revenue generation, and the total revenue and number of orders from that customer (cards).
- The top 20 customers filtered by total revenue (table). Rows in the *Total Revenue* column are formatted to show bars indicating total revenue values. The table and applied filtering can be seen below.

![Images/customer_detail_table_format.png](Images/customer_detail_table_format.png)

- Total customers against time period (line chart). The chart is formatted to allow drill down to the month level, and includes a forcast for the next 10 periods.

A slicer is included, allowing the user to filter the data by year. 

The orange bar to the left of the page is to become the page navigation bar. 
An example of the final page layout can be seen below:

![Images/customer_detail_all.png](Images/customer_detail_all.png)


#### Executive Summary

The *Executive Summary* page is popolulated with several visuals to illustrate:

- Total Revenue, Total Profit and Total Orders (card visuals).

- Total Revenue agaist time - Start of Year/Quarter/Month (line chart with drill down to the Start of Month level).
- Total Revenue by Country and Store Type (donut charts).

- Orders by Product Category (bar chart).
- KPIs:\
    Measures are created for *Previous Quarter Revenue*, *Previous Quarter Profit* and *Previous Quarter Orders* using DAX; for example:
    \
    \
    Previous Quarter Revenue = CALCULATE([Total Revenue], FILTER('Dates', DATEADD('Dates'[Start of Quarter], -1, QUARTER)))

    Subsequently, measures for *Target Revenue*, *Target Profit* and *Target Orders* are created based on a 5% increase on the previous quarter, using DAX; for example: 
    \
    \
    Target Revenue = [Previous Quarter Revenue] * 1.05

    Current total quarterly revenue / profit / orders are shown against target revenue / profit / orders in three KPI visuals. 

- Top 10 products with number of orders, total revenue and total profit (table).

An example of the Executive Summary page can be seen below: 

![Images/executive_summary_all.png](Images/executive_summary_all.png)

#### Product Detail page

The *Product Detail* page is populated with several visuals to illustrate:
- The quarter-to-date orders, revenue and profit against their respective targets (10% growth on the previous quarter) - gauge visuals. 
    - For each metric, three new DAX measures are created, for example: \
    \
    Last Quarter Revenue = CALCULATE([Total Revenue], DATESINPERIOD('Dates'[Date], LASTDATE(Orders[Order Date]), -1, QUARTER))
    \
    \
    Quarter Target Revenue = [Last Quarter Revenue] * 1.1
    \
    \
    QTD Revenue = CALCULATE([Total Revenue], DATESQTD(Orders[Order Date]))
    
    
- Total revenue against start of quarter (date), grouped by product category - area chart. 
- The top 10 products with total revenue, total customers, total orders and profit per order - table. \
Profit per order is defined by: \
Profit per Order = DIVIDE([Total Profit], [Total Orders])
- Quantity sold against profit per item for each product, grouped by product category - scatter chart. \
Profit per item is defined as a new column in the Products table by: \
Profit per Item = Products[Sale Price] - Products[Cost Price]

A slicer toolbar is created containing two slicers allowing product category and store country selection. The slicers are grouped on top of a rectagle constituting the toolbar. Two bookmarks are created, one in which the toolbar is visible and one in which it is hidden. A button is included on the toolbar and assiged the action of hiding the toolbar by association with the "slicer bar closed" bookmark. Similarly, a button is placed on the navigation bar and assigned the action of switching to the "slicer bar open" bookmark. 

The below image shows and example of the slicer toolbar setup.

![Images/product_detail_slice_bar.png](Images/product_detail_slice_bar.png)

Cards are added to the top left of the page to indicate the filter states for product category and store country. 

Cards are added to the lower right of the page to indicate the most ordered product and the product generating the highest revenue, within the filter contexts. \
\
An example of the final page layout can be seen below. 

![Images/product_detail_all.png](Images/product_detail_all.png)


#### Stores Map

The stores map page contains a large map of stores by Geography Hierarchy (World Region - Country - Country Region) with bubble size proportional to year-to-date profit. A slicer visual in Tile Mode allows rapid filtering by country, including a "Select all" option. The visual is connected to a tooltip page "Stores Tooltip" that displays the year-to-date profit against the profit goal in a gauge visual. \
\
An example of the Stores Map page drilled to *Country Region* level, with Tooltip settings shown for the map visual, can be seen below:\
\
![Images/stores_map_country_level.png](Images/stores_map_country_level.png)

#### Stores Tooltip
 The Stores Tooltip page displays the year-to-date profit against the profit goal in a gauge visual. The profit goal is defined as a 20% increase in profit over the previous year, and is defined in two stages using DAX:\
 \
Previous Year Profit = CALCULATE([Total Profit], PREVIOUSYEAR(Dates[Date]))\
\
Profit Goal = [Previous Year Profit] * 1.2

When on the Stores Map page, the Stores Tooltip page is displayed when hovering over a bubble; the guage visual values automaticlly adjust relative to the bubble context and drilldown level.\
\
A card visual is included to indicate the current selection. For this a new measure is defined, "Country Region Selection":\
\
Country Region Selection = IF(ISFILTERED(Stores[Country Region]), SELECTEDVALUE(Stores[Country Region]), IF(ISFILTERED(Stores[Country]), SELECTEDVALUE(Stores[Country]), SELECTEDVALUE('Stores'[World Region])))  

#### Stores Drillthrough

The Stores Drillthrough Page is accessed from the Stores Map page by drilling down to *Country Region* level, right-clicking on a bubble, and selecting Drill through > Stores Drillthrough.
\
The Stores Drillthrough page is populated with the following visuals: 

- A card visual showing the currently selected store. New measure, *Store Selection* was created for use in this visual using DAX:\
\
Store Selection = IF(ISFILTERED(Stores[Country Region]), SELECTEDVALUE(Stores[Geography]), "No Selection")

- Table of top five products with columns for *Description*, *Profit YTD*, *Total Orders* and *Total Revenue*. 
- Column chart of total orders by product category.
- Two gauge visuals showing the year-to-date profit and year-to-date revenue against their respective goals (e.g. Profit Goal, as described above in the Stores Tooltip section).

An example of the Stores Drillthrough page, showing page settings, can be seen below:\
\
![Images/stores_drillthrough_all.png](Images/stores_drillthrough_all.png)

#### Report Navigation
The report navigation bar is finalised with the following:
- Buttons are added to the navigation bar for quick access to each of the report pages, excluding the Stores Tooltip page. 
    - For each button a default icon (white fill) and an "on hover" icon (navy) are assigned. 
    - Each button is assigned the action of "Page navigation" with the destination set to the relevant page. 
    - The buttons are grouped and placed on the navigation bar of each of the four main pages. 

An example of a report page with the completed navigation bar and related settings can be seen below:

![Images/executive_summary_navigation_settings.png](Images/executive_summary_navigation_settings.png)

#### Cross-filter settings
The cross-filter settings are adjusted so that some visuals do not filter others, to ensure that relevant information is always displayed. \
This is achieved by selecting a visual, opening the format ribbon, clicking *Edit interactions* and then selecting either *Filter*, *Highlight* or *None* to determine how each visual is affected by the selected visual. 


## Database Analysis with SQL

It is import to be able to use alternative tools to view and aggreagte data in a database, since not all clients will have access to Power BI or equivalent software. 

In this section of the project, data on a Postgres database server hosted on Microsoft Azure is queried. \
The files associated with this section of the project are stored in a directory called **SQL_tasks**.


### Review of tables
A connection to the database is intitally set up using the SQLTools extension with the Postgres driver selected in VSCode. The connection settings are saved in a .json file: **.vscode/settings.json**.\
\
To obtain an overview of the contents of the database, information about the tables is extracted and saved to a number of .csv files for reference.\
Two approaches to this task are explored:
#### Maunual queries
The initial SQL queries used to perform this task manually can be seen in the file **orders_db_queries.sql**.\
\
Two processes are implemented:
- Extracting a list of tables of type 'BASE TABLE' from the database and saving it as a .csv file.

- Extracting the column headings from each table in the tables list and saving each set of headings as a .csv file. 

The files are saved in the directory 'tables_columns'

#### Automated connection and queries
Automation of the same process is achieved in **database_queries_auto.ipynb**. In this jupyter notebook the class DatabaseConnector is constructed and includes the following methods:
- get_tables: queries the database and extracts the relevant table names, saves them to a .csv file and additionally converts them to a list. 

- get_columns: using a for loop, interates through the list of table names and queries the database, extracting the column names for each table and saving each set to a .csv file of the appropriate name. 

- get_data: establishes a connection to the database and runs the two methods above as sub-methods. 

Files are saved to the newly-created directory 'tables_columns_auto'.\
\
The notebook also contains a function to extract the connection details from a .yaml file into a dictionary, which is used in the get_data method.  

### Data analysis queries
Queries are written across five .sql files to answer the following questions about the data in orders_db:
1. How many staff are there in all of the UK stores?

2. Which month in 2022 has had the highest revenue?
3. Which German store type had the highest revenue for 2022?
4. Create a view where the rows are the store types and the columns are the total sales, percentage of total sales and the count of orders
5. Which product category generated the most profit for the "Wiltshire, UK" region in 2021?

Each final result of each question is saved to a .csv file.\
The .sql and .csv files for this section are saved in the directory 'questions_answers'. 
