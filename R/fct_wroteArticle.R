function(topic=NA,index=NA,link) {
  stopifnot((!is.na(topic) | !is.na(index)) & grepl("http",link))
  Topics<-googlesheets4::read_sheet(ss = "1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Topics")
  #topic<-"wrong"
  if (!is.na(topic)) {
    pmatches<-grep(tolower(topic),Topics$Topic)
    lmatches<-order(stringdist::stringdist(tolower(topic),tolower(Topics$Topic)))
    indChoice<-unique(c(pmatches,lmatches[1:10]))
    article<-utils_queryUser("Which article are you referring to?",
                             choices=Topics$Topic[indChoice],type="character")
  } else if (!is.na(index) & is.numeric(index)) {
    YN<-utils_queryUser(paste0("Is this the article you are referring to? \n",
                             Topics$Topic[index]),
                             choices=c("Yes","No"),type="character")
    if (grepl("y",tolower(YN))) {
      article<-Topics$Topic[index]
    } else {
      print("Try and rerun the function. You didn't get the correct article index.")
      print("Here's the Topics and indexes, if it helps:")
      print(Topics[,c(1,2,4)])
    }
  } else {
    print("Something wrong with your inputs for this function")
  }
  Topics$Written[Topics$Topic==article]<-TRUE
  Topics$Link[Topics$Topic==article]<-link
  Topics$Date[Topics$Topic==article]<-as.character(Sys.Date())
  googlesheets4::write_sheet(data = Topics,ss="1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Topics")    
  print("Changed status of:")
  print(paste("ARTICLE (Index = ",Topics$Index[Topics$Topic==article],"):",article))
}