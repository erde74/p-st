Class {
	#name : #P4ClassReference,
	#superclass : #P4Object,
	#instVars : [
		'cls',
		'package'
	],
	#category : #'P4-Kernel-Package'
}

{ #category : #iterating }
P4ClassReference >> classesDo: action [
	action value: cls
]

{ #category : #accessing }
P4ClassReference >> cls [
	^ cls
]

{ #category : #accessing }
P4ClassReference >> cls: anObject [
	cls := anObject
]

{ #category : #accessing }
P4ClassReference >> package [
	^ package
]

{ #category : #accessing }
P4ClassReference >> package: anObject [
	package := anObject.
	cls ifNotNil: [ cls package: anObject ]  
]

{ #category : #iterating }
P4ClassReference >> packagesDo: action [

]
