# ClassroomClone

I tried to make a clone of Google Classroom.

Let's see where it takes me.

There's a `dev` file for running development server. I'm too lazy to type that all.

# Getting Started

- Go to [Google Cloud Console](https://console.cloud.google.com/) and create a new project.
- Go to API & Services, then OAuth consent screen, and create a new Web Client.
- Put `http://localhost:4000/auth/google/callback` in Authorized redirect URIs.
- Copy the Client ID and Client Secret.
- Paste the Client ID and Client Secret in `.env` file (see the `.env.example` for format).
- Install dependencies

```sh
$ mix deps.get
```

- Run the `dev` file

```sh
$ ./dev
```

Visit `localhost:4000`.

## License

See [LICENSE](LICENSE) file for more information.
