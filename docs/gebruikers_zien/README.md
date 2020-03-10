---
title: Gebruikers zien
---
# Gebruikers laten zien

Nu hebben we al wat kleine dingen gedaan, maar tot nu to hebben we nog steeds geen gebruiker
kunnen laten zien. Dat gaan we nu veranderen, we gaan de gebruikers laten zien in het JSON
formaat.

::: tip
JSON staat voor JavaScript Object Notation, en dit een standaard waarmee je leesbare tekst kan
opslaan in een database
:::

We beginnen door een nieuw bestand aan te maken, ``UserController``, op dezelfde manier zoals we eerder
hebben gedaan, dus linker muisknop op ``com/enreach/workshop`` en kiezen voor new Kotlin File/Class

![Nieuw bestand aanmaken](/user_controller.png)

Hier gebruiken we weer code om ons de gebruikers te laten zien

```kotlin
package com.enreach.workshop

import org.springframework.http.MediaType
import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController

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
}
```

Laten we eens kijken wat we nu eigenlijk gemaakt hebben, sla het bestand op en als je op dit play knopje ![Applicatie runnen](/run_application.png) klikt
dan zal de applicatie starten, je kan nu de applicatie openen door naar [http://localhost:8080](http://localhost:8080) te browsen.

Je zal nu de volgende 2 items zien ![User endpoint](/user_endpoint.png)

Probeer maar eens of je de gebruikers terug kan vinden die in onze database staan.
