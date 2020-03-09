---
title: Gebruiker verwijderen
---

# Gebruiker verwijderen
Wat nu als de gebruiker niet meer in ons systeem wil staan? Dat kan, dat doen we met een
DELETE verzoek. Laten we eens kijken hoe we die maken, het geheel bestaat weer uit 2 delen
een deel voor de database zelf, en de controller welke ervoor zorgt dat er ook dingen gedaan worden in
de database.

## Database code
```kotlin
@Throws(RuntimeException::class)
fun deleteUser(user: User) {
    if (!users.containsKey(user.id)) {
        throw RuntimeException(String.format("User with ID %d was not found for deleting", user.id))
    }
    users.remove(user.id)
}
```
De totale class ziet er nu dan zo uit:
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
            throw RuntimeException(String.format("User with ID %d was not found for editing", user.id))
        }
        users[user.id] = user
    }

    @Throws(RuntimeException::class)
    fun deleteUser(user: User) {
        if (!users.containsKey(user.id)) {
            throw RuntimeException(String.format("User with ID %d was not found for deleting", user.id))
        }
        users.remove(user.id)
    }
}
```

## User controller
Nu we de database aangepast hebben, kunnen we ons systeem een gebruiker dan ook echt
kunnen laten verwijderen.

We kunnen nu de volgende code toevoegen

```kotlin
@DeleteMapping("/users/{userId}")
fun deleteUser(@PathVariable userId: Int): ResponseEntity<Any> {
    return try {
        val user = userDatabase.showSingleUser(userId)
            ?: throw RuntimeException(String.format("The user with ID %d does not exist can not continue", userId))

        userDatabase.deleteUser(user)
        ResponseEntity.ok().build()
    } catch (runtimeException: RuntimeException) {
        ResponseEntity.notFound().build()
    }
}
```

En dan ziet het totaal er nu zo uit:
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

    @DeleteMapping("/users/{userId}")
    fun deleteUser(@PathVariable userId: Int): ResponseEntity<Any> {
        return try {
            val user = userDatabase.showSingleUser(userId)
                ?: throw RuntimeException(String.format("The user with ID %d does not exist can not continue", userId))

            userDatabase.deleteUser(user)
            ResponseEntity.ok().build()
        } catch (runtimeException: RuntimeException) {
            ResponseEntity.notFound().build()
        }
    }
}
```