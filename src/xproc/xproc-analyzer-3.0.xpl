<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:xpan="https://www.daliboris.cz/ns/xproc/analysis"
	xmlns:xhtml="http://www.w3.org/1999/xhtml" 
	version="3.0">
	
	<p:documentation>
		<xhtml:section xml:lang="en">
			<xhtml:h1>XProc files Analyzer</xhtml:h1>
			<xhtml:p>Analyzes XProc files in the libraries and pipeplines.</xhtml:p>
		</xhtml:section>
		<xhtml:section xml:lang="cs">
			<xhtml:h1>Analyzátor souborů XProc</xhtml:h1>
			<xhtml:p>Analyzuje soubory XProc v knihovnách a kanálech.</xhtml:p>
		</xhtml:section>
	</p:documentation>

	<!-- OUTPUT PORTS -->
	<p:output port="result" serialization="map{'indent' : true()}" />
	
	<!-- OPTIONS -->
	<p:option name="debug-path" select="()" as="xs:string?" />
	<p:option name="base-uri" as="xs:anyURI" select="static-base-uri()"/>
	
	<p:option name="input-directory" select="'.'" as="xs:string" />
	<p:option name="output-directory" select="'../report'" as="xs:string" />
	<p:option name="output-file-stem" select="'README'" as="xs:string"  />
	<p:option name="documentation-format" select="('markdown', 'html')" as="xs:string*" values="('html', 'markdown')" />
	
	<p:declare-step type="xpan:create-analysis">
		
		<p:documentation>
			<xhtml:section xml:lang="en">
				<xhtml:h2>Create analysis</xhtml:h2>
				<xhtml:p>Analyzes XProc files in the directory and creates report in XML format.</xhtml:p>
			</xhtml:section>
			<xhtml:section xml:lang="cs">
				<xhtml:h2>Vytvoření analýzy</xhtml:h2>
				<xhtml:p>Analyzuje soubory XProc ve složce a vytvoří souhrn ve formátu XML.</xhtml:p>
			</xhtml:section>
		</p:documentation>
		
		<!-- OUTPUT PORTS -->
		<p:output port="result" primary="true" />
		
		<!-- OPTIONS -->
		<p:option name="debug-path" select="()" as="xs:string?" />
		<p:option name="base-uri" as="xs:anyURI" select="static-base-uri()"/>
		
		<p:option name="input-directory" select="'.'" as="xs:string" />

	 <!-- PIPELINE STEPS -->
		<p:directory-list path="{$input-directory}" include-filter="^.*\.xpl" />
		
		<p:for-each>
			<p:with-input select="//c:file"/>
			<p:variable name="source" select="resolve-uri(/c:file/@name, base-uri(/))" />
			<p:load href="{$source}" />
			<p:xslt>
				<p:with-input port="stylesheet" href="../xslt/xproc-analyzer.xsl" />
			</p:xslt>
		</p:for-each>
		
		<p:wrap-sequence wrapper="xpan:report" />
		
		<p:namespace-delete prefixes="p c xs" />
		
	</p:declare-step>
	
	<p:declare-step type="xpan:create-report">
		
		<p:documentation>
			<xhtml:section xml:lang="en">
				<xhtml:h2>Create report</xhtml:h2>
				<xhtml:p>Converts analysis of XProc files to HTML or Markdown format.</xhtml:p>
			</xhtml:section>
			<xhtml:section xml:lang="cs">
				<xhtml:h2>Vytvoření souhrnu</xhtml:h2>
				<xhtml:p>Konvertuje analýzu souborů XProc a vytvoří souhrn ve formátu HTML nebo Markdown.</xhtml:p>
			</xhtml:section>
		</p:documentation>

		<!-- INPUT PORTS -->
		<p:input port="source" primary="true" />
		
		<!-- OUTPUT PORTS -->
		<p:output port="result" primary="true" />
		
		<!-- OPTIONS -->
		<p:option name="debug-path" select="()" as="xs:string?" />
		<p:option name="base-uri" as="xs:anyURI" select="static-base-uri()"/>
		
		<p:option name="format" select="'html'" as="xs:string" values="('html', 'markdown')" />
		
		<!-- PIPELINE STEPS -->
		<p:choose>
			<p:when test="$format='html'">
				<p:xslt>
					<p:with-input port="stylesheet" href="../xslt/analysis-report-to-html.xsl" />
				</p:xslt>				
			</p:when>
			<p:when test="$format = 'markdown'">
				<p:xslt>
				<p:with-input port="stylesheet" href="../xslt/analysis-report-to-md.xsl" />
			</p:xslt>				
			</p:when>
		</p:choose>
		
	</p:declare-step>
	
	<!-- VARIABLES -->
	<p:variable name="debug" select="$debug-path || '' ne ''" />
	<p:variable name="debug-path-uri" select="resolve-uri($debug-path, $base-uri)" />
	
	<!-- PIPELINE STEPS -->
	<xpan:create-analysis input-directory="{$input-directory}" debug-path="{$debug-path}" base-uri="{$base-uri}" />
	<p:store href="{$output-directory}/{$output-file-stem}.xml" serialization="map{'indent' : true()}" message="Storing analysis to {$output-directory}/{$output-file-stem}.xml" name="analysis" />
	
	<p:for-each name="loop">
		<p:with-input select="$documentation-format"/>
		<p:output port="result-uri" primary="true" />
		<p:variable name="format" select="." />
		<p:variable name="extension" select="if($format = 'html') then '.html' else '.md'" />
		<xpan:create-report format="{$format}" debug-path="{$debug-path}" base-uri="{$base-uri}">
			<p:with-input port="source" pipe="result@analysis" />
		</xpan:create-report>
		<p:store href="{$output-directory}/{$output-file-stem}{$extension}" serialization="map{'indent' : true()}" message="Storing documentation to {$output-directory}/{$output-file-stem}{$extension}" />
		<p:identity>
			<p:with-input pipe="result-uri" />
		</p:identity>
	</p:for-each>
	
	<p:identity>
		<p:with-input pipe="result-uri@analysis result-uri@loop" />
	</p:identity>
	<p:wrap-sequence wrapper="c:result" />
	
</p:declare-step>
