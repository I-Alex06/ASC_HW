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
			movl indexline,%eax
			mull cols
			addl indexcol,%eax
			movl (%edi,%eax,4),%ebx
			pushl %ebx
			push $formatPrint
			call printf
			pop %ebx
			pop %ebx
			pushl $0
			call fflush
			pop %ebx
			addl $1,indexcol
			jmp afis_col
		cont_afis_linii:
		movl $4, %eax
		movl $1, %ebx
		mov $NewLine, %ecx
		movl $2, %edx
		int $0x80
		addl $1,indexline
		jmp afis_linii

et_exit:
    movl $1,%eax
    xorl %ebx,%ebx
    int $0x80
	