.MODEL small
.STACK 100h
.DATA
  DuomenuFailas db 20, 0, 20 dup(0)
  RezultatuFailas db 20, 0, 20 dup(0)
  DuomenuHandle dw 0
  RezultatuHandle dw 0
  Duomenys db 255, 0, 255 dup (0)
  DisasemblintaEilute db 255, 0, 255 dup (24h)
  KlasiuBufferis db 4 dup(13), 2 dup (14), 7, 10, 6 dup (0), 7, 10, 6 dup (0), 7, 10, 6 dup (0), 7, 10, 4 dup (56), 2 dup(0), 51, 0, 4 dup (18), 2 dup (19)
  db 52, 7 dup (0), 53, 0, 4 dup(23), 2 dup(24), 54, 0, 8 dup (16), 8 dup (21), 8 dup (8), 8 dup (11), 16 dup (0), 41, 42, 43, 44, 45, 46, 47, 48, 49, 50
  db 40, 39, 31, 30, 27, 25, 4 dup (15), 4 dup (0), 4 dup (1), 2, 0, 2, 12, 10 dup (0), 28, 5 dup(0), 2 dup (3), 2 dup (4), 8 dup(0), 16 dup(5)
  db 6 dup(0), 32, 33, 2 dup (0), 2 dup (6), 2 dup (0), 34, 35, 0, 9, 20 dup(0), 20, 55, 4 dup(0), 29, 36, 37, 38, 10 dup(0), 2 dup(26), 6 dup (0), 17, 22
  ProceduruPavadinimai dw IDK, MOV1, MOV2, MOV3, MOV4, MOV5, MOV6, PUSH1, PUSH2, INT1, POP1, POP2, POP3, ADD1, ADD2, ASC, INC1, ID, SUB1, SUB2, LOOP1
  dw DEC1, IDCJ, CMP1, CMP2, JG1, MD, JLE1, CALL1, CALL2, JGE1, JL1, RET1, RET2, RETF1, RETF2, JMP1, JMP2, JMP3, JNP1, JP1, JO1, JNO1, JNAE1
  dw JAE1, JE1, JNE1, JBE1, JA1, JS1, JNS1, PRE1, PRE2, PRE3, PRE4, JCXZ1, AND1
  Adresas db 4 dup(0), ":", 4 dup(" ")
  KomandosPradzia dw 0
  KomandosPabaiga dw 0
  KomandosEsamasAdresas dw 0
  dBit db 10
  wBit db 10
  modBit db 10
  regBit db 10
  srBit db 10
  rmBit db 10
  Poslinkis dw 0
  BusPtr db 0
  BusBetarpiskasOperandas db 0
  VienoBaitoAdresas db 0
  Coma db ", "
  DoublePoint db ":"
  EoL db 0Ah
  BaitoPoslinkis db 2 dup (0), "h"
  DviejuBaituPoslinkis db 4 dup (0), "h"
  TiesioginisAdresas db "[", 4 dup (0), "h", "]"
  NuskaitytiBaitai db 20 dup (0)
  TotalBytesRead dw 0
  Byteptr db "byte ptr "
  Wordptr db "word ptr "
  FarPtr db "far "
	HelpMessage db "Enter the data and the results file names$"
  FileNameErrorMessage db "Invalid data file name$"
  ErrorMakingFileMessage db "Error making file$"
  ErrorReadingFileMessage db "Error reading data file$"
  ErrorWritingMessage db "Error writting results$"
  NeatpazintasBaitas db 2 dup(0), 18 dup(20h), "UNKNOWN", 0Ah
  Unknownword db " UNKNOWN"
  KomanduPav dw 0
  db "MOV   ", "PUSH  ", "POP   ", "ADD   ", "INC   ", "SUB   ", "DEC   ", "CMP   ", "MUL   ", "DIV   ", "CALL  ", "RET   ", "JMP   ", "JO    ", "JNO   ", "JNAE  "
  db "JAE   ", "JE    ", "JNE   ", "JBE   ", "JA    ", "JS    ", "JNS   ", "JP    ", "JNP   ", "JL    ", "JGE   ", "JLE   ", "JG    ", "JCXZ  ", "LOOP  ", "INT   ", "RETF  ", "AND   "
  KokieRegistrai dw 0
  KokieRegistraiMOD11 dw 0
  KoksPrefiksas dw 0
  PapildomiBaitai dw 0
  RegistraiBaitai dw 0
  db "al", "cl", "dl", "bl", "ah", "ch", "dh", "bh"
  Registrai2Baitai dw 0
  db "ax", "cx", "dx", "bx", "sp", "bp", "si", "di"
  AddRegistrai dw 0
  db "[bx + si]", "[bx + di]", "[bp + si]", "[bp + di]", "[si]", "[di]", "[bx]"
  AddRegistraiSuPoslinkiu dw 0
  db "[bx + si] + ", "[bx + di] + ", "[bp + si] + ", "[bp + di] + ", "[si] + ", "[di] + ", "[bp] + ", "[bx] + "
  Prefiksai dw 0
  db "es:", "cs:", "ss:", "ds:"
  Segmentai dw 0
  db "es", "cs", "ss", "ds"
