Class {
	#name : #P4Class,
	#superclass : #P4Behavior,
	#instVars : [
		'name',
		'package'
	],
	#category : #'P4-Kernel-Behavior'
}

{ #category : #exporting }
P4Class >> dumpGlobalOn: bo [
	self error: 'Should go via pharo class'
]

{ #category : #exporting }
P4Class >> dumpLocalOn: bo [
	self error: 'Should go via pharo class'
]

{ #category : #accessing }
P4Class >> name [
	^ name

]

{ #category : #accessing }
P4Class >> name: anObject [
	name := anObject
]

{ #category : #exporting }
P4Class >> pExportedName [
	^ (self package relativeNameFor: self name) asSymbol
]

{ #category : #accessing }
P4Class >> package [
	^ package
]

{ #category : #accessing }
P4Class >> package: anObject [
	package := anObject
]

{ #category : #accessing }
P4Class >> printOn: aStream [
	aStream << name.
]
