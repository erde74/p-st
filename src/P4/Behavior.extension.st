Extension { #name : #Behavior }

{ #category : #'*P4' }
Behavior >> mapToPclass [
	^ {
	
	Object 				-> P4Object. 
	Behavior 			-> P4Behavior.
	Metaclass 			-> P4Metaclass.
	Class 				-> P4Class.
	IdentityDictionary 	-> P4IdentityDictionary.
	Dictionary 			-> P4Dictionary.
	Array 				-> P4Array.
	ByteSymbol 		-> P4Symbol.
	ByteString 			-> P4String.
	UndefinedObject 	-> P4UndefinedObject.
	True 				-> P4True.
	False 				-> P4False.
	SmallInteger 		-> P4SmallInteger.
	
	} asDictionary at: self ifAbsent: [ self error: 'Trying to export invalid class' ]
		
  
]

{ #category : #'*P4' }
Behavior >> pLookupSelector: aSelector [
	| method |
	method := self lookupSelector: aSelector.
	^ (method methodClass mapToPclass methodDict) 	at: aSelector
]
