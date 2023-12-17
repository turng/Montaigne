<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    exclude-result-prefixes="xs"
    version="1.0">
    
    <xsl:template match="tei:TEI">
        <html xmlns="http://www.w3.org/1999/xhtml">
            <head>
                <title>Essays</title>
                <link rel="stylesheet" href=""/>
                <style>
                    .bordeaux-text {
                        font-style:italic;
                    }
                    
                    .text {
                        width: 600px;
                        margin: auto;
                    }
                    
                    h2 {
                        text-transform: capitalize;
                    }
                    
                    
                    /* the next three CSS instructions set up the pop-up feature, whereby the original appears if you hover over
                    the normalized text.*/
                    
                    /*this makes the original text red, but also sets the display to none, meaning the text will be invisible.
                    It will also be removed from the stream of the document. The text after this will fill in the empty space*/
                    .orig {
                        display: none;
                        color:red;
                    }
                    
                    /* this  makes the regularized text visually distinct, so a user will know they can interact with it.
                    You could do this however you want: in bold, in another color, etc... */
                    .reg {
                        text-decoration: underline;
                    }                   
                     
                    /*This takes advantage of the "+" combinator in CSS, which means: the first sibling immediately following the element. 
                    So the CSS selector here is looking for:
                    an element with class "orig" that comes right after an element with class "reg" that is being hovered over.
                    When it finds this element, it will execute the syle instruction below, which is to show the .orig element, as an inline element.
                    You can use this for app lem rdg, too*/
                    .reg:hover + .orig{
                        display:inline;
                    }
                    
                    .portrait {
                        float:left;
                        padding-right: 20px;
                    }
                    
                </style>
            </head>
            <body>              
                <xsl:apply-templates/>
            </body>            
        </html>
    </xsl:template>
    
    <xsl:template match="tei:teiHeader"/>
    
    <xsl:template match="tei:text">
        <div class="text"><xsl:apply-templates/></div>
    </xsl:template>
    
    <xsl:template match="tei:body">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='preface']">
        <div class="preface">
            <!-- use <xsl:value-of select="Xpath expression"/> to output specific content and values from the TEI, using XPath expressions
            Note that <xsl:value-of ../> is an empty element: it doesn't take content-->
            <h2><xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="@n"/></h2>
            <xsl:apply-templates/>
            <hr/>
            <!-- use "mode" to run a specific element through two different templates, for different purposes...
                Here, we're sending the processor to another tei:note template, which will output the notes. The first one simply 
                output an asterisk and did not process the note itself (there was no <xsl:apply-templates> instruction).
                We place the <xsl:apply-templates mode="note"/> here at the end of the section div (for preface)
                in order to have the notes output as endnotes inside this section -->
            <div class="endnotes"><xsl:apply-templates select="descendant::tei:note" mode="note"/></div>
        </div>
        <hr/>
    </xsl:template>
    
    <xsl:template match="tei:div[@type='chapter']">
        <div class="chapter">
            <!-- use <xsl:value-of select="XPath expression"/> to output specific content and values from the TEI, using XPath expressions
            Note that this is an empty element: it doesn't take content-->
            <h2><xsl:value-of select="@type"/><xsl:text> </xsl:text><xsl:value-of select="@n"/></h2>
            <div class="chapter-text"><xsl:apply-templates/></div>
            <hr/>
            <!-- use "mode" to run a specific element through two different templates, for different purposes...
                Here, we're sending the processor to another tei:note template, which will output the notes. The first one simply 
                output an asterisk and did not process the note itself (there was no <xsl:apply-templates> instruction).
                We place the <xsl:apply-templates mode="note"/> here at the end of the section div (not for the chapters)
                in order to have the notes output as endnotes inside this section -->
            <div class="endnotes"><xsl:apply-templates select="descendant::tei:note" mode="note"/></div>
            <hr/>
        </div>
    </xsl:template>
    
    <xsl:template match="tei:head">
        <h2><xsl:apply-templates/></h2>
    </xsl:template>
    
    <xsl:template match="tei:p">
        <p><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:signed">
        <p style="margin-left: 50px;"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:seg[@source='bordeaux_copy']">
        <span class="bordeaux-text"><xsl:apply-templates/></span>
    </xsl:template>
    
    <!-- we're using the HTML <blockquote>, which comes with default style instructions to indent the text
        We could also use something like <p style="margin-left: 40px;">-->
    <xsl:template match="tei:cit">
        <blockquote class="citation"><xsl:apply-templates/></blockquote>
    </xsl:template>
    
    <xsl:template match="tei:quote">
        <!-- use <xsl:if test=""> to set a condition: the instructions inside the statement will be carried out if the condition is met.
            The template itself will run on every <quote>. The <xsl:if> will test to see if the <quote> it's running on has an @xml:lang attribute set to "la" or 
            to "en" respectively. If so, the instructions will be carried out. If not, they won't be.-->
        <xsl:if test="@xml:lang='la'">
            <p><em><xsl:apply-templates/></em></p>
        </xsl:if>
        <xsl:if test="@xml:lang='en'">
            <p><xsl:apply-templates/></p>
        </xsl:if>
    </xsl:template>
    
    <!-- Here are the two <note> templates
        The first one - without any mode - will be run by any <xsl:apply-templates/> instruction that doesn't specify a mode.
        In this case, the <xsl:apply-templates/> instructions in question are the ones in the template for <p> and for <signed>.
        The instructions in the template itself are simply to output an asterisk and do nothing else. Notice that there is no <xsl:apply-templates> here.
        This will ensure that the text of the notes is not output.-->
    <xsl:template match="tei:note">
        <span class="note-ref"><a href="#{@xml:id}"><xsl:text>*</xsl:text></a></span>
    </xsl:template>
    
    <!-- I've left the <a> tag in the template above. You can leave it  out. But the <a> tag here permits linking down to the note. You can create an internal link 
            to an element by giving the element an id. In the template below, we're giving each <p> around a note an id derived from the xml:id of the note
            in the TEI file. We use the curly brackets to add a value to an attribute using an XPath expression. Then in this note template, we link to that 
            id by using href and putting a hash-tag in front of the id. This will create a link, whose target is the element with that id.-->
    
    <!-- This second template for note, with the mode set to "note," will run when invoked by an <xsl:apply-templates mode="note"/> instruction,
        which specifies that only templates in mode="note" should run. Here, the <xsl:apply-templates mode="note"/> statements in question are the ones
        we added in the endnotes div inside the template for <div[@type="preface"]> or <div[@type="chapter"]>. The output of this template will be added there.
        This template will wrap the text of the notes in <p> takes and add an asterisk at the beginning, so a reader can see it's a note.-->   
    <xsl:template match="tei:note" mode="note">
        <p class="note-text" id="{@xml:id}"><xsl:text>* </xsl:text><xsl:apply-templates/></p>
    </xsl:template>  
    
    <!-- this is a way to set up your HTML so that you can take advantage of the CSS instruction to hide or display content, based on whether
        a user is hovering over it. We'll just set the <span>s here with the necessary classes.
        Note though that we're using <xsl:apply-templates select=""/> to reverse the order of the elements in TEI-->
    <xsl:template match="tei:choice">
        <span class="reg"><xsl:apply-templates select="tei:reg"/></span>
        <span class="orig"><xsl:text> [orig: </xsl:text><xsl:apply-templates select="tei:orig"/><xsl:text>]</xsl:text></span>
    </xsl:template>
    
    <!-- this is a simple template to turn <figure> elements in TEI into HTML images.
        Note the use of curly brackets inside the attribute value. This allows you to express the attribute value as an XPath expression.
        Here we want the value of the @url attribute which is inside the <graphic> element, which is a child of <figure>.
        Rememner: <figure> is the context for this template. Thus simply writing <tei:graphic> means by default we're looking for a child named <graphic>.-->
    <xsl:template match="tei:figure">
        <div class="portrait"><img src="{tei:graphic/@url}" width="300"/></div>
    </xsl:template>
    
</xsl:stylesheet>
