Class {
	#name : #P4SmalltalkParser,
	#superclass : #P4SmalltalkGrammar,
	#instVars : [
		'stream'
	],
	#category : #'P4-Parser'
}

{ #category : #convenience }
P4SmalltalkParser >> createReference: path [
	| name |
	path size = 1 ifTrue: [ name := path first.
		name = #'self' ifTrue: [ ^ ASTSelf new ].
		name = #'super' ifTrue: [ ^ ASTSuper new ].
		^ ASTVariable new name: name ].
	^ ASTPath new path: path
]

{ #category : #convenience }
P4SmalltalkParser >> createVariable: variable [
	^ ASTVariable new name: variable
]

{ #category : #initialization }
P4SmalltalkParser >> initialize [
	super initialize.
	stream := WriteStream on: (String new: 1024).
]

{ #category : #initialization }
P4SmalltalkParser >> initializeAnnotations [
	^ super initializeAnnotations
		semantics: [ :result | result asArray ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeArray [
	^ super initializeArray
		semantics: [ :result |
			ASTArray new literals: result asArray ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeAssignmentExpressions [
	^ super initializeAssignmentExpressions
		semantics: [ :result | result asArray ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeBinaryExpression [
	^ super initializeBinaryExpression
		semantics: [ :parts | |result|
			result := parts first.
			2 to: parts size by: 2 do: [ :i |
				result := (ASTBinaryExpression new)
					receiver: result;
					selector: (parts at: i);
					argument: (parts at: i + 1). ].
				result ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeBinaryMessageDefinition [
	^ super initializeBinaryMessageDefinition
		semantics: [ :result | 
			(ASTBinaryMessageDefinition new)
				selector: result first;
				parameter: (self createVariable: (result at: 2)) ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeBinaryMessageExpression [
	^ super initializeBinaryMessageExpression 
		semantics: [ :parts | 
			(ASTBinaryExpression new)
				selector: parts first;
				argument: (parts at: 2) ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeBinarySelector [
	^ super initializeBinarySelector
		semantics: [ :result | result asSymbol ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeBlock [
	^ super initializeBlock
		semantics: [ :result |
			result size = 1
				ifTrue: [
					result add: PEGFailedOptionalResult.
					result add: OrderedCollection new ].
			(ASTBlock new)
				parameters: (result first resultIfFailed: [ Array new ]);
				temporaries: ((result at: 2) resultIfFailed: [ Array new ]);
				statements: (result at: 3) ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeBlockArguments [
	^ super initializeBlockArguments
		semantics: [ :result |
			result collect: [ :variable | self createVariable: variable ]]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeBraceExpression [
	^ super initializeBraceExpression
		semantics: [ :result |
			ASTBraceExpression new
				expressions: result ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeBracketIndexExpression [
	| optionalAssignment isAssignment keywords arguments |
	^ super initializeBracketIndexExpression
		semantics: [ :parts | 
			optionalAssignment :=  parts second.
			isAssignment := optionalAssignment class == PEGSucceededOptionalResult.
			keywords := isAssignment ifFalse: [ Array with: #at: ] ifTrue: [ Array with: #at: with: #put:].
			arguments := isAssignment ifFalse: [ Array with: parts first] ifTrue: [ Array with: parts first with: optionalAssignment result].
			(ASTMessageExpression new)
				keywords: keywords;
				arguments: arguments ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeCapitalIdentifier [
	^ super initializeCapitalIdentifier
		semantics: [ :result | result asString ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeCharacterConstant [
	^ super initializeCharacterConstant
		semantics: [ :char | ASTCharacter new char: char ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeExpression [
	| vars expression |
	^ super initializeExpression
		semantics: [ :result | 
			vars := result first.
			expression := result at: 2.
			vars ifMatched: [ :variables |
				variables reverseDo: [ :variable | 
					expression := (ASTAssignmentExpression new)
						expression: expression;
						variable: variable ] ].
			expression ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeFloat [
	^ super initializeFloat
		semantics: [ :result | 
			ASTFloat new
				high: result removeFirst;
				low: result asString ].
]

{ #category : #initialization }
P4SmalltalkParser >> initializeIdentifier [
	^ super initializeIdentifier
		semantics: [ :result | result asString ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeKeyword [
	^ super initializeKeyword
		semantics: [ :result | result asString ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeKeywordAnnotation [
	| halfsize keywords arguments |
	^ super initializeKeywordAnnotation
		semantics: [ :parts |
			halfsize := parts size // 2.
			keywords := Array new: halfsize.
			arguments := Array new: halfsize.
			1 to: halfsize do: [ :i | 
				keywords at: i put: (parts at: i * 2 - 1).
				arguments at: i put: (parts at: i * 2) ].
			(ASTKeywordAnnotation new)
				keywords: keywords;
				arguments: arguments ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeKeywordExpression [
	^ super initializeKeywordExpression
		semantics: [ :parts | (parts at: 2) receiver: parts first ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeKeywordMessageExpression [
	| halfsize keywords arguments |
	^ super initializeKeywordMessageExpression
		semantics: [ :parts | 
			halfsize := parts size // 2.
			keywords := Array new: halfsize.
			arguments := Array new: halfsize.
			1 to: halfsize do: [ :i |
				keywords at: i put: (parts at: i * 2 - 1).
				arguments at: i put: (parts at: i * 2) ].
			(ASTMessageExpression new)
				keywords: keywords;
				arguments: arguments ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeKeywordsArguments [
	| halfsize keywords parameters |
	^ super initializeKeywordsArguments
		semantics: [ :parts | 
			halfsize := parts size // 2.
			keywords := Array new: halfsize.
			parameters := Array new: halfsize.
			1 to: halfsize do: [ :i |
				keywords at: i put: (parts at: i*2-1).
				parameters at: i put: (self createVariable: (parts at: i*2)) ].
			(ASTKeywordMessageDefinition new)
				keywords: keywords;
				parameters: parameters ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeMethod [
	^ super initializeMethod
		semantics: [ :parts | 
			(ASTMethod new)
				message: parts first;
				annotations: (parts at: 2);
				temporaries: ((parts at: 3) resultIfFailed: [ Array new ]);
				statements: (parts at: 4)]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeNumber [
	^ super initializeNumber
		semantics: [ :result | 
			(ASTNumber new)
				number: result;
				base: '10' ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeNumberFormat [
	^ super initializeNumberFormat
		semantics: [ :result | result asString ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializePrimaryVariable [
	^ super initializePrimaryVariable
		semantics: [ :result | self createReference: result asArray ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeRadix [
	^ super initializeRadix
		semantics: [ :result | 
			(ASTNumber new)
				base: result first;
				number: result second ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeReturn [
	^ super initializeReturn
		semantics: [ :expression | ASTReturnExpression new expression: expression ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeScopedExpression [
	^ super initializeScopedExpression
		semantics: [ :result | 
			result scoped.
			result ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeStatements [
	^ super initializeStatements
		semantics: [ :result | 
			result removeLast ifMatched: [ :exp | result add: exp ].
			result asOrderedCollection ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeString [
	^ super initializeString
		semantics: [ :result |
			result size = 0
				ifTrue: [ '' ]
				ifFalse: [
					result inject: (stream with: (result removeFirst)) into: [ :s :i | s << '''' << i ].
					stream contents ] ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeStringConstant [
	^ super initializeStringConstant
		semantics: [ :result | ASTString new string: result ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeStringSegment [
	^ super initializeStringSegment
		semantics: [ :result | result asString ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeSymbolConstant [
	^ super initializeSymbolConstant
		semantics: [ :result | ASTSymbol named: result ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeSymbolInArray [
	^ super initializeSymbolInArray
		semantics: [ :symbol | ASTSymbol named: symbol ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeSymbolKeywords [
	^ super initializeSymbolKeywords
		semantics: [ :result |
			result inject: (stream on: '') into: [ :c :e | c << e ].
			stream contents ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeTemporaries [ 
	^ super initializeTemporaries
		semantics: [ :result | result asArray ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeUnaryAnnotation [
	^ super initializeUnaryAnnotation 
		semantics: [ :selector | ASTUnaryAnnotation new selector: selector ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeUnaryExpression [
	^ super initializeUnaryExpression
		semantics: [ :parts | |result|
			result := parts first.
			2 to: parts size do: [ :i | 
					result := (ASTUnaryExpression new)
						receiver: result;
						selector: (parts at: i) ].
			result ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeUnaryMessageDefinition [
	^ super initializeUnaryMessageDefinition 
		semantics: [ :selector | ASTUnaryMessageDefinition new selector: selector ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeUnaryMessageExpression [ 
	^ super initializeUnaryMessageExpression 
		semantics: [ :selector | ASTUnaryExpression new selector: selector ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeUnaryObjectDescription [
	^ super initializeUnaryObjectDescription 
		semantics: [ :parts | |result|
			result := parts first.
			2 to: parts size do: [ :i | 
					result := (ASTUnaryExpression new)
						receiver: result;
						selector: (parts at: i) ].
			result ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeUnarySelector [
	^ super initializeUnarySelector
		semantics: [ :selector | selector ]
]

{ #category : #initialization }
P4SmalltalkParser >> initializeVariableName [
	^ super initializeVariableName
		semantics: [ :result | self createVariable: result ]
]

{ #category : #expression }
P4SmalltalkParser >> preStoreCascadedMessageExpression [
	^ super preStoreCascadedMessageExpression
		semantics: [ :parts | 
				(ASTMessageCascadeExpression new)
					receiver: parts first receiver;
					cascades: parts asArray ]
]
