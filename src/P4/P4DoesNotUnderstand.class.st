Class {
	#name : #P4DoesNotUnderstand,
	#superclass : #P4Object,
	#type : #variable,
	#instVars : [
		'selector',
		'arguments'
	],
	#category : #'P4-Kernel-Callable'
}

{ #category : #accessing }
P4DoesNotUnderstand >> arguments [
	^ arguments
]

{ #category : #'as yet unclassified' }
P4DoesNotUnderstand >> perform: aSelector on: receiver with: args [
	<groundTypes>
	<typeHint: #receiver as: #'Kernel.Object.Object'>
	arguments := args.
	selector := aSelector.
	^ receiver doesNotUnderstand: self  
]

{ #category : #accessing }
P4DoesNotUnderstand >> selector [
	^ selector
]
