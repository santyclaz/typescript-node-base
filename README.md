# Running with Docker Compose

1. Run `docker compose up`
   ```sh
   docker compose up -d
   ```
2. Run the desired command in `service` container
   - _**Example**_: Run the `hello-world.ts` script
     ```sh
     docker compose exec service node hello-world.ts
     ```
   - _**Example**_: Start the example webserver
     ```sh
     docker compose exec service node server.ts
     ```
     visit [http://localhost:3000/health](http://localhost:3000/health)
3. To clean-up containers, run `docker compose down`
   ```sh
   docker compose down
   ```

# Running with Dev Containers in VS Code

1. Make sure you have `Dev Containers` extension or equivalent installed along with `Docker`
2. Open this folder in VS Code
3. Run command `Dev Containers: Rebuid and Reopen in Container`
4. Run the desired command in the VS Code terminal
   - _**Example**_: Run the `hello-world.ts` script
     ```sh
     node hello-world.ts
     ```
   - _**Example**_: Start the example webserver
     ```sh
     node server.ts
     ```
     visit [http://localhost:3000/health](http://localhost:3000/health)

**Note**: By default Claude Code is installed in the dev container. To disable, comment out `"./compose.claude.yml"` in [`.devcontainer/devcontainer.yml`](./.devcontainer/devcontainer.json).

# Resources

- [Ultimate Guide to Dev Containers](https://www.daytona.io/dotfiles/ultimate-guide-to-dev-containers)
- [How to Safely Run AI Agents Like Cursor and Claude Code Inside a DevContainer](https://codewithandrea.com/articles/run-ai-agents-inside-devcontainer/)
