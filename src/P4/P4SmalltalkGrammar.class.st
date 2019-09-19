"
SCParser is a PEG which parses Smalltalk code.

""""""
TODO:
 - add tests for rules flagged with XXX
 - complete grammar of expressions
 - replace argument with parameter
""""""

Grammar:

methodParser					= messagePattern & temporaries? & annotations? & methodStatments?

BASIC-BLOCK:

temporaries 						= bar & variableName+ & bar
		
XXXsubExpression 					= expression & ('.' omit)
XXXfinalExpression 				= expression & ('.'? omit)
XXXreturn 							= ('^' omit) & finalExpression
XXXstatements 					= subExpression * & (return | finalExpression)?

XXXbraceExpression 				= ('{' omit) & subExpression* & expression & ('}' omit)
XXXscopedExpression 				= ('(' omit) & expression & (')' omit)

EXPRESSION:

primary 							= primaryVariable | literal | block | braceExpression | scopedExpression

expression 						= assignmentExpressions & (cascadedMessageExpression | messageExpression | primary)

cascadedMessageExpression 		= messageExpression & ((';' omit) & (keywordMessageExpression | binaryMessageExpression | unaryMessageExpression))+
messageExpression 				= keywordExpression | binaryExpression | unaryExpression
	
unaryExpression 				= primary & unarySelector+
binaryExpression 				= unaryObjectDescription & binarySelector & binaryObjectDescription

unaryMessageExpression 		= unarySelector
binaryMessageExpression 		= binarySelector & unaryObjectDescription

binaryObjectDescription 			= binaryExpression | unaryObjectDescription
unaryObjectDescription 			= unaryExpression | primary

ASSIGNMENT:

assignmentOp 					= ':=' | '_'
assignmentExpressions 			= (variableName & assignmentOp) times

BLOCK:

blockArguments 				= (':' & identifier) +
XXXblock 						= '[' & (blockArguments & bar) optional & temporaries optional & statements & ']'

SELECTOR:

keyword 						= identifier && (':' omit)
keywordsArguments 			= (keyword & argumentName) +

binarySelector 					= ( ( (specialCharacter | '-') && specialCharacter ** ) | '|' )
binaryArgument 				= binarySelector & argumentName

unarySelector 					= identifier && (':'! omit)
		
messagePattern 					= keywordsArguments | binaryArgument | unarySelector

LITERAL:

