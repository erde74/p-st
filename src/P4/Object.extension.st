Extension { #name : #Object }

{ #category : #'*P4' }
Object >> dump: var on: binaryOut for: aReference at: offset [
	| instVarReference |
	(var isKindOf: SmallInteger) 
		ifTrue: [	binaryOut pointerPut: var asTaggedInteger at: aReference pointerOffset: offset-1 ]
		ifFalse: [instVarReference := binaryOut localDump: var.
				binaryOut pointerPut: instVarReference addend at: aReference pointerOffset: offset - 1.
			 	binaryOut referTo: instVarReference at: aReference pointerOffset: offset-1 ]

]

{ #category : #'*P4' }
Object >> dumpGlobalOn: binaryOut [
	self error: 'not a global object'  
]

{ #category : #'*P4' }
Object >> dumpLocalOn: binaryOut [
	^ self dumpOn: binaryOut
]

{ #category : #'*P4' }
Object >> dumpOn: binaryOut [
	| myRef var |
	myRef := binaryOut allocate: self.
	
	1 to: self pclass pInstSize do: [ :i |
		var := self pInstVarAt: i.
		self dump: var on: binaryOut for: myRef at: i ].
	
	1 to: self pVariableSize do: [ :i |
		var := self pVariableAt: i.
		self dump: var on: binaryOut for: myRef at: i+self pclass pInstSize ].
	
	^ myRef

]

{ #category : #'*P4' }
Object >> flush [

]

{ #category : #'*P4' }
Object >> pByteAt: i [
	^ self basicAt: i    
]

{ #category : #'*P4' }
Object >> pByteName [
	^ nil
]

{ #category : #'*P4' }
Object >> pByteSize [ 
	self class isBytes 
		ifTrue: [ ^ self basicSize ].
	^ 0
]

{ #category : #'*P4' }
Object >> pExportedName [ 
	^ nil
]

{ #category : #'*P4' }
Object >> pHash [
	^ self hash
]

{ #category : #'*P4' }
Object >> pHeader [
	| base variable bytes hash |
	base := self pclass pInstSize.
	variable := self pclass pIsVariable ifTrue: [ 1 ] ifFalse: [ 0 ].
	bytes := self pclass pIsBytes ifTrue: [ 1 ] ifFalse: [ 0 ].
	hash := self identityHash.
	^ (hash bitShift: 12) + (bytes bitShift: 9) + (variable bitShift: 8) + base
]

{ #category : #'*P4' }
Object >> pInstSize [ 
	^ self instSize 
]

{ #category : #'*P4' }
Object >> pInstVarAt: i [
	^ self instVarAt: i  
]

{ #category : #'*P4' }
Object >> pIsBytes [
	^ self isBytes
]

{ #category : #'*P4' }
Object >> pIsVariable [
	^ self isBytes not and: [ self isVariable ]
]

{ #category : #'*P4' }
Object >> pIsVariableOrBytes [
	^ self isVariable
]

{ #category : #'*P4' }
Object >> pVariableAt: i [
	^ self basicAt: i    
]

{ #category : #'*P4' }
Object >> pVariableSize [ 
	self class isBytes 
		ifFalse: [ ^ self basicSize ].
	^ 0
]

{ #category : #'*P4' }
Object >> pVariableSizeHeader [ 
	^ self basicSize 
]

{ #category : #'*P4' }
Object >> pclass [
	^ self class asPClass
]

{ #category : #'*P4' }
Object class >> pname [
	^ self name
]

{ #category : #'*P4' }
Object >> printObj [
	<preventExport>
]
