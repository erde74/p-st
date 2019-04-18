Class {
	#name : #P4ELFNoTypeSymbol,
	#superclass : #P4ELFSymbol,
	#category : #'P4-Exec-ELF'
}

{ #category : #header }
P4ELFNoTypeSymbol >> sectionHeaderIndex [
	" special section index: COMMON "
	^ 0
]

{ #category : #header }
P4ELFNoTypeSymbol >> size [
	^ 16r0
]

{ #category : #header }
P4ELFNoTypeSymbol >> type [
	^ 16r0
]

{ #category : #header }
P4ELFNoTypeSymbol >> value [
	^ 16r0
]
