# xdoc-xpl-lib

XProc 3.0 Library for generating documentation of XProc projects

This library analyzes XProc documents and creates documentation for individual steps in the libraries and pipelines.

Analysis can be transformed to the HTML or Markdown document.

## How to use

- include this library in your project
- set options for [xproc-analyzer.xpl](src/xproc/xproc-analyzer.xpl) pipeline
  - `input-directory`: directory with XProc files (path can be relative or absolute), 
  - `output-directory`: directory whre the report and documentation will be stored (path can be relative or absolute), 
  - `output-file-stem`: stem of the generated file, i. e. file name without extension
  - `report-format`: format of the generated documentation, can be `html` or `markdown`
- call main step from the [xproc-analyzer.xpl](src/xproc/xproc-analyzer.xpl) pipeline