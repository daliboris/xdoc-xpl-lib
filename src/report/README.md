# XProc Analysis Report

## xproc-analyzer-3.0.xpl
#### **default**
#### Documentation (148)
    
##### XProc files Analyzer
Analyzes XProc files in the libraries and pipeplines.
##### Analyzátor souborů XProc
Analyzuje soubory XProc v knihovnách a kanálech.
#### Namespaces (6)
    
| prefix | string |
| --- | --- |
| c | http://www.w3.org/ns/xproc-step |
| p | http://www.w3.org/ns/xproc |
| xhtml | http://www.w3.org/1999/xhtml |
| xpan | https://www.daliboris.cz/ns/xproc/analysis |
| xs | http://www.w3.org/2001/XMLSchema |
| xml | http://www.w3.org/XML/1998/namespace |

#### Options (6)
      
| name | properties |
| --- | --- |
| debug-path | name = debug-path \| select = () \| as = xs:string? |
| base-uri | name = base-uri \| as = xs:anyURI \| select = static-base-uri() |
| input-directory | name = input-directory \| select = '.' \| as = xs:string |
| output-directory | name = output-directory \| select = '../report' \| as = xs:string |
| output-file-stem | name = output-file-stem \| select = 'README' \| as = xs:string |
| documentation-format | name = documentation-format \| select = ('markdown', 'html') \| as = xs:string* \| values = ('html', 'markdown') |

#### Ports (1)
    
| direction | value | primary |
| --- | --- | ---| 
| output | result | false |

### Steps  (3 + 1)
      


| position | step | name | parameter | value | 
| --- | --- | --- | --- | --- | 
| 1 | xpan:analyze |  |   |   | 
|   |   |   | base-uri | {$base-uri} | 
|   |   |   | debug-path | {$debug-path} | 
|   |   |   | documentation-format | ('markdown', 'html') | 
|   |   |   | input-directory | {$input-directory} | 
|   |   |   | output-directory | {$output-directory} | 
|   |   |   | output-file-stem | {$output-file-stem} | 

#### **xpan:create-analysis**
#### Documentation (172)
    
##### Create analysis
Analyzes XProc files in the directory and creates report in XML format.
##### Vytvoření analýzy
Analyzuje soubory XProc ve složce a vytvoří souhrn ve formátu XML.
#### Options (3)
      
| name | properties |
| --- | --- |
| debug-path | name = debug-path \| select = () \| as = xs:string? |
| base-uri | name = base-uri \| as = xs:anyURI \| select = static-base-uri() |
| input-directory | name = input-directory \| select = '.' \| as = xs:string |

#### Ports (1)
    
| direction | value | primary |
| --- | --- | ---| 
| output | **result** | true |

### Steps  (0 + 4)
      
#### Documentation (172)
    
##### Create analysis
Analyzes XProc files in the directory and creates report in XML format.
##### Vytvoření analýzy
Analyzuje soubory XProc ve složce a vytvoří souhrn ve formátu XML.


| position | step | name | parameter | value | 
| --- | --- | --- | --- | --- | 
| 1 | p:directory-list |  |   |   | 
|   |   |   | include-filter | ^.*\.xpl | 
|   |   |   | path | {$input-directory} | 
| 2 | p:for-each |  |   |   | 
|   |   |   | select | //c:file | 
| 3 | p:wrap-sequence |  |   |   | 
|   |   |   | wrapper | xpan:report | 
| 4 | p:namespace-delete |  |   |   | 
|   |   |   | prefixes | p c xs | 


#### **xpan:create-report**
#### Documentation (173)
    
##### Create report
Converts analysis of XProc files to HTML or Markdown format.
##### Vytvoření souhrnu
Konvertuje analýzu souborů XProc a vytvoří souhrn ve formátu HTML nebo Markdown.
#### Options (3)
      
| name | properties |
| --- | --- |
| debug-path | name = debug-path \| select = () \| as = xs:string? |
| base-uri | name = base-uri \| as = xs:anyURI \| select = static-base-uri() |
| format | name = format \| select = 'html' \| as = xs:string \| values = ('html', 'markdown') |

#### Ports (2)
    
| direction | value | primary |
| --- | --- | ---| 
| input | **source** | true |
| output | **result** | true |

### Steps  (0 + 1)
      
#### Documentation (173)
    
##### Create report
Converts analysis of XProc files to HTML or Markdown format.
##### Vytvoření souhrnu
Konvertuje analýzu souborů XProc a vytvoří souhrn ve formátu HTML nebo Markdown.


| position | step | name | parameter | value | 
| --- | --- | --- | --- | --- | 
| 1 | p:choose |  |   |   | 


#### **xpan:analyze**
#### Documentation (166)
    
##### Analyze
Analyzes XProc files in the libraries and pipeplines and saves report files.
##### Analýza
Analyzuje soubory XProc v knihovnách a kanálech a uloží výsledné soubory.
#### Options (6)
      
| name | properties |
| --- | --- |
| debug-path | name = debug-path \| select = () \| as = xs:string? |
| base-uri | name = base-uri \| as = xs:anyURI \| select = static-base-uri() |
| input-directory | name = input-directory \| select = '.' \| as = xs:string |
| output-directory | name = output-directory \| select = '../report' \| as = xs:string |
| output-file-stem | name = output-file-stem \| select = 'README' \| as = xs:string |
| documentation-format | name = documentation-format \| select = ('markdown', 'html') \| as = xs:string* \| values = ('html', 'markdown') |

#### Ports (1)
    
| direction | value | primary |
| --- | --- | ---| 
| output | result | false |

### Steps  (0 + 7)
      
#### Documentation (166)
    
##### Analyze
Analyzes XProc files in the libraries and pipeplines and saves report files.
##### Analýza
Analyzuje soubory XProc v knihovnách a kanálech a uloží výsledné soubory.


| position | step | name | parameter | value | 
| --- | --- | --- | --- | --- | 
| 1 | p:variable | debug |   |   | 
|   |   |   | select | $debug-path \|\| '' ne '' | 
| 2 | p:variable | debug-path-uri |   |   | 
|   |   |   | select | resolve-uri($debug-path, $base-uri) | 
| 3 | xpan:create-analysis |  |   |   | 
|   |   |   | base-uri | {$base-uri} | 
|   |   |   | debug-path | {$debug-path} | 
|   |   |   | input-directory | {$input-directory} | 
| 4 | p:store | analysis |   |   | 
|   |   |   | href | {$output-directory}/{$output-file-stem}.xml | 
|   |   |   | serialization | map{'indent' : true()} | 
| 5 | p:for-each |  |   |   | 
|   |   |   | select | $documentation-format | 
| 6 | p:identity |  |   |   | 
|   |   |   | pipe | result-uri@analysis result-uri@loop | 
| 7 | p:wrap-sequence |  |   |   | 
|   |   |   | wrapper | c:result | 



