Extension { #name : #UndefinedObject }

{ #category : #'*P4' }
UndefinedObject >> dumpGlobalOn: executableFormat [
	^ self dumpOn: executableFormat.
]

{ #category : #'*P4' }
UndefinedObject >> dumpLocalOn: executableFormat [
	^ executableFormat postpone: self
]

{ #category : #'*P4' }
UndefinedObject >> pExportedName [ 
	^ #nil
]
