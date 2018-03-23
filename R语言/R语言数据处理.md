## Integer vs. Double
> typeof(x)将返回数据类型

> c() 将创建一个 vector

### Creating Integer and Double Vectors
```R
# create a string of double-precision values
dbl_var <- c(1, 2.5, 4.5)

# placing an L after the values creates a string of integers
int_var <- c(1L, 6L, 10L)
```

### Converting Between Integer and Double Values
```R
# converts integers to double-precision values
as.double(int_var)

# identical to as.double()
as.numeric(int_var)

# converts doubles to integers
as.integer()
```

## Generating sequence of non-random numbers
### Specifing Numbers within a Sequence
> To explicitly specify numbers in a sequence you can use the colon : operator to specify all integers between two specified numbers or the combine c() function to explicity specify all numbers in the sequence.
```R
# create a vector of integers between 1 and 10
1:10

# create a vector consisting of 1, 5, and 10
c(1, 5, 10)

# save the vector of integers between 1 and 10 as object x
x <- 1:10
```
### Generating Regular Sequences
