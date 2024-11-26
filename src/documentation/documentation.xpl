<p:declare-step 
	xmlns:p="http://www.w3.org/ns/xproc" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xpan="https://www.daliboris.cz/ns/xproc/analysis"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	version="3.0">
	
	<p:import href="../xproc/xproc-analyzer-3.0.xpl" />
	
	<p:documentation>
		<xhtml:section>
			<xhtml:h2></xhtml:h2>
			<xhtml:p></xhtml:p>
		</xhtml:section>
	</p:documentation>
   
   
	<!-- OUTPUT PORTS -->
	<p:output port="result" primary="true" serialization="map{'indent' : true()}" />
	
	<!-- OPTIONS -->
	<p:option name="debug-path" select="()" as="xs:string?" />
	<p:option name="base-uri" as="xs:anyURI" select="static-base-uri()"/>
	
	<!-- VARIABLES -->
	<p:variable name="debug" select="$debug-path || '' ne ''" />
	<p:variable name="debug-path-uri" select="resolve-uri($debug-path, $base-uri)" />
	
	<!-- PIPELINE BODY -->
	
	<xpan:analyze input-directory="../xproc" 
		output-file-stem="README"
		output-directory="."
		debug-path="{$debug-path}" base-uri="{$base-uri}">
		<p:with-option name="documentation-format" select="('markdown', 'html')" />
	</xpan:analyze>
	

</p:declare-step>
