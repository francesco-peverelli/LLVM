; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s -check-prefix=X64
; X64:     rep
; X64-NOT:     rep
; X64:     movsq
; X64-NOT:     movsq
; X64:     rep
; X64-NOT:     rep
; X64:     movsq
; X64-NOT:     rep
; X64-NOT:     movsq

; RUN: llc < %s -mtriple=x86_64-win32 | FileCheck %s -check-prefix=W64
; W64: {{^g:}}
; W64:      subq    $184, %rsp
; W64:      movq    %rsi, 176(%rsp)
; W64:      movq    %rcx, 32(%rsp)
; W64-NEXT: movq    %rdx, 40(%rsp)
; W64-NEXT: movq    %r8, 48(%rsp)
; W64-NEXT: leaq    32(%rsp), %rsi
; W64-NEXT: movq    %rsi, %rcx
; W64-NEXT: callq   f
; W64-NEXT: movq    %rsi, %rcx
; W64-NEXT: callq   f
; W64-NEXT: movq    176(%rsp), %rsi
; W64-NEXT: addq    $184, %rsp
; W64-NEXT: ret

; RUN: llc < %s -march=x86 | FileCheck %s -check-prefix=X32
; X32:     rep
; X32-NOT:     rep
; X32:     movsl
; X32-NOT:     movsl
; X32:     rep
; X32-NOT:     rep
; X32:     movsl
; X32-NOT:     rep
; X32-NOT:     movsl

%struct.s = type { i64, i64, i64, i64, i64, i64, i64, i64,
                   i64, i64, i64, i64, i64, i64, i64, i64,
                   i64 }

define void @g(i64 %a, i64 %b, i64 %c) {
entry:
	%d = alloca %struct.s, align 16
	%tmp = getelementptr %struct.s* %d, i32 0, i32 0
	store i64 %a, i64* %tmp, align 16
	%tmp2 = getelementptr %struct.s* %d, i32 0, i32 1
	store i64 %b, i64* %tmp2, align 16
	%tmp4 = getelementptr %struct.s* %d, i32 0, i32 2
	store i64 %c, i64* %tmp4, align 16
	call void @f( %struct.s* %d byval)
	call void @f( %struct.s* %d byval)
	ret void
}

declare void @f(%struct.s* byval)
