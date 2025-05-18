# Input Manager
``` mermaid
graph TD
  A[MainNode] -- Calles --> B[InputManager]
  B -- Deicides Input type --> C[Handle Input]
  C --> [Zoomed in inputs]
  C --> [World map input]
  C --> [Look input]
  C --> [UI input]
  ```