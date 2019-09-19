Class {
	#name : #P4AST2TAC,
	#superclass : #P4Object,
	#instVars : [
		'builder',
		'closureCaptures',
		'helper',
		'callable',
		'currentInstVars'
	],
	#category : #'P4-TAC'
}

{ #category : #accessing }
P4AST2TAC class >> pname [
	<preventExport>
	^ pname ifNil: [ pname := (self name copyFrom: 'P4' size + 1 to: self name size) asSymbol ]
]

{ #category : #convenience }
P4AST2TAC >> argumentsEmptyOrStatic: arguments [
	^ arguments allSatisfy: [:arg | arg isDynamic not ]



]

{ #category : #convenience }
P4AST2TAC >> callable [ 
	^callable
]

{ #category : #compiling }
P4AST2TAC >> compileCallable: aCallable [
	builder locals: callable locals.
	builder temps: callable temps.
	builder setMethodObject: callable.
	builder declareLocals: aCallable temporaries.
	self declareInstVars.
	
	callable preamble: builder preamble.
	self insertPreamble.

	builder useAsNextBasicBlock: (callable registerPushing: builder nextBasicBlock).
	self storeBasePointer.

	callable argumentLoading: builder nextBasicBlock.
	builder useAsNextBasicBlock: callable argumentLoading.
	self loadIncomingArguments: aCallable arguments.
	self readAnnotations: aCallable.
	
	builder useAsNextBasicBlock: (callable primitiveCalling: builder nextBasicBlock).

	callable entry: builder nextBasicBlock.
	self unrollPrimitive.	
	builder useAsNextBasicBlock: callable entry.

	self compileStatements: aCallable statements.
	builder endBlock.
	
	callable postamble: builder postamble.
	callable popArguments: builder nextBasicBlock.
	builder useAsNextBasicBlock: callable popArguments.  
	self insertPopArguments.
	
	self compileInvokeBlock.

]

{ #category : #convenience }
P4AST2TAC >> compileInvokeBlock [ 
]

{ #category : #compiling }
P4AST2TAC >> compileStatements: statements [
	|result|
	
	statements isEmpty ifTrue: [ ^ self emptyBody ].
	
	statements allButLastDo: [ :statement |
		statement acceptVisitor: self ].
	
	result := statements last acceptVisitor: self.
		
	statements last isReturn ifFalse: [
		self insertReturn: result ]
]

{ #category : #compiling }
P4AST2TAC >> currentInstVars: vars [
	currentInstVars := vars
]

{ #category : #compiling }
P4AST2TAC >> emptyBody [
	self subclassResponsibility
]

{ #category : #convenience }
P4AST2TAC >> evaluateArguments: arguments [
	| argumentTemps argument value |
	argumentTemps := Array new: arguments size.
	1 to: arguments size - 1 do: [ :index |
		argument := arguments at: index.
		value := builder temporaryStore: (argument acceptVisitor: self).
		argumentTemps at: index put: value ].
	argumentTemps at: arguments size put: (arguments last acceptVisitor: self).
	
	^ argumentTemps
]

{ #category : #accessing }
P4AST2TAC >> helper: aHelper [
	helper := aHelper
]

{ #category : #convenience }
P4AST2TAC >> insertPopArguments [
]

{ #category : #convenience }
P4AST2TAC >> insertPreamble [
]

{ #category : #compiling }
P4AST2TAC >> insertReturn: lastValue [
	self subclassResponsibility
]

{ #category : #convenience }
P4AST2TAC >> loadIncomingArguments: arguments [
	self subclassResponsibility
]

{ #category : #convenience }
P4AST2TAC >> lookupLValue: anASTVariable [
	^ builder local: anASTVariable name ifAbsent: [
		builder instVar: anASTVariable name ]
]

{ #category : #accessing }
P4AST2TAC >> methodSuper [
	self subclassResponsibility
]

{ #category : #convenience }
P4AST2TAC >> readAnnotations: aCallable [  
]

{ #category : #convenience }
P4AST2TAC >> send: message to: receiver receiverTac: receiverTac with: arguments [
	
	| receiverTemp argumentTemps ret tacMessage |
	(helper implements: message selector ) ifTrue: [ 
		^ helper send: message to: receiver with: arguments for: self ].	
	
	receiverTac 
		ifNil: [receiverTemp := receiver acceptVisitor: self]
		ifNotNil: [receiverTemp := receiverTac].
	
	(self argumentsEmptyOrStatic: arguments)
		ifTrue: [ 
			argumentTemps := arguments collect: [ :arg | arg acceptVisitor: self ]]
		ifFalse: [
			receiverTemp := builder temporaryStore: receiverTemp.
			argumentTemps := self evaluateArguments: arguments. ].
		
	tacMessage := P4TACMessage new selector: message selector; numOfArguments: message arguments size.
		
	receiver isSuper 
		ifTrue: [^self tacSuperSend: tacMessage to: receiverTemp with: argumentTemps]
		ifFalse: [^self tacSend: tacMessage to: receiverTemp with: argumentTemps]
]

{ #category : #convenience }
P4AST2TAC >> send: message to: receiver with: arguments [
	^ self send: message to: receiver receiverTac: nil with: arguments
]

{ #category : #convenience }
P4AST2TAC >> tacSend: message to: receiver with: arguments [
	builder volatileFence.
	helper loadArguments: arguments andReceiver: receiver toSend: message selector.
	
	helper invoke: message for: receiver with: arguments.
	^ helper resultVariable
]

{ #category : #convenience }
P4AST2TAC >> tacSuperSend: message to: receiver with: arguments [
	builder volatileFence.
	helper loadArguments: arguments andReceiver: receiver toSend: message selector.
	
	self flag: 'the super call should really not be looked up statically!'.
	builder move: (receiver accessAt: P4SmalltalkConfiguration classIndex) to: helper resultVariable.
	builder directCall: (self methodSuper earlySelectorAddress: message selector).

	^ helper resultVariable
]

{ #category : #compiling }
P4AST2TAC >> unrollPrimitive [
]

{ #category : #visiting }
P4AST2TAC >> visit: anASTNode [
	^ anASTNode acceptVisitor: self
]

{ #category : #visitor }
P4AST2TAC >> visitArgumentNode: anASTVariable [
	^ self visitVariableNode: anASTVariable
]

{ #category : #visiting }
P4AST2TAC >> visitArrayNode: anArray [
	self error: 'Literal arrays are not yet supported by the compiler. Patches welcome!'
]

{ #category : #visitor }
P4AST2TAC >> visitAssignmentNode: anAssignmentExpression [
	| value variable |
	variable := self lookupLValue: anAssignmentExpression variable.
	value := anAssignmentExpression value acceptVisitor: self.
	value := builder temporaryStore: value.  
	builder move: value to: variable.
	^ value

]

{ #category : #visitor }
P4AST2TAC >> visitBlockNode: aBlockNode [
	| result |
	builder volatileFence.
	result := builder closure: aBlockNode inScope: callable.
	closureCaptures add: result.
	^ result resultVariable
]

{ #category : #visitor }
P4AST2TAC >> visitCascadeNode: aCascadeNode [
	| lastMessage receiver |
	receiver := builder temporaryStore: (aCascadeNode receiver acceptVisitor: self).
	aCascadeNode messages do: [ :aMessageExpression |
		lastMessage := self send: aMessageExpression to: aCascadeNode receiver receiverTac: receiver with: aMessageExpression arguments ].
	^ lastMessage
]

{ #category : #visiting }
P4AST2TAC >> visitCharacter: anASTCharacter [
	^ builder loadConstant: anASTCharacter char
]

{ #category : #'as yet unclassified' }
P4AST2TAC >> visitGlobalNode: aRBGlobalNode [ 
	^ self visitVariableNode: aRBGlobalNode
]

{ #category : #visitor }
P4AST2TAC >> visitInlinedBlock: aBlock returnTo: aResultVariable [
	| lastStatement |
	( aBlock statements size > 1 ) ifTrue: [
		aBlock statements allButLastDo: [ :statement |
			statement acceptVisitor: self ]].
	
	( aBlock statements size > 0 ) 
		ifTrue: [
			lastStatement := aBlock statements last acceptVisitor: self.
			lastStatement asValue 
				ifNil: [ builder move: builder nil to: aResultVariable ]
				ifNotNil: [ builder move: lastStatement asValue to: aResultVariable ]]
		ifFalse: [
			builder move: builder nil to: aResultVariable ].
	^ aResultVariable.

]

{ #category : #visiting }
P4AST2TAC >> visitInstanceVariableNode: anASTVariable [
	^ builder local: anASTVariable name ifAbsent: [
		builder instVarOrGlobal: anASTVariable name ]
]

{ #category : #visitor }
P4AST2TAC >> visitLiteralNode: aLiteralNode [
	| value |
	value := aLiteralNode value.
	value = true
		ifTrue: [ ^ builder instVarOrGlobal: #true ].
	value = false
		ifTrue: [ ^ builder instVarOrGlobal: #false ].
	value = nil
		ifTrue: [ ^ builder instVarOrGlobal: #nil ].
	^ aLiteralNode value isInteger
		ifFalse: [ builder loadConstant: value ]
		ifTrue: [ P4TACConstant with: (value << 1) + 1 ]
]

{ #category : #visitor }
P4AST2TAC >> visitMessageNode: aMessageExpression [
	^ self
		send: aMessageExpression
		to: aMessageExpression receiver
		with: aMessageExpression arguments
]

{ #category : #visiting }
P4AST2TAC >> visitNumberNode: anASTNumber [
	self flag: 'Support bignums separately'.
	^ P4TACConstant with: (anASTNumber asNumber << 1) + 1
]

{ #category : #visitor }
P4AST2TAC >> visitPragmaNode: aPragmaNode [	
	"ignored"
]

{ #category : #visitor }
P4AST2TAC >> visitReturnNode: aReturnNode [
	self subclassResponsibility
]

{ #category : #visitor }
P4AST2TAC >> visitSelfNode: aSelf [
	^ builder self
]

{ #category : #visiting }
P4AST2TAC >> visitString: anASTString [
	^ builder loadConstant: anASTString string
]

{ #category : #visitor }
P4AST2TAC >> visitSuperNode: anASTSuper [
	^ builder self
]

{ #category : #visiting }
P4AST2TAC >> visitSymbol: anASTSymbol [
	^ builder loadConstant: anASTSymbol symbol
]

{ #category : #visitor }
P4AST2TAC >> visitTemporaryNode: anASTVariable [
	^ self visitVariableNode: anASTVariable
]

{ #category : #visiting }
P4AST2TAC >> visitUnaryExpression: anASTUnaryExpression [
	^ self
		send: anASTUnaryExpression
		to: anASTUnaryExpression receiver
		with: #()
]

{ #category : #visitor }
P4AST2TAC >> visitVariableNode: anASTVariable [
	^ builder local: anASTVariable name ifAbsent: [
		builder instVarOrGlobal: anASTVariable name ]
]
