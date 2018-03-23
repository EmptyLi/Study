### CHAPTER FIVE 10 MINUTES TO PANDAS
```python
In [1]: import pandas as pd

In [2]: import numpy as np

In [3]: import matplotlib.pyplot as plt
```
#### 5.1 Object Creation
> Creating a Series by passing a list of values, letting pandas create a default integer index:
> 传入一个list对象，创建一个具有默认索引的 Series 对象
```python
 In [4]: s = pd.Series([1,3,5,np.nan,6,8])
```
> Creating a DataFrame by passing a numpy array, with a datetime index and labeled columns
> 传入一个 numpy array 对象创建一个以时间为索引的 DataFrame 对象
```sql
In [7]: dates = pd.date_range('20130101', periods=6)

In [9]: df = pd.DataFrame(np.random.randn(6,4), index=dates, columns=list('ABCD'))
```

> Creating a DataFrame by passing a dict of objects that can be converted to series-like.
> 传入一个字典对象转换成一个 DataFrame 对象
```python
In [11]: pd.Timestamp('20130102')
Out[11]: Timestamp('2013-01-02 00:00:00')

In [12]: pd.Series(1,index=list(range(4)),dtype='float32')
Out[12]:
0    1.0
1    1.0
2    1.0
3    1.0
dtype: float32

In [13]: np.array([3] * 4,dtype='int32')
Out[13]: array([3, 3, 3, 3])

In [14]: pd.Categorical(["test","train","test","train"])
Out[14]:
[test, train, test, train]
Categories (2, object): [test, train]

In [16]: df2 = pd.DataFrame({ 'A' : 1.,
    ...: 'B' : pd.Timestamp('20130102'),
    ...: 'C' : pd.Series(1,index=list(range(4)),dtype='float32'),
    ...: 'D' : np.array([3] * 4,dtype='int32'),
    ...: 'E' : pd.Categorical(["test","train","test","train"]),
    ...: 'F' : 'foo' })

# 查看列的类型
In [18]: df2.dtypes
```

#### 5.2 Viewing Data
> See the top & bottom rows of the frame
```python
In [19]: df.head()

In [20]: df.tail(3)

```

> Display the index, columns, and the underlying numpy data
```python
In [21]: df.index
Out[21]:
DatetimeIndex(['2013-01-01', '2013-01-02', '2013-01-03', '2013-01-04',
               '2013-01-05', '2013-01-06'],
              dtype='datetime64[ns]', freq='D')

In [22]: df.columns
Out[22]: Index(['A', 'B', 'C', 'D'], dtype='object')

In [23]: df.values
```
> Describe shows a quick statistic summary of your data
```python
In [25]: df.describe()
Out[25]:
              A         B         C         D
count  6.000000  6.000000  6.000000  6.000000
mean  -0.237564 -0.124112 -0.160527 -0.123289
std    1.144114  1.173393  0.784553  0.999272
min   -1.481931 -1.818939 -0.998916 -1.048233
25%   -1.073905 -0.659305 -0.874365 -0.879429
50%   -0.386529  0.011467 -0.106597 -0.505024
75%    0.370741  0.185714  0.415818  0.739990
max    1.509470  1.690432  0.789282  1.167780
```
> Transposing your data
```python
In [26]: df.T
```

