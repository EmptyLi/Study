
### Working with Python Pandas and XlsxWriter

#### Using XlsxWriter with Pandas

``` Python

import pandas as pd

# Create a Pandas dataframe from the data
df = pd.DataFrame({'data': [10, 20, 30, 40, 50]})

# Create a Pandas Excel writer using XlsxWriter as the engine
writer = pd.ExcelWriter('pandas_simple.xlsx', engine = 'xlsxwriter')

# Convert the dataframe to an XlsxWriter Excel object
df.to_excel(writer, sheet_name = 'sheet1')

# Close the Pandas Excel writer and output the Excel file
writer.save()
```

#### Accessing XlsxWriter from Pandas

``` python
# Get the xlsxwriter objects from the dataframe writer object
workbook = writer.book
worksheet = writer.sheets['sheet1']

# This is equivalent to the following code when using xlsxwriter on its own
workbook = xlsxwriter.workbook('filename.xlsx')
worksheet = workbook.add_sheet()
```

#### Adding Charts to Dataframe output

```python
# Get the xlsxwriter objects from the dataframe writer object
workbook = writer.book
worksheet = writer.sheets['sheet1']

# Create a chart object
chart = workbook.add_chart({'type': 'column'})

# Configure the Series of the chart from the dataframe data
chart.add_series({'values': '=sheet1!$B$2:$B$8'})

# Insert the chart into the worksheet
worksheet.insert_chart('D2', chart)

```
#### Adding Conditional Formatting to Dataframe output
```Python
# Apply a conditional format to the cell range
worksheet.conditional_format('B2:B8', {'type': '3_color_scale'})
```

#### Formatting of the Dataframe output
```Python
# Add some cell formats 
format1 = workbook.add_format({'num_format': '#,##0.00'})

format2 = workbook.add_format({'num_format': ''})
```
