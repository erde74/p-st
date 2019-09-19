Class {
	#name : #P4ELFObjectSymbol,
	#superclass : #P4ELFSymbol,
	#instVars : [
		'section'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #accessing }
P4ELFObjectSymbol >> initialize [ 
	super initialize.
	size := 0.
]

{ #category : #accessing }
P4ELFObjectSymbol >> section [
	^ section
]

{ #category : #accessing }
P4ELFObjectSymbol >> section: anObject [
	section := anObject
]

{ #category : #header }
P4ELFObjectSymbol >> sectionHeaderIndex [
	" special section index: COMMON "
	section ifNotNil: [ ^section headerIndex ].
	^ -14.
]

{ #category : #accessing }
P4ELFObjectSymbol >> sectionOffset [
	^ value
]

{ #category : #header }
P4ELFObjectSymbol >> type [
	^ 16r1
]
