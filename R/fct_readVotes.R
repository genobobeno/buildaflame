fct_readVotes<-function() {
  # Votes<-data.frame(Category=Sheet$Category[2],Topic = Sheet$Topic[2],Index = Sheet$Index[2],
  #                   User = "eugene.quickreaction@gmail.com",Comment = "Fail Forward",Timestamp = Sys.time())
  # 
  # googlesheets4::write_sheet(data = Votes,ss="1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Votes")
  Votes<-googlesheets4::read_sheet(ss = "1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Votes")
  Votes$Voted<-1
  AggVotes<-aggregate(Voted~Topic,data = Votes,sum)
  Comments<-aggregate(Comment~Topic,data = Votes,paste,sep=" :: ")
  Topics<-googlesheets4::read_sheet(ss = "1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Topics")
  Col.Names<-names(Topics)
  Topics$Votes<-NULL
  Topics<-merge(Topics,AggVotes,by="Topic",all.x=TRUE)
  names(Topics)[names(Topics)=="Voted"]<-"Votes"
  Topics$Votes<-ifelse(Topics$Votes>0,Topics$Votes,0)
  Topics<-Topics[,Col.Names]
  googlesheets4::write_sheet(data = Topics,ss="1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Topics")
  print(merge(AggVotes,Comments,by="Topic"))
}