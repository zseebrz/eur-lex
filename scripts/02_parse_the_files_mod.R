### Parse the downloaded files
library(stringi)
### helper function to get the directory code
get_dircode <- function(var_name, myxpath_dircode) {
  tryCatch(
    #entries = html_nodes(h,xpath=myxpath_dircode),
    out[i,var_name] <<- trimws(stri_split_lines1(html_text(html_nodes(h,xpath=myxpath_dircode)[6][1]))[2]),
    warning=function(w){out[i,var_name] <<- NA},
    error=function(e){out[i,var_name] <<- NA})
} 

### Identify the files
#docs <- list.files(path= './legal_acts/', pattern = "*.html", full.names=TRUE, recursive=TRUE)  
#try first on a restricted set
#docs <- list.files(path= './legal_acts_2019/', pattern = "*.html", full.names=TRUE, recursive=TRUE)  
#let's try with all the downloaded files
docs <- list.files(path= './legal_acts_2014_2019/', pattern = "*.html", full.names=TRUE, recursive=TRUE)  

### Prepare the outfile
out<-data.frame(matrix(NA, nrow=length(docs), ncol=12))
colnames(out)<-c('celex', 'type','author', 'amends','in_force', 'date_doc','date_pub', 'date_force', 'date_expiration', 'keywords', 'dircode, legal_basis','title')

for (i in 1:length(docs)){
    cat ('Processing: ', i, ' / ', length(docs), '\n')
  
    h<-read_html(docs[i], encoding='UTF-8') #read the file
    
    # Basic information
    get_content('celex', '//meta[@property="eli:id_local"]/@content') 
    
    get_content('title', '//meta[@lang="en"][@property="eli:title"]/@content')
    
    get_content('type', '//meta[@property="eli:type_document"]/@resource')
    
    get_content('author', '//meta[@property="eli:passed_by"]/@resource')
    
    get_content('amends', '//meta[@property="eli:changes"]/@resource')

    get_content('in_force', '//meta[@property="eli:in_force"]/@resource')
    
    # Dates
    get_content('date_doc', '//meta[@property="eli:date_document"]/@content')
    
    get_content('date_pub', '//meta[@property="eli:date_publication"]/@content')
    
    get_content('date_force', '//meta[@property="eli:first_date_entry_in_force"]/@content')
    
    get_content('date_expiration', '//meta[@property="eli:date_no_longer_in_force"]/@content')
    
    # Descriptors
    get_content('keywords', '//meta[@property="eli:is_about"]/@resource')

    get_content('legal_basis', '//meta[@property="eli:based_on"]/@resource')
    
    get_dircode('dircode', '//div[@id="PPClass_Contents"]/div[@class="panel-body"]/dl[@class="NMetadata"]/*')
}

#save the result
write.csv(out, './output_table/all_acts_2004-2019.csv')
save(out, file='./output_table/all_acts_2004-2019.Rdata')
