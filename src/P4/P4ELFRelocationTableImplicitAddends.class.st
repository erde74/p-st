Class {
	#name : #P4ELFRelocationTableImplicitAddends,
	#superclass : #P4ELFRelocationTableExplicitAddends,
	#category : #'P4-Exec-ELF'
}

{ #category : #accessing }
P4ELFRelocationTableImplicitAddends >> absoluteRelocate: aSymbol at: codeStream addend: anAddend [
	data add: (P4ELF64RelocationEntry new
				absolute;
				symbol: aSymbol;
				offset: codeStream position).
				
	codeStream wordPut: anAddend
]

{ #category : #header }
P4ELFRelocationTableImplicitAddends >> entrySizeInPointers [
	^ 2
]

{ #category : #accessing }
P4ELFRelocationTableImplicitAddends >> relocate: aSymbol at: codeStream addend: addend [
"	self halt."
	data add: (P4ELF64RelocationEntry new
				relative;
				symbol: aSymbol;
				offset: codeStream position).
				
	codeStream wordPut: addend
]

{ #category : #accessing }
P4ELFRelocationTableImplicitAddends >> sizeInPointers [
	" address + symbol identifier "
	^ data size * 2
]

{ #category : #header }
P4ELFRelocationTableImplicitAddends >> type [
	" 9 REL Relocation entries without explicit addents (multiple) "
	^ 16r9
]