> Sorting by an axis
```python
In [29]: df.sort_index(axis=0, ascending=False)
Out[29]:
                   A         B         C         D
2013-01-06 -0.982473 -1.818939  0.429424  1.056880
2013-01-05  0.424516  0.229202  0.789282 -0.799369
2013-01-04 -1.481931  0.055251 -0.998916  1.167780
2013-01-03  0.209416 -0.868301 -0.588193 -1.048233
2013-01-02 -1.104382 -0.032317  0.375000 -0.906115
2013-01-01  1.509470  1.690432 -0.969755 -0.210679

In [30]: df.sort_index(axis=0, ascending=True)
Out[30]:
                   A         B         C         D
2013-01-01  1.509470  1.690432 -0.969755 -0.210679
2013-01-02 -1.104382 -0.032317  0.375000 -0.906115
2013-01-03  0.209416 -0.868301 -0.588193 -1.048233
2013-01-04 -1.481931  0.055251 -0.998916  1.167780
2013-01-05  0.424516  0.229202  0.789282 -0.799369
2013-01-06 -0.982473 -1.818939  0.429424  1.056880

In [31]: df.sort_index(axis=1, ascending=False)
Out[31]:
                   D         C         B         A
2013-01-01 -0.210679 -0.969755  1.690432  1.509470
2013-01-02 -0.906115  0.375000 -0.032317 -1.104382
2013-01-03 -1.048233 -0.588193 -0.868301  0.209416
2013-01-04  1.167780 -0.998916  0.055251 -1.481931
2013-01-05 -0.799369  0.789282  0.229202  0.424516
2013-01-06  1.056880  0.429424 -1.818939 -0.982473

In [32]: df.sort_index(axis=1, ascending=True)
Out[32]:
                   A         B         C         D
2013-01-01  1.509470  1.690432 -0.969755 -0.210679
2013-01-02 -1.104382 -0.032317  0.375000 -0.906115
2013-01-03  0.209416 -0.868301 -0.588193 -1.048233
2013-01-04 -1.481931  0.055251 -0.998916  1.167780
2013-01-05  0.424516  0.229202  0.789282 -0.799369
2013-01-06 -0.982473 -1.818939  0.429424  1.056880
```
> Sorting by values
```python
In [39]: df.sort_values(by='B', ascending=False)
Out[39]:
                   A         B         C         D
2013-01-01  1.509470  1.690432 -0.969755 -0.210679
2013-01-05  0.424516  0.229202  0.789282 -0.799369
2013-01-04 -1.481931  0.055251 -0.998916  1.167780
2013-01-02 -1.104382 -0.032317  0.375000 -0.906115
2013-01-03  0.209416 -0.868301 -0.588193 -1.048233
2013-01-06 -0.982473 -1.818939  0.429424  1.056880

In [40]: df.sort_values(by='B', ascending=True)
Out[40]:
                   A         B         C         D
2013-01-06 -0.982473 -1.818939  0.429424  1.056880
2013-01-03  0.209416 -0.868301 -0.588193 -1.048233
2013-01-02 -1.104382 -0.032317  0.375000 -0.906115
2013-01-04 -1.481931  0.055251 -0.998916  1.167780
2013-01-05  0.424516  0.229202  0.789282 -0.799369
2013-01-01  1.509470  1.690432 -0.969755 -0.210679
```
### 5.3 Selection
#### 5.3.1 Getting
> Selecting a single column, which yields a Series, equivalent to df.A
```python
In [41]: df['A']
```
> Selecting via [], which slices the rows.
```python
In [42]: df[0:2]
Out[42]:
                   A         B         C         D
2013-01-01  1.509470  1.690432 -0.969755 -0.210679
2013-01-02 -1.104382 -0.032317  0.375000 -0.906115

In [43]: df['20130102':'20130104']
Out[43]:
                   A         B         C         D
2013-01-02 -1.104382 -0.032317  0.375000 -0.906115
2013-01-03  0.209416 -0.868301 -0.588193 -1.048233
2013-01-04 -1.481931  0.055251 -0.998916  1.167780
```

