# Input Manager
``` mermaid
graph TD
  A[MainNode] -- Calles --> B[InputManager]
  B -- Deicides Input type --> C[Handle Input]
  B --> C[Zoomed in inputs]
  B --> D[World map input]
  B --> E[Look input]
  B --> F[UI input]
  ```