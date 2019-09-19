Class {
	#name : #P4AbstractGrammar,
	#superclass : #P4Object,
	#instVars : [
		'parsers'
	],
	#category : #'P4-Parser'
}

{ #category : #'error handling' }
P4AbstractGrammar >> doesNotUnderstand: message [
	^ parsers
		at: message selector
		ifAbsentPut: [ |selector|
			selector := ('initialize' , message selector capitalized) asSymbol.
			(self respondsTo: selector)
				ifTrue: [ self perform: selector ]
				ifFalse: [ super doesNotUnderstand: message ] ]
]

{ #category : #initialization }
P4AbstractGrammar >> initialize [
	parsers := IdentityDictionary new.
]

{ #category : #parsing }
P4AbstractGrammar >> initializeSeparator [
	^ PEGParser separators
]

{ #category : #parsing }
P4AbstractGrammar >> match: string to: parser [ 
	^ parser match: (PEGStringScanner on: string separator: self separator)
]

{ #category : #accessors }
P4AbstractGrammar >> parsers [
	^ parsers
]
