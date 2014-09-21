# Q1

library(datasets)
data(iris)
?iris

colMeans(subset(iris,
            Species=="virginica",
            select="Sepal.Length"),
     na.rm=T)
# 6.588

# Q3

library(datasets)
data(mtcars)

sapply(split(mtcars$mpg, mtcars$cyl), mean)

# Q4

15.1-26.66364
# -11.56364

debug(ls)
ls
