# XProc Analysis Report



    





    

| --- | --- |
| c | http://www.w3.org/ns/xproc-step |
| p | http://www.w3.org/ns/xproc |
| xhtml | http://www.w3.org/1999/xhtml |
| xpan | https://www.daliboris.cz/ns/xproc/analysis |
| xs | http://www.w3.org/2001/XMLSchema |
| xml | http://www.w3.org/XML/1998/namespace |


      
#### Documentation (148)
    





#### **xpan:create-analysis**

    





      

| --- | --- |
| debug-path | name = debug-path \| select = () \| as = xs:string? |
| base-uri | name = base-uri \| as = xs:anyURI \| select = static-base-uri() |
| input-directory | name = input-directory \| select = '.' \| as = xs:string |


    

| --- | --- | ---| 
| output | **result** | true |


      
#### Documentation (172)
    







| --- | --- | --- | --- | --- | 
| 1 | p:variable | input-directory-uri |   |   | 
|   |   |   | select | resolve-uri($input-directory, $base-uri) | 
| 2 | p:directory-list |  |   |   | 
|   |   |   | include-filter | ^.*\.xpl | 
|   |   |   | path | {$input-directory-uri} | 
| 3 | p:for-each |  |   |   | 
|   |   |   | select | //c:file | 
| 4 | p:wrap-sequence |  |   |   | 
|   |   |   | wrapper | xpan:report | 
| 5 | p:namespace-delete |  |   |   | 
|   |   |   | prefixes | p c xs | 


#### **xpan:create-report**

    





      

| --- | --- |
| debug-path | name = debug-path \| select = () \| as = xs:string? |
| base-uri | name = base-uri \| as = xs:anyURI \| select = static-base-uri() |
| format | name = format \| select = 'html' \| as = xs:string \| values = ('html', 'markdown') |


    

| --- | --- | ---| 
| input | **source** | true |
| output | **result** | true |


      
#### Documentation (173)
    







| --- | --- | --- | --- | --- | 
| 1 | p:choose |  |   |   | 


#### **xpan:analyze**

    





      

| --- | --- |
| debug-path | name = debug-path \| select = () \| as = xs:string? |
| base-uri | name = base-uri \| as = xs:anyURI \| select = static-base-uri() |
| input-directory | name = input-directory \| select = '.' \| as = xs:string |
| output-directory | name = output-directory \| select = '../report' \| as = xs:string |
| output-file-stem | name = output-file-stem \| select = 'README' \| as = xs:string |
| documentation-format | name = documentation-format \| select = ('markdown', 'html') \| as = xs:string* \| values = ('html', 'markdown') |


    

| --- | --- | ---| 
| output | result | false |


      
#### Documentation (166)
    







| --- | --- | --- | --- | --- | 
| 1 | p:variable | debug |   |   | 
|   |   |   | select | $debug-path \|\| '' ne '' | 
| 2 | p:variable | debug-path-uri |   |   | 
|   |   |   | select | resolve-uri($debug-path, $base-uri) | 
| 3 | p:variable | output-directory-uri |   |   | 
|   |   |   | select | resolve-uri($output-directory, $base-uri) | 
| 4 | p:variable | input-directory-uri |   |   | 
|   |   |   | select | resolve-uri($input-directory, $base-uri) | 
| 5 | p:variable | output-slash |   |   | 
|   |   |   | select | if(ends-with($output-directory-uri, '/')) then '' else '/' | 
| 6 | xpan:create-analysis |  |   |   | 
|   |   |   | base-uri | {$base-uri} | 
|   |   |   | debug-path | {$debug-path} | 
|   |   |   | input-directory | {$input-directory} | 
| 7 | p:store | analysis |   |   | 
|   |   |   | href | {$output-directory-uri}{$output-slash}{$output-file-stem}.xml | 
|   |   |   | serialization | map{'indent' : true()} | 
| 8 | p:for-each |  |   |   | 
|   |   |   | select | $documentation-format | 
| 9 | p:identity |  |   |   | 
|   |   |   | pipe | result-uri@analysis result-uri@loop | 
| 10 | p:wrap-sequence |  |   |   | 
|   |   |   | wrapper | c:result | 


