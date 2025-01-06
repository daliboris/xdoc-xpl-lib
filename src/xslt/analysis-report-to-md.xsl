<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xpan="https://www.daliboris.cz/ns/xproc/analysis"
  xmlns:xhtml="http://www.w3.org/1999/xhtml"
  xmlns="https://www.daliboris.cz/ns/xproc/analysis"
  exclude-result-prefixes="xs math xd xpan"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> November 26, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:character-map name="javascript">
    <xsl:output-character character="&gt;" string=">"/>
    <xsl:output-character character="&amp;" string="&amp;"/>
  </xsl:character-map>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:output method="text" indent="no" use-character-maps="javascript" />
  
  <xsl:mode on-no-match="shallow-skip"/>
  
  <xsl:variable name="new-line" select="'&#xa;&#xd;'"/>
  <xsl:variable name="single-line" select="'&#xa;'"/>
  
  <xsl:template match="/">
    <xsl:text># XProc Analysis Report</xsl:text>
    <xsl:value-of select="$new-line"/>
    
    <!-- 
    <xsl:text>## List of steps</xsl:text>
    <xsl:apply-templates select="//xpan:analysis//xpan:step" mode="overview">
      <xsl:sort select="@type" />
    </xsl:apply-templates>
     -->
    
    <xsl:value-of select="$new-line"/>
    <xsl:apply-templates select="//xpan:analysis" />
    
  </xsl:template>
  

  <xsl:template match="xpan:step" mode="overview">
    <xsl:value-of select="$new-line"/>
