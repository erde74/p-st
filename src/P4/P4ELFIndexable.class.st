Class {
	#name : #P4ELFIndexable,
	#superclass : #P4Object,
	#instVars : [
		'name',
		'nameIndex',
		'symbolTableIndex',
		'symbolTable'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #accessing }
P4ELFIndexable >> name [
	^ name

]

{ #category : #header }
P4ELFIndexable >> name: aName [
	name := aName
]

{ #category : #accessing }
P4ELFIndexable >> nameIndex [
	^ nameIndex
]

{ #category : #accessing }
P4ELFIndexable >> nameIndex: anObject [
	nameIndex := anObject
]

{ #category : #accessing }
P4ELFIndexable >> symbolTable: aSymbolTable [
	symbolTable := aSymbolTable 
]

{ #category : #accessing }
P4ELFIndexable >> symbolTableIndex [
	^ symbolTableIndex
]

{ #category : #accessing }
P4ELFIndexable >> symbolTableIndex: anObject [
	symbolTableIndex := anObject
]
