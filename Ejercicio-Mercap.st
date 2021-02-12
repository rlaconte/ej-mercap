!classDefinition: #CallTest category: 'Ejercicio-Mercap'!
TestCase subclass: #CallTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap'!

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 16:58:49'!
test00_CanCalculateCostWhenCallCoversMoreThanTwoMidnights
	"| end start testCall |
	start := DateAndTime year: 2020 day: 1 hour: 12 minute: 0 second: 0.
	end := start + (Duration days: 2).
	testCall := Call from: start to: end.
	self assert: (testCall cost = 576)."! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 13:23:09'!
test01_10MinuteCallLasts10Minutes
	| end start testCall |
	start := DateAndTime year: 2020 day: 1 hour: 0 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	self assert: (testCall lastsMinutes: 10).! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 13:23:18'!
test02_CanNotCreateCallThatStartsAfterItEnds
	| end start |
	start := DateAndTime year: 2020 day: 1 hour: 0 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	self 
		should: [Call from: end to: start.]
		raise: Error - MessageNotUnderstood
		withExceptionDo: [ :anError | self assert: anError messageText = Call invalidDateAndTimeErrorMessage.]! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 13:23:29'!
test04_10MinuteCallOnBusinessDayCosts2
	| end start testCall |
	start := DateAndTime year: 2020 day: 1 hour: 0 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	self assert: (testCall cost = 2).! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 13:23:39'!
test05_10MinuteCallOnNonBusinessDayCosts1
	| end start testCall |
	start := DateAndTime year: 2020 day: 4 hour: 0 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	self assert: (testCall cost = 1).! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 13:24:32'!
test06_5MinutesOnBusinessDayAnd5MinutesOnNextBusinessDayCosts2
	| end start testCall |
	start := DateAndTime year: 2020 day: 1 hour: 23 minute: 55 second: 0.
	end := start + (Duration minutes: 10).
	testCall := Call from: start to: end.
	self assert: (testCall cost = 2).! !

!CallTest methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 17:40:47'!
test07_InternationalCallCostDependsOnCountryCalled
	| end start testCall countriesCallCost |
	start := DateAndTime year: 2020 day: 1 hour: 0 minute: 0 second: 0.
	end := start + (Duration minutes: 10).
	countriesCallCost := Dictionary new.
	countriesCallCost add: #Brasil->10.
	testCall := Call from: start to: end country: #Brasil.
	self assert: (testCall costWith: countriesCallCost = 100).! !


!classDefinition: #Call category: 'Ejercicio-Mercap'!
Object subclass: #Call
	instanceVariableNames: 'startingDateAndTime endingDateAndTime'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap'!

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 23:14:57'!
appliesTo: monthName
	^endingDateAndTime monthName = monthName ! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 17:31:46'!
costWith: costsList
	self subclassResponsibility ! !

!Call methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 16:30:32'!
lastsMinutes: anAmountOfMinutes
	^ anAmountOfMinutes = (endingDateAndTime - startingDateAndTime) totalMinutes! !

"-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- "!

!classDefinition: 'Call class' category: 'Ejercicio-Mercap'!
Call class
	instanceVariableNames: ''!

!Call class methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 17:25:59'!
from: startingDateAndTime to: endingDateAndTime
	startingDateAndTime > endingDateAndTime ifTrue: [self error: self invalidDateAndTimeErrorMessage].
	^LocalCall new from: startingDateAndTime to: endingDateAndTime.! !

!Call class methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 17:28:38'!
from: startingDateAndTime to: endingDateAndTime country: countryCalled
	startingDateAndTime > endingDateAndTime ifTrue: [self error: self invalidDateAndTimeErrorMessage].
	^InternationalCall new from: startingDateAndTime to: endingDateAndTime country: countryCalled .! !

!Call class methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 12:32:51'!
invalidDateAndTimeErrorMessage
	^'Starting and/or ending date and times are invalid'! !


!classDefinition: #InternationalCall category: 'Ejercicio-Mercap'!
Call subclass: #InternationalCall
	instanceVariableNames: 'countryCalled'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap'!

!InternationalCall methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 17:34:07'!
costWith: costsList
	^(endingDateAndTime - startingDateAndTime) totalMinutes * (costsList at: countryCalled) ! !

!InternationalCall methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 17:29:49'!
from: start to: end country: country
	startingDateAndTime :=  start.
	endingDateAndTime := end.
	countryCalled := country.! !


!classDefinition: #LocalCall category: 'Ejercicio-Mercap'!
Call subclass: #LocalCall
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap'!

