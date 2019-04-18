Class {
	#name : #P4BinarySymbolOut,
	#superclass : #P4BinaryOut,
	#category : #'P4-Exec'
}

{ #category : #'as yet unclassified' }
P4BinarySymbolOut >> symbol: aSymbol [
	^ aSymbol dumpOn: self
]
