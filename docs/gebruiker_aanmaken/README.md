---
title: Gebruikers aanmaken
---
# Gebruiker aanmaken

Nu hebben we dus 3 gebruikers in ons systeem staan, maar wat nu als we er een extra gebruiker
bij willen? Daar kunnen we een aparte URL voor maken. 

::: details Wat is een URL?
URL staat voor Uniform Resource Locator, vergelijkbaar met je huisnummer en postcode. Hiermee kunnen
we door het internet navigeren, voorbeelden van een URL: https://nu.nl, https://enreach.com
:::

Om een gebruiker toe te voegen gaan we de code aanpassen die we eerder hebben gemaakt.

## User database
De user database gaan we uitbreiden met een nieuwe functie, voeg deze code maar onderaan de class
toe.

```kotlin
@Throws(RuntimeException::class)
fun addUser(user: User) {
    if (users.containsKey(user.id)) {
        throw RuntimeException("User with ID: {$user.id} already exists, can not add that user again")
    }
    users.put(user.id, user)
}
```

Sla de class op en de class ziet er nu zo uit:
```kotlin
package com.enreach.workshop

import org.springframework.stereotype.Repository
import java.lang.RuntimeException

@Repository
class UserDatabase {
    private val users: MutableMap<Int, User> = mutableMapOf<Int, User>(
        Pair(1, User(1, "test@test.nl", "Eerste tester")),
        Pair(2, User(2, "test2@test.nl", "Tweede tester")),
        Pair(3, User(3, "test3@test.nl", "Derde tester"))
    )

    fun showAllUsers(): Map<Int, User> {
        return users
    }

    fun showSingleUser(id: Int): User? {
        return users[id]
    }

    @Throws(RuntimeException::class)
    fun addUser(user: User) {
        if (users.containsKey(user.id)) {
            throw RuntimeException(String.format("User with ID: %s already exists, can not add that user again", user.id))
        }
        users.put(user.id, user)
    }
}
```

Wat hebben we nu gedaan? We hebben het nu mogelijk gemaakt om een gebruiker toe te voegen, maar we willen
niet dat we gebruikers overscrijven, want die bestaan al! Dus we controleren eerst of er al niet een gebruiker met
dat ID bestaat in ons systeem, en dan voegen pas voegen we een nieuwe toe.

## User controller

Nu we de database aangepast hebben gaan we het mogelijk maken dat de gebruiker ook echt toegevoegd kan worden
door de applicatie uit te breiden. Plak deze code maar eens onderaan de ``UserController`` class.

```kotlin
@PostMapping("/users", consumes = [MediaType.APPLICATION_JSON_VALUE])
fun createUser(@RequestBody user: User): ResponseEntity<Any> {
    return try {
        userDatabase.addUser(user)
        val location: URI = ServletUriComponentsBuilder
            .fromCurrentRequest()
            .buildAndExpand(user.id)
            .toUri()
        ResponseEntity.created(location).build()
    } catch (runtimeException: RuntimeException) {
        ResponseEntity.status(HttpStatus.CONFLICT).body(runtimeException.message)
    }
}
```

Wat hebben we nu gedaan dan? We hebben ons systeem verteld dat we graag een gebruiker willen kunnen
toevoegen, we noemen dat een POST. Probeer maar eens uit, als je op het re-run icoontje klikt ![Re-run build](/re_run.png)
even wachten tot ons systeem weer online is en dan kan je klikken op [http://localhost:8080](http://lodalhost:8080)

Je zal zien dat je een nieuwe URL erbij hebt gekregen: ![Re-run build](/user_post.png)

::: tip
Probeer ook eens een nieuwe gebruiker aan te maken met een id dat al bestaat! Je zal zien dat dit niet mag
:::