!LocalCall methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 17:34:21'!
cost
	| accumulatedCost nextDate firstDayName |
	accumulatedCost := 0.
	nextDate := (startingDateAndTime + (Duration days: 1)) date.
	firstDayName := startingDateAndTime dayOfWeekName.
	nextDate > endingDateAndTime date
	ifTrue: [
		(firstDayName = #Sunday or: firstDayName = #Saturday) 
			ifTrue: [accumulatedCost := accumulatedCost + ((endingDateAndTime - startingDateAndTime) totalMinutes * 0.1)]
			ifFalse: [	accumulatedCost := accumulatedCost + ((endingDateAndTime - startingDateAndTime) totalMinutes * 0.2)].
		]
	ifFalse: [
		(firstDayName = #Sunday or: firstDayName = #Saturday) 
			ifTrue: [accumulatedCost := accumulatedCost + (((DateAndTime date: nextDate time: Time new) - startingDateAndTime) totalMinutes * 0.1)]
			ifFalse: [accumulatedCost := accumulatedCost + (((DateAndTime date: nextDate time: Time new) - startingDateAndTime) totalMinutes * 0.2)].
		(nextDate = #Sunday or: nextDate = #Saturday) 
			ifTrue: [accumulatedCost := accumulatedCost + ((endingDateAndTime - (DateAndTime date: nextDate time: Time new)) totalMinutes * 0.1)]
			ifFalse: [accumulatedCost := accumulatedCost + ((endingDateAndTime - (DateAndTime date: nextDate time: Time new)) totalMinutes * 0.2)].
		].
	^accumulatedCost .
	"| accumulatedCost nextDate actualDayName actualDateTime |
	accumulatedCost := 0.
	actualDateTime := startingDateAndTime.
	actualDayName := actualDateTime dayOfWeekName.
	nextDate := (actualDateTime + (Duration days: 1)) date.
	[nextDate > endingDateAndTime date] 
		whileFalse: [
			(actualDayName = #Sunday or: actualDayName = #Saturday) 
				ifTrue: [accumulatedCost := accumulatedCost + (((DateAndTime date: nextDate time: Time new) - actualDateTime) totalMinutes * 0.1)]
				ifFalse: [accumulatedCost := accumulatedCost + (((DateAndTime date: nextDate time: Time new) - actualDateTime) totalMinutes * 0.2)].
			actualDateTime := DateAndTime date: nextDate time: Time new.
			nextDate := (actualDateTime + (Duration days: 1)) date.
			actualDayName := actualDateTime dayOfWeekName.
		].
	(actualDayName = #Sunday or: actualDayName = #Saturday) 
		ifTrue: [accumulatedCost := accumulatedCost + ((endingDateAndTime - actualDateTime) totalMinutes * 0.1)]
		ifFalse: [accumulatedCost := accumulatedCost + ((endingDateAndTime - actualDateTime) totalMinutes * 0.2)]."! !

!LocalCall methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 17:32:45'!
costWith: costsList
	^self cost! !

!LocalCall methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 17:30:00'!
from: start to: end
	startingDateAndTime :=  start.
	endingDateAndTime := end.! !


!classDefinition: #Client category: 'Ejercicio-Mercap'!
Object subclass: #Client
	instanceVariableNames: 'calls'
	classVariableNames: ''
	poolDictionaries: ''
	category: 'Ejercicio-Mercap'!

!Client methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 23:14:02'!
createReceiptFor: monthName with: costsList andBasePaymentOf: monthlyPayment
	"Recorrer todas las llamadas de la variable de instancia calculando y acumulando los costos solo si las llamadas finalizan en el mes indicado.
	Los acumulados deberian ser distintos para las llamadas locales y las internacionales/nacionales"
	| internationalConsumption localConsumption |
	localConsumption := 0.
	internationalConsumption := 0.
	calls do: [ :call | 
		(call appliesTo: monthName) ifTrue: [
			(call isKindOf: InternationalCall) ifTrue: [internationalConsumption := internationalConsumption + call costWith: costsList].
			(call isKindOf: LocalCall) ifTrue: [localConsumption := localConsumption + call costWith: costsList].
		]
	].
	^OrderedCollection with: monthlyPayment with: localConsumption with: internationalConsumption ! !

!Client methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 22:30:29'!
initialize
	calls := OrderedCollection new.! !

!Client methodsFor: 'as yet unclassified' stamp: 'RL 2/11/2021 22:30:46'!
registerCall: aCall
	calls addLast: aCall! !
