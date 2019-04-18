Class {
	#name : #P4ELFFuncSymbol,
	#superclass : #P4ELFObjectSymbol,
	#category : #'P4-Exec-ELF'
}

{ #category : #accessing }
P4ELFFuncSymbol >> sectionHeaderIndex [
	^ section headerIndex
]

{ #category : #header }
P4ELFFuncSymbol >> type [
	^ 16r2
]
