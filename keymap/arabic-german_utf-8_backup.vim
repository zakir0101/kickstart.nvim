" Vim Keymap file for Arabic
" Maintainer   : Arabic Support group <support-at-arabeyes.org>
" Created by   : Nadim Shaikli <nadim-at-arabeyes.org>
" Last Updated : 2023-10-27
" This is for a standard Microsoft Arabic keyboard layout.

" Use this short name in the status line.
let b:keymap_name = "arab"


loadkeymap

" TODO: CHARACTERS
"
q	<char-0x0636>			" (1590)	- DAD
w	<char-0x0635>			" (1589)	- SAD
e	<char-0x062b>			" (1579)	- THEH
r	<char-0x0642>			" (1602)	- QAF
t	<char-0x0641>			" (1601)	- FEH
z	<char-0x063a>			" (1594)	- GHAIN
u	<char-0x0639>			" (1593)	- AIN
i	<char-0x0647>			" (1607)	- HEH
o	<char-0x062e>			" (1582)	- KHAH
p	<char-0x062d>			" (1581)	- HAH
ü	<char-0x062c>			" (1580)	- JEEM
+	<char-0x062f>			" (1583)	- DAL
a	<char-0x0634>			" (1588)	- SHEEN
s	<char-0x0633>			" (1587)	- SEEN
d	<char-0x064a>			" (1610)	- YEH
f	<char-0x0628>			" (1576)	- BEH
g	<char-0x0644>			" (1604)	- LAM
h	<char-0x0627>			" (1575)	- ALEF
j	<char-0x062a>			" (1578)	- TEH
k	<char-0x0646>			" (1606)	- NOON
l	<char-0x0645>			" (1605)	- MEEM
ö	<char-0x0643>			" (1603)	- KAF
ä	<char-0x0637>			" (1591)	- TAH
y	<char-0x0626>			" (1574)	- YEH with HAMZA ABOVE
x	<char-0x0621>			" (1569)	- HAMZA
c	<char-0x0624>			" (1572)	- WAW with HAMZA ABOVE
v	<char-0x0631>			" (1585)	- REH
b	<char-0x0644><char-0x0627>	" (1604/1575)	- LAA (lam alef)
n	<char-0x0649>			" (1609)	- ALEF MAKSURA
m	<char-0x0629>			" (1577)	- TEH MARBUTA


" WARNING: 

,	<char-0x0648>			" (1608)	- WAW
.	<char-0x0632>			" (1586)	- ZAIN
-	<char-0x0638>			" (1592)	- ZAH
*	<char-0x0630>			" (1584)	- THAL


" --------------------------------------------------------------------------------
" TODO: Harakat

Q	<char-0x064e>			" (1614)	- Tanween -- FATHA
W	<char-0x064b>			" (1611)	- Tanween -- FATHATAN
E	<char-0x064f>			" (1615)	- Tanween -- DAMMA
R	<char-0x064c>			" (1612)	- Tanween -- DAMMATAN
A	<char-0x0650>			" (1616)	- Tanween -- KASRA
S	<char-0x064d>			" (1613)	- Tanween -- KASRATAN
X	<char-0x0652>			" (1618)	- Tanween -- SUKUN
"WARNING:  DONE
C	<char-0x0651>			" (1617)	- Tanween -- SHADDA  
J	<char-0x0640>			" (1600)	- TATWEEL

" --------------------------------------------------------------------------------

" TODO: COMBINED

H	<char-0x0623>			" (1571)	- ALEF with HAMZA ABOVE
N	<char-0x0625>			" (1573)	- ALEF with HAMZA BELOW
Z	<char-0x0622>			" (1570)	- ALEF with MADDA ABOVE
G	<char-0x0644><char-0x0623>	" (1604/1571)	- LAA  with HAMZA ABOVE
B	<char-0x0644><char-0x0625>	" (1604/1573)	- LAA  with HAMZA BELOW
T	<char-0x0644><char-0x0622>	" (1604/1570)	- LAA  with MADDA ABOVE


" --------------------------------------------------------------------------------

" TODO : SYMBOLS


?	<char-0x061f>			" (1567)	- Arabic Question Mark


" 1:
;	<char-0x060c>			" (1548)	- Arabic Comma
:	<char-0x002e>			" (46)		- ASCII -- .

"_____________
" 2:
" COLOUNS 

Ö	<char-0x003a>			" (58)	        - ASCII -- :
Ä	<char-0x061b>			" (1563)	- Arabic Semicolon

"_____________


"3:
" MINUS
" UNDERSCORE
M	<char-0x002d> 			" (39)		- ASCII -- minus (-)
U	<char-0x005f>			" (96)		- ASCII --  _


"_____________

" 4:
" NORMAL ADD
" NORMAL MULITPLY 
D	<char-0x002b>			" (91)		- ASCII -- +
F	<char-0x002a>			" (93)		- ASCII -- *



" --------------------------------------------------------------------------------

" WARN : NOT NEEDED

"D	<char-0x005b>			" (91)		- ASCII -- [
"F	<char-0x005d>			" (93)		- ASCII -- ]
"C	<char-0x007b>			" (123)		- ASCII -- {
"V	<char-0x007d>			" (125)		- ASCII -- }
"Ü	<char-0x003c>			" (60)		- ASCII -- <
"*	<char-0x003e>			" (62)		- ASCII -- >
"L	<char-0x002f>			" (47)		- ASCII -- /
"U	<char-0x0060>			" (96)		- ASCII -- `
"Y	<char-0x007e>			" (126)		- ASCII -- ~
"M	<char-0x002c> "<char-0x0027>			" (39)		- ASCII -- '
"

" --------------------------------------------------------------------------------


" WARN: NOT IMPORTANG
"
"I	<char-0x00f7>			" (247)		- ASCII suppl -- div
"O	<char-0x00d7>			" (215)		- ASCII suppl -- Arabic mulitply
"<	<char-0x002c>			" (44)		- ASCII -- ,
"P	<char-0x061b>			" (1563)	- Arabic Semicolon

