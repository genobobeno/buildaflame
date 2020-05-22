rsconnect::setAccountInfo(name='buildaflame',
                          token='B7307E35E8DD543675C69F3399634BF8',
                          secret='Y7BBgAFwP1e+Ue7SxaAaiMwzfSyRfJeR2UXrb5qS')

library(rsconnect)
rsconnect::deployApp('path/to/your/app')

install.packages(c("shinydashboard","golem"),dependencies = TRUE)
install.packages("googlesheets4",dependencies = T)
install.packages("gargle",dependencies = T)

googledrive::buildaflame/surveyresults

survey<-googlesheets4::read_sheet("1-4kwf6x4-zJC7JOKly-Wp4VZ47arooxO87PUTlOgI6I")

colnames(c("username","timestamp","topiccategory","topic","comment"))