##
## Retrieve stuff from Gitlab's API
## The API returns the query in 20-entries page. Thus, first we parse the response
## to know how many pages of 20 events are there, and then we retrieve the data from
## each page.
##
library(jsonlite)
library(pheatmap)
library(ggplot2)
library(reshape)

users <- #MY_USERS_OF_INTEREST

commits <- do.call(rbind, lapply(users, function(u) {
  cat(u)
  # get number of pages
  x <- system(paste0("curl --head --header 'PRIVATE-TOKEN: #MY_TOKEN' 'https://gitlab.com/api/v4/users/", u, "/events?after=2018-01-01&id=", u, "&per_page=20&sort=desc'"), intern=TRUE)
  pages <- as.integer(unlist(strsplit(x[grepl("^X-Total-Pages", x)], ": "))[2])


  # get commit information
  x <- do.call(rbind, lapply(1:pages, function(i) {
    y <- fromJSON(system(paste0("curl --header 'PRIVATE-TOKEN: #MY_TOKEN' 'https://gitlab.com/api/v4/users/", u, "/events?after=2018-01-01&id=", u, "&page=", i, "&per_page=20&sort=desc'"), intern=TRUE))

    if(length(y) > 0 && !is.null(y$push_data$commit_count)) {
      data.frame(page=i, when=y$created_at, who=u, commits=y$push_data$commit_count)
    } else {
      data.frame(page=i, when=NA, who=u, commits=NA)
    }
  }))

  x <- x[!is.na(x$commits), ]
  x <- x[x$commits > 0, ]
}))

# transform and plot data
commits$when <- as.Date(commits$when)
ggplot(commits, aes(x=when, y=who, size=commits)) +
  geom_point() +
  ggtitle("number of commits per day") +
  theme_bw()

# heatmap
commits2 <- cast(commits[, -1], when ~ who, value="commits", fun.aggregate="sum")
rownames(commits2) <- commits2[, 1]
commits2 <- commits2[, -1]

pheatmap(commits2, cluster_rows=FALSE, cluster_cols=FALSE, main="Number of commits per day")

write.csv(commits , file="data.csv")
write.csv(commits2, file="data_heatmap.csv")
