section .data
limit:1000
result:0
start:3
section .text
_start:
.loop:
ld start
cmp limit
jz .exit
jmp .mod3
.mod3:
ld start
div #3
mul #3
cmp start
jz .sum
jmp .mod5
.mod5:
ld start
div #5
mul #5
cmp start
jz .sum
jmp .self
.sum:
ld start
add result
st result
jmp .self
.self:
ld start
add #1
st start
jmp .loop
.exit:
ld result
HLT