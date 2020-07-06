function(category,topic) {
  Topics<-googlesheets4::read_sheet(ss = "1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Topics")
  if (lower(category) %in% lower(Topics$Category)) {
    category<-Topics$Category[which(lower(Topics$Category)==lower(category))[1]]
    Topics<-rbind(Topics,data.frame(Category=category,Topic=topic,Votes=0,Index=max(Topics$Index)+1,
                                    Written=FALSE,Link="empty",Date="empty",Title="empty"))
    googlesheets4::write_sheet(data = Topics,ss="1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Topics")    
    print(paste0("Added article: ",topic," :: into Category: ",category))
  } else {
    print("We haven't discussed the addition of new categories...")
  }
}