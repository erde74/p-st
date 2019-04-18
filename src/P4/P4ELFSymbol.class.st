Class {
	#name : #P4ELFSymbol,
	#superclass : #P4ELFIndexable,
	#instVars : [
		'value',
		'size',
		'visibility',
		'bind'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #'as yet unclassified' }
P4ELFSymbol class >> pname [
	<preventExport>
	^ pname ifNil: [ pname := (self name copyFrom: 'P4ELF' size + 1 to: self name size) asSymbol ]
]

{ #category : #accessing }
P4ELFSymbol >> bind [
	^ bind
]

{ #category : #visibility }
P4ELFSymbol >> default [
	visibility := 16r0
]

{ #category : #bind }
P4ELFSymbol >> global [
	bind := 16r1
]

{ #category : #visibility }
P4ELFSymbol >> hidden [
	visibility := 16r2
]

{ #category : #header }
P4ELFSymbol >> info [
	^ 0
]

{ #category : #'initialize-release' }
P4ELFSymbol >> initialize [
	nameIndex := 0.
	self
		local;
		default.
]

{ #category : #visibility }
P4ELFSymbol >> internal [
	visibility := 16r1
]

{ #category : #bind }
P4ELFSymbol >> isLocal [
	^ bind = 16r0
]

{ #category : #bind }
P4ELFSymbol >> local [
	bind := 16r0
]

{ #category : #header }
P4ELFSymbol >> other [
	^ 0
]

{ #category : #visibility }
P4ELFSymbol >> protected [
	visibility := 16r3
]

{ #category : #header }
P4ELFSymbol >> sectionHeaderIndex [
	^ 16r0
]

{ #category : #accessing }
P4ELFSymbol >> size [
	^ size
]

{ #category : #accessing }
P4ELFSymbol >> size: anObject [
	size := anObject
]

{ #category : #accessing }
P4ELFSymbol >> value [
	^ value

]

{ #category : #accessing }
P4ELFSymbol >> value: anObject [
	value := anObject
]

{ #category : #accessing }
P4ELFSymbol >> visibility [
	^ visibility
]

{ #category : #bind }
P4ELFSymbol >> weak [
	bind := 16r2
]

{ #category : #writing }
P4ELFSymbol >> writeSymbolOn: aStream [
	aStream wordPut: self nameIndex.
	aStream nextPut: (self bind << 4) + (self type bitAnd: 16rF).
	aStream nextPut: self other.
	aStream halfWordPut: self sectionHeaderIndex.
	aStream pointerPut: self value.
	aStream pointerPut: self size
]
