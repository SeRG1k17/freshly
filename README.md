[**Freshly - Mobile Technical Interview**](https://docs.google.com/document/d/10oP4IUxjJtckOv9W3zndulpqEaMWMq_4uA7vJ98k_SE/edit)
### Short description

![Scheme](https://habrastorage.org/web/fe8/c82/a32/fe8c82a32b1548b1a297187e24ae755a.png)
Clean Architecture with separate targets:
1. Application (named Freshly)
2. Presentation
3. Domain
4. Platform
5. Common target (contains helpers, extensions, etc.)

#### Additional notes
* Unit tests implemented in Platform by RxTest
* UI tests implemented in the main target
