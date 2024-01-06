.data
m: .space 4
n: .space 4
cols: .space 4
p: .space 4
decriptare: .space 4
len: .long 0
len_matrice: .long 0
catt: .space 4
rest: .space 4
index: .long 0
indexline: .space 4
indexcol: .space 4
k: .space 4
gen: .long 0
matriceOld: .space 1600
matriceNew: .space 1600
vector_cheie: .space 88
cheie: .space 11
mesaj: .space 11
mesajHexa: .space 21
mesajtemp: .space 23
formatPrintHexa: .asciz "0x%s\n"
formatHexa: .asciz "%s"
formatString: .asciz "%s"
formatPrintString: .asciz "%s\n"
formatScan: .asciz "%ld"
formatPrint: .asciz "%ld "
NewLine: .asciz "\n"
.text
.global main
main:
	lea matriceOld,%edi
    ;//citire date
    pushl $m
    push $formatScan
    call scanf
    pop %ebx
    pop %ebx
	movl m,%eax
	add $1,%eax
	movl %eax,m
    pushl $n
    push $formatScan
    call scanf
    pop %ebx
    pop %ebx
	movl n,%eax
	inc %eax
	movl %eax,n
	inc %eax
	movl %eax, cols
    pushl $p
    push $formatScan
    call scanf
    pop %ebx
    pop %ebx
	;//citire celule vii
	movl $0,%ecx
	CitireCeluleVii:
		pushl %ecx
		cmp %ecx , p
		je ContCitire
		pushl $indexline
		push $formatScan
		call scanf
		pop %ebx
		pop %ebx
		pushl $indexcol
		push $formatScan
		call scanf
		pop %ebx
		pop %ebx
		movl indexline,%eax
		inc %eax
		movl cols,%ebx
		mul %ebx
		add indexcol,%eax
		inc %eax
		movl $1,(%edi , %eax,4)
		pop %ecx
		inc %ecx
		jmp CitireCeluleVii
	ContCitire:
    pushl $k
    push $formatScan
    call scanf
    pop %ebx
    pop %ebx
	pushl $decriptare
	pushl $formatScan
	call scanf
	pop %ebx
	pop %ebx
		movl decriptare,%ebx
		cmp $1,%ebx
		je citirehexa
		push $mesaj
		pushl $formatString
		call scanf
		pop %eax
		pop %eax
		lea mesaj,%edx
		xorl %ecx,%ecx
		for_len:
			xorl %eax,%eax
			movb (%edx,%ecx,1),%al
			cmp $0,%eax
			je exit_len
			incl %ecx
			jmp for_len
		exit_len:
		movl %ecx, len
		jmp exit_citire_mesaj
	citirehexa:
		push $0
		call fflush
		pop %eax
		push $mesajtemp
		pushl $formatHexa
		call scanf
		pop %eax
		pop %eax
		lea mesajtemp,%edx
		movl $1,%ecx
		for_len2:
			xorl %eax,%eax
			movb (%edx,%ecx,2),%al
			cmp $0,%eax
			je exit_len2
			incl %ecx
			jmp for_len2
		exit_len2:
		subl $1,%ecx
		movl %ecx, len
		lea  mesaj,%edi
		for_stoh:
			movl index,%ecx
			cmp len, %ecx
			je exit_citire_mesaj
			xorl %ebx,%ebx
			xorl %eax,%eax
			movb 2(%edx,%ecx,2),%al
			cmp $65,%eax
			jl minus48_1
			subb $7,2(%edx,%ecx,2)
			minus48_1:
			subb $48,2(%edx,%ecx,2)
			movb 2(%edx,%ecx,2),%bl
			shl $4,%ebx
			xorl %eax,%eax
			movb 3(%edx,%ecx,2),%al
			cmp $65,%eax
			jl minus48_2
			subb $7,3(%edx,%ecx,2)
			minus48_2:
			subb $48, 3(%edx,%ecx,2)
			addb 3(%edx,%ecx,2),%bl
			movb %bl,(%edi,%ecx,1)
			incl index
			jmp for_stoh
	exit_citire_mesaj:
	
	;//generare matrice noua
	lea matriceOld,%edi
	for_gen:
		movl gen,%ecx
		cmp %ecx,k
		je exit_gen
		movl $1,indexline
	for_lines:
		movl indexline,%ecx
		cmp %ecx,m
		je cont_gen
		movl $1,indexcol
		for_cols:
			movl indexcol,%ecx
			cmp %ecx,n
			je cont_for_lines
			movl indexline,%eax
			mull cols
			addl indexcol,%eax
			xorl %ebx,%ebx
			subl cols,%eax
			addl (%edi,%eax,4),%ebx
			subl $1,%eax
			addl (%edi,%eax,4),%ebx
			addl cols,%eax
			addl (%edi,%eax,4),%ebx
			addl cols,%eax
			addl (%edi,%eax,4),%ebx
			addl $1,%eax
			addl (%edi,%eax,4),%ebx
			addl $1,%eax
			addl (%edi,%eax,4),%ebx
			subl cols,%eax
			addl (%edi,%eax,4),%ebx
			subl cols,%eax
			addl (%edi,%eax,4),%ebx
			addl cols,%eax
			subl $1,%eax
			movl $3,%ecx
			cmp %ebx,%ecx
			je vie
			movl $1,%ecx
			cmp (%edi,%eax,4),%ecx
			jne moarta
			movl $2,%ecx
			cmp %ebx,%ecx
			je vie
			moarta:
				lea matriceNew,%ebx
				movl $0,(%ebx,%eax,4)
				jmp cont_for_cols
			vie:
				lea matriceNew,%ebx
				movl $1,(%ebx,%eax,4)
			cont_for_cols:
			addl $1,indexcol
			jmp for_cols
		cont_for_lines:
		lea matriceNew,%ebx
		addl $1,indexline
		jmp for_lines
		cont_gen:
			movl $1,indexline
			for_lines2:
				movl indexline,%ecx
				cmp %ecx,m
				je cont_gen2
				movl $1,indexcol
				for_cols2:
					movl indexcol,%ecx
					cmp %ecx,n
					je cont_for_lines2
					movl indexline,%eax
					mull cols
					addl indexcol,%eax
					movl (%ebx,%eax,4),%ecx
					movl %ecx, (%edi,%eax,4)
					addl $1,indexcol
					jmp for_cols2
				cont_for_lines2:
				addl $1,indexline
				jmp for_lines2
		
		cont_gen2:
		addl $1 ,gen
		jmp for_gen
	exit_gen:
		movl m,%eax
		incl %eax
		mull cols
		movl %eax,len_matrice
		xorl %edx,%edx
		movl len,%eax
		movl $8,%ecx
		mull %ecx
		divl len_matrice
		movl %eax,catt
		movl %edx,rest
		movl $0,%ecx
		lea vector_cheie,%edx
		movl $0,index
		for_cat:
			cmp catt,%ecx
			je exit_cat
			movl $0,%eax
			for_cat_vector:
				cmp len_matrice,%eax
				je exit_cat_matrice
				xorl %ebx,%ebx
				movb (%edi,%eax,4),%bl
				pushl %eax
				movl index,%eax
				movb %bl,(%edx,%eax,1)
				popl %eax
				incl %eax
				incl index
				jmp for_cat_vector
			exit_cat_matrice:
			incl %ecx
			jmp for_cat
		exit_cat:
		movl $0,%ecx
		for_rest:
			cmp rest,%ecx
			je exit_rest
			xorl %ebx,%ebx
			movb (%edi,%ecx,4),%bl
			movl index,%eax
			movb %bl,(%edx,%eax,1)
			incl index
			incl %ecx
			jmp for_rest
		exit_rest:
		lea cheie,%edi
		movl $0,%ecx
		for_cheie:
			cmp len,%ecx
			je exit_cheie
			xorl %eax,%eax
			addb (%edx,%ecx,8),%al
			shl $1,%eax
			addb 1(%edx,%ecx,8),%al
			shl $1,%eax
			addb 2(%edx,%ecx,8),%al
			shl $1,%eax
			addb 3(%edx,%ecx,8),%al
			shl $1,%eax
			addb 4(%edx,%ecx,8),%al
			shl $1,%eax
			addb 5(%edx,%ecx,8),%al
			shl $1,%eax
			addb 6(%edx,%ecx,8),%al
			shl $1,%eax
			addb 7(%edx,%ecx,8),%al
			movb %al,(%edi,%ecx,1)
			pushl %edx
			lea mesaj,%edx
			xorb %al, (%edx,%ecx,1)
			popl %edx
			incl %ecx
			jmp for_cheie
		exit_cheie:
	
	;//afisare
	movl decriptare,%ebx
	cmp $1,%ebx
	je afisare_string
		lea mesaj,%edi
		lea mesajHexa,%edx
		movl $0 ,index
		for_htos:
			movl index,%ecx
			cmp len,%ecx
			je exit_htos
			xorl %eax,%eax
			movb (%edi,%ecx,1),%al
			shr $4,%eax
			cmp $9,%eax
			jle plus48_1
			addb $7,%al
			plus48_1:
			addb $48,%al
			movb %al,(%edx,%ecx,2)
			xorl %eax,%eax
			movb (%edi,%ecx,1),%al
			shl $4,%eax
			movb $0,%ah
			shr $4,%eax
			cmp $9,%eax
			jle plus48_2
			addb $7,%al
			plus48_2:
			addb $48,%al
			movb %al,1(%edx,%ecx,2)
			incl index
			jmp for_htos
		exit_htos:
		push $mesajHexa
		push $formatPrintHexa
		call printf
		pop %ebx
		pop %ebx
		push $0
		call fflush
		pop %eax
		jmp et_exit
	afisare_string:
		push $mesaj
		push $formatPrintString
		call printf
		pop %ebx
		pop %ebx
		push $0
		call fflush
		pop %eax
	

et_exit:
    movl $1,%eax
    xorl %ebx,%ebx
    int $0x80
	