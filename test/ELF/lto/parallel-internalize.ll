; REQUIRES: x86
; RUN: llvm-as -o %t.bc %s
; RUN: ld.lld -m elf_x86_64 --lto-jobs=2 -save-temps -o %t %t.bc -e foo --lto-O0
; RUN: llvm-readobj -t -dyn-symbols %t | FileCheck %s
; RUN: llvm-nm %t0.lto.o | FileCheck --check-prefix=CHECK0 %s
; RUN: llvm-nm %t1.lto.o | FileCheck --check-prefix=CHECK1 %s

; CHECK:      Symbols [
; CHECK-NEXT:   Symbol {
; CHECK-NEXT:     Name:  (0)
; CHECK-NEXT:     Value: 0x0
; CHECK-NEXT:     Size: 0
; CHECK-NEXT:     Binding: Local (0x0)
; CHECK-NEXT:     Type: None (0x0)
; CHECK-NEXT:     Other: 0
; CHECK-NEXT:     Section: Undefined (0x0)
; CHECK-NEXT:   }
; CHECK-NEXT:   Symbol {
; CHECK-NEXT:     Name: bar (5)
; CHECK-NEXT:     Value: 0x11010
; CHECK-NEXT:     Size: 8
; CHECK-NEXT:     Binding: Local (0x0)
; CHECK-NEXT:     Type: Function (0x2)
; CHECK-NEXT:     Other [ (0x2)
; CHECK-NEXT:       STV_HIDDEN (0x2)
; CHECK-NEXT:     ]
; CHECK-NEXT:     Section: .text (0x2)
; CHECK-NEXT:   }
; CHECK-NEXT:   Symbol {
; CHECK-NEXT:     Name: foo (1)
; CHECK-NEXT:     Value: 0x11000
; CHECK-NEXT:     Size: 8
; CHECK-NEXT:     Binding: Global (0x1)
; CHECK-NEXT:     Type: Function (0x2)
; CHECK-NEXT:     Other: 0
; CHECK-NEXT:     Section: .text (0x2)
; CHECK-NEXT:   }
; CHECK-NEXT: ]
; CHECK-NEXT: DynamicSymbols [
; CHECK-NEXT: ]

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; CHECK0: U bar
; CHECK0: T foo
define void @foo() {
  call void @bar()
  ret void
}

; CHECK1: T bar
; CHECK1: U foo
define void @bar() {
  call void @foo()
  ret void
}
