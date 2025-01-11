<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:math="http://www.w3.org/2005/xpath-functions/math"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:xpan="https://www.daliboris.cz/ns/xproc/analysis"
  xmlns="https://www.daliboris.cz/ns/xproc/analysis"
  exclude-result-prefixes="xs math xd xpan"
  version="3.0">
  <xd:doc scope="stylesheet">
    <xd:desc>
      <xd:p><xd:b>Created on:</xd:b> May 4, 2024</xd:p>
      <xd:p><xd:b>Author:</xd:b> Boris</xd:p>
      <xd:p></xd:p>
    </xd:desc>
  </xd:doc>
  
  <xsl:character-map name="javascript">
    <xsl:output-character character="&gt;" string=">"/>
    <xsl:output-character character="&amp;" string="&amp;"/>
  </xsl:character-map>
  
  <xsl:strip-space elements="*"/>
  
  <xsl:output method="html" indent="yes" use-character-maps="javascript" />
  
  <xsl:mode on-no-match="shallow-skip"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title>XProc Analysis Report</title>
        <xsl:call-template name="insert-css"/>
      </head>
      <body>
        <div class="container">
          <main class="details">
            <div class="heading"> 
              <h2>Steps details</h2>
              <fieldset>
                <legend>Expand</legend>
                <input type="checkbox" id="expand-files" name="files"  />
                  <label for="expand-files">Files</label>
                <input type="checkbox" id="expand-documentation" name="documentation"  />
                <label for="expand-documentation">Documentation</label>
                <input type="checkbox" id="expand-steps" name="steps"  />
                  <label for="expand-steps">Steps</label>
                <input type="checkbox" id="expand-all" name="all"  />
                <label for="expand-steps">All</label>
              </fieldset>
            </div>
          <xsl:apply-templates select="//xpan:analysis" />  
        </main>
        <nav class="overview">
          <h2>List of steps</h2>
          <ol>
            <xsl:apply-templates select="//xpan:analysis//xpan:step" mode="overview">
              <xsl:sort select="@type" />
            </xsl:apply-templates>  
          </ol>
        </nav>
        </div>
        <xsl:call-template name="insert-javascript"/>
      </body>
    </html>
  </xsl:template>
  
  
  
  <xsl:template match="xpan:step" mode="overview">
    <li>
      <a href="#{generate-id()}"><xsl:value-of select="(@type, 'default')[1]"/></a> 
      <xsl:if test="not(@type)">
        <xsl:text> (</xsl:text>
        <xsl:value-of select="parent::xpan:analysis/@file-name"/>
        <xsl:text>)</xsl:text>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match="xpan:analysis">

    <xsl:variable name="semver" select="xpan:library/@semver"/>
    <details class="file">
        <summary>
          <strong><xsl:value-of select="@file-name"/></strong> 
          <xsl:if test="$semver">
            <span class="semver"><xsl:value-of select="$semver"/></span>
          </xsl:if>
        </summary>
        <xsl:apply-templates />
      </details>

  </xsl:template>
  
  <xsl:template match="xpan:documentation">
      <details class="documentation">
        <summary>
          <strong>Documentation</strong> (<xsl:value-of select="@length"/>)          
        </summary>
        <xsl:copy-of select="*" />
      </details>
  </xsl:template>
  
  <xsl:template match="xpan:prolog">
    <div class="prolog">
      <xsl:apply-templates />
    </div>
  </xsl:template>
  
  <xsl:template match="xpan:step">
    <details class="step" id="{generate-id()}">
      <xsl:if test="parent::xpan:analysis">
        <xsl:attribute name="open" select="'open'" />
      </xsl:if>
      <summary><strong><xsl:value-of select="(@type, 'default')[1]"/></strong><xsl:if test="@name"><xsl:text> </xsl:text>(<xsl:value-of select="@name"/>)</xsl:if></summary>
      <xsl:apply-templates />
    </details>
  </xsl:template>
  
  <xsl:template match="xpan:body">
    <details class="body">
      <summary><strong>Steps</strong> (<xsl:value-of select="count(xpan:step)" /> + <xsl:value-of select="count(xpan:call)"/>)</summary>
      <xsl:apply-templates select="xpan:documentation" />
      <xsl:apply-templates select="xpan:step" />
      <xsl:if test="xpan:call">
        <table class="steps">
          <colgroup><col /><col /><col /><col /><col /></colgroup>
          <thead>
            <tr>
              <th>#</th>
              <th>step</th>
              <th>name</th>
              <th>parameter</th>
              <th>value</th>
            </tr>
          </thead>
          <tbody>
            <xsl:apply-templates select="xpan:call" />
          </tbody>
        </table>        
      </xsl:if>
    </details>
  </xsl:template>
  
  <xsl:template match="xpan:call">
    <xsl:variable name="position" >
      <xsl:number from="xpan:body" level="multiple" />
    </xsl:variable>
    <xsl:variable name="params" select="xpan:parameter" />
    
    <tr class="call">
      <xsl:if test="xpan:parameter[@name = 'use-when'][@value='false()']">
        <xsl:attribute name="class" select="'call disabled'" />
      </xsl:if>
      <td><xsl:value-of select="$position"/></td>
      <td class="step"><xsl:value-of select="@step"/></td> 
      <td><xsl:value-of select="@name"/></td>
      
      <xsl:choose>
        <xsl:when test="xpan:parameter">
          <xsl:apply-templates select="xpan:parameter[position() eq 1]">
            <xsl:sort select="@name" />
          </xsl:apply-templates>    
        </xsl:when>
        <xsl:otherwise>
          <td></td>
          <td></td>
        </xsl:otherwise>
      </xsl:choose>
    </tr>
    <xsl:apply-templates select="xpan:parameter[position() gt 1]">
      <xsl:sort select="@name" />
    </xsl:apply-templates>
    <xsl:apply-templates select="xpan:port">
      <xsl:sort select="@name" />
    </xsl:apply-templates>
    <xsl:apply-templates select="xpan:* except (xpan:parameter, xpan:port)">
      <xsl:sort select="@name" />
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="xpan:call/xpan:parameter[1] | xpan:call/xpan:port/xpan:parameter[1]" priority="2">
    <xsl:call-template name="param-name-and-value"/>
  </xsl:template>
  
  <xsl:template match="xpan:call/xpan:port">
    <tr class="port">
      <td></td>
      <td>[port]</td>
      <td><xsl:value-of select="@name"/></td>
      <xsl:apply-templates select="xpan:parameter[position() eq 1]">
        <xsl:sort select="@name" />
      </xsl:apply-templates>
    </tr>
    <xsl:apply-templates select="xpan:parameter[position() gt 1]">
      <xsl:sort select="@name" />
    </xsl:apply-templates>
  </xsl:template>
  
  <xsl:template match="xpan:parameter | xpan:port/xpan:parameter">
    <tr class="parameter">
      <xsl:if test="parent::xpan:call[xpan:parameter[@name = 'use-when'][@value='false()']]">
        <xsl:attribute name="class" select="'call disabled'" />
      </xsl:if>
      <td></td>
      <td></td>
      <td></td>
      <xsl:call-template name="param-name-and-value"/>
    </tr>
  </xsl:template>
  
  <xsl:template name="param-name-and-value">
    <td>
      <xsl:value-of select="@name" />
    </td>
    <td>
      <xsl:choose>
        <xsl:when test="@path">
          <a href="{@path}">
            <xsl:value-of select="@value" />
          </a>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@value" />
        </xsl:otherwise>
      </xsl:choose>
    </td>
  </xsl:template>
  
  <xsl:template match="xpan:parameter" use-when="false()">
    <li><xsl:value-of select="@name"/> = <xsl:value-of select="@value"/> </li>
  </xsl:template>

  <xsl:template match="xpan:imports">
    <details class="imports">
      <summary><strong>Imports</strong>  (<xsl:value-of select="count(*)"/>)</summary>
      <ol>
        <xsl:apply-templates />
      </ol>
    </details>
  </xsl:template>
  
  <xsl:template match="xpan:import">
    <li><xsl:value-of select="@href"/></li>
  </xsl:template>
  
  <xsl:template match="xpan:ports">
    <details class="ports">
      <summary><strong>Ports</strong> (<xsl:value-of select="count(*)"/>)</summary>
      <table>
        <colgroup><col /><col /><col /><col /></colgroup>
        <thead>
          <tr>
            <th>#</th>
            <th>direction</th>
            <th>value</th>
            <th>primary</th>
          </tr>
        </thead>
        <xsl:apply-templates select="xpan:input" >
          <xsl:sort select="xpan:input/@port" />
        </xsl:apply-templates>
        <xsl:apply-templates select="xpan:output">
          <xsl:sort select="xpan:output/@port" />
        </xsl:apply-templates>
      </table>
    </details>
  </xsl:template>
  
  <xsl:template match="xpan:input | xpan:output">
    <tr>
      <td><xsl:number from="xpan:body" /></td>
      <td><xsl:value-of select="local-name()"/></td>
      <td>
        <xsl:choose>
          <xsl:when test="@primary = ('true', 'yes', '1')">
            <strong><xsl:value-of select="@port"/></strong>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@port"/>
          </xsl:otherwise>
        </xsl:choose>
      </td>
      <td><xsl:value-of select="(@primary, 'false')[1]"/></td>
    </tr>
  </xsl:template>
  
  <xsl:template match="xpan:options">
    <details class="options">
      <summary><strong>Options</strong>  (<xsl:value-of select="count(*)"/>)</summary>
      <table>
        <colgroup><col /><col /><col /></colgroup>
        <thead>
          <tr>
            <th>#</th>
            <th>name</th>
            <th>properties</th>
          </tr>
        </thead>
        <xsl:apply-templates>
          <xsl:sort select="xpan:option/@name" />
        </xsl:apply-templates>
      </table>
    </details>
  </xsl:template>
  
  <xsl:template match="xpan:option">
    <tr>
      <td><xsl:number from="xpan:body" /></td>
      <td><xsl:value-of select="@name"/></td>
      <td><xsl:value-of select="(for $att in @* return concat(name($att), ' = ', $att)) => string-join(' | ')"/></td>
    </tr>
  </xsl:template>
  
  <xsl:template match="xpan:body/xpan:step/xpan:prolog/xpan:namespaces" priority="2" />
  
  <xsl:template match="xpan:namespaces">
    <details class="namespaces">
      <summary><strong>Namespaces</strong>  (<xsl:value-of select="count(*)"/>)</summary>
      <table>
        <colgroup><col /><col /><col /></colgroup>
        <thead>
          <tr>
            <th>#</th>
            <th>prefix</th>
            <th>string</th>
          </tr>
        </thead>
        <xsl:apply-templates>
          <xsl:sort select="xpan:namespace/@prefix" />
        </xsl:apply-templates>
      </table>
    </details>
  </xsl:template>
  
  <xsl:template match="xpan:namespace">
    <tr>
      <td><xsl:number from="xpan:body" /></td>
      <td><xsl:value-of select="@prefix"/></td>
      <td><xsl:value-of select="@value"/></td>
    </tr>
  </xsl:template>

  <xsl:template name="insert-javascript">
    <script>
      <![CDATA[
      
            function collapseOrExpandItems(expandSelector, itemsSelector, mainExpand) {
              const expand = document.querySelector(expandSelector);
              const items = document.querySelectorAll(itemsSelector);
              
              expand.addEventListener("click", (e) => {
              if(expand.checked && !mainExpand.checked) {
                mainExpand.click();
              }
              items.forEach((item) => {
                if(!expand.checked) 
                  {item.removeAttribute('open')}
                else
                  {item.setAttribute('open', 'open')}
              });
            });
            };
            
            const expandFiles = document.querySelector("#expand-files");
            const expandAll = document.querySelector('#expand-all');
            
            const items = document.querySelectorAll("details");
            expandAll.addEventListener("click", (e) => {
              
              items.forEach((item) => {
                if(!expandAll.checked) 
                  {item.removeAttribute('open')}
                else
                  {item.setAttribute('open', 'open')}
              });
            });
            
            collapseOrExpandItems("#expand-files", "details.file", expandFiles);
            collapseOrExpandItems("#expand-steps", "details.body", expandFiles);
            collapseOrExpandItems("#expand-documentation", "details.documentation", expandFiles);

            
            ]]>
    </script>
  </xsl:template>
  
  <xsl:template name="insert-css">
    <style>
      details {
      border: 1px solid #aaa;
      border-radius: 4px;
      padding: 0.5em 0.5em 0;
      }
      
      summary {
      margin: -0.5em -0.5em 0;
      padding: 0.5em;
      }
      
      details[open] {
      padding: 0.5em;
      }
      
      details[open] summary {
      border-bottom: 1px solid #aaa;
      margin-bottom: 0.5em;
      }
      /* table */
      table {
      border-collapse: collapse;
      }
      
      /* table columns */
      col:nth-of-type(even) { 
      background: #F2F2F2; 
      }
      
      /* table rows */
      tr.call {
      border-top: 1pt solid black;
      }
      tr.call td.step {
      font-weight: bold;
      }
      tr.disabled {
      color: silver;
      }
      tr.parameter {
      border-bottom: 1pt solid silver;
      }
      tr:hover {
      background-color: yellow;
      }
      
      /* table cells */
      th, td {
      padding: .5em;
      }
      
      .container {
      display: grid;
      grid-template-columns: 3fr 1fr;
      gap: 15px 10px;
      justify-content: stretch;
      }
      .details > .heading {
      /*
      display: grid;
      grid-template-columns: 3fr 1fr;
      gap: 15px;
      justify-content: stretch;
      */
      display: flex;
      justify-content: space-between;
      }
      .heading > fieldset {
      place-self: center stretch;
      }
      .semver {
      font-size: 90%;
      color: brown;
      }
      .semver::before {
      content: '(version: '
      }
      .semver::after {
      content: ')'
      }
      @media print {
        details {
        border: 1px solid white;
        }
        details[open] summary {
        border-bottom: 1px solid white;
        }
        .container {
        display: grid;
        grid-template-columns: 1fr;
        }
        nav.overview {
        display: block;
        }
      }
    </style>
  </xsl:template>
  
</xsl:stylesheet>