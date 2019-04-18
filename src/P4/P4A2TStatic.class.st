Class {
	#name : #P4A2TStatic,
	#superclass : #P4A2THelper,
	#category : #'P4-TAC'
}

{ #category : #convenience }
P4A2TStatic >> currentHost: host [ 
	(host inPharo class canPerform: #typeHints) ifTrue: [
		host inPharo typeHints keysAndValuesDo: [ :name :type |
			self typeHint: name as: type]]
]

{ #category : #'hardwired-calls' }
P4A2TStatic >> insertTypeGuardForCall: method expected: aType [
	| receiver |
	self 
		insertTypeGuard: {aType}
		andCondition: {}
		for: (self arg: 1 of: methodCompiler numArgs)
		around: [
			builder 
				directCallSkipTypeCheck: method earlySelectorAddress 
				on: method pMethodClass.]
		fallback: [
			builder 
				move: (builder loadConstant: method selector) to: self resultVariable;
				invoke: method numArgs.]
]

{ #category : #visitor }
P4A2TStatic >> invoke: message for: receiver with: arguments [
	| method |
	(receiver hasTypeHint and: [groundTypes not]) ifTrue: [	
			builder move: (builder loadConstant: receiver typeHint) to: self typeVariable.
			^ builder directCall: (receiver typeHint earlySelectorAddress: message selector) ] .
		
	(receiver hasTypeHint) ifTrue: [ 
		method := receiver typeHint pLookupSelector: message selector.
		^ self insertTypeGuardForCall: method expected: receiver typeHint ].
	
	(receiver isStaticallyTyped)	ifTrue: [
		method := receiver staticType pLookupSelector: message selector.
			^ builder 
				directCallSkipTypeCheck: method earlySelectorAddress   
				on: method pMethodClass ].
	
	^ super invoke: message for: receiver with: arguments.
]

{ #category : #convenience }
P4A2TStatic >> resolve: classPath [
	^P4Package byPathName: classPath
]

{ #category : #accessing }
P4A2TStatic >> staticType: variable as: type [
		(builder localOrInstVar: variable) staticType: (self resolve: type). 
]

{ #category : #accessing }
P4A2TStatic >> typeHint: variable as: type [
	(builder localOrInstVar: variable) typeHint: (self resolve: type).  

]
