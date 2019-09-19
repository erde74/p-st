Class {
	#name : #P4SmalltalkBehavior,
	#superclass : #P4Object,
	#instVars : [
		'methodDictionary',
		'class',
		'superbehavior'
	],
	#classInstVars : [
		'instance'
	],
	#category : #'P4-Kernel-Behavior'
}

{ #category : #'as yet unclassified' }
P4SmalltalkBehavior class >> for: aClass [
	^ self new setClass: aClass 
]

{ #category : #accessing }
P4SmalltalkBehavior >> dumpGlobalOn: bo [
	^ self dumpOn: bo
]

{ #category : #accessing }
P4SmalltalkBehavior >> dumpLocalOn: bo [
	^ bo postpone: self  
]

{ #category : #accessing }
P4SmalltalkBehavior >> initialize [ 
	methodDictionary := P4MethodDictionary new
]

{ #category : #accessing }
P4SmalltalkBehavior >> installMethod: aMethod [  
	methodDictionary at: aMethod selector put: aMethod 
]

{ #category : #'as yet unclassified' }
P4SmalltalkBehavior >> lookup: selector for: object [
	<groundTypes>
	<typeHint: #methods 	as: #'Kernel.Behavior.MethodDictionary'>
	<typeHint: #behavior 	as: #'Kernel.Behavior.SmalltalkBehavior'>

	| methods behavior |
	behavior := self.
	[ behavior == nil ] whileFalse: [
		methods := behavior methodDictionary.
		(methods at: selector) 
			ifNotNil: [ :method | ^ method ].
		behavior := behavior superbehavior ].
	
	^ P4DoesNotUnderstand new
]

{ #category : #accessing }
P4SmalltalkBehavior >> methodDictionary [
	^ methodDictionary
]

{ #category : #accessing }
P4SmalltalkBehavior >> methodDictionary: anObject [
	methodDictionary := anObject
]

{ #category : #accessing }
P4SmalltalkBehavior >> pExportedName [ 
	<preventExport>
	^ (self theClass pExportedName, '_behavior') asSymbol 
]

{ #category : #accessing }
P4SmalltalkBehavior >> setClass: aClass [
	class := aClass
]

{ #category : #accessing }
P4SmalltalkBehavior >> superbehavior [ 
	^ superbehavior 
]

{ #category : #accessing }
P4SmalltalkBehavior >> superbehavior: aBehavior [
	superbehavior := aBehavior
]

{ #category : #accessing }
P4SmalltalkBehavior >> superclass [ 
	^ superbehavior 
		ifNil: [ nil ]
		ifNotNil: [ superbehavior theClass ]
]

{ #category : #accessing }
P4SmalltalkBehavior >> superclass: aClass [
	aClass 
		ifNil: [ superbehavior := nil ]
		ifNotNil: [ superbehavior := aClass theBehavior ]
]

{ #category : #accessing }
P4SmalltalkBehavior >> theBehavior [
	^ self
]

{ #category : #accessing }
P4SmalltalkBehavior >> theClass [
	^ class
]