#### 5.3.2 Selection by Label
> For getting a cross section using a label
```python
In [44]: df.loc[dates[0]]

In [47]: df.loc['20130102':'20130104', ['A', 'B']]
Out[47]:
                   A         B
2013-01-02 -1.104382 -0.032317
2013-01-03  0.209416 -0.868301
2013-01-04 -1.481931  0.055251
```
> For getting fast access to a scalar
```python
In [48]: df.loc[dates[0],'A']
Out[48]: 1.5094702133612654

In [49]: df.at[dates[0],'A']
Out[49]: 1.5094702133612654
```
#### 5.3.3 Selection by Position
> Select via the position of the passed integers
```python
In [50]: df.iloc[3]

In [51]: df.iloc[1,1]
Out[51]: -0.032317460144580382

In [52]: df.iat[1,1]
Out[52]: -0.032317460144580382
```
#### 5.3.4 Boolean Indexing
> Using a single column’s values to select data
```python
In [53]: df[df.A > 0]
Out[53]:
                   A         B         C         D
2013-01-01  1.509470  1.690432 -0.969755 -0.210679
2013-01-03  0.209416 -0.868301 -0.588193 -1.048233
2013-01-05  0.424516  0.229202  0.789282 -0.799369

In [54]: df[df > 0]
Out[54]:
                   A         B         C        D
2013-01-01  1.509470  1.690432       NaN      NaN
2013-01-02       NaN       NaN  0.375000      NaN
2013-01-03  0.209416       NaN       NaN      NaN
2013-01-04       NaN  0.055251       NaN  1.16778
2013-01-05  0.424516  0.229202  0.789282      NaN
2013-01-06       NaN       NaN  0.429424  1.05688
```
> Using the isin() method for filtering:
```python
In [55]: df2 = df.copy()

In [56]: df2['E'] = ['one', 'one','two','three','four','three']

In [57]: df2[df2['E'].isin(['two','four'])]
Out[57]:
                   A         B         C         D     E
2013-01-03  0.209416 -0.868301 -0.588193 -1.048233   two
2013-01-05  0.424516  0.229202  0.789282 -0.799369  four
```
#### 5.3.5 Setting
> Setting a new column automatically aligns the data by the indexes
```python
In [58]: s1 = pd.Series([1,2,3,4,5,6], index=pd.date_range('20130102', periods=6))

In [59]: df['F'] = s1

In [60]: df
Out[60]:
                   A         B         C         D    F
2013-01-01  1.509470  1.690432 -0.969755 -0.210679  NaN
2013-01-02 -1.104382 -0.032317  0.375000 -0.906115  1.0
2013-01-03  0.209416 -0.868301 -0.588193 -1.048233  2.0
2013-01-04 -1.481931  0.055251 -0.998916  1.167780  3.0
2013-01-05  0.424516  0.229202  0.789282 -0.799369  4.0
2013-01-06 -0.982473 -1.818939  0.429424  1.056880  5.0
```
> Setting values by label
```python
In [61]: df.at[dates[0],'A'] = 0

In [62]: df.iat[0,1] = 0

In [63]: df.loc[:,'D'] = np.array([5] * len(df))
```
> A where operation with setting.
```python
In [65]: df2
Out[65]:
                   A         B         C  D    F
2013-01-01  0.000000  0.000000 -0.969755  5  NaN
2013-01-02 -1.104382 -0.032317  0.375000  5  1.0
2013-01-03  0.209416 -0.868301 -0.588193  5  2.0
2013-01-04 -1.481931  0.055251 -0.998916  5  3.0
2013-01-05  0.424516  0.229202  0.789282  5  4.0
2013-01-06 -0.982473 -1.818939  0.429424  5  5.0

In [66]: df2[df2 > 0]
Out[66]:
                   A         B         C  D    F
2013-01-01       NaN       NaN       NaN  5  NaN
2013-01-02       NaN       NaN  0.375000  5  1.0
2013-01-03  0.209416       NaN       NaN  5  2.0
2013-01-04       NaN  0.055251       NaN  5  3.0
2013-01-05  0.424516  0.229202  0.789282  5  4.0
2013-01-06       NaN       NaN  0.429424  5  5.0

In [67]: df2[df2 > 0] = -df2

In [68]: df2
Out[68]:
                   A         B         C  D    F
2013-01-01  0.000000  0.000000 -0.969755 -5  NaN
2013-01-02 -1.104382 -0.032317 -0.375000 -5 -1.0
2013-01-03 -0.209416 -0.868301 -0.588193 -5 -2.0
2013-01-04 -1.481931 -0.055251 -0.998916 -5 -3.0
2013-01-05 -0.424516 -0.229202 -0.789282 -5 -4.0
2013-01-06 -0.982473 -1.818939 -0.429424 -5 -5.0
```
### 5.4 Missing Data
> Reindexing allows you to change/add/delete the index on a specified axis. This returns a copy of the data.
```python
In [69]: df1 = df.reindex(index=dates[0:4], columns=list(df.columns) + ['E'])

In [71]: df1.loc[dates[0]:dates[1],'E'] = 1

```
>To drop any rows that have missing data
```python
In [72]: df1
Out[72]:
                   A         B         C  D    F    E
2013-01-01  0.000000  0.000000 -0.969755  5  NaN  1.0
2013-01-02 -1.104382 -0.032317  0.375000  5  1.0  1.0
2013-01-03  0.209416 -0.868301 -0.588193  5  2.0  NaN
2013-01-04 -1.481931  0.055251 -0.998916  5  3.0  NaN

In [73]: df1.dropna(how='any')
Out[73]:
                   A         B      C  D    F    E
2013-01-02 -1.104382 -0.032317  0.375  5  1.0  1.0
```

