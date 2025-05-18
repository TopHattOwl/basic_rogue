# Input Manager
``` mermaid
graph TD
  A[MainNode] -- Calles --> B[InputManager]
  B -- Deicides Input type --> C[Handle Input]
  C --> D[Zoomed in inputs]
  C --> E[World map input]
  C --> F[Look input]
  C --> G[UI input]
  ```