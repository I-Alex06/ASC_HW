.data
m: .space 4
n: .space 4
cols: .space 4
p: .space 4
indexline: .space 4
indexcol: .space 4
k: .space 4
gen: .long 0
matriceOld: .space 1600
matriceNew: .space 1600
formatScan: .asciz "%ld"
formatPrint: .asciz "%ld "
formatNL: .asciz "%s"
NewLine: .asciz "\n"
readf: .asciz "r"
readfloc: .asciz "in.txt"
writef: .asciz "w"
writefloc: .asciz "out.txt"
.text
.global main
main:
	lea matriceOld,%edi
    ;//citire date
	push $readf
	push $readfloc
	call fopen
	b1:
	pop %ebx
	pop %ebx
    pushl $m
    push $formatScan
	push %eax
    call fscanf
	b2:
	pop %eax
    pop %ebx
    pop %ebx
	movl m,%ebx
	add $1,%ebx
	movl %ebx,m
    pushl $n
    push $formatScan
	push %eax
    call fscanf
	pop %eax
    pop %ebx
    pop %ebx
	movl n,%ebx
	inc %ebx
	movl %ebx,n
	inc %ebx
	movl %ebx, cols
    pushl $p
    push $formatScan
	push %eax
    call fscanf
	pop %eax
    pop %ebx
    pop %ebx
	;//citire celule vii
	movl $0,%ecx
	CitireCeluleVii:
		cmp %ecx , p
		je ContCitire
		pushl %ecx
		pushl $indexline
		push $formatScan
		push %eax
		call fscanf
		pop %eax
		pop %ebx
		pop %ebx
		pushl $indexcol
		push $formatScan
		push %eax
		call fscanf
		pop %eax
		pop %ebx
		pop %ebx
		push %eax
		movl indexline,%eax
		inc %eax
		movl cols,%ebx
		mul %ebx
		add indexcol,%eax
		inc %eax
		movl $1,(%edi , %eax,4)
		pop %eax
		pop %ecx
		inc %ecx
		jmp CitireCeluleVii
	ContCitire:
    pushl $k
    push $formatScan
	push %eax
    call fscanf
	pop %eax
    pop %ebx
    pop %ebx
	push %eax
	call fclose
	pop %eax
	;//generare matrice noua
	for_gen:
		movl gen,%ecx
		cmp %ecx,k
		je afisare
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
	
	
	
	;//afisare
	afisare:
	push $writef
	push $writefloc
	call fopen
	pop %ebx
	pop %ebx
	movl $1,indexline
	afis_linii:
		movl indexline,%ecx
		cmp %ecx,m
		je et_exit
		movl $1,indexcol
		afis_col:
			movl indexcol,%ecx
			cmp %ecx,n
			je cont_afis_linii
			push %eax
			movl indexline,%eax
			mull cols
			addl indexcol,%eax
			movl (%edi,%eax,4),%ebx
			pop %eax
			pushl %ebx
			push $formatPrint
			push %eax
			call fprintf
			pop %eax
			pop %ebx
			pop %ebx
			push %eax
			call fflush
			pop %eax
			addl $1,indexcol
			jmp afis_col
		cont_afis_linii:
		push $NewLine
		push $formatNL
		push %eax
		call fprintf
		pop %eax
		pop %ebx
		pop %ebx
		push %eax
		call fflush
		pop %eax
		addl $1,indexline
		jmp afis_linii

et_exit:
	push %eax
	call fclose
	pop %eax
    movl $1,%eax
    xorl %ebx,%ebx
    int $0x80
	