
p.70.74 <- top.words.per.period[top.words.per.period$period == "1970-1974",]
colnames(p.70.74) <- c("w.value", "P70.74")

p.75.79 <- top.words.per.period[top.words.per.period$period == "1975-1979",]
colnames(p.75.79) <- c("w.value", "P75.79")

p.80.84 <- top.words.per.period[top.words.per.period$period == "1980-1984",]
colnames(p.80.84) <- c("w.value", "P80.84")

p.85.89 <- top.words.per.period[top.words.per.period$period == "1985-1989",]
colnames(p.85.89) <- c("w.value", "P85.89")

p.90.94 <- top.words.per.period[top.words.per.period$period == "1990-1994",]
colnames(p.90.94) <- c("w.value", "P90.94")

p.95.99 <- top.words.per.period[top.words.per.period$period == "1995-1999",]
colnames(p.95.99) <- c("w.value", "P95.99")

p.00.04 <- top.words.per.period[top.words.per.period$period == "2000-2004",]
colnames(p.00.04) <- c("w.value", "P00.04")

p.05.09 <- top.words.per.period[top.words.per.period$period == "2005-2009",]
colnames(p.05.09) <- c("w.value", "P05.09")

p.10.14 <- top.words.per.period[top.words.per.period$period == "2010-2014",]
colnames(p.10.14) <- c("w.value", "P10.14")

p.15.19 <- top.words.per.period[top.words.per.period$period == "2015-2019",]
colnames(p.15.19) <- c("w.value", "P15.19")

mmm <- merge(x = p.70.74[1:2], y = p.75.79[1:2], by = "w.value", all = TRUE)
mmm <- merge(x = mmm, y = p.80.84[1:2], by = "w.value", all = TRUE)
mmm <- merge(x = mmm, y = p.85.89[1:2], by = "w.value", all = TRUE)
mmm <- merge(x = mmm, y = p.90.94[1:2], by = "w.value", all = TRUE)
mmm <- merge(x = mmm, y = p.95.99[1:2], by = "w.value", all = TRUE)
mmm <- merge(x = mmm, y = p.00.04[1:2], by = "w.value", all = TRUE)
mmm <- merge(x = mmm, y = p.05.09[1:2], by = "w.value", all = TRUE)
mmm <- merge(x = mmm, y = p.10.14[1:2], by = "w.value", all = TRUE)
mmm <- merge(x = mmm, y = p.15.19[1:2], by = "w.value", all = TRUE)