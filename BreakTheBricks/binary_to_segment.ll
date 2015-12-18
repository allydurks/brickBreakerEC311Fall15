Revision 3
; Created by bitgen P.28xd at Sun Dec 06 14:24:11 2015
; Bit lines have the following form:
; <offset> <frame address> <frame offset> <information>
; <information> may be zero or more <kw>=<value> pairs
; Block=<blockname     specifies the block associated with this
;                      memory cell.
;
; Latch=<name>         specifies the latch associated with this memory cell.
;
; Net=<netname>        specifies the user net associated with this
;                      memory cell.
;
; COMPARE=[YES | NO]   specifies whether or not it is appropriate
;                      to compare this bit position between a
;                      "program" and a "readback" bitstream.
;                      If not present the default is NO.
;
; Ram=<ram id>:<bit>   This is used in cases where a CLB function
; Rom=<ram id>:<bit>   generator is used as RAM (or ROM).  <Ram id>
;                      will be either 'F', 'G', or 'M', indicating
;                      that it is part of a single F or G function
;                      generator used as RAM, or as a single RAM
;                      (or ROM) built from both F and G.  <Bit> is
;                      a decimal number.
;
; Info lines have the following form:
; Info <name>=<value>  specifies a bit associated with the LCA
;                      configuration options, and the value of
;                      that bit.  The names of these bits may have
;                      special meaning to software reading the .ll file.
;
Bit   769806 0x0019001c    206 Block=OLOGIC_X18Y7 Type=DRP
Bit   769814 0x0019001c    214 Block=OLOGIC_X18Y7 Type=DRP
Bit   769870 0x0019001c    270 Block=OLOGIC_X18Y9 Type=DRP
Bit   769878 0x0019001c    278 Block=OLOGIC_X18Y9 Type=DRP
Bit   769897 0x0019001c    297 Block=OLOGIC_X18Y8 Type=DRP
Bit   769905 0x0019001c    305 Block=OLOGIC_X18Y8 Type=DRP
Bit   769934 0x0019001c    334 Block=OLOGIC_X18Y11 Type=DRP
Bit   769942 0x0019001c    342 Block=OLOGIC_X18Y11 Type=DRP
Bit   769961 0x0019001c    361 Block=OLOGIC_X18Y10 Type=DRP
Bit   769969 0x0019001c    369 Block=OLOGIC_X18Y10 Type=DRP
Bit   770142 0x0019001c    542 Block=OLOGIC_X18Y13 Type=DRP
Bit   770150 0x0019001c    550 Block=OLOGIC_X18Y13 Type=DRP
Bit   770169 0x0019001c    569 Block=OLOGIC_X18Y12 Type=DRP
Bit   770177 0x0019001c    577 Block=OLOGIC_X18Y12 Type=DRP
