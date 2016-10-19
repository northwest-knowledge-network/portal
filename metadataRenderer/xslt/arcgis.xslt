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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:utils="urn:XSLTUtils"
  exclude-result-prefixes="msxsl">

  <xsl:output method="html" indent="yes"/>

  <!-- When the root node in the XML is encountered (the metadata element), the
       HTML template is set up. -->
  <xsl:template match="/">
    <div class="meta-container">

      <!-- TITLE. If the metadata doesn't have an title element or if it contains no data, no text appears below. -->
      <xsl:if test="/metadata/dataIdInfo[1]/idCitation[1]/resTitle[1] != ''">
        <h2 class="meta-title">
          <xsl:value-of select="/metadata/dataIdInfo[1]/idCitation[1]/resTitle[1]"
            disable-output-escaping="yes"/>
        </h2>
      </xsl:if>

      <div class="meta-record">

        <!-- ABSTRACT. If the metadata doesn't have an abstract element or if it contains no data, no text appears below. -->
        <xsl:if test="/metadata/dataIdInfo[1]/idAbs[1] != ''">
          <div class="meta-abstract">
            <div class="meta-abstract-heading">Abstract:</div>

            <xsl:choose>
              <xsl:when test="string-length(/metadata/dataIdInfo/idAbs)>400">
                <!-- if length is longer than 400 (or whatever)-->
                <!-- Use spans to truncate the abstact and allow the remainder to be shown -->
                <!-- NOTE: this functionality requires jquery, which is not included in this
                  file because it is assumed to exist in the parent document for the snippet
                  that this XSLT creates -->
                <div>
                  <span style="display:none">
                    <xsl:value-of select="/metadata/dataIdInfo/idAbs"
                      disable-output-escaping="yes"/>
                    <a href="#"
                      onclick="jQuery(this).parent().parent().children().toggle(); return false">
                      [Less]</a>
                  </span>
                  <span style="display:inline">
                    <xsl:call-template name="trim-last-word">
                      <xsl:with-param name="in"
                        select="substring(/metadata/dataIdInfo/idAbs, 1, 400)"/>
                    </xsl:call-template>
                    <a href="#"
                      onclick="jQuery(this).parent().parent().children().toggle(); return false">
                      [More]</a>
                  </span>
                </div>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="/metadata/dataIdInfo/idAbs"
                  disable-output-escaping="yes"/>
              </xsl:otherwise>
            </xsl:choose>

          </div> <!--/meta-abstract-->
        </xsl:if>

        <!-- ONLINE RESOURCE(S). If element does not exist or contains no data, no text appears below.  -->
        <xsl:if
          test="(/metadata/distInfo/distributor/distorTran/onLineSrc != '')">

          <div class="meta-resources">
            <dl>
              <dt>
                <div class="meta-resource-heading">Online Resource(s):</div>
              </dt>
              <xsl:for-each select="/metadata/distInfo/distributor/distorTran">
                <xsl:if test="not(starts-with(normalize-space(onLineSrc/linkage), 'file://'))">
                  <div class="meta-resource">
                    <dd>
                      <a href="{normalize-space(onLineSrc/linkage)}"
                        target="_blank" >
                        <xsl:choose>
                          <xsl:when test="onLineSrc/orDesc != ''">
                            <xsl:value-of select="normalize-space(onLineSrc/orDesc)" disable-output-escaping="yes"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <xsl:value-of select="normalize-space(onLineSrc/linkage)" disable-output-escaping="yes"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </a>
                    </dd>
                  </div>
                </xsl:if>
              </xsl:for-each>
            </dl>
          </div>
        </xsl:if>

        <!-- FULL METADATA LINK -->
        <!-- The %META-LINK-HREF% is replaced after the transform by the calling code, which knows the URL to the transformed file -->
	<div class="view-md-record">
          <a class="meta-link" href="%META-LINK-HREF%" target="_blank">View Full Metadata Record</a>
          &#160;&#160;&#160;&#160;
	  <span class="show-on-map">
            <input style="visibility:hidden;" onclick="toggleBox(%i%);" type="checkbox" value="" /> Show data extent on map above
	  </span>
	</div>

      </div> <!--meta-record-->
    </div> <!--/meta-container-->


  </xsl:template>
  <xsl:template name="trim-last-word">
    <xsl:param name="in"/>
    <xsl:choose>
      <xsl:when test="substring($in, string-length($in), 1)=' '">
        <xsl:value-of select="$in"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="trim-last-word">
          <xsl:with-param name="in" select="substring($in, 1, string-length($in)-1)"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
