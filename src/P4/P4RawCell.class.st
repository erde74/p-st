Class {
	#name : #P4RawCell,
	#superclass : #P4Object,
	#category : #'P4-Kernel-Memory'
}

{ #category : #accessing }
P4RawCell >> + number [
	<pNative: #plus module: #Memory>
]

{ #category : #accessing }
P4RawCell >> - number [
	<pNative: #minus module: #Memory>
]

{ #category : #accessing }
P4RawCell >> >> number [
	<pNative: #shiftRight module: #Memory>
]

{ #category : #testing }
P4RawCell >> isMarked [
	^ (self read bitAnd: 1) = 1
]

{ #category : #accessing }
P4RawCell >> read [
	<pNative: #read module: #Memory>
]

{ #category : #accessing }
P4RawCell >> write: aValue [
	<pNative: #write module: #Memory>
]
