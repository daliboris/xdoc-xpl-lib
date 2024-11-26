# xdoc-xpl-lib

XProc 3.0 Library for generating documentation of XProc projects

This library analyzes XProc documents and creates documentation for individual steps in the libraries and pipelines.

Analysis can be transformed to the HTML or Markdown document.

## How to use

- include [xproc-analyzer-3.0.xpl](src/xproc/xproc-analyzer-3.0.xpl) library in your project
- add namespace `xmlns:xpan="https://www.daliboris.cz/ns/xproc/analysis"` of this library
- set options for `xpan:analyze`, `xpan:create-analysis` or `xpan:create-report` pipeline
  - `input-directory`: directory with XProc files (path can be relative or absolute), 
  - `output-directory`: directory whre the report and documentation will be stored (path can be relative or absolute), 
  - `output-file-stem`: stem of the generated file, i. e. file name without the extension
  - `report-format`: format of the generated documentation, can be `html` or `markdown`
- call main step from the [xproc-analyzer-3.0.xpl](src/xproc/xproc-analyzer-3.0.xpl) pipeline

For example following code analyzes XProc files stored in the `xproc` directory and stores generated HTML and Markdown report in the current directory; file names start with `README`:

```xml
<p:import href="../xproc/xproc-analyzer-3.0.xpl" />
<!-- --> 
<xpan:analyze input-directory="../xproc" 
	output-file-stem="README"
	output-directory="."
	debug-path="{$debug-path}" base-uri="{$base-uri}">
 <p:with-option name="documentation-format" select="('markdown', 'html')" />
</xpan:analyze>
```	

For full example see [documentation.xpl](src/documentation/documentation.xpl) file.