.CODE
  Start:
  mov ax, @DATA
  mov ds, ax

  cmp byte ptr [es:80h], 0
  je Help
  cmp [es:82h], '?/'
  jne ExtraSegmentoSkaitymas
  cmp byte ptr [es:84h], 0Dh
  je Help

  Help:
  mov ah, 09h
  mov dx, offset HelpMessage
  int 21h
  jmp ToEnd

  FileNameError:
  mov ah, 09h
  mov dx, offset FileNameErrorMessage
  int 21h
  jmp ToEnd

  ErrorMakingFile:
  mov ah, 09h
  mov dx, offset ErrorMakingFileMessage
  int 21h
  jmp ToEnd

  ErrorReadingFile:
  mov ah, 09h
  mov dx, offset ErrorReadingFileMessage
  int 21h
  jmp ToEnd

  ExtraSegmentoSkaitymas:
  mov bx, 82h
  mov si, offset DuomenuFailas

  DuomenuFailoPavadinimas:
  cmp byte ptr [es:bx], 20h
  je DuomenuFailoPavadinimoSkaitymoPabaiga
  mov dl, byte ptr [es:bx]
  mov [si], dl
  inc bx
  inc si
  jmp DuomenuFailoPavadinimas

  DuomenuFailoPavadinimoSkaitymoPabaiga:
  mov si, offset RezultatuFailas
	inc bx

  RezultatuFailoPavadinimas:
  cmp byte ptr [es:bx], 0Dh
  je RezultatuFailoPavadinimoSkaitymoPabaiga
  mov dl, byte ptr [es:bx]
  mov [si], dl
  inc bx
  inc si
  jmp RezultatuFailoPavadinimas

  RezultatuFailoPavadinimoSkaitymoPabaiga:
  mov ax, 3D00h
  mov dx, offset DuomenuFailas
  int 21h
  jc FileNameError

  mov [DuomenuHandle], ax

  mov ah, 3Ch
	mov cx, 00h
	mov dx, offset RezultatuFailas
	int 21h
	jc ErrorMakingFile

  mov ax, 3D01h
  mov dx, offset RezultatuFailas
  int 21h
  jc ErrorMakingFile

  mov [RezultatuHandle], ax

  mov ah, 3Fh
  mov cx, 255
  mov bx, [DuomenuHandle]
  mov dx,	offset Duomenys
  int 21h
  jc ErrorReadingFile
  mov TotalBytesRead, ax

  PradedamDisassembly:
  cmp KoksPrefiksas, 0
  jne TikrinamKlase
  mov si, KomandosPabaiga
  mov ax, TotalBytesRead
  cmp si, ax
  jae ToEnd
  mov KomandosPradzia, si
  mov ax, KomandosPradzia
  mov al, ah
  xor ah, ah
  mov si, offset Adresas
  call PutByte
  mov ax, KomandosPradzia
  xor ah, ah
  call PutByte

  mov ah, 40h
  mov cx, 7
  mov bx, [RezultatuHandle]
  mov dx, offset Adresas
  int 21h

  TikrinamKlase:
  xor ax, ax
  xor bx, bx
  call getNextByte
  mov bl, cl
  mov al, [KlasiuBufferis + bx]

  mov cl, bl
  mov bl, al
  shl bl, 1
  call [ProceduruPavadinimai + bx]

  jmp PradedamDisassembly

  ErrorWritingResults:
  mov ah, 09h
  mov dx, offset ErrorWritingMessage
  int 21h

  ToEnd:
  mov ah, 4Ch
  int 21h

  PROC IDK
  mov al, cl
  mov si, offset NeatpazintasBaitas
  call PutByte
  mov ah, 40h
  mov cx, 28
  mov bx, [RezultatuHandle]
  mov dx, offset NeatpazintasBaitas
  int 21h
  inc KomandosPabaiga
  ret
  endp

  PROC MOV1
  call getdwmodregrm
  call printReadBytes
  mov dx, 1
  call PrintCommand
  call PrintCommandAtributes
  ret
  endp

  PROC MOV2
  call getdwmodregrm
  mov wBit, 1b
  mov srBit, 1
  call printReadBytes
  mov dx, 1
  call PrintCommand
  call PrintCommandAtributes
  ret
  endp

  PROC MOV3
  call getwBit
  mov modBit, 01b
  call printReadBytes
  mov dx, 1
  mov regBit, 000b
  mov modBit, 00b
  mov rmBit, 110b
  mov dBit, 1b
  call PrintCommand
  call PrintCommandAtributes
  ret
  endp

  PROC MOV4
  call getwBit
  mov modBit, 01b
  call printReadBytes
  mov dx, 1
  mov regBit, 000b
  mov modBit, 00b
  mov rmBit, 110b
  mov dBit, 0b
  call PrintCommand
  call PrintCommandAtributes
  ret
  endp

  PROC MOV5
  call getSpecialwBit
  call getSpecialREGbit
  cmp wBit, 1b
  je MOV5a
  mov modBit, 11b
  call printReadBytes
  mov dx, 1
  call PrintCommand
  mov bx, offset RegistraiBaitai
  call KoksRegistras
  call PutComa
  call printBaitoPoslinks
  jmp MOV5end
  MOV5a:
  mov modBit, 01b
  call printReadBytes
  mov dx, 1
  call PrintCommand
  mov bx, offset Registrai2Baitai
  call KoksRegistras
  call PutComa
  call printDviejuBaitPoslinks
  MOV5end:
  call putEoL
  ret
  endp

  PROC MOV6
  call getdwmodregrm
  cmp wBit, 1b
  je BusWordPtr
  add PapildomiBaitai, 1
  call printReadBytes
  mov dx, 1
  call PrintCommand
  call putByteptr
  call cmpMod
  cmp modBit, 11b
  jne MOV6endbp
  mov bx, RegistraiBaitai
  call KoksRegistrasmod11
  jmp MOV6endbp
  BusWordPtr:
  add PapildomiBaitai, 2
  call printReadBytes
  mov dx, 1
  call PrintCommand
  call putWordptr
  call cmpMod
  mov bx, Registrai2Baitai
  call KoksRegistrasmod11
  jmp MOV6endwp
  MOV6endbp:
  call PutComa
  call printBaitoPoslinks
  call putEoL
  jmp MOV6end
  MOV6endwp:
  call PutComa
  call printDviejuBaitPoslinks
  call putEoL
  MOV6end:
  ret
  endp

  PROC PUSH1
  call getREGbit
  mov VienoBaitoAdresas, 1
  call printReadBytes
  mov dx, 7
  call PrintCommand
  mov bx, offset Segmentai
  call KoksRegistras
  call putEoL
  ret
  endp

  PROC PUSH2
  call getSpecialREGbit
  mov al, regBit
  mov rmBit, al
  mov VienoBaitoAdresas, 1
  call printReadBytes
  mov dx, 7
  call PrintCommand
  mov bx, offset Registrai2Baitai
  call KoksRegistrasmod11
  call putEoL
  ret
  endp

  PROC INT1
  mov modBit, 11b
  call printReadBytes
  mov dx, 187
  call PrintCommand
  call printBaitoPoslinks
  call putEoL
  ret
  endp

  PROC POP1
  call getREGbit
  mov VienoBaitoAdresas, 1
  call printReadBytes
  mov dx, 13
  call PrintCommand
  mov bx, offset Segmentai
  call KoksRegistras
  call putEoL
  ret
  endp

  PROC POP2
  call getSpecialREGbit
  mov al, regBit
  mov rmBit, al
  mov VienoBaitoAdresas, 1
  call printReadBytes
  mov dx, 13
  call PrintCommand
  mov bx, offset Registrai2Baitai
  call KoksRegistrasmod11
  call putEoL
  ret
  endp

  PROC POP3
  call getdwmodregrm
  call printReadBytes
  mov dx, 13
  call PrintCommand
  call cmpMod
  cmp modBit, 11b
  jne POP3end
  mov bx, offset Registrai2Baitai
  call KoksRegistrasmod11
  POP3end:
  call putEoL
  ret
  endp

  PROC ADD1
  call getdwmodregrm
  call printReadBytes
  mov dx, 19
  call PrintCommand
  call PrintCommandAtributes
  ret
  endp

  PROC ADD2
  call getwBit
  mov rmBit, 000b
  cmp wBit, 1b
  je ADD2w1
  mov modBit, 11b
  call printReadBytes
  mov dx, 19
  call PrintCommand
  mov bx, offset RegistraiBaitai
  call KoksRegistrasmod11
  call PutComa
  call printBaitoPoslinks
  jmp ADD2end
  ADD2w1:
  mov modBit, 10b
  call printReadBytes
  mov dx, 19
  call PrintCommand
  mov bx, offset Registrai2Baitai
  call KoksRegistrasmod11
  call PutComa
  call printDviejuBaitPoslinks
  ADD2end:
  call putEoL
  ret
  endp

  PROC ASC
  call getdwmodregrm
  cmp dBit, 1b
  je sBit1
  cmp wBit, 1b
  je wbit1
  add PapildomiBaitai, 1
  call printReadBytes
  jmp ASCcmp
  wbit1:
  add PapildomiBaitai, 2
  call printReadBytes
  jmp ASCcmp
  sBit1:
  add PapildomiBaitai, 1
  call printReadBytes
  ASCcmp:
  cmp regBit, 000b
  je busADD
  cmp regbit, 101b
  je busSUB
  cmp regBit, 111b
  je busCMP
  mov ah, 40h
  mov cx, 8
  mov bx, [RezultatuHandle]
  mov dx, offset Unknownword
  int 21h
  call putEoL
  jmp ASCend
  busADD:
  mov dx, 19
  jmp patikomanda
  busSUB:
  mov dx, 31
  jmp patikomanda
  busCMP:
  mov dx, 43
  patikomanda:
  call PrintCommand
  cmp modBit, 11b
  je nebusbyteptr
  cmp wBit, 1b
  je busbyteptrw1
  call putBytePtr
  call cmpMod
  jmp regzinomas
  busbyteptrw1:
  call putWordPtr
  call cmpMod
  jmp regzinomas
  nebusbyteptr:
  cmp wBit, 1b
  je nebusbyteptrw1
  mov bx, offset RegistraiBaitai
  call KoksRegistrasmod11
  jmp regzinomas
  nebusbyteptrw1:
  mov bx, offset Registrai2Baitai
  call KoksRegistrasmod11
  regzinomas:
  call PutComa
  call OperandasSuSbit
  call putEoL
  ASCend:
  ret
  endp

  PROC INC1
  call getSpecialREGbit
  mov al, regBit
  mov rmBit, al
  mov VienoBaitoAdresas, 1
  call printReadBytes
  mov dx, 25
  call PrintCommand
  mov bx, offset Registrai2Baitai
  call KoksRegistrasmod11
  call putEoL
  ret
  endp

  PROC ID
  call getdwmodregrm
  call printReadBytes
  cmp regBit, 000b
  je busINC
  mov dx, 37
  jmp patsID
  busINC:
  mov dx, 25
  patsID:
  call PrintCommand
  call putBytePtr
  call cmpMod
  cmp modBit, 11b
  jne IDend
  mov bx, offset RegistraiBaitai
  call KoksRegistrasmod11
  IDend:
  call putEoL
  ret
  endp

  PROC SUB1
  call getdwmodregrm
  call printReadBytes
  mov dx, 31
  call PrintCommand
  call PrintCommandAtributes
  ret
  endp

  PROC SUB2
  call getwBit
  mov rmBit, 000b
  cmp wBit, 1
  je SUB2w1
  mov modBit, 11b
  mov bx, offset RegistraiBaitai
  push bx
  jmp patsSUB2
  SUB2w1:
  mov modbit, 01b
  mov bx, offset Registrai2Baitai
  push bx
  patsSUB2:
  call printReadBytes
  mov dx, 31
  call PrintCommand
  pop bx
  call KoksRegistrasmod11
  call PutComa
  cmp wBit, 1
  je SUB2w1vel
  call printBaitoPoslinks
  jmp SUB2end
  SUB2w1vel:
  call printDviejuBaitPoslinks
  SUB2end:
  call putEoL
  ret
  endp

  PROC LOOP1
  mov modBit, 11b
  call printReadBytes
  mov dx, 181
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC DEC1
  call getSpecialREGbit
  mov al, regBit
  mov rmBit, al
  mov VienoBaitoAdresas, 1
  call printReadBytes
  mov dx, 37
  call PrintCommand
  mov bx, offset Registrai2Baitai
  call KoksRegistrasmod11
  call putEoL
  ret
  endp

  PROC IDCJ
  call getdwmodregrm
  call printReadBytes
  cmp regBit, 000b
  je IDCJinc
  cmp regBit, 001b
  je IDCJdec
  cmp regBit, 010b
  je IDCJcall
  cmp regBit, 011b
  je IDCJcall
  cmp regBit, 100b
  je IDCJjmp
  cmp regBit, 101b
  je IDCJjmp
  mov dx, 7
  jmp patsIDCJ
  IDCJinc:
  mov dx, 25
  jmp patsIDCJ
  IDCJdec:
  mov dx, 37
  jmp patsIDCJ
  IDCJcall:
  mov dx, 61
  jmp patsIDCJ
  IDCJjmp:
  mov dx, 73
  patsIDCJ:
  call PrintCommand
  cmp regBit, 011b
  je busfar
  cmp regbit, 101b
  je busfar
  cmp regBit, 000b
  je busptrr
  cmp regBit, 001b
  je busptrr
  jmp IDCJarg
  busfar:
  call printfar
  jmp IDCJarg
  busptrr:
  cmp wBit, 1
  je IDCJwordptr
  call putBytePtr
  jmp IDCJarg
  IDCJwordptr:
  call putWordPtr
  IDCJarg:
  call cmpMod
  cmp modBit, 11b
  jne IDCJend
  mov bx, offset Registrai2Baitai
  call KoksRegistrasmod11
  IDCJend:
  call putEoL
  ret
  endp

  PROC CMP1
  call getdwmodregrm
  call printReadBytes
  mov dx, 43
  call PrintCommand
  call PrintCommandAtributes
  ret
  endp

  PROC CMP2
  call getwBit
  mov rmBit, 000b
  cmp wBit, 1b
  je CMP2w1
  mov modBit, 11b
  call printReadBytes
  mov dx, 43
  call PrintCommand
  mov bx, offset RegistraiBaitai
  call KoksRegistrasmod11
  call PutComa
  call printBaitoPoslinks
  jmp CMP2end
  CMP2w1:
  mov modBit, 10b
  call printReadBytes
  mov dx, 43
  call PrintCommand
  mov bx, offset Registrai2Baitai
  call KoksRegistrasmod11
  call PutComa
  call printDviejuBaitPoslinks
  CMP2end:
  call putEoL
  ret
  endp

  PROC JG1
  mov modBit, 11b
  call printReadBytes
  mov dx, 169
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC MD
  call getdwmodregrm
  call printReadBytes
  cmp regBit, 100b
  je MDmul
  cmp regBit, 110b
  je MDdiv
  mov ah, 40h
  mov cx, 8
  mov bx, [RezultatuHandle]
  mov dx, offset Unknownword
  int 21h
  jmp MDend
  MDmul:
  mov dx, 49
  jmp patsMD
  MDdiv:
  mov dx, 55
  patsMD:
  call PrintCommand
  cmp wBit, 1b
  je patsMDw1
  cmp modBit, 11b
  je patsMDw0mod11
  call putBytePtr
  call cmpMod
  jmp MDend
  patsMDw0mod11:
  mov bx, offset RegistraiBaitai
  call KoksRegistrasmod11
  jmp MDend
  patsMDw1:
  cmp modBit, 11b
  je patsMDw1mod11
  call putWordPtr
  call cmpMod
  jmp MDend
  patsMDw1mod11:
  mov bx, offset Registrai2Baitai
  call KoksRegistrasmod11
  MDend:
  call putEoL
  ret
  endp

  PROC JLE1
  mov modBit, 11b
  call printReadBytes
  mov dx, 163
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC CALL1
  mov modBit, 10b
  add PapildomiBaitai, 1
  call printReadBytes
  mov dx, 61
  call PrintCommand
  call getNextByte
  call getNextByte
  cmp KoksPrefiksas, 0
  je CALL1nerpf
  call PrintPrefiks
  CALL1nerpf:
  call printDviejuBaitPoslinks
  call putdoublepoint
  sub KomandosEsamasAdresas, 4
  call printDviejuBaitPoslinks
  add KomandosEsamasAdresas, 2
  call putEoL
  ret
  endp

  PROC CALL2
  mov modBit, 01b
  call printReadBytes
  mov dx, 61
  call PrintCommand
  call printposlinkis2b
  call putEoL
  ret
  endp

  PROC JGE1
  mov modBit, 11b
  call printReadBytes
  mov dx, 157
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JL1
  mov modBit, 11b
  call printReadBytes
  mov dx, 151
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC RET1
  mov modBit, 01b
  call printReadBytes
  mov dx, 67
  call PrintCommand
  cmp KoksPrefiksas, 0
  je RET1nerpf
  call PrintPrefiks
  RET1nerpf:
  call printDviejuBaitPoslinks
  call putEoL
  ret
  endp

  PROC RET2
  mov VienoBaitoAdresas, 1
  call printReadBytes
  mov dx, 67
  call PrintCommand
  call putEoL
  ret
  endp

  PROC RETF1
  mov modBit, 01b
  call printReadBytes
  mov dx, 193
  call PrintCommand
  cmp KoksPrefiksas, 0
  je RET1nerpfa
  call PrintPrefiks
  RET1nerpfa:
  call printDviejuBaitPoslinks
  call putEoL
  ret
  endp

  PROC RETF2
  mov VienoBaitoAdresas, 1
  call printReadBytes
  mov dx, 193
  call PrintCommand
  call putEoL
  ret
  endp

  PROC JMP1
  mov modBit, 01b
  call printReadBytes
  mov dx, 73
  call PrintCommand
  call printposlinkis2b
  call putEoL
  ret
  endp

  PROC JMP2
  mov modBit, 10b
  add PapildomiBaitai, 1
  call printReadBytes
  mov dx, 73
  call PrintCommand
  call getNextByte
  call getNextByte
  cmp KoksPrefiksas, 0
  je CALL1nerpfa
  call PrintPrefiks
  CALL1nerpfa:
  call printDviejuBaitPoslinks
  call putdoublepoint
  sub KomandosEsamasAdresas, 4
  call printDviejuBaitPoslinks
  add KomandosEsamasAdresas, 2
  call putEoL
  ret
  endp

  PROC JMP3
  mov modBit, 11b
  call printReadBytes
  mov dx, 73
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JNP1
  mov modBit, 11b
  call printReadBytes
  mov dx, 145
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JP1
  mov modBit, 11b
  call printReadBytes
  mov dx, 139
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JO1
  mov modBit, 11b
  call printReadBytes
  mov dx, 79
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JNO1
  mov modBit, 11b
  call printReadBytes
  mov dx, 85
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JNAE1
  mov modBit, 11b
  call printReadBytes
  mov dx, 91
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JAE1
  mov modBit, 11b
  call printReadBytes
  mov dx, 97
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JE1
  mov modBit, 11b
  call printReadBytes
  mov dx, 103
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JNE1
  mov modBit, 11b
  call printReadBytes
  mov dx, 109
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JBE1
  mov modBit, 11b
  call printReadBytes
  mov dx, 115
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JA1
  mov modBit, 11b
  call printReadBytes
  mov dx, 121
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JS1
  mov modBit, 11b
  call printReadBytes
  mov dx, 127
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC JNS1
  mov modBit, 11b
  call printReadBytes
  mov dx, 133
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC PRE1
  mov ax, 2
  add ax, offset Prefiksai
  mov KoksPrefiksas, ax
  add PapildomiBaitai, 1
  ret
  endp

  PROC PRE2
  mov ax, 5
  add ax, offset Prefiksai
  mov KoksPrefiksas, ax
  add PapildomiBaitai, 1
  ret
  endp

  PROC PRE3
  mov ax, 8
  add ax, offset Prefiksai
  mov KoksPrefiksas, ax
  add PapildomiBaitai, 1
  ret
  endp

  PROC PRE4
  mov ax, 11
  add ax, offset Prefiksai
  mov KoksPrefiksas, ax
  add PapildomiBaitai, 1
  ret
  endp

  PROC JCXZ1
  mov modBit, 11b
  call printReadBytes
  mov dx, 175
  call PrintCommand
  call printposlinkis
  call putEoL
  ret
  endp

  PROC AND1
  call getdwmodregrm
  call printReadBytes
  mov dx, 199
  call PrintCommand
  call PrintCommandAtributes
  ret
  endp

  PROC getCommandEnd
  mov ax, KomandosPradzia
  cmp VienoBaitoAdresas, 1
  je AdresasvienasBaitas
  cmp modBit, 00b
  je Komandosmod00
  cmp modBit, 01b
  je Komandosmod01
  cmp modBit, 10b
  je Komandosmod10
  add ax, 2
  jmp CommandEndEnd
  Komandosmod00:
  cmp rmBit, 110b
  je Komandosrm110
  add ax, 2
  jmp CommandEndEnd
  Komandosrm110:
  add ax, 4
  jmp CommandEndEnd
  Komandosmod01:
  add ax, 3
  jmp CommandEndEnd
  Komandosmod10:
  add ax, 4
  jmp CommandEndEnd
  AdresasvienasBaitas:
  add ax, 1
  CommandEndEnd:
  mov KomandosPabaiga, ax
  mov bx, PapildomiBaitai
  add KomandosPabaiga, bx
  ret
  endp

  PROC printReadBytes
  call getCommandEnd
  mov cx, KomandosPradzia
  mov bx, KomandosPabaiga
  mov si, offset NuskaitytiBaitai
  sub bx, cx
  xor dx, dx
  BituSpausdinimas:
  cmp dx, bx
  je SudedamTarpus
  push dx
  xor ah, ah
  push si
  mov si, cx
  mov al, [Duomenys + si]
  inc cx
  pop si
  call PutByte
  pop dx
  inc dx
  jmp BituSpausdinimas
  SudedamTarpus:
  mov cl, 20h
  cmp dx, 10
  je ReadBytesEnd
  mov [si], cl
  inc si
  mov [si], cl
  inc si
  inc dx
  jmp SudedamTarpus
  ReadBytesEnd:
  mov ah, 40h
  mov cx, 19
  mov bx, [RezultatuHandle]
  mov dx, offset NuskaitytiBaitai
  int 21h
  mov PapildomiBaitai, 0
  mov VienoBaitoAdresas, 0
  ret
  endp

  PROC PutByte
  mov dx, 10h
  div dl
  cmp al, 9
  ja Raide1
  add al, 30h
  mov [si], al
  inc si
  jmp Skaicius2
  Raide1:
  add al, 37h
  mov [si], al
  inc si
  Skaicius2:
  cmp ah, 9
  ja Raide2
  add ah, 30h
  mov [si], ah
  inc si
  jmp PutByteEnd
  Raide2:
  add ah, 37h
  mov [si], ah
  inc si
  PutByteEnd:
  ret
  endp

  PROC getNextByte
  mov si, KomandosEsamasAdresas
  mov cl, [Duomenys + si]
  inc KomandosEsamasAdresas
  ret
  endp

  PROC getwBit
  mov wBit, cl
  and wBit, 00000001b
  ret
  endp

  PROC getSpecialwBit
  mov wBit, cl
  push cx
  mov cl, 3
  and wBit, 00001000b
  shr wBit, cl
  pop cx
  ret
  endp

  PROC getdBit
  mov dBit, cl
  and dBit, 00000010b
  shr dBit, 1
  ret
  endp

  PROC getMOdBit
  mov modBit, cl
  push cx
  mov cl, 6
  and modBit, 11000000b
  shr modBit, cl
  pop cx
  ret
  endp

  PROC getREGbit
  mov regBit, cl
  push cx
  mov cl, 3
  and regBit, 00111000b
  shr regBit, cl
  pop cx
  ret
  endp

  PROC getSpecialREGbit
  mov regBit, cl
  and regBit, 00000111b
  ret
  endp

  PROC getRMbit
  mov rmBit, cl
  push cx
  and rmBit, 00000111b
  pop cx
  ret
  endp

  PROC getdwmodregrm
  call getwBit
  call getdBit
  call getNextByte
  call getMOdBit
  call getREGbit
  call getRMbit
  ret
  endp

  PROC PrintCommand
  mov ah, 40h
  mov cx, 6
  mov bx, [RezultatuHandle]
  add dx, offset KomanduPav
  int 21h
  ret
  endp

  PROC PrintCommandAtributes
  cmp srBit, 1
  je BusSegmentai
  cmp wBit, 0b
  je Baitai
  mov bx, offset Registrai2Baitai
  mov KokieRegistrai, bx
  mov KokieRegistraiMOD11, bx
  call DarbasSuBaitais
  jmp PrintCommandEnd
  Baitai:
  mov bx, offset RegistraiBaitai
  mov KokieRegistrai, bx
  mov KokieRegistraiMOD11, bx
  call DarbasSuBaitais
  jmp PrintCommandEnd
  BusSegmentai:
  mov bx, offset Segmentai
  mov KokieRegistrai, bx
  mov bx, offset Registrai2Baitai
  mov KokieRegistraiMOD11, bx
  call DarbasSuBaitais
  PrintCommandEnd:
  mov ah, 40h
  mov cx, 1
  mov bx, [RezultatuHandle]
  mov dx, offset EoL
  int 21h
  mov KoksPrefiksas, 0
  ret
  endp

  PROC DarbasSuBaitais
  cmp dBit, 0b
  je RegistrasAntras
  RegistrasPirmas:
  mov bx, KokieRegistrai
  call KoksRegistras
  call PutComa
  cmp modBit, 00b
  je RegPirmasNeraPoslinkio
  cmp modBit, 01b
  je RegPirmasPoslinkis1B
  cmp modBit, 10b
  je RegPirmasPoslinkis2B
  mov bx, KokieRegistraiMOD11
  call KoksRegistrasmod11
  jmp PrintEnd
  RegPirmasNeraPoslinkio:
  call mod00
  jmp PrintEnd
  RegPirmasPoslinkis1B:
  call mod01
  jmp PrintEnd
  RegPirmasPoslinkis2B:
  call mod10
  jmp PrintEnd
  RegistrasAntras:
  cmp modBit, 00b
  je RegAntrasNeraPoslinkio
  cmp modBit, 01b
  je RegAntrasPoslinkis1B
  cmp modBit, 10b
  je RegAntrasPoslinkis2B
  mov bx, KokieRegistraiMOD11
  call KoksRegistrasmod11
  call PutComa
  mov bx, KokieRegistrai
  call KoksRegistras
  jmp PrintEnd
  RegAntrasNeraPoslinkio:
  call mod00
  call PutComa
  mov bx, KokieRegistrai
  call KoksRegistras
  jmp PrintEnd
  RegAntrasPoslinkis1B:
  call mod01
  call PutComa
  mov bx, KokieRegistrai
  call KoksRegistras
  jmp PrintEnd
  RegAntrasPoslinkis2B:
  call mod10
  call PutComa
  mov bx, KokieRegistrai
  call KoksRegistras
  printEnd:
  ret
  endp

  PROC PutComa
  mov ah, 40h
  mov cx, 2
  mov bx, [RezultatuHandle]
  mov dx, offset Coma
  int 21h
  ret
  endp

  PROC KoksRegistrasmod11
  cmp rmBit, 000b
  je rmAl
  cmp rmBit, 001b
  je rmCl
  cmp rmBit, 010b
  je rmDl
  cmp rmBit, 011b
  je rmBl
  cmp rmBit, 100b
  je rmAh
  cmp rmBit, 101b
  je rmCh
  cmp rmBit, 110b
  je rmDh
  mov dx, 16
  jmp rmPrintEnd
  rmAl:
  mov dx, 2
  jmp RmPrintEnd
  rmCl:
  mov dx, 4
  jmp RegPrintEnd
  RmDl:
  mov dx, 6
  jmp RmPrintEnd
  RmBl:
  mov dx, 8
  jmp RmPrintEnd
  RmAh:
  mov dx, 10
  jmp RmPrintEnd
  RmCh:
  mov dx, 12
  jmp RmPrintEnd
  RmDh:
  mov dx, 14
  RmPrintEnd:
  cmp KoksPrefiksas, 0
  jne RmPrintEndpf
  mov ah, 40h
  add dx, bx
  mov cx, 2
  mov bx, [RezultatuHandle]
  int 21h
  jmp modd11end
  RmPrintEndpf:
  push bx
  push dx
  call PrintPrefiks
  pop dx
  pop bx
  mov ah, 40h
  add dx, bx
  mov cx, 2
  mov bx, [RezultatuHandle]
  int 21h
  modd11end:
  ret
  endp

  PROC KoksRegistras
  cmp regBit, 000b
  je RegAl
  cmp regBit, 001b
  je RegCl
  cmp regBit, 010b
  je RegDl
  cmp regBit, 011b
  je RegBl
  cmp regBit, 100b
  je RegAh
  cmp regBit, 101b
  je RegCh
  cmp regBit, 110b
  je RegDh
  mov dx, 16
  jmp RegPrintEnd
  RegAl:
  mov dx, 2
  jmp RegPrintEnd
  RegCl:
  mov dx, 4
  jmp RegPrintEnd
  RegDl:
  mov dx, 6
  jmp RegPrintEnd
  RegBl:
  mov dx, 8
  jmp RegPrintEnd
  RegAh:
  mov dx, 10
  jmp RegPrintEnd
  RegCh:
  mov dx, 12
  jmp RegPrintEnd
  RegDh:
  mov dx, 14
  RegPrintEnd:
  mov ah, 40h
  add dx, bx
  mov cx, 2
  mov bx, [RezultatuHandle]
  int 21h
  ret
  endp

  PROC mod00
  cmp rmBit, 000b
  je bxsi
  cmp rmBit, 001b
  je bxdi
  cmp rmBit, 010b
  je bpsi
  cmp rmBit, 011b
  je bpdi
  cmp rmBit, 100b
  je sins
  cmp rmBit, 101b
  je dins
  cmp rmBit, 111b
  je bxns
  cmp KoksPrefiksas, 0
  je nebusprefikso
  call PrintPrefiks
  nebusprefikso:
  call printTiesioginisAdresas
  jmp mod00end
  bxsi:
  mov dx, 2
  jmp printmod009b
  bxdi:
  mov dx, 11
  jmp printmod009b
  bpsi:
  mov dx, 20
  jmp printmod009b
  bpdi:
  mov dx, 29
  jmp printmod009b
  sins:
  mov dx, 38
  jmp printmod004b
  dins:
  mov dx, 42
  jmp printmod004b
  bxns:
  mov dx, 46
  jmp printmod004b
  printmod009b:
  cmp KoksPrefiksas, 0
  jne printmod009bpf
  mov ah, 40h
  mov cx, 9
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistrai
  int 21h
  jmp mod00end
  printmod009bpf:
  push dx
  call PrintPrefiks
  pop dx
  mov ah, 40h
  mov cx, 9
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistrai
  int 21h
  jmp mod00end
  printmod004b:
  cmp KoksPrefiksas, 0
  jne printmod004bpf
  mov ah, 40h
  mov cx, 4
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistrai
  int 21h
  jmp mod00end
  printmod004bpf:
  push dx
  call PrintPrefiks
  pop dx
  mov ah, 40h
  mov cx, 4
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistrai
  int 21h
  mod00end:
  ret
  endp

  PROC mod01
  cmp rmBit, 000b
  je bxsis
  cmp rmBit, 001b
  je bxdis
  cmp rmBit, 010b
  je bpsis
  cmp rmBit, 011b
  je bpdis
  cmp rmBit, 100b
  je sis
  cmp rmBit, 101b
  je dis
  cmp rmBit, 110b
  je bps
  cmp rmBit, 111b
  je bxs
  bxsis:
  mov dx, 2
  jmp printmod0112b
  bxdis:
  mov dx, 14
  jmp printmod0112b
  bpsis:
  mov dx, 26
  jmp printmod0112b
  bpdis:
  mov dx, 38
  jmp printmod0112b
  sis:
  mov dx, 50
  jmp printmod017b
  dis:
  mov dx, 57
  jmp printmod017b
  bps:
  mov dx, 64
  jmp printmod017b
  bxs:
  mov dx, 71
  jmp printmod017b
  printmod0112b:
  cmp KoksPrefiksas, 0
  jne printmod0112bpf
  mov ah, 40h
  mov cx, 12
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistraiSuPoslinkiu
  int 21h
  call printBaitoPoslinks
  jmp mod01end
  printmod0112bpf:
  push dx
  call PrintPrefiks
  pop dx
  mov ah, 40h
  mov cx, 12
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistraiSuPoslinkiu
  int 21h
  call printBaitoPoslinks
  jmp mod01end
  printmod017b:
  cmp KoksPrefiksas, 0
  jne printmod017bpf
  mov ah, 40h
  mov cx, 7
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistraiSuPoslinkiu
  int 21h
  call printBaitoPoslinks
  jmp mod01end
  printmod017bpf:
  push dx
  call PrintPrefiks
  pop dx
  mov ah, 40h
  mov cx, 7
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistraiSuPoslinkiu
  int 21h
  call printBaitoPoslinks
  mod01end:
  ret
  endp

  PROC mod10
  cmp rmBit, 000b
  je bxsisx
  cmp rmBit, 001b
  je bxdisx
  cmp rmBit, 010b
  je bpsisx
  cmp rmBit, 011b
  je bpdisx
  cmp rmBit, 100b
  je sisx
  cmp rmBit, 101b
  je disx
  cmp rmBit, 110b
  je bpsx
  cmp rmBit, 111b
  je bxsx
  bxsisx:
  mov dx, 2
  jmp printmod1012b
  bxdisx:
  mov dx, 14
  jmp printmod1012b
  bpsisx:
  mov dx, 26
  jmp printmod1012b
  bpdisx:
  mov dx, 38
  jmp printmod1012b
  sisx:
  mov dx, 50
  jmp printmod107b
  disx:
  mov dx, 57
  jmp printmod107b
  bpsx:
  mov dx, 64
  jmp printmod107b
  bxsx:
  mov dx, 71
  jmp printmod107b
  printmod1012b:
  cmp KoksPrefiksas, 0
  jne printmod1012bpf
  mov ah, 40h
  mov cx, 12
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistraiSuPoslinkiu
  int 21h
  call printDviejuBaitPoslinks
  jmp mod10end
  printmod1012bpf:
  push dx
  call PrintPrefiks
  pop dx
  mov ah, 40h
  mov cx, 12
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistraiSuPoslinkiu
  int 21h
  call printDviejuBaitPoslinks
  jmp mod10end
  printmod107b:
  cmp KoksPrefiksas, 0
  jne printmod107bpf
  mov ah, 40h
  mov cx, 7
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistraiSuPoslinkiu
  int 21h
  call printDviejuBaitPoslinks
  jmp mod10end
  printmod107bpf:
  push dx
  call PrintPrefiks
  pop dx
  mov ah, 40h
  mov cx, 7
  mov bx, [RezultatuHandle]
  add dx, offset AddRegistraiSuPoslinkiu
  int 21h
  call printDviejuBaitPoslinks
  mod10end:
  ret
  endp

  PROC printBaitoPoslinks
  call getNextByte
  mov al, cl
  mov si, offset BaitoPoslinkis
  call PutByte
  mov ah, 40h
  mov cx, 3
  mov bx, [RezultatuHandle]
  mov dx, offset BaitoPoslinkis
  int 21h
  ret
  endp

  PROC printDviejuBaitPoslinks
  call getNextByte
  mov ch, cl
  call getNextByte
  mov al, cl
  mov si, offset DviejuBaituPoslinkis
  call PutByte
  mov al, ch
  xor ah, ah
  call PutByte
  mov ah, 40h
  mov cx, 5
  mov bx, [RezultatuHandle]
  mov dx, offset DviejuBaituPoslinkis
  int 21h
  ret
  endp

  PROC printTiesioginisAdresas
  call getNextByte
  mov ch, cl
  call getNextByte
  mov al, cl
  mov si, offset TiesioginisAdresas
  inc si
  call PutByte
  mov al, ch
  xor ah, ah
  call PutByte
  mov ah, 40h
  mov cx, 7
  mov bx, [RezultatuHandle]
  mov dx, offset TiesioginisAdresas
  int 21h
  ret
  endp

  PROC putEoL
  mov ah, 40h
  mov cx, 1
  mov bx, [RezultatuHandle]
  mov dx, offset EoL
  int 21h
  ret
  endp

  PROC putBytePtr
  mov ah, 40h
  mov cx, 9
  mov bx, [RezultatuHandle]
  mov dx, offset Byteptr
  int 21h
  ret
  endp

  PROC putWordPtr
  mov ah, 40h
  mov cx, 9
  mov bx, [RezultatuHandle]
  mov dx, offset Wordptr
  int 21h
  ret
  endp

  PROC cmpMod
  cmp modBit, 00b
  je mod00a
  cmp modBit, 01b
  je mod01a
  cmp modBit, 10b
  je mod10a
  jmp cmpModend
  mod00a:
  call mod00
  jmp cmpModend
  mod01a:
  call mod01
  jmp cmpModend
  mod10a:
  call mod10
  cmpModend:
  ret
  endp

  PROC OperandasSuSbit
  cmp dBit, 1b
  je operandaspleciamas
  cmp wBit, 1b
  je operandasbus2b
  call printBaitoPoslinks
  jmp opend
  operandasbus2b:
  call printDviejuBaitPoslinks
  jmp opend
  operandaspleciamas:
  call getNextByte
  mov si, offset DviejuBaituPoslinkis
  cmp cl, 80h
  jae pleciamasFF
  mov al, 00h
  call PutByte
  jmp PraplestoBaitoprint
  pleciamasFF:
  mov al, 0FFh
  call PutByte
  PraplestoBaitoprint:
  mov al, cl
  xor ah, ah
  call PutByte
  mov ah, 40h
  mov cx, 5
  mov bx, [RezultatuHandle]
  mov dx, offset DviejuBaituPoslinkis
  int 21h
  opend:
  ret
  endp

  PROC PrintPrefiks
  mov ah, 40h
  mov cx, 3
  mov bx, [RezultatuHandle]
  mov dx, KoksPrefiksas
  int 21h
  mov KoksPrefiksas, 0
  ret
  endp

  PROC printfar
  mov ah, 40h
  mov cx, 4
  mov bx, [RezultatuHandle]
  mov dx, offset FarPtr
  int 21h
  ret
  endp

  PROC printposlinkis
  cmp KoksPrefiksas, 0
  je poslinkisprint
  call PrintPrefiks
  poslinkisprint:
  call getNextByte
  mov ax, KomandosPabaiga
  add ax, cx
  mov cl, al
  mov al, ah
  mov si, offset DviejuBaituPoslinkis
  xor ah, ah
  call PutByte
  mov al, cl
  xor ah, ah
  call PutByte
  mov ah, 40h
  mov cx, 5
  mov bx, [RezultatuHandle]
  mov dx, offset DviejuBaituPoslinkis
  int 21h
  ret
  endp

  PROC printposlinkis2b
  cmp KoksPrefiksas, 0
  je poslinkisprint2b
  call PrintPrefiks
  poslinkisprint2b:
  mov ax, KomandosPabaiga
  call getNextByte
  mov bl, cl
  call getNextByte
  mov ch, cl
  mov cl, bl
  add ax, cx
  mov cl, al
  mov al, ah
  mov si, offset DviejuBaituPoslinkis
  xor ah, ah
  call PutByte
  mov al, cl
  xor ah, ah
  call PutByte
  mov ah, 40h
  mov cx, 5
  mov bx, [RezultatuHandle]
  mov dx, offset DviejuBaituPoslinkis
  int 21h
  ret
  endp

  PROC putdoublepoint
  mov ah, 40h
  mov cx, 1
  mov bx, [RezultatuHandle]
  mov dx, offset DoublePoint
  int 21h
  ret
  endp

  end Start
