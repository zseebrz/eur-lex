### Download the files

#construct a vector of urls
letter = "R" #use L, R, and D
year0 = 2019 #choose start year
year1 = 2019 #choose end year
start = 1 #choose starting number 
end = 1210 #choose end number


urls<-NA
for (i in year0:year1){
  for (j in start:end){
    urls[j+(i-year0)*end]<-paste0("http://eur-lex.europa.eu/legal-content/EN/ALL/?uri=CELEX:3",i,letter,add.zeros(j))
  }
}

#download the files
for (i in 1: length(urls)){
  if (url.exists(urls[i], .header=TRUE)['statusMessage']=='Not Found')
    print (urls[i])
  #next
  else
    download.file(urls[i], destfile=paste0("./legal_acts/",substr(urls[i],nchar(urls[i])-9, nchar(urls[i])),".html"), 
                  #method='libcurl', mode='w', cacheOK=TRUE, quiet=T, Sys.sleep(1))
                  method='wininet', mode='w', cacheOK=TRUE, quiet=T, Sys.sleep(1))
                  #method='wget', mode='w', cacheOK=TRUE, quiet=T, Sys.sleep(1))
}  


### this is only needed for celex nubmers with brackets
celex_b<-read.table('celex_brackets.txt', header=T)
urls<-NA
for (i in 1:length(celex_b$celex)){
  urls[i]<-paste0("http://eur-lex.europa.eu/legal-content/EN/ALL/?uri=CELEX:",celex_b$celex[i])
}
urls<-urls[is.na(urls)==F]

##########################################################################################
# alternative version that downloads all files and only then removes empty ones
for (i in 111: length(urls)){
  tryCatch(
    download.file(urls[i], destfile=paste0("./legal_acts/",substr(urls[i],nchar(urls[i])-9, nchar(urls[i])),".html"), 
                  method='libcurl', mode='w', cacheOK=TRUE, quiet=T, Sys.sleep(1)), 
    warning=function(w){print (urls[i])},
    error=function(e){print (urls[i])})
}  

#delete empty files: this only works once the files are downloaded and R Studio is restarted. Otherwise the files are kept open for some reason.
docs <- list.files(path= './legal_acts/', pattern = "*.html", full.names=TRUE)  
inds <- file.size(docs) == 0 
file.remove(docs[inds])

##########################################################################################
# ECALab: download everything between 2014-2019. looping with L, R, D
##########################################################################################

eurlex_letters = c("R", "D", "L")
year0 = 2004 #choose start year
year1 = 2019 #choose end year
start = 1 #choose starting number 
end = 2500 #choose end number

urls<-NA
for (letter in eurlex_letters){
  print(letter)


for (i in year0:year1){
  if (letter == 'L'){
    end = 250
    print('L-series Celex-number, endpoint restricted to 250')}
  for (j in start:end){
    urls[j+(i-year0)*end]<-paste0("http://eur-lex.europa.eu/legal-content/EN/ALL/?uri=CELEX:3",i,letter,add.zeros(j))
  }
}
} #end of url generation loop
  
#download the files
#for (i in 1: length(urls)){
#the script froze at 25706/40000, restarting from there
#the script froze again at 26019/40000, restarting from there
#the script froze again at 31694/40000, restarting from there
for (i in 1: length(urls)){
  #if (url.exists(urls[i], .header=TRUE)['statusMessage']=='Not Found')
  if (url.exists(urls[i]) == FALSE){  
    cat ('Does not exist: ', urls[i], '\n')
    next}
  else
    cat (urls[i], i, '/', length(urls), '\n')
    download.file(urls[i], destfile=paste0("./legal_acts/",substr(urls[i],nchar(urls[i])-9, nchar(urls[i])),".html"), 
                  #method='libcurl', mode='w', cacheOK=TRUE, quiet=T, Sys.sleep(1))
                  method='wininet', mode='w', cacheOK=TRUE, quiet=T, Sys.sleep(1))
  #method='wget', mode='w', cacheOK=TRUE, quiet=T, Sys.sleep(1))
}  


fileConn<-file("output.txt")
writeLines(urls, fileConn)
close(fileConn)
#-----------------------------------------------------------------------
#trying again, this time downloading separately by letters
#-----------------------------------------------------------------------
#construct a vector of urls
letter = "L" #use L, R, and D
year0 = 2004 #choose start year
year1 = 2019 #choose end year
start = 1 #choose starting number 
end = 2500 #choose end number


urls<-NA
for (i in year0:year1){
  for (j in start:end){
    urls[j+(i-year0)*end]<-paste0("http://eur-lex.europa.eu/legal-content/EN/ALL/?uri=CELEX:3",i,letter,add.zeros(j))
  }
}

#download the files
#for (i in 1: length(urls)){
for (i in 1: length(urls)){
  if (url.exists(urls[i])  == FALSE){
      cat ('Does not exist: ', urls[i], '\n')
      next}
  else
    cat (urls[i], i, '/', length(urls), '\n')
    #change the folder name to L, R or D series
    download.file(urls[i], destfile=paste0("./L/",substr(urls[i],nchar(urls[i])-9, nchar(urls[i])),".html"), 
                  #method='libcurl', mode='w', cacheOK=TRUE, quiet=T, Sys.sleep(1))
                  method='wininet', mode='w', cacheOK=TRUE, quiet=T, Sys.sleep(1))
  #method='wget', mode='w', cacheOK=TRUE, quiet=T, Sys.sleep(1))
}  

#R is done, 22414 items
#D in done, 11398 items
#L in progress