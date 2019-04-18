Class {
	#name : #P4Metaclass,
	#superclass : #P4Behavior,
	#instVars : [
		'instance'
	],
	#category : #'P4-Kernel-Behavior'
}

{ #category : #exporting }
P4Metaclass class >> pExportedName [
	^ self == P4Metaclass
		ifTrue: [ #Metaclass ]
		ifFalse: [ super pExportedName ]
]

{ #category : #accessing }
P4Metaclass >> instance: aClass [
	instance := aClass
]

{ #category : #accessing }
P4Metaclass >> pExportedName [ 
	^ (instance pExportedName,'_class') asSymbol 
]
