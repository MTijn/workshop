---
title: Gebruiker wijzigen
---

# Gebruikers wijzigen

Wat nu als iemand een foutje maakt tijdens het aanmaken van een gebruiker? Laten we het modelijk maken
een gebruiker te wijzigen. In ons geval gaan we een gebruiker aanpassen door een PUT verzoek te doen
naar ons systeem.

## Database
```kotlin
@Throws(RuntimeException::class)
fun editUser(user: User) {
    if (!users.containsKey(user.id)) {
        throw RuntimeException(String.format("User with ID %d was not found for editing"))
    }
    users[user.id] = user
}
```
De totale class ziet er nu zo uit:
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
            throw RuntimeException(String.format("User with ID: %d already exists, can not add that user again", user.id))
        }
        users[user.id] = user
    }

    @Throws(RuntimeException::class)
    fun editUser(user: User) {
        if (!users.containsKey(user.id)) {
            throw RuntimeException(String.format("User with ID %d was not found for editing"))
        }
        users[user.id] = user
    }
}
```
Nu kan de database in ieder geval een gebruiker wijzigen, maar wat als de gebruiker niet bestaat? Dan zeggen we
dat er iets exceptioneels is gebeurd, en vertellen dan ook meteen wat er aan de hand was.

## Controller
```kotlin
@PutMapping("/users/{userId}", consumes = [MediaType.APPLICATION_JSON_VALUE])
fun editUser(@PathVariable userId: Int, @RequestBody user: User): ResponseEntity<Any> {
    return try {
        if (userDatabase.showSingleUser(userId) == null) {
            throw RuntimeException(String.format("The user with ID %d does not exist can not continue", userId))
        }

        userDatabase.editUser(user)
        ResponseEntity.ok().build()
    } catch (runtimeException: RuntimeException) {
        ResponseEntity.badRequest().body(runtimeException.message)
    }
}
```

Nu ziet de totale class er zo uit:
```kotlin
package com.enreach.workshop

import io.swagger.models.Response
import org.springframework.http.HttpStatus
import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.*
import org.springframework.web.servlet.support.ServletUriComponentsBuilder
import java.net.URI


@RestController
class UserController(val userDatabase: UserDatabase) {
    @GetMapping("/users", produces = [MediaType.APPLICATION_JSON_VALUE])
    fun showUsers(): ResponseEntity<Any> {
        return ResponseEntity.ok(userDatabase.showAllUsers())
    }

    @GetMapping("/users/{userId}")
    fun showSingleUser(@PathVariable userId: Int): ResponseEntity<Any>
    {
        val user = userDatabase.showSingleUser(userId) ?: return ResponseEntity.notFound().build()
        return ResponseEntity.ok(user)
    }

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

    @PutMapping("/users/{userId}", consumes = [MediaType.APPLICATION_JSON_VALUE])
    fun editUser(@PathVariable userId: Int, @RequestBody user: User): ResponseEntity<Any> {
        return try {
            if (userDatabase.showSingleUser(userId) == null) {
                throw RuntimeException(String.format("The user with ID %d does not exist can not continue", userId))
            }

            userDatabase.editUser(user)
            ResponseEntity.ok().build()
        } catch (runtimeException: RuntimeException) {
            ResponseEntity.badRequest().body(runtimeException.message)
        }
    }
}
```

Als je het goed gedaan hebt, kan je op ![Re-run build](/re_run.png) klikken, dat zal de applicatie opnieuw opstarten. Als
je nu weer naar [http://localhost:8080](http://lodalhost:8080) gaan, zul je zien dat we een PUT URL erbij hebben
gekregen voor de user-controller. Ga je gang en kijk of je een gebruiker kan veranderen.