> Filling missing data
```python
In [74]: df1.fillna(value=5)

```

> To get the boolean mask where values are nan
```python
In [75]: pd.isna(df1)

```

### 5.5 Operations
#### 5.5.1 Stats
> Operations in general exclude missing data
```python
In [76]: df.mean()
Out[76]:
A   -0.489142
B   -0.405851
C   -0.160527
D    5.000000
F    3.000000
dtype: float64

In [77]: df.mean(1)
Out[77]:
2013-01-01    1.007561
2013-01-02    1.047660
2013-01-03    1.150584
2013-01-04    1.114881
2013-01-05    2.088600
2013-01-06    1.525602
Freq: D, dtype: float64
```
> Operating with objects that have different dimensionality and need alignment. In addition, pandas automatically broadcasts along the specified dimension
```python
In [78]: s = pd.Series([1,3,5,np.nan,6,8], index=dates)

In [79]: s
Out[79]:
2013-01-01    1.0
2013-01-02    3.0
2013-01-03    5.0
2013-01-04    NaN
2013-01-05    6.0
2013-01-06    8.0
Freq: D, dtype: float64

In [80]: s = pd.Series([1,3,5,np.nan,6,8], index=dates).shift(2)

In [81]: s
Out[81]:
2013-01-01    NaN
2013-01-02    NaN
2013-01-03    1.0
2013-01-04    3.0
2013-01-05    5.0
2013-01-06    NaN
Freq: D, dtype: float64

In [82]: df
Out[82]:
                   A         B         C  D    F
2013-01-01  0.000000  0.000000 -0.969755  5  NaN
2013-01-02 -1.104382 -0.032317  0.375000  5  1.0
2013-01-03  0.209416 -0.868301 -0.588193  5  2.0
2013-01-04 -1.481931  0.055251 -0.998916  5  3.0
2013-01-05  0.424516  0.229202  0.789282  5  4.0
2013-01-06 -0.982473 -1.818939  0.429424  5  5.0

In [83]: df.sub(s, axis='index')
Out[83]:
                   A         B         C    D    F
2013-01-01       NaN       NaN       NaN  NaN  NaN
2013-01-02       NaN       NaN       NaN  NaN  NaN
2013-01-03 -0.790584 -1.868301 -1.588193  4.0  1.0
2013-01-04 -4.481931 -2.944749 -3.998916  2.0  0.0
2013-01-05 -4.575484 -4.770798 -4.210718  0.0 -1.0
2013-01-06       NaN       NaN       NaN  NaN  NaN
```

#### 5.5.2 Apply
> Applying functions to the data
```python
In [84]: df.apply(np.cumsum)

In [85]: df.apply(lambda x: x.max() - x.min())

```
#### 5.5.3 Histogramming
```python
In [86]: s = pd.Series(np.random.randint(0, 7, size=10))

In [87]: s.value_counts()
```

