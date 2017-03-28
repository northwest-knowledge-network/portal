<?xml version="1.0" encoding="UTF-8"?>

<!--
  
# This work was created by participants in the Northwest Knowledge Network
# (NKN), and is copyrighted by NKN. For more information on NKN, see our
# web site at http://www.northwestknowledge.net
#
#   Copyright 2016 Northwest Knowledge Network
#
# Licensed under the Creative Commons CC BY 4.0 License (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   https://creativecommons.org/licenses/by/4.0/legalcode
#
# Software distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:nkn="https://nknportal.nkn.uidaho.edu/renderMetadata2/xsd/nkn.xsd"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:dc="http://purl.org/dc/elements/1.1/"
  exclude-result-prefixes="xs"
  version="2.0">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="/">
    <div class="record">
      <div class="xsltpath"><xsl:value-of select="/nkn:record/nkn:xsltPath" /></div>
      <div class="recordTitle"><xsl:value-of select="/nkn:record/nkn:title" /></div>
      <div class="recordDetails">
        <div class="xmlUrl"><xsl:value-of select="/nkn:record/nkn:xmlUrl" /></div>
        <xsl:if test="/nkn:record/nkn:abstract[. != '']">
        	<div class="abstract"><xsl:value-of select="/nkn:record/nkn:abstract" disable-output-escaping="yes" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:description[. != '']">
        	<div class="descript"><xsl:value-of select="/nkn:record/nkn:description" disable-output-escaping="yes" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:purpose[. != '']">
        	<div class="purpose"><xsl:value-of select="/nkn:record/nkn:purpose" /></div>
        </xsl:if>

  	<!-- Contact Information -->
        <xsl:if test="(/nkn:record/nkn:contact/nkn:cntPerson[. != '']) or (/nkn:record/nkn:contact/nkn:cntOrg[. != ''])">
         <div class="contact">
		<xsl:if test="/nkn:record/nkn:contact/nkn:cntPerson[. != '']">
            	  <div class="cntPerson"><xsl:value-of select="/nkn:record/nkn:contact/nkn:cntPerson" /></div>
        	</xsl:if>

        	<xsl:if test="/nkn:record/nkn:contact/nkn:cntOrg[. != '']">
                  <div class="cntOrg"><xsl:value-of select="/nkn:record/nkn:contact/nkn:cntOrg" /></div>
        	</xsl:if>
        	<xsl:if test="/nkn:record/nkn:contact/nkn:cntEmail[. != '']">
                  <div class="cntEmail"><xsl:value-of select="/nkn:record/nkn:contact/nkn:cntEmail" /></div>
        	</xsl:if>
        	<xsl:if test="/nkn:record/nkn:contact/nkn:cntVoice[. != '']">
                  <div class="cntVoice"><xsl:value-of select="/nkn:record/nkn:contact/nkn:cntVoice" /></div>
        	</xsl:if>
	 </div> 
        </xsl:if>

        <xsl:if test="/nkn:record/nkn:creator[. != '']">
        	<div class="creator"><xsl:value-of select="/nkn:record/nkn:creator" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:date[. != '']">
        	<div class="date"><xsl:value-of select="/nkn:record/nkn:date" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:publisher[. != '']">
        	<div class="publisher"><xsl:value-of select="/nkn:record/nkn:publisher" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:resDesc[. != '']">
        	<div class="resDesc"><xsl:value-of select="/nkn:record/nkn:resDesc" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:geoForm[. != '']">
        	<div class="geoForm"><xsl:value-of select="/nkn:record/nkn:geoForm" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:formName[. != '']">
        	<div class="formName"><xsl:value-of select="/nkn:record/nkn:formName" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:supInfo[. != '']">
        	<div class="supInfo"><xsl:value-of select="/nkn:record/nkn:supInfo" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:dataCred[. != '']">
        	<div class="dataCred"><xsl:value-of select="/nkn:record/nkn:dataCred" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:constraints[. != '']">
        	<div class="constraints"><xsl:value-of select="/nkn:record/nkn:constraints" disable-output-escaping="yes" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:liabilities[. != '']">
        	<div class="liabilities"><xsl:value-of select="/nkn:record/nkn:liabilities" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:geoBoundsW[. != '']">
        	<div class="geoBounds"></div>
        	<div class="geoBoundsW"><xsl:value-of select="/nkn:record/nkn:geoBoundsW" /></div>
        	<div class="geoBoundsE"><xsl:value-of select="/nkn:record/nkn:geoBoundsE" /></div>
        	<div class="geoBoundsN"><xsl:value-of select="/nkn:record/nkn:geoBoundsN" /></div>
        	<div class="geoBoundsS"><xsl:value-of select="/nkn:record/nkn:geoBoundsS" /></div>
        </xsl:if>
        <xsl:if test="/nkn:record/nkn:temporal[. != '']">
        	<div class="temporal"><xsl:value-of select="/nkn:record/nkn:temporal" /></div>
        </xsl:if>

  	<!-- Online links -->
        <div class="linksLabel">Online Link(s):</div>
        <xsl:for-each select="/nkn:record/nkn:links/nkn:link">
          <span class="summaryLink"><a href="{nkn:linkUrl}" target="_blank"><xsl:value-of select="nkn:linkTitle" /></a></span>
        </xsl:for-each>
        <span class="summaryLink"><a href="{/nkn:record/nkn:xmlUrl}" target="_blank">View Metadata as XML</a></span>

      </div>  <!-- close recordDetails -->

    </div>  <!-- close record -->
  </xsl:template>
</xsl:stylesheet>
