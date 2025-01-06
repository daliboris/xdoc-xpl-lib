<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns:p="http://www.w3.org/ns/xproc" 
  xmlns:c="http://www.w3.org/ns/xproc-step" 
  xmlns:xpan="https://www.daliboris.cz/ns/xproc/analysis"
  xmlns:xhtml="http://www.w3.org/1999/xhtml" 
  xmlns="https://www.daliboris.cz/ns/xproc/analysis"
  exclude-result-prefixes="xs math xd p c xpan"
  version="2.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> May 4, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:output method="xml" indent="yes" />
  <xsl:mode on-no-match="shallow-skip"/>
  
  <xsl:template match="/">
    <xsl:variable name="file-name" select="tokenize(base-uri(), '/')[last()]"/>
    <analysis file-name="{$file-name}" path="{base-uri()}">
      <xsl:apply-templates />
    </analysis>
  </xsl:template>
  
  
  <xsl:template match="p:declare-step">
    <step>
      <xsl:copy-of select="@type | @name" />
      <xsl:call-template name="get-prolog"/>
      <body>
        <xsl:apply-templates mode="get-body" />
      </body>
    </step>
  </xsl:template>
  
  <xsl:template match="p:library">
    <library>
      <xsl:copy-of select="@type | @name" />
      <xsl:call-template name="get-version" />
      <xsl:call-template name="get-prolog"/>
      <body>
        <xsl:apply-templates mode="get-body" />
      </body>
    </library>
  </xsl:template>
  
  
  <xsl:template match="p:library/*" mode="get-body get-prolog">
    <xsl:apply-templates select="." />
  </xsl:template>
  
  <xsl:template match="/p:declare-step/p:documentation" mode="get-body" priority="3" />
  
  <xsl:template match="p:documentation" mode="get-body get-prolog" priority="2">
    <xsl:element name="{local-name()}">
      <xsl:attribute name="length" select="normalize-space(.) => string-length()" />
      <xsl:copy-of select="*" />
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="p:declare-step/p:declare-step" mode="get-body"  priority="2">
    <xsl:apply-templates select="." />
  </xsl:template>
  
  <xsl:template match="p:declare-step/*" mode="get-body">
    <call step="{name()}">
      <xsl:copy-of select="@name" />
      <xsl:apply-templates select="@* except (@name, @message, @p:message)" mode="get-parameters" />
      <xsl:apply-templates select="*" mode="get-parameters" />
    </call>
  </xsl:template>
  
  <xsl:template  match="p:for-each | p:choose" mode="get-body" priority="2">
    <call step="{name()}">
      <xsl:if test="self::p:choose">
        <xsl:attribute name="length" select="count(p:when)" />
      </xsl:if>
      <xsl:if test="self::p:for-each">
        <xsl:apply-templates select="p:with-input" mode="get-parameters" />
      </xsl:if>
    </call>
  </xsl:template>
  
  <xsl:template name="get-version">
    <xsl:variable name="version" select="p:documentation[1]/xhtml:meta[@name='version']"/>
    <xsl:if test="exists($version)">
      <xsl:attribute name="semver" select="$version/@content" />
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="get-prolog">
    <prolog>
      <xsl:apply-templates select="p:documentation" mode="get-prolog" />
      <xsl:call-template name="get-namespaces" />
      <xsl:call-template name="get-imports"/>
      <xsl:call-template name="get-options"/>
      <xsl:call-template name="get-ports"/>
    </prolog>
  </xsl:template>
  
  <xsl:template name="get-namespaces">
    <namespaces>
      <xsl:for-each select="namespace::*">
        <namespace prefix="{name()}" value="{.}" />
      </xsl:for-each>
    </namespaces>
  </xsl:template>
  
  <xsl:template name="get-ports">
    <xsl:if test="p:input | p:output">
      <ports>
        <xsl:apply-templates select="p:input" mode="get-prolog" />
        <xsl:apply-templates select="p:output" mode="get-prolog" />
      </ports>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="@*" mode="get-parameters">
    <parameter name="{name()}" value="{.}" />
  </xsl:template>
  
  <xsl:template match="p:with-input" mode="get-parameters" priority="2">
    <port name="{(@port,'anonymous')[1]}">
      <xsl:apply-templates select="@* except @port" mode="#current" />
    </port>
  </xsl:template>
  
  <xsl:template match="p:with-option" mode="get-parameters" priority="2">
    <parameter name="{@name}" value="{@select}" />
  </xsl:template>
  
  <xsl:template match="*" mode="get-parameters">
    <parameter name="{name()}" value="{.}" />
  </xsl:template>

  
  <xsl:template name="get-options">
    <xsl:if test="p:option">
      <options>
        <xsl:apply-templates select="p:option" mode="get-prolog" />
      </options>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="get-imports">
    <xsl:if test="p:import">
      <imports>
        <xsl:apply-templates select="p:import" mode="get-prolog"/>
      </imports>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="p:import" mode="get-prolog">
    <import href="{@href}" />
  </xsl:template>
  
  <xsl:template match="p:option" mode="get-prolog">
    <option>
      <xsl:copy-of select="@*" />
    </option>
  </xsl:template>
  
  <xsl:template match="p:input | p:output" mode="get-prolog">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@* except @serialization" />
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="p:import | p:option | p:input | p:output" 
    mode="get-body" priority="2" />
  
</xsl:stylesheet>