#### 5.5.4 String Methods
> Series is equipped with a set of string processing methods in the str attribute that make it easy to operate on each element of the array
```python
In [88]: s = pd.Series(['A', 'B', 'C', 'Aaba', 'Baca', np.nan, 'CABA', 'dog', 'cat'])

In [89]: s.str.upper()

In [90]: s.str.lower()

```

### 5.6 Merge
#### 5.6.1 Concat
> Concatenating pandas objects together with concat():
```python
In [91]: df = pd.DataFrame(np.random.randn(10, 4))

# break it into pieces
In [93]: pieces = [df[:3], df[3:7], df[7:]]

In [94]: pieces
Out[94]:
[          0         1         2         3
 0 -0.614175  1.292729  0.918938  0.293192
 1 -0.857969  0.070571 -0.118315 -1.265318
 2  2.127979 -1.084430  0.509884 -0.438967,
           0         1         2         3
 3 -0.622106  1.082788 -0.234932 -1.144742
 4  1.959651  0.437238  0.288533 -0.660960
 5 -0.591373  0.283814 -0.451910 -1.343372
 6  1.127774 -0.737363  0.304315  0.302072,
           0         1         2         3
 7  1.177588 -1.140446  0.439324 -1.198692
 8  0.729143  0.468971  2.293460  1.014457
 9  0.397685  0.951461  0.798795 -0.750922]

 In [95]: pd.concat(pieces)
Out[95]:
          0         1         2         3
0 -0.614175  1.292729  0.918938  0.293192
1 -0.857969  0.070571 -0.118315 -1.265318
2  2.127979 -1.084430  0.509884 -0.438967
3 -0.622106  1.082788 -0.234932 -1.144742
4  1.959651  0.437238  0.288533 -0.660960
5 -0.591373  0.283814 -0.451910 -1.343372
6  1.127774 -0.737363  0.304315  0.302072
7  1.177588 -1.140446  0.439324 -1.198692
8  0.729143  0.468971  2.293460  1.014457
9  0.397685  0.951461  0.798795 -0.750922
```
#### 5.6.2 Join
```python
In [96]: left = pd.DataFrame({'key': ['foo', 'foo'], 'lval': [1, 2]})

In [97]: right = pd.DataFrame({'key': ['foo', 'foo'], 'rval': [4, 5]})

In [98]: pd.merge(left, right, on='key')
```

### 5.6.3 Append
```python
In [99]: df = pd.DataFrame(np.random.randn(8, 4), columns=['A','B','C','D'])

In [101]: s = df.iloc[3]

In [104]: df.append(s, ignore_index=True)
```

### 5.7 Grouping
- Splitting the data into groups based on some criteria
- Applying a function to each group independently
- Combining the results into a data structure
```python
In [105]: df = pd.DataFrame({'A' : ['foo', 'bar', 'foo', 'bar','foo', 'bar', 'foo', 'foo'],
     ...: 'B' : ['one', 'one', 'two', 'three', 'two', 'two', 'one', 'three'],
     ...: 'C' : np.random.randn(8),
     ...: 'D' : np.random.randn(8)})
```

> Grouping and then applying a function sum to the resulting groups.
```python
In [107]: df.groupby('A').sum()
```

> Grouping by multiple columns forms a hierarchical index, which we then apply the function
```python
In [108]: df.groupby(['A','B']).sum()
Out[108]:
                  C         D
A   B
bar one   -0.586807  1.017495
    three  0.271996 -0.653116
    two    1.732780  0.906312
foo one   -0.106569  0.787432
    three  2.411684  0.227292
    two    1.661608 -1.273156
```

### 5.8 Reshaping
#### 5.8.1 Stack

