	.text
	.file	"sample.c"
	.globl	testfunc                        # -- Begin function testfunc
	.p2align	4, 0x90
	.type	testfunc,@function
testfunc:                               # @testfunc
	.cfi_startproc
# %bb.0:
	movl	$1, %eax
	retq
.Lfunc_end0:
	.size	testfunc, .Lfunc_end0-testfunc
	.cfi_endproc
                                        # -- End function
	.globl	main                            # -- Begin function main
	.p2align	4, 0x90
	.type	main,@function
main:                                   # @main
	.cfi_startproc
# %bb.0:
	pushq	%rax
	.cfi_def_cfa_offset 16
	leaq	.L.str(%rip), %rdi
	movl	$1, %esi
	xorl	%eax, %eax
	callq	printf@PLT
	xorl	%eax, %eax
	popq	%rcx
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end1:
	.size	main, .Lfunc_end1-main
	.cfi_endproc
                                        # -- End function
	.type	.L.str,@object                  # @.str
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str:
	.asciz	"%d\n"
	.size	.L.str, 4

	.ident	"Debian clang version 14.0.6-2"
	.section	".note.GNU-stack","",@progbits
	.addrsig
