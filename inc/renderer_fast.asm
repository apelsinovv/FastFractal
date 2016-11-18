push eax
push ebx
push ecx
push edx

push edi
push esi

movss xmm6, const1

//раскопируваем ее по всему регистру
shufps xmm6, xmm6, 0
movss xmm0, const256
movss xmm6, xmm0
shufpd xmm6, xmm6, 1

mov edx, zskip

mov ebx, cl_gradiento_float
mov edi, line
mov esi, map

mov eax, wy
sal eax, 2  //умножаем на 4
add esi, eax

mov ecx, w
//делим на 4
sar ecx, 2

@for_row:

	movaps xmm0, [esi]

	//по быстрому сначала считаем дробные части
	cvttps2dq xmm1, xmm0
	cvtdq2ps xmm1, xmm1

	//теерь в xmm0 храняться коэффициенты интерполяции
	subps xmm0, xmm1

	//грузим единицы, и вычитаем из них коэффициенты
	movaps xmm2, xmm6
	shufps xmm2, xmm2, 0 //забыли раскопировать лов-парт по всему регистру

	subps xmm2, xmm0
	//меняем местами
	shufpd xmm6, xmm6, 1 

	//в xmm1 - индексы цветов
	//в xmm2 - коэффициенты интерполяции
	//в xmm0 - коэффициенты интерполяции второго порядка
	//в xmm6 - константа, которую надо беречь ака зеницу ока
	//в xmm7 - будем таки накапливать сумму цветов 
	//нам теперь надо просто перемешать нужные цвета

		//PASS-1
		{$I inc/renderer_fast_one_pass.asm}

	shufps xmm0, xmm0, 57
	shufps xmm1, xmm1, 57
	shufps xmm2, xmm2, 57


		//PASS-2
		{$I inc/renderer_fast_one_pass.asm}

	shufps xmm0, xmm0, 57
	shufps xmm1, xmm1, 57
	shufps xmm2, xmm2, 57

		//PASS-3
		{$I inc/renderer_fast_one_pass.asm}

	shufps xmm0, xmm0, 57
	shufps xmm1, xmm1, 57
	shufps xmm2, xmm2, 57
	
		//PASS-4
		{$I inc/renderer_fast_one_pass.asm}

	//в самом конце, происходит сброс в буфер вывода, или линию картинки
	movntps [edi], xmm7 
	//меняем местами (возвращаем в исходное положение)
	shufpd xmm6, xmm6, 1 

	add esi, 16
	add edi, 16

	dec ecx
jnz @for_row


pop esi
pop edi


pop edx
pop ecx
pop ebx
pop eax