```python
In [114]: tuples = list(zip(*[['bar', 'bar', 'baz', 'baz',
     ...: 'foo', 'foo', 'qux', 'qux'],
     ...: ['one', 'two', 'one', 'two',
     ...: 'one', 'two', 'one', 'two']]))

     In [116]: index = pd.MultiIndex.from_tuples(tuples, names=['first', 'second'])

In [117]: index
Out[117]:
MultiIndex(levels=[['bar', 'baz', 'foo', 'qux'], ['one', 'two']],
           labels=[[0, 0, 1, 1, 2, 2, 3, 3], [0, 1, 0, 1, 0, 1, 0, 1]],
           names=['first', 'second'])

In [118]: df = pd.DataFrame(np.random.randn(8, 2), index=index, columns=['A', 'B'])

```
> The stack() method “compresses” a level in the DataFrame’s columns.
```python
In [125]: df2
Out[125]:
                     A         B
first second
bar   one    -1.893055 -1.661977
      two    -0.597097 -0.550415
baz   one    -0.669136 -0.058023
      two    -0.476634  0.273827

In [126]: df2.stack()
Out[126]:
first  second
bar    one     A   -1.893055
               B   -1.661977
       two     A   -0.597097
               B   -0.550415
baz    one     A   -0.669136
               B   -0.058023
       two     A   -0.476634
               B    0.273827
dtype: float64
```

> With a “stacked” DataFrame or Series (having a MultiIndex as the index), the inverse operation of stack() is unstack(), which by default unstacks the last level:
```python
In [128]: stacked
Out[128]:
first  second
bar    one     A   -1.893055
               B   -1.661977
       two     A   -0.597097
               B   -0.550415
baz    one     A   -0.669136
               B   -0.058023
       two     A   -0.476634
               B    0.273827
dtype: float64

In [129]: stacked.unstack()
Out[129]:
                     A         B
first second
bar   one    -1.893055 -1.661977
      two    -0.597097 -0.550415
baz   one    -0.669136 -0.058023
      two    -0.476634  0.273827

In [130]: stacked.unstack(0)
Out[130]:
first          bar       baz
second
one    A -1.893055 -0.669136
       B -1.661977 -0.058023
two    A -0.597097 -0.476634
       B -0.550415  0.273827
```

#### 5.8.2 Pivot Tables
```python
In [131]: df = pd.DataFrame({'A' : ['one', 'one', 'two', 'three'] * 3,
     ...: 'B' : ['A', 'B', 'C'] * 4,
     ...: 'C' : ['foo', 'foo', 'foo', 'bar', 'bar', 'bar'] * 2,
     ...: 'D' : np.random.randn(12),
     ...: 'E' : np.random.randn(12)})

```
> We can produce pivot tables from this data very easily
```python
In [133]: pd.pivot_table(df, values='D', index=['A', 'B'], columns=['C'])
Out[133]:
C             bar       foo
A     B
one   A  0.286501  0.125153
      B -0.192352  0.862010
      C  0.362863 -2.070379
three A  0.082135       NaN
      B       NaN  0.375914
      C  0.156249       NaN
two   A       NaN -2.126993
      B  1.069589       NaN
      C       NaN -1.056874
```

## 5.9 Time Series
```python
In [136]: rng = pd.date_range('1/1/2012', periods=100, freq='S')

In [137]: ts = pd.Series(np.random.randint(0, 500, len(rng)), index=rng)

In [138]: ts.resample('5Min').sum()
Out[138]:
2012-01-01    26205
Freq: 5T, dtype: int32

In [139]: rng = pd.date_range('3/6/2012 00:00', periods=5, freq='D')

In [141]: ts = pd.Series(np.random.randn(len(rng)), rng)

In [143]: ts_utc = ts.tz_localize('UTC')

In [145]: ts_utc.tz_convert('US/Eastern')

In [146]: rng = pd.date_range('1/1/2012', periods=5, freq='M')

In [147]: ps = ts.to_period()
Out[148]:
2012-03-06   -0.898127
2012-03-07    1.149241
2012-03-08    1.423320
2012-03-09   -0.356556
2012-03-10    0.109979
Freq: D, dtype: float64

```
