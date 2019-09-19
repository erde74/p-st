Class {
	#name : #P4ELFFileSymbol,
	#superclass : #P4ELFSymbol,
	#category : #'P4-Exec-ELF'
}

{ #category : #header }
P4ELFFileSymbol >> sectionHeaderIndex [
	" special section index: FILE "
	^ -15
]

{ #category : #header }
P4ELFFileSymbol >> size [
	^ 0
]

{ #category : #header }
P4ELFFileSymbol >> type [
	^ 16r4
]

{ #category : #header }
P4ELFFileSymbol >> value [
	^ 0
]
