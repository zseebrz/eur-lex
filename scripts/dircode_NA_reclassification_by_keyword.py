# -*- coding: utf-8 -*-
"""
Created on Mon Aug 12 14:56:09 2019

@author: VARGAZ
"""

# new[, 17:42] <- lapply(eurlex_data[, 17:42], function(x) eurovoc_en$TERMS[match(x, eurovoc_en$ID)])
# new$toplevel_dircode <- lapply(eurlex_data$dircode, function(x) top_level$text[match(substr(x, 1, 2), top_level$ID)])    


import pandas as pd
import numpy as np
output_xls = 'd:\\Working\\working_docs\\35_R_script_legislation\\eurlex_data_w_keywords_and_dircodes_ECA_classification.xlsx'
df_ori =  pd.read_excel('d:\\Working\\working_docs\\35_R_script_legislation\\eurlex_data_w_keywords_and_dircodes.xlsx')
df_ori['ECA_dircode'] = df_ori['toplevel_dircode']
df_ori['ECA_dircode'] = df_ori['ECA_dircode'].fillna('Unclassified')

#df_ori[df_ori['title'].str.contains('import|export|price', case=False, regex=True)]
#df_ori['ECA_dircode'].loc[df_ori['title'].str.contains('import|export|price', case=False, regex=True, na=False)]

index_of_none_values = list(df_ori.index[df_ori.ECA_dircode == 'Unclassified'])

df_temp = df_ori.loc[index_of_none_values]
df_temp['ECA_dircode'].loc[df_temp['title'].str.contains('import|export|price|tariff', case=False, regex=True, na=False)] = 'NA-import/export/food supply-ECA'
df_temp['ECA_dircode'].loc[df_temp['title'].str.contains('aid|refund|tender|intervention|quantit|buy', case=False, regex=True, na=False)] = 'NA-intervention-ECA'
#df_none = df_temp[df_temp.ECA_dircode == 'None']
df_out = df_ori.copy()
df_out.loc[index_of_none_values] = df_temp

df_out.to_excel(output_xls, index=False)

