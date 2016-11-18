cvtss2si eax, xmm1

sub eax, edx //вычитаем zskip
//проверяем на ноль
cmp eax, 0

//jns +02
db $79, $02

	xor eax, eax

sal eax, 4 //умножаем на 16

//берем цветовые констаны 
movaps xmm3, [ebx + eax]
add eax, 16
movaps xmm4, [ebx + eax]

//умножаем их на соотвествующие коефиценты
movss xmm5, xmm0
shufps xmm5, xmm5, 0

mulps xmm4, xmm5

movss xmm5, xmm2
shufps xmm5, xmm5, 0

mulps xmm3, xmm5

//складываем (это у нас была линейная интерполяция)
addps xmm3, xmm4

//теперь весь xmm3 надо умножить на 255
movss xmm4, xmm6
shufps xmm4, xmm4, 0 //грузим первое число

//умножаем на 256
mulps xmm3, xmm4

//дальше надо все это запаковать в 4 8-мибиттных числа
cvttps2dq xmm3, xmm3
movaps xmm4, xmm3

psrldq xmm4, 3
por xmm3, xmm4

psrldq xmm4, 3
por xmm3, xmm4

psrldq xmm4, 3
por xmm3, xmm4
//теперь в младшей части xmm3 лежит код цвета, который надо сбросить в регистр-акумулятор

movss xmm7, xmm3

shufps xmm7, xmm7, 57 //00,11,10,01 (сдвиг в обратную сторону)