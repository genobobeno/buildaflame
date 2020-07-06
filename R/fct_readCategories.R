fct_readCategories<-function() {
  Topics<-googlesheets4::read_sheet(ss = "1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I",sheet = "Topics")
  print(unique(Topics$Category))
  unique(Topics$Category)
}