specialCharacter 				= '+' | '*' | '/' | '\' | '~' | '<' | '>' | '=' | '@' | '%' | '?' | '!' | '&' | '`' | ','
character 						= ('[' | ']' | '{' | '}' | '(' | ')' | '_' | '^' | ';' | '$' | '#' | ':' | '-' | '|' | '.') | space | decimalDigit | letter | specialCharacter
characterConstant 				= '$' && character

string 							= ( ('''' omit) && (''''!)**  && ('''' omit) )++
stringConstant 					= string
		
symbolKeywords 				= (keyword + ':') ++
symbolString 					= string
symbol 							= symbolKeywords | identifier | binarySelector | string
symbolInArray 					= symbol
symbolConstant 					= ('#' omit) && symbol
		
XXXarray 						= '(' & (number | stringConstant | symbolInArray | symbolConstant | characterConstant | array)*  & ')'
arrayConstant 					= '#' & array

VARIABLE:

identifier 						= letter && (letter | decimalDigit) **
capitalIdentifier 				= uppercase && (letter | decimalDigit) **
argumentName 					= identifier
variableName 					= identifier
primaryVariable 				= identifier

CONVENIENCE:

bar 							= '|'
decimalDigit 					= [0-9]
uppercase 						= [A-Z]
lowercase 						= [a-z]
letter 							= lowercase | uppercase
			
SEPARATOR:

space 							= ' ' | '\t' | '\n' 								""= PEGParser separators ""
commentFormat 					= '""' ('""'!) ** '""'
separator 						= (space | commentFormat) **
"
Class {
	#name : #P4SmalltalkGrammar,
	#superclass : #P4AbstractGrammar,
	#classInstVars : [
		'instance'
	],
	#category : #'P4-Parser'
}

{ #category : #'as yet unclassified' }
P4SmalltalkGrammar class >> benchmark: aParser [
	"self benchmark: PPSmalltalkGrammar new"
	"self benchmark: PPSmalltalkParser new"
	"self benchmark: RBParser '487243 characters/sec'"
	"self benchmark: SCParser new"
	<ignoreForCoverage>
	<preventExport>
	| sources |
	sources := OrderedCollection new.
	P4Object withAllSubclassesDo: [ :class |	class selectors do: [ :selector |	sources add: (class sourceCodeAt: selector) ] ].
	^ self benchmark: aParser sources: sources asArray
]

{ #category : #'as yet unclassified' }
P4SmalltalkGrammar class >> benchmark: aParser sources: aCollection [
	<preventExport>
	<ignoreForCoverage>
	| start count end |
	start := Time millisecondClockValue.
	end := start + 10000.
	count := 0.
	[  aCollection do: [ :each | aParser parseMethod: each ].
	count := count + 1.
	Time millisecondClockValue < end ] whileTrue.
	end := Time millisecondClockValue.
	^ (1000 * count * (aCollection detectSum: [ :each | each size ]) 	/ (end - start)) asInteger asString , ' characters/sec'
]

{ #category : #'as yet unclassified' }
P4SmalltalkGrammar class >> instance [
	"instance := nil"
	instance ifNil: [ instance := super new ].
	^ instance
]

{ #category : #assignment }
P4SmalltalkGrammar >> assignmentOp [
	^ ':=' asParser omit
]

{ #category : #annotations }
P4SmalltalkGrammar >> initializeAnnotations [
	^ PEGMultiParser
		named: 'ANNOTATIONS'
		parsing: ('<' asParser
					& (self keywordAnnotation | self unaryAnnotation)
					<& '>') times
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeArray [
	| array |
	array := PEGMultiParser named: 'ARRAY'.
	array <= ('(' asParser
				& (self numberConstant | self stringConstant
					<= self symbolInArray
					<= self symbolConstant
					<= self characterConstant
					<= array) times
				<& ')').
	^ array
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeArrayConstant [
	^ '#' asParser & self array
]

{ #category : #assignment }
P4SmalltalkGrammar >> initializeAssignmentExpressions [
	^ PEGMultiParser
		named: 'ASSIGNMENT-EXPRESSIONS'
		parsing: (self variableName & self assignmentOp) plus
]

{ #category : #convenience }
P4SmalltalkGrammar >> initializeBar [
	^ '|' asParser
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeBinaryExpression [
	self preStoreBinaryObjectDescription.
	parsers at: #binaryExpression ifAbsentPut:
		(PEGMultiParser
			named: 'BINARY-EXPRESSION'
			parsing: (self unaryObjectDescription & self binarySelector) plus & self unaryObjectDescription).
	self injectBinaryObjectDescription.
	^ self binaryExpression
]

{ #category : #selector }
P4SmalltalkGrammar >> initializeBinaryMessageDefinition [
	^ PEGMultiParser
		named: 'BINARY-ARGUMENT'
		parsing: self binarySelector & self parameterName
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeBinaryMessageExpression [
	^ PEGMultiParser
		named: 'BINARY-MESSAGE-EXPRESSION'
		parsing: self binarySelector & self unaryObjectDescription
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeBinaryObjectDescription [
	self binaryExpression.	" binaryExpression will build this parser. "
	^ self binaryObjectDescription
]

{ #category : #selector }
P4SmalltalkGrammar >> initializeBinarySelector [
	^ PEGMultiParser
		named: 'BINARY-SELECTOR'
		parsing: (self specialCharacter | '-' asParser consume)
					&& self specialCharacter strongTimes
					| ('|' asParser consume)
]

{ #category : #block }
P4SmalltalkGrammar >> initializeBlock [
	^ PEGMultiParser
		named: 'BLOCK'
		parsing: '[' asParser
				& (((self blockArguments & self bar) optional
					& self temporaries optional
					<& self statements
					<& ']') | (self blockArguments optional & ']'))
]

{ #category : #block }
P4SmalltalkGrammar >> initializeBlockArguments [
	^ PEGMultiParser
		named: 'BLOCK-ARGUMENTS'
		parsing: (':' asParser & self identifier) plus
]

{ #category : #'basic-block' }
P4SmalltalkGrammar >> initializeBraceExpression [
	^ PEGParser
		named: 'BRACE-EXPRESSION'
		parsing: '{' asParser
					& self statements
					<& '}'
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeBracketIndexExpression [
	^ PEGMultiParser
		named: 'BRACKET-INDEX-EXPRESSION'
		parsing: '[' asParser
					& self expression
					<& ']'
					<& ( self assignmentOp & self expression ) optional
]

{ #category : #variable }
P4SmalltalkGrammar >> initializeCapitalIdentifier [
	^ PEGMultiParser
		named: 'CAPITAL-IDENTIFIER'
		parsing: self uppercase && (self letter | self decimalDigit) strongTimes
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeCascadedMessageExpression [
	self expression.	" expression will build this parser. "
	^ self cascadedMessageExpression
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeCharacter [
	^ '[]{}()_^;$#:-|.''"' asPEGChoice | PEGParser separators
		<= self decimalDigit
		<= self letter
		<= self specialCharacter
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeCharacterConstant [
	^ PEGParser
		named: 'CHARACTER-CONSTANT'
		parsing: '$' asParser && self character
]

{ #category : #separator }
P4SmalltalkGrammar >> initializeCommentFormat [
	| commentBorder |
	commentBorder := '"' asParser.
	^ commentBorder
		&& commentBorder not consume strongTimes
		<& commentBorder
]

{ #category : #convenience }
P4SmalltalkGrammar >> initializeDecimalDigit [
	^ '0-9' asPEGRange
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeExpression [
	" Prestoring required parsers to handle circular references. "
	self preStorePrimary.
	self preStoreMessageExpression.
	self preStoreCascadedMessageExpression.
	parsers at: #expression
		put: (PEGMultiParser
			named: 'EXPRESSION'
			parsing: self assignmentExpressions optional
						& (self cascadedMessageExpression
							| self messageExpression
							<= self primary)).	
	" After having built the expression parser, we inject the parsers into their stubs. "
	self injectPrimary.
	self injectMessageExpression.
	self injectCascadedMessageExpression.	
	^ parsers at: #expression
]

{ #category : #'basic-block' }
P4SmalltalkGrammar >> initializeFinalExpression [
	^ self expression
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeFloat [
	^ PEGMultiParser
		named: 'FLOAT'
		parsing: self numberFormat && '.' <& self decimalDigit strongPlus
]

{ #category : #variable }
P4SmalltalkGrammar >> initializeIdentifier [
	^ PEGMultiParser
		named: 'IDENTIFIER'
		parsing: self identifierBody
]

{ #category : #variable }
P4SmalltalkGrammar >> initializeIdentifierBody [
	^ self letter &&
		(self lowercase | self uppercase
		<= self decimalDigit
		<= '!?' asPEGChoice) strongTimes
]

{ #category : #selector }
P4SmalltalkGrammar >> initializeKeyword [
	^ PEGMultiParser
		named: 'KEYWORD'
		parsing: self identifierBody && (':' asParser consume)
]

{ #category : #annotations }
P4SmalltalkGrammar >> initializeKeywordAnnotation [
	^ PEGMultiParser
		named: 'KEYWORD-ANNOTATION'
		parsing: (self keyword & self primary) plus
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeKeywordExpression [
	^ PEGMultiParser
		named: 'KEYWORD-EXPRESSION'
		parsing: self binaryObjectDescription & (self keywordMessageExpression | self bracketIndexExpression)
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeKeywordMessageExpression [
	^ PEGMultiParser
		named: 'KEYWORD-MESSAGE-EXPRESSION'
		parsing: (self keyword & self binaryObjectDescription) plus
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeKeywordsArguments [
	^ PEGMultiParser
		named: 'KEYWORDS-ARGUMENTS'
		parsing: (self keyword & self parameterName) plus
]

{ #category : #convenience }
P4SmalltalkGrammar >> initializeLetter [
	^ self lowercase | self uppercase
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeLiteral [
	^ self float 
		| self numberConstant
		<= self symbolConstant
		<= self characterConstant
		<= self stringConstant
		<= self arrayConstant
]

{ #category : #convenience }
P4SmalltalkGrammar >> initializeLowercase [
	^ 'a-z' asPEGRange
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeMessageExpression [
	self expression.	" expression will build this parser. "
	^ self messageExpression
]

{ #category : #selector }
P4SmalltalkGrammar >> initializeMessagePattern [
	^ PEGParser
		named: 'MESSAGE-PATTERN'
		parsing: self keywordsArguments | self binaryMessageDefinition <= self unaryMessageDefinition
]

{ #category : #method }
P4SmalltalkGrammar >> initializeMethod [
	^ (PEGMultiParser
		named: 'METHOD'
		parsing: (self separator
			& self messagePattern
			<& self annotations
			<& self temporaries optional
			<& self statements
			<& self separator) end)
		separator: self separator	" Allow comment/whitespace at the end of a method. "
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeNumber [
	^ PEGParser
		named: 'NUMBER'
		parsing: self numberFormat
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeNumberConstant [
	" XXX For now. "
	^ self radix | self number
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeNumberFormat [
	^ PEGMultiParser
		named: 'NUMBER-FORMAT'
		parsing: ('-' asParser consume & (self decimalDigit | self uppercase) strongPlus) | (self decimalDigit | self uppercase) strongPlus
]

{ #category : #variable }
P4SmalltalkGrammar >> initializeParameterName [
	^ self identifier
]

{ #category : #expression }
P4SmalltalkGrammar >> initializePrimary [
	self expression.	" self expression will initialize primary. "
	^ self primary
]

{ #category : #variable }
P4SmalltalkGrammar >> initializePrimaryVariable [
	^ PEGMultiParser
		named: 'PRIMARY-VARIABLE'
		parsing: self identifier && ('.' asParser && self identifier) strongTimes
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeRadix [
	^ PEGMultiParser
		named: 'RADIX-NUMBER'
		parsing: self numberFormat & 'r' <& self numberFormat
]

{ #category : #'basic-block' }
P4SmalltalkGrammar >> initializeReturn [
	^ PEGParser
		named: 'RETURN'
		parsing: '^' asParser & self expression <& '.' asParser optional omit
]

{ #category : #'basic-block' }
P4SmalltalkGrammar >> initializeScopedExpression [
	^ PEGParser
		named: 'SCOPED-EXPRESSION'
		parsing: '(' asParser & self expression <& ')'
]

{ #category : #separator }
P4SmalltalkGrammar >> initializeSeparator [
	" has to be strongPlus since plus would match separator in between -> infinite recursion. "

	^ (super initializeSeparator | self commentFormat) strongTimes omit
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeSpecialCharacter [
	^ '+*/\~<>=@%?!&`,' asPEGChoice
]

