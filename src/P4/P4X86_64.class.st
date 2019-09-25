"
Documentation of the X86_64 instruction set can be found at:

http://ref.x86asm.net/geek64.html
(how to read it: http://ref.x86asm.net)

The X86_64 is little endian so all values (addresses and constants) need to be written out in that format.

------------------------------------------
Register based instructions
------------------------------------------

Registers come in 2 combinations. The named registers are combination 0: register(0). The numbered registers (r8 to r15) are combination 1: register(1).

Instructions handling registers are often prefixed with an instrution carrying meta-information about the size of the arguments. 0x40 is the default and is left out; this is used for the combination (constant, register(0) access). The combination (constant, register(1) access) is encoded in 0x41. From then on the combinations (register(X), register(Y) (access?)) is encoded as 0x48 + X<<2 + Y. 

Registers can generally be read/written directly, or used as a pointer and written to at a certain offset. This is encoded in the upper two bits of the operand, called the ""access type"" in this code.

2r00 -> the register is used as a pointer and assignment is to *reg
2r01 -> the register is used as an array and the fixed index is <= than 16rFF: reg[index]
2r10 -> the register is used as an array and the fixed index is >= 16rFF but <= 16rFFFFFFFF
2r11 -> the register value is used as is

The case where the indexed register is the RBP or R13 (its sibling in combination 1) is slightly different. There the 00 is preserved for accessing the RIP at a 32bit offset. 

When the indexed register is the RSP or R12 (its sibling in combination 1) the operand is followed by 0x24 (twice the index of the RSP/R12). (I don't yet know why though...)

Within all register combinations only a single register can be accessed at an offset. In the operand encoding the register combination, the accessed register is the ""primary register"" and its index is always encoded in the lower 3 bits of the operand. The secondary register is encoded in the remaining 3 bits:

2 bits access type + 3 bits secondary register + 3 bits primary register

The instruction itself distinguishes if the target register is the primary or the secondary register. If the assigned register is the primary register the instruction code is used with 1 offset. If the assigned register is the secondary register, the instruction code is used with an offset 3.

----------------------------
Conditional Jumps
----------------------------

Conditional jumps depend on 4 flags:

CF = carry flag
ZF = zero flag
PF = parity flag
SF = sign flag

These flags are filled in by the cmp:with: instruction. There are 2^4 (4 flags) combinations, thus from 16r0 to 16rF.
All those jumps come in 2 flavors, a second-order instruction that uses 32bit offsets, and a first-order short sequence for single-byte offsets. So jumping between 0x00 and 0xFF distance is cheaper (shorter sequence) than jumping between 0xFF and 0xFFFFFFFF.

------------------------
Jumps and Calls
------------------------

Jumps and calls can be direct to an address, or indirect via a register (which can be accessed).

If a call is done to a register it is encoded in the same way as a ""constant/register combination"", meaning that it will be prefixed with 0x41 if the register is a register(1).


"
Class {
	#name : #'P4X86_64',
	#superclass : #P4Assembler,
	#instVars : [
		'rax',
		'rsp',
		'rdi',
		'rsi',
		'rdx',
		'rcx',
		'r8',
		'r9',
		'rbx',
		'rbp',
		'r10',
		'r11',
		'r12',
		'r13',
		'r14',
		'r15',
		'rip'
	],
	#category : #'P4-SystemSpec'
}

{ #category : #assembling }
P4X86_64 >> accessMaskFor: accessReg [

	" The instruction pointer can only be read as access 2r00 "
	accessReg asRegister == self instructionPointer ifTrue: [ ^ 2r00 ].
	accessReg isAccess ifFalse: [ ^ 2r11 ].
	
	" BasePointer (and R13) and InstructionPointer overlap, so 00 is an invalid access for the Base Pointer (and R13).
	  Otherwise it would look as if we were accessing the Instruction Pointer  "
	accessReg asRegister index == self basePointer index ifFalse: [
		accessReg offset = 0 ifTrue: [ ^ 2r00 ]].
	
	( -16r80 <= accessReg offset and: [ accessReg offset <= 16r7F ]) ifTrue: [ ^ 2r01 ].
	(-16r80000000 <= accessReg offset and: [ accessReg offset <= 16r7FFFFFFF ]) ifTrue: [ ^ 2r10 ].
	
	self error: 'outside range of signed 32bit displacement'
]

{ #category : #instructions }
P4X86_64 >> adc: firstReg with: secondReg [
	self instructionIndex: 16r2 firstReg: firstReg secondReg: secondReg.
]

{ #category : #instructions }
P4X86_64 >> add: firstReg to: secondReg [
	self instructionIndex: 16r0 firstReg: firstReg secondReg: secondReg.
]

{ #category : #instructions }
P4X86_64 >> and: firstReg with: secondReg [
	self instructionIndex: 16r4 firstReg: firstReg secondReg: secondReg.
]

{ #category : #accessing }
P4X86_64 >> basePointer [ 
	^ rbp
]

{ #category : #accessing }
P4X86_64 >> callRegisters [
	^ {rdi. rsi. rdx. rcx. r8. r9}
]

{ #category : #instructions }
P4X86_64 >> cmp: firstReg with: secondReg [
	self instructionIndex: 16r7 firstReg: firstReg secondReg: secondReg.
]

{ #category : #calling }
P4X86_64 >> directRelativeCall: functionName [
	stream nextPut: 16rE8.
	self installFunctionReference: functionName.
	self prefillAddress.
]

{ #category : #calling }
P4X86_64 >> directRelativeCall: functionName offset: offset [
	stream nextPut: 16rE8.
	self installFunctionReference: functionName.
	stream wordPut: offset.
]

{ #category : #elf }
P4X86_64 >> elfClass [
	"
	0 None
	1 32 bit
	2 64 bit
	"
	^ 16r02
]

{ #category : #elf }
P4X86_64 >> elfHeaderSize [
	^ 64
]

{ #category : #elf }
P4X86_64 >> elfMachine [
	^ 16r003e
]

{ #category : #accessing }
P4X86_64 >> extraRegisters [
	^ {rbx. rbp. r12. r13. r14. r15}
]

{ #category : #accessing }
P4X86_64 >> flags [
	" Processor specific flag (used in BinPack) "
	^ 0
]

{ #category : #calling }
P4X86_64 >> indirectCall: aRegister [
	aRegister combination = 1 ifTrue: [ stream nextPut: 16r41 ].
	self writeInstruction: 16rFF mask: 2r010 reg: aRegister
]

{ #category : #calling }
P4X86_64 >> indirectJmp: aRegister [
	aRegister combination = 1 ifTrue: [ stream nextPut: 16r41 ].
	self writeInstruction: 16rFF mask: 2r100 reg: aRegister
]

{ #category : #'initialize-release' }
P4X86_64 >> initialize [
	super initialize.
	
	rax := P4ASMRegister named: #rax.
	rcx := P4ASMRegister named: #rcx.
	rdx := P4ASMRegister named: #rdx.
	rbx := P4ASMRegister named: #rbx.
	rsp := P4ASMRegister named: #rsp.
	rbp := P4ASMRegister named: #rbp.
	rsi := P4ASMRegister named: #rsi.
	rdi := P4ASMRegister named: #rdi.
	
	self tagRegisters: {rax. rcx. rdx. rbx. rsp. rbp. rsi. rdi} combination: 0.
	
	r8 := P4ASMRegister named: #r8.
	r9 := P4ASMRegister named: #r9.
	r10 := P4ASMRegister named: #r10.
	r11 := P4ASMRegister named: #r11.
	r12 := P4ASMRegister named: #r12.
	r13 := P4ASMRegister named: #r13.
	r14 := P4ASMRegister named: #r14.
	r15 := P4ASMRegister named: #r15.
	
	self tagRegisters: {r8. r9. r10. r11. r12. r13. r14. r15} combination: 1.
	
	rip := P4ASMRegister named: #rip.
	rip index: rbp index.
	rip combination: rbp combination.
	
	forceShortJump := false.
]

{ #category : #assembling }
P4X86_64 >> insertDanglingRelativeJump: label instructionIndex: anInstruction shortBase: shortBase longBase: longBase  longIsSecondOrder: longIsSecondOrder [
	| short |
	short := self isShortJump.
	short 
		ifFalse: [ 
			longIsSecondOrder ifTrue: [self secondOrderCode]. 
			stream nextPut: anInstruction + longBase  ]
		ifTrue: [ stream nextPut: anInstruction + shortBase ].
		
	" Make the function dangling for filling when found or adding to globals for external linking "
	self link: label.

	short
		ifFalse: [ self prefillAddress ]
		ifTrue: [ self prefillShortAddress ].
	
	
]

{ #category : #assembling }
P4X86_64 >> insertRelativeJump: anAddress instructionIndex: anInstruction shortBase: shortBase longBase: longBase longIsSecondOrder: longIsSecondOrder [
	| relative |
	relative := anAddress - stream position.
	( self isShortJump: relative )
		ifFalse: [ 
			longIsSecondOrder 
				ifTrue: [self secondOrderCode. relative := relative - 1].
			stream nextPut: anInstruction + longBase.
			stream wordPut: relative - 1 - stream wordSize ]
		ifTrue: [ 
			stream nextPut: anInstruction + shortBase.
			stream nextPut: relative - 2 ].
]

{ #category : #calling }
P4X86_64 >> installFunctionReference: functionName [
	installer installFunction: functionName at: stream position
]

{ #category : #calling }
P4X86_64 >> installReference: functionName [
	installer installReference: functionName at: stream position
]

{ #category : #assembling }
P4X86_64 >> instructionIndex: anIndex constant: aConstant secondReg: secondReg [
	| mark |
	secondReg isAccess
		ifTrue: [ secondReg combination = 1 ifTrue: [ stream nextPut: 16r41 ]]
		ifFalse: [ stream nextPut: 16r48 + secondReg combination ].
	
	anIndex < 8 ifTrue: [
		aConstant isExternal
			ifFalse: [
				( -16r80 <= aConstant constantValue and: [ aConstant constantValue <= 16r7F ]) ifTrue: [
					self writeInstruction: 16r83 mask: anIndex reg: secondReg.
					^ stream nextPut: aConstant constantValue ]].

		secondReg == rax ifTrue: [
			stream nextPut: (anIndex * 8) + 5.
			^ self putConstantWord: aConstant ].
		
		secondReg isAccess ifTrue: [ self error: 'Can''t combine 32bit constants with indirect registers!' ].
		
		(-16r80000000 <= aConstant constantValue or: [ aConstant constantValue <= 16r7FFFFFFF ]) ifTrue: [
			self writeInstruction: 16r81 mask: anIndex reg: secondReg.
			^ self putConstantWord: aConstant ].
		
		self error: 'outside range of signed 32bit displacement' ].
	
	secondReg isAccess ifTrue: [ self error: 'Can''t combine 32bit constants with indirect registers!' ].

	" At the moment this is just used for MOV. Not sure if it's used for something else ... "
	self writeInstruction: (anIndex * 8) + 16r3F mask: 2r000 reg: secondReg.
	self putConstantWord: aConstant.
]

{ #category : #assembling }
P4X86_64 >> instructionIndex: anIndex firstReg: firstReg secondReg: secondReg [

	firstReg isRelative ifTrue: [
		secondReg isAccess
			ifTrue: [ self error: 'too many memory references' ].
		self
			writeInstruction: (anIndex * 8) + 3
			accessMask: 2r00
			firstReg: self instructionPointer
			secondReg: secondReg.

		self flag: 'Let the relocation add the offset rather than installing it here'.
		linker addressForLabel: firstReg target ifPresent: [ :address |
			^ stream wordPut: (address + firstReg offset - stream position - stream wordSize) ].
		self error: 'Should only happen for method objects... I suppose'. ].

	firstReg isConstant ifTrue: [
		^ self
			instructionIndex: anIndex
			constant: firstReg
			secondReg: secondReg ].
		
	firstReg isAccess ifTrue: [
		secondReg isAccess
			ifTrue: [ self error: 'too many memory references' ].
		^ self
			writeInstructionAccess: (anIndex * 8) + 3
			accessMask: (self accessMaskFor: firstReg)
			firstReg: firstReg
			secondReg: secondReg ].
	
	secondReg isAccess ifTrue: [
		^ self
			writeInstructionAccess: (anIndex * 8) + 1
			accessMask: (self accessMaskFor: secondReg)
			firstReg: secondReg
			secondReg: firstReg ].

	^ self
		writeInstruction: (anIndex * 8) + 1
		accessMask: (self accessMaskFor: secondReg)
		firstReg: secondReg
		secondReg: firstReg
]

{ #category : #accessing }
P4X86_64 >> instructionPointer [ 
	^ rip
]

{ #category : #'stack operations' }
P4X86_64 >> int3 [
	stream nextPut: 16rcc
]

{ #category : #accessing }
P4X86_64 >> intermediateRegisters [ 
	^ {r10.r11.}
]

{ #category : #'conditional branching' }
P4X86_64 >> ja: aLabel [
	" Jump short if not below or equal/not above (CF=1 AND ZF=1) "
	self jumpIndex: 16r7 to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jc: aLabel [
	" Jump short if below/not above or equal/carry (CF=1) "
	self jumpIndex: 16r2 to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> je: aLabel [
	" Jump short if zero/equal (ZF=0) "
	self jumpIndex: 16r4 to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jg: aLabel [
	" Jump short if not less nor equal/greater ((ZF=0) AND (SF=OF)) "
	self jumpIndex: 16rF to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jge: aLabel [
	" Jump short if not less/greater or equal (SF=OF) "
	self jumpIndex: 16rD to: aLabel.
]

{ #category : #calling }
P4X86_64 >> jmp: label [
	| jumpInstruction |
	" TODO allow jumping to a register-stored address. "
	jumpInstruction := 16rE9.
	linker addressForLabel: label ifPresent: [ :address |
		^ self insertRelativeJump: address instructionIndex: jumpInstruction shortBase: 2 longBase: 0 longIsSecondOrder: false ].
	self insertDanglingRelativeJump: label instructionIndex: jumpInstruction shortBase: 2 longBase: 0 longIsSecondOrder: false.
]

{ #category : #'conditional branching' }
P4X86_64 >> jna: aLabel [
	" Jump short if below or equal/not above (CF=1 AND ZF=1) "
	self jumpIndex: 16r6 to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jnc: aLabel [
	" Jump short if not below/above or equal/not carry (CF=0) "
	self jumpIndex: 16r3 to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jne: aLabel [
	" Jump short if not zero/not equal (ZF=1) "
	self jumpIndex: 16r5 to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jng: aLabel [
	" Jump short if less or equal/not greater ((ZF=1) OR (SF!=OF)) "
	self jumpIndex: 16rE to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jnge: aLabel [
	" Jump short if less/not greater (SF!=OF) "
	self jumpIndex: 16rC to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jno: aLabel [
	" Jump if not overflow "
	self jumpIndex: 16r1 to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jns: aLabel [
	" Jump short if not sign (SF=1) "
	self jumpIndex: 16r9 to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jo: aLabel [
	" Jump if overflow "
	self jumpIndex: 16r0 to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jpe: aLabel [
	" Jump short if parity/parity even (PF=1) "
	self jumpIndex: 16rA to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> jpo: aLabel [
	" Jump short if not parity/parity odd "
	self jumpIndex: 16rB to: aLabel.
]

{ #category : #'conditional branching' }
P4X86_64 >> js: aLabel [
	" Jump short if sign (SF=1) "
	self jumpIndex: 16r8 to: aLabel.
]

{ #category : #assembling }
P4X86_64 >> jumpIndex: anIndex to: aLabel [
	linker addressForLabel: aLabel ifPresent: [ :address |
		^ self insertRelativeJump: address instructionIndex: anIndex shortBase: 16r70 longBase: 16r80 longIsSecondOrder: true ].
	self insertDanglingRelativeJump: aLabel instructionIndex: anIndex  shortBase: 16r70 longBase: 16r80 longIsSecondOrder: true.
	
]

{ #category : #instructions }
P4X86_64 >> lea: firstReg to: secondReg [
	
	| accessMask |
	firstReg isAccess ifFalse: [ self error: 'LEA expects register access as first argument' ].
	secondReg isAccess ifTrue: [ self error: 'LEA expects normal register as second argument' ].
	accessMask := self accessMaskFor: rip.
	self
		writeInstruction: 16r8D
		accessMask: accessMask
		firstReg: rip
		secondReg: secondReg.

	self link: firstReg label.
	stream wordPut: 16r0.
]

{ #category : #returning }
P4X86_64 >> leave [
	stream nextPut: 16rC9
]

{ #category : #assembling }
P4X86_64 >> link: aLabel [
	linker dangling: aLabel at: stream position
]

{ #category : #macho }
P4X86_64 >> machOCPUSubType [
	"
	CPU_SUBTYPE_X86_ALL     ((cpu_subtype_t)3)
	CPU_SUBTYPE_X86_64_ALL      ((cpu_subtype_t)3)
	"
	^ 16r3
]

{ #category : #macho }
P4X86_64 >> machOCPUType [
	"
	X86 -> 07
	64bit -> type | 01000000
	"
	^ 16r01000007
]

{ #category : #macho }
P4X86_64 >> machOMagic [
	"
	32bit -> FEEDFACE
	64bit -> FEEDFACF
	"
	^ 16rFEEDFACF
]

{ #category : #instructions }
P4X86_64 >> mov: firstReg to: secondReg [
	self instructionIndex: 16r11 firstReg: firstReg secondReg: secondReg.
]

{ #category : #instructions }
P4X86_64 >> or: firstReg with: secondReg [
	self instructionIndex: 16r1 firstReg: firstReg secondReg: secondReg.
]

{ #category : #accessing }
P4X86_64 >> pointerSize [
	^ 8
]

{ #category : #'stack operations' }
P4X86_64 >> pop: aRegister [
	aRegister isAccess ifTrue: [ self error: 'Not yet supported '].
	aRegister combination = 1 ifTrue: [ stream nextPut: 16r41 ].
	stream nextPut: 16r58 + aRegister index
]

{ #category : #assembling }
P4X86_64 >> prefillAddress [
	" Prefil space with 0 for linking (static or dynamic) "
	stream wordPut: 0.
]

{ #category : #assembling }
P4X86_64 >> prefillShortAddress [
	" Prefil short address with 1, we have to fill this before linking with a short jump address"
	stream nextPut: 1.
]

{ #category : #assembling }
P4X86_64 >> prefixFor: aValue [
	| prefix |
	" Assume 64 Bit Operand Size "
	prefix := 16r48 + aValue combination.
	stream nextPut: prefix
]

{ #category : #assembling }
P4X86_64 >> prefixFor: aValue and: secondValue [
	| prefix |
	" Assume 64 Bit Operand Size "
	prefix := 16r48 + (secondValue combination << 2) + aValue combination.
	stream nextPut: prefix
]

{ #category : #'stack operations' }
P4X86_64 >> push: aRegister [
	aRegister isAccess ifTrue: [ self error: 'Not yet supported '].
	aRegister combination = 1 ifTrue: [ stream nextPut: 16r41 ].
	stream nextPut: 16r50 + aRegister index
]

{ #category : #assembling }
P4X86_64 >> putConstantWord: aConstant [
	aConstant isExternal ifTrue: [ 
		installer global: aConstant label at: stream position.
		^ stream wordPut: 0 ].
	stream wordPut: aConstant constantValue.
]

{ #category : #accessing }
P4X86_64 >> r10 [
	^ r10
]

{ #category : #accessing }
P4X86_64 >> r11 [
	^ r11
]

{ #category : #accessing }
P4X86_64 >> r12 [
	^ r12
]

{ #category : #accessing }
P4X86_64 >> r13 [
	^ r13
]

{ #category : #accessing }
P4X86_64 >> r14 [
	^ r14
]

{ #category : #accessing }
P4X86_64 >> r15 [
	^ r15
]

{ #category : #accessing }
P4X86_64 >> r8 [
	^ r8
]

{ #category : #accessing }
P4X86_64 >> r9 [
	^ r9
]

{ #category : #accessing }
P4X86_64 >> rax [
	^ rax
]

{ #category : #accessing }
P4X86_64 >> rbp [
	^ rbp
]

{ #category : #accessing }
P4X86_64 >> rbx [
	^ rbx
]

{ #category : #accessing }
P4X86_64 >> rcx [
	^ rcx
]

{ #category : #accessing }
P4X86_64 >> rdi [
	^ rdi
]

{ #category : #accessing }
P4X86_64 >> rdx [
	^ rdx
]

{ #category : #accessing }
P4X86_64 >> resultVariable [ 
	^ rax
]

{ #category : #returning }
P4X86_64 >> ret [
	stream nextPut: 16rC3.
]

{ #category : #accessing }
P4X86_64 >> rip [
	^ rip
]

{ #category : #accessing }
P4X86_64 >> rsi [
	^ rsi
]

{ #category : #instructions }
P4X86_64 >> sbb: firstReg with: secondReg [
	self instructionIndex: 16r3 firstReg: firstReg secondReg: secondReg.
]

{ #category : #assembling }
P4X86_64 >> secondOrderCode [
	stream nextPut: 16r0F.
]

{ #category : #instructions }
P4X86_64 >> shl: reg by: num [
	reg isAccess ifTrue: [ self error: 'cannot be an access' ].
	self prefixFor: reg. 
	self writeInstruction: 16rC1 mask: 2r100 reg: reg.
	stream nextPut: num
]

{ #category : #instructions }
P4X86_64 >> shr: reg by: num [
	reg isAccess ifTrue: [ self error: 'cannot be an access' ].
	self prefixFor: reg.  
	self writeInstruction: 16rC1 mask: 2r101 reg: reg.
	stream nextPut: num
]

{ #category : #accessing }
P4X86_64 >> stackPointer [ 
	^ rsp
]

{ #category : #instructions }
P4X86_64 >> sub: firstReg from: secondReg [
	self instructionIndex: 16r5 firstReg: firstReg secondReg: secondReg.
]

{ #category : #'initialize-release' }
P4X86_64 >> tagRegisters: registers combination: aCombination [
	registers withIndexDo: [ :reg :index |
		reg combination: aCombination.
		reg index: index - 1 ]
]

{ #category : #instructions }
P4X86_64 >> test: firstReg with: secondReg [
	firstReg isConstant ifTrue: [
		secondReg isAccess ifTrue: [ self error: 'Cannot test constant with register access' ].
		secondReg combination = 1 ifTrue: [ self error: 'Second combination registers not (yet) supported for "test"'].
		" We don't need a 64bit prefix if the value is within 32bit range "
		(-16r80000000 <= firstReg constantValue or: [ firstReg constantValue <= 16r7FFFFFFF ])
			ifFalse: [ self error: 'Can only test with constants of max 32bit' ].
		stream nextPut: 16rF7.
		stream nextPut: ((2r11 << 6) + (2r000 << 3) + secondReg index).
		^ stream wordPut: firstReg constantValue ].
	
	self error: 'NYI'
]

{ #category : #instructions }
P4X86_64 >> testBit: bit on: reg [
	(reg combination = 1) ifTrue: [ self prefixFor: reg ].
	self secondOrderCode.
	self writeInstruction: 16rBA mask: 2r100 reg: reg.
	stream nextPut: bit
]

{ #category : #accessing }
P4X86_64 >> volatileRegisters [
	^ {rdx. rcx. rsi. rdi. r8. r9. }
]

{ #category : #accessing }
P4X86_64 >> wordSize [
	^ 4
]

{ #category : #assembling }
P4X86_64 >> writeAccess: aReg mask: accessMask [
	accessMask = 2r11 ifFalse: [
		aReg asRegister index == self stackPointer index ifTrue: [ stream nextPut: 16r24 ]].
	(accessMask = 2r10 or: [ aReg asRegister == self instructionPointer ])
		ifTrue: [ stream wordPut: aReg offset ].

	accessMask = 2r01 ifTrue: [ stream nextPut: aReg offset ].
]

{ #category : #assembling }
P4X86_64 >> writeInstruction: anInstruction accessMask: accessMask firstReg: firstReg secondReg: secondReg [
	self prefixFor: firstReg and: secondReg.
	stream nextPut: anInstruction.
	stream nextPut: ((accessMask << 6) + (secondReg index << 3) + firstReg index).
]

{ #category : #assembling }
P4X86_64 >> writeInstruction: anInstruction mask: aMask reg: aReg [
	| accessMask |
	stream nextPut: anInstruction.
	accessMask := self accessMaskFor: aReg.
	stream nextPut: ((accessMask << 6) + (aMask << 3) + aReg index).
	
	self writeAccess: aReg mask: accessMask
]

{ #category : #assembling }
P4X86_64 >> writeInstructionAccess: anInstruction accessMask: accessMask firstReg: firstReg secondReg: secondReg [
	self writeInstruction: anInstruction accessMask: accessMask firstReg: firstReg secondReg: secondReg.
	self writeAccess: firstReg mask: accessMask
]

{ #category : #instructions }
P4X86_64 >> xor: firstReg with: secondReg [
	self instructionIndex: 16r6 firstReg: firstReg secondReg: secondReg.
]
