Class {
	#name : #P4TACLinearScanRegisterAllocator,
	#superclass : #P4Object,
	#instVars : [
		'processor',
		'usedRegisters',
		'maxUsedRegisters',
		'stackSize',
		'variables',
		'actives',
		'usedVolatileRegisters'
	],
	#category : #'P4-TAC'
}

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> assignRegister: aRegister to: aVariable [
	aVariable register: aRegister
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> backupRegistersFor: aMethod [
	| block |
	block := aMethod registerPushing.
	block positionAtBeginning.
	aMethod hasNonLocalReturn ifTrue: [ maxUsedRegisters := self numberOfRegisters ].
	
	1 to: maxUsedRegisters do: [ :i |
		block << (processor extraRegisters at: i) push ].
	aMethod hasNonLocalReturn 
		ifTrue: [ block << (processor intermediateRegisters at: 1) push ].
	
	block := aMethod postamble.
	block positionAtBeginning.
	aMethod hasNonLocalReturn 
		ifTrue: [ block << (processor intermediateRegisters at: 1) pop ].
	maxUsedRegisters to: 1 by: -1 do: [ :i |
		block << (processor extraRegisters at: i) pop ].


]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> checkForUnassignedLocals: locals [
	locals do: [ :l |
		l firstAssign ifNil: [
			self error: 'Register allocation cannot proceed. there seems to be a problem with the TAC since a variable was used but never assigned.']]
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> expireIntervalsBefore: line [
	| toRemove |
	toRemove := 0.
	actives reverseDo: [ :var |
		( var lastUse > line ) 
			ifTrue: [ ^ actives removeLast: toRemove ].
		toRemove := toRemove + 1.
		self freeRegister: var register.
	].

	^ actives removeFirst: toRemove
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> freeRegister: aRegister [
	(usedVolatileRegisters includes: aRegister) 
		ifTrue: [ usedVolatileRegisters remove: aRegister ]
		ifFalse: [ (usedRegisters includes: aRegister) 
			ifTrue: [ usedRegisters remove: aRegister ]
			ifFalse: [ self error: 'couldn''t free register. its not used']]

]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> isRegisterFreeFor: variable [
	variable canBeVolatile ifTrue: [
		(usedVolatileRegisters size < self numberOfVolatileRegisters)
			ifTrue: [ ^ true ]].
	^ usedRegisters size < self numberOfRegisters

]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> linearScanRegisterAllocation [
	variables do: [ :var |
		self expireIntervalsBefore: var firstAssign.
		(self isRegisterFreeFor: var)
			ifFalse: [ self spill: var ]
			ifTrue: [
				self nextFreeRegisterFor: var.  
				actives add: var ]].
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> nextFreeRegisterFor: aVariable [
	aVariable canBeVolatile ifTrue: [ (self nextVolatileRegisterFor: aVariable) ifNotNil: [ ^self ]].
	(self nextRegisterFor: aVariable) ifNil: [ self error: 'couldn''t find a free register' ]
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> nextRegisterFor: aVariable [
	processor extraRegisters do: [ :r |
		(usedRegisters includes: r) ifFalse: [
			( maxUsedRegisters == usedRegisters size ) ifTrue: [
				maxUsedRegisters := maxUsedRegisters +1].
			usedRegisters add: r.
			^ aVariable assignRegister: r for: self ]].
	^ nil
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> nextStackPosition [
	| oldSize |
	oldSize := stackSize.
	stackSize := stackSize + 1.
	^ P4ASMRegisterAccess new
		register: processor stackPointer;
		offset: oldSize * processor pointerSize
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> nextVolatileRegisterFor: aVariable [
	processor volatileRegisters do: [ :r |
		(usedVolatileRegisters includes: r) ifFalse: [
			usedVolatileRegisters add: r.
			^ aVariable assignRegister: r for: self ]].
	^ nil.
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> numberOfRegisters [
	^ processor extraRegisters size
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> numberOfVolatileRegisters [
	^ processor volatileRegisters size
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> processor: aProcessor [
	processor := aProcessor
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> runOn: aTACNode [
	aTACNode accept: self
	
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> spill: variable [
	| spill |
	"self has to stay in a register. otherwise getting the class of an instVar can be a triple access."
	spill := actives first.
	spill isSelf ifTrue: [ spill := actives second ].  
	( spill lastUse > variable lastUse or: [variable isSelf])
		ifTrue: [
			variable register: spill register .  
			spill register: self nextStackPosition.
			actives remove: spill.
			actives add: variable.
		] ifFalse: [
			variable register: self nextStackPosition.
		]
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> visitCallable: aCallable [
	aCallable expungeUnusedLocals.
	self checkForUnassignedLocals: aCallable locals values.  
	self checkForUnassignedLocals: aCallable temps.  
	variables := aCallable locals values asSortedCollection:  [ :a :b | a firstAssign < b firstAssign ].
	variables addAll: aCallable temps.
	actives := SortedCollection sortBlock: [ :a :b | a lastUse > b lastUse ].
	usedRegisters := Set new.
	usedVolatileRegisters := Set new.
	stackSize := 0.
	maxUsedRegisters := 0.
	self linearScanRegisterAllocation.
	aCallable usedRegisters: maxUsedRegisters .
	aCallable frameSize: stackSize.
	self backupRegistersFor: aCallable.
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> visitClosure: aClosure [
	self visitCallable: aClosure   
]

{ #category : #'as yet unclassified' }
P4TACLinearScanRegisterAllocator >> visitMethod: aMethod [
	self visitCallable: aMethod.
	
	aMethod closures do: [ :closure |
		closure accept: self ]

]