{ #category : #'basic-block' }
P4SmalltalkGrammar >> initializeStatements [
	^ PEGMultiParser
		named: 'STATEMENTS'
		parsing: self subExpression times & (self return | self expression) optional
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeString [
	^ PEGMultiParser
		named: 'STRING'
		parsing: self stringSegment strongPlus
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeStringConstant [
	^ PEGParser
		named: 'STRING-CONSTANT'
		parsing: self string
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeStringSegment [
	" XXX Have to optimize and clean..."
	| stringBorder |
	stringBorder := '''' asParser.
	^ PEGMultiParser
		named: 'STRING-SEGMENT'
		parsing: stringBorder && stringBorder not consume strongTimes <& stringBorder
]

{ #category : #'basic-block' }
P4SmalltalkGrammar >> initializeSubExpression [
	^ self expression & '.' | '.'
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeSymbol [
	^ PEGParser
		named: 'SYMBOL'
		parsing: self symbolKeywords | self identifier <= self binarySelector <= self string
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeSymbolConstant [
	^ PEGParser
		named: 'SYMBOL-CONSTANT'
		parsing: '#' asParser plus && self symbol
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeSymbolInArray [
	^ PEGParser
		named: 'SYMBOL-IN-ARRAY'
		parsing: self symbol
]

{ #category : #literal }
P4SmalltalkGrammar >> initializeSymbolKeywords [
	^ PEGMultiParser
		named: 'SYMBOL-KEYWORDS'
		parsing: self keyword strongPlus
]

{ #category : #'basic-block' }
P4SmalltalkGrammar >> initializeTemporaries [
	^ PEGMultiParser
		named: 'TEMPORARIES'
		parsing: self bar & self variableName times <& self bar
]

{ #category : #annotations }
P4SmalltalkGrammar >> initializeUnaryAnnotation [
	^ PEGParser
		named: 'UNARY-ANNOTATION'
		parsing: self unarySelector
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeUnaryExpression [
	^ PEGMultiParser
		named: 'UNARY-EXPRESSION'
		parsing: self primary & self unarySelector plus
]

{ #category : #selector }
P4SmalltalkGrammar >> initializeUnaryMessageDefinition [
	^ PEGParser
		named: 'UNARY-MESSAGE-DEFINITION'
		parsing: self unarySelector
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeUnaryMessageExpression [
	^ PEGParser
		named: 'UNARY-MESSAGE-EXPRESSION'
		parsing: self unarySelector
]

{ #category : #expression }
P4SmalltalkGrammar >> initializeUnaryObjectDescription [
	^ (PEGMultiParser
		named: 'UNARY-OBJECT-DESCRIPTION'
		parsing: self primary & self unarySelector times) memo
]

{ #category : #selector }
P4SmalltalkGrammar >> initializeUnarySelector [
	^ PEGParser
		named: 'UNARY-SELECTOR'
		parsing: self identifier && ':' asParser not
]

{ #category : #convenience }
P4SmalltalkGrammar >> initializeUppercase [
	^ 'A-Z' asPEGRange
]

{ #category : #variable }
P4SmalltalkGrammar >> initializeVariableName [
	^ PEGParser
		named: 'VARIABLE-NAME'
		parsing: self identifier
]

{ #category : #expression }
P4SmalltalkGrammar >> injectBinaryObjectDescription [
	^ self binaryObjectDescription <= (self binaryExpression | self unaryObjectDescription)
]

{ #category : #expression }
P4SmalltalkGrammar >> injectCascadedMessageExpression [
	^ self cascadedMessageExpression
		<= (self messageExpression
			& (';' asParser
				& (self keywordMessageExpression
					| self binaryMessageExpression
					<= self unaryMessageExpression)) plus)
]

{ #category : #expression }
P4SmalltalkGrammar >> injectMessageExpression [
	^ self messageExpression <= (self keywordExpression | self binaryExpression <= self unaryExpression)
]

{ #category : #expression }
P4SmalltalkGrammar >> injectPrimary [ 
	^ self primary <= (self primaryVariable | self literal <= self block <= self scopedExpression <= self braceExpression)
]

{ #category : #parsing }
P4SmalltalkGrammar >> parseMethod: method [
	^ self match: method to: self method
]

{ #category : #parsing }
P4SmalltalkGrammar >> parseStatements: statements [
	^ self match: statements to: self statements end
]

{ #category : #expression }
P4SmalltalkGrammar >> preStoreBinaryObjectDescription [
	^ parsers at: #binaryObjectDescription ifAbsentPut: [ (PEGParser named: 'BINARY-OBJECT-DESCRIPTION') memo ]
]

{ #category : #expression }
P4SmalltalkGrammar >> preStoreBracketIndexExpression [
	^ parsers at: #bracketIndexExpression ifAbsentPut: [ PEGParser named: 'BRACKET-INDEX-EXPRESSION' ]
]

{ #category : #expression }
P4SmalltalkGrammar >> preStoreCascadedMessageExpression [
	^ parsers at: #cascadedMessageExpression ifAbsentPut: [ PEGMultiParser named: 'CASCADED-MESSAGE-EXPRESSION' ]
]

{ #category : #expression }
P4SmalltalkGrammar >> preStoreMessageExpression [
	^ parsers at: #messageExpression ifAbsentPut: [ (PEGParser named: 'MESSAGE-EXPRESSION') memo ]
]

{ #category : #expression }
P4SmalltalkGrammar >> preStorePrimary [
	^ parsers at: #primary ifAbsentPut: [ (PEGParser named: 'PRIMARY') memo ]
]
