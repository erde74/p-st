Class {
	#name : #P4ELFStringSet,
	#superclass : #P4Object,
	#instVars : [
		'strings',
		'size'
	],
	#category : #'P4-Exec-ELF'
}

{ #category : #'as yet unclassified' }
P4ELFStringSet >> add: string [
	^ strings at: string ifAbsentPut: [ |result|
		result := size.
		size := size + string size + 1.
		result ]
]

{ #category : #'as yet unclassified' }
P4ELFStringSet >> initialize [ 
	strings := Dictionary new.
	size := 0.
]

{ #category : #'as yet unclassified' }
P4ELFStringSet >> putOn: aStream [
	strings keys reverseDo: [ :string |
		aStream 
			<< string;
			nextPut: 0 ]
]

{ #category : #'as yet unclassified' }
P4ELFStringSet >> size [
	^size
]