<xsl:value-of select="concat('- [#', generate-id(), ']', '(', (@type, 'default')[1] ,')', '(', parent::xpan:analysis/@file-name, ')')"/>
  </xsl:template>
  
  <xsl:template match="xpan:analysis">
    <xsl:variable name="semver" select="xpan:library/@semver"/>
    <xsl:text>## </xsl:text>
    <xsl:value-of select="@file-name"/>
    <xsl:if test="$semver">
      <xsl:value-of select="' (version: ' || $semver || ')'"/>
    </xsl:if>
    
    <xsl:value-of select="$new-line"/>
    <xsl:apply-templates />

  </xsl:template>
  
  <xsl:template match="xpan:documentation">
    <xsl:text>#### Documentation</xsl:text> (<xsl:value-of select="@length"/>)
    <xsl:value-of select="$new-line"/>
    <xsl:apply-templates />
  </xsl:template>
  
  <xsl:template match="xhtml:section"><xsl:apply-templates /></xsl:template>
  
  <xsl:template match="xhtml:h1 | xhtml:h2 | xhtml:h3"><xsl:text>##### </xsl:text>
    <xsl:apply-templates />
    <xsl:value-of select="$new-line"/>
  </xsl:template>
  
  <xsl:template match="xhtml:p">
    <xsl:apply-templates />
    <xsl:value-of select="$new-line"/>
  </xsl:template>
  
  <xsl:template match="xhtml:*/text()">
    <xsl:value-of select="."/>
  </xsl:template>
  
  <xsl:template match="xpan:prolog">
    <div class="prolog">
      <xsl:apply-templates />
    </div>
  </xsl:template>
  
  <xsl:template match="xpan:step">
    <xsl:text>####</xsl:text>
    <!--<xsl:value-of select="generate-id()"/>-->
    
    <xsl:text> **</xsl:text>
    <xsl:value-of select="(@type, 'default')[1]"/>
    <xsl:text>**</xsl:text>
    <xsl:if test="@name"><xsl:text> </xsl:text>(<xsl:value-of select="@name"/>)</xsl:if>
    <xsl:value-of select="$new-line"/>
    <xsl:apply-templates />
    
  </xsl:template>
  
  <xsl:template match="xpan:body">
      <xsl:text>### Steps </xsl:text> (<xsl:value-of select="count(xpan:step)" /> + <xsl:value-of select="count(xpan:call)"/>)
      <xsl:value-of select="$single-line"/>
      <xsl:apply-templates select="xpan:documentation" />
      <xsl:value-of select="$single-line"/>
      
      <xsl:if test="xpan:call">
        <xsl:value-of select="$new-line"/>
        <xsl:text>| </xsl:text>
        <xsl:text>position</xsl:text>
        <xsl:text> | </xsl:text>
        <xsl:text>step</xsl:text>
        <xsl:text> | </xsl:text>
        <xsl:text>name</xsl:text>
        <xsl:text> | </xsl:text>
        <xsl:text>parameter</xsl:text>
        <xsl:text> | </xsl:text>
        <xsl:text>value</xsl:text>
        <xsl:text> | </xsl:text>
        <xsl:value-of select="$single-line"/>
        <xsl:text>| </xsl:text>
        <xsl:text>---</xsl:text>
        <xsl:text> | </xsl:text>
        <xsl:text>---</xsl:text>
        <xsl:text> | </xsl:text>
        <xsl:text>---</xsl:text>
        <xsl:text> | </xsl:text>
        <xsl:text>---</xsl:text>
        <xsl:text> | </xsl:text>
        <xsl:text>---</xsl:text>
        <xsl:text> | </xsl:text>
        <xsl:value-of select="$single-line"/>
        <xsl:apply-templates select="xpan:call" />
        <xsl:value-of select="$new-line"/>
      </xsl:if>
    
    <xsl:apply-templates select="xpan:step" />
    <xsl:value-of select="$single-line"/>
  </xsl:template>
  
  <xsl:template match="xpan:call">
    <xsl:variable name="position">
      <xsl:number from="xpan:body" />
    </xsl:variable>
    
    <xsl:text>| </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="@step"/>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> | </xsl:text>
    <xsl:text> </xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:text> </xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="$single-line"/>
    <xsl:apply-templates>
      <xsl:sort select="@name" />
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="xpan:parameter">
    
    <xsl:text>| </xsl:text>
    <xsl:text> </xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:text> </xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:text> </xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="replace(@value, '\|', '\\|')"/>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="$single-line"/>
  </xsl:template>
  

  <xsl:template match="xpan:imports">
    <xsl:text>#### Imports </xsl:text>(<xsl:value-of select="count(*)"/>)
    <xsl:value-of select="$new-line"/>
    <xsl:apply-templates />
    <xsl:value-of select="$new-line"/>
  </xsl:template>
  
  <xsl:template match="xpan:import">
    <xsl:text>- </xsl:text><xsl:value-of select="@href"/>
    <xsl:value-of select="$new-line"/>
  </xsl:template>
  
  <xsl:template match="xpan:ports">
    <xsl:text>#### Ports </xsl:text>(<xsl:value-of select="count(*)"/>)
    <xsl:value-of select="$new-line"/>
    <xsl:text>| </xsl:text>
    <xsl:text>direction</xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:text>value</xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:text>primary</xsl:text>
    <xsl:text> |</xsl:text>
    <xsl:value-of select="$single-line"/>
    <xsl:text>| </xsl:text>
    <xsl:text>---</xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:text>---</xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:text>---</xsl:text>
    <xsl:text>| </xsl:text>
    <xsl:value-of select="$single-line"/>
    <xsl:apply-templates select="xpan:input" >
      <xsl:sort select="xpan:input/@port" />
    </xsl:apply-templates>
    <xsl:apply-templates select="xpan:output">
      <xsl:sort select="xpan:output/@port" />
    </xsl:apply-templates>
    <xsl:value-of select="$new-line"/>
  </xsl:template>
  
  <xsl:template match="xpan:input | xpan:output">
    
    <xsl:text>| </xsl:text>
    <xsl:value-of select="local-name()"/>
    <xsl:text> | </xsl:text>
    <xsl:choose>
      <xsl:when test="@primary = ('true', 'yes', '1')">
        <xsl:text>**</xsl:text><xsl:value-of select="@port"/><xsl:text>**</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@port"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> | </xsl:text>
      <xsl:value-of select="(@primary, 'false')[1]"/>
    <xsl:text> |</xsl:text>
    <xsl:value-of select="$single-line"/>
  </xsl:template>
  
  <xsl:template match="xpan:options">
      <xsl:text>#### Options </xsl:text>(<xsl:value-of select="count(*)"/>)
      <xsl:value-of select="$new-line"/>
      <xsl:text>| </xsl:text>
      <xsl:text>name</xsl:text>
      <xsl:text> | </xsl:text>
      <xsl:text>properties</xsl:text>
      <xsl:text> |</xsl:text>
      <xsl:value-of select="$single-line"/>
      <xsl:text>| </xsl:text>
      <xsl:text>---</xsl:text>
      <xsl:text> | </xsl:text>
      <xsl:text>---</xsl:text>
      <xsl:text> |</xsl:text>
      <xsl:value-of select="$single-line"/>
      <xsl:apply-templates>
        <xsl:sort select="xpan:option/@name" />
      </xsl:apply-templates>
    <xsl:value-of select="$new-line"/>
  </xsl:template>
  
  <xsl:template match="xpan:option">
    <xsl:text>| </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="(for $att in @* return concat(name($att), ' = ', $att)) => string-join(' \| ')"/>
    <xsl:text> |</xsl:text>
    <xsl:value-of select="$single-line"/>
  </xsl:template>
  
  <xsl:template match="xpan:body/xpan:step/xpan:prolog/xpan:namespaces" priority="2" />
  
  <xsl:template match="xpan:namespaces">
    <xsl:text>#### Namespaces </xsl:text>(<xsl:value-of select="count(*)"/>)
    <xsl:value-of select="$new-line"/>
    <xsl:text>| </xsl:text>
    <xsl:text>prefix</xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:text>string</xsl:text>
    <xsl:text> |</xsl:text>
    <xsl:value-of select="$single-line"/>
    <xsl:text>| </xsl:text>
    <xsl:text>---</xsl:text>
    <xsl:text> | </xsl:text>
    <xsl:text>---</xsl:text>
    <xsl:text> |</xsl:text>
    <xsl:value-of select="$single-line"/>
    <xsl:apply-templates>
      <xsl:sort select="xpan:namespace/@prefix" />
    </xsl:apply-templates>
    <xsl:value-of select="$new-line"/>
  </xsl:template>
  
  <xsl:template match="xpan:namespace">
    <xsl:text>| </xsl:text>
    <xsl:value-of select="@prefix"/>
    <xsl:text> | </xsl:text>
    <xsl:value-of select="@value"/>
    <xsl:text> |</xsl:text>
    <xsl:value-of select="$single-line"/>
  </xsl:template>

  
</xsl:stylesheet>