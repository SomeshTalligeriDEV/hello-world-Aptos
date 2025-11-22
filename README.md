# Hello Aptos - A Simple Message Storage Smart Contract

This is a beginner-friendly smart contract built on the Aptos blockchain using the Move programming language. The contract allows users to store and retrieve personalized messages on-chain, demonstrating fundamental concepts of decentralized storage and blockchain interactions.

## What This Project Does

At its core, this smart contract provides two main capabilities:

1. **Store a Message**: Users can save a text message to their account on the blockchain
2. **Retrieve a Message**: Anyone can read the message stored by a specific account

Think of it as a decentralized notepad where each account can maintain one message at a time. When you set a new message, it automatically replaces any previous message you had stored.

## Project Structure

The project is organized into several key directories:

- `sources/` - Contains the main smart contract code
  - `hello-aptos.move` - The production-ready contract
- `tests/` - Contains test modules with debug logging
  - `hello_aptos_test.move` - Test version with detailed console output
- `Move.toml` - Package configuration and dependencies
- `scripts/` - Utility scripts for deployment and interaction
- `.aptos/` - Local configuration files (generated automatically)

## Prerequisites

Before you can work with this project, you'll need to have the following installed on your system:

1. **Aptos CLI** - The command-line tool for interacting with the Aptos blockchain
   - Installation guide: https://aptos.dev/tools/aptos-cli/install-cli/
   - Verify installation: `aptos --version`

2. **Git** - For cloning the repository and version control
   - Most systems have this pre-installed
   - Check with: `git --version`

## Getting Started

### Step 1: Clone or Download the Project

If you're getting this code from a repository, clone it to your local machine:

```bash
git clone <repository-url>
cd aptos1
```

If you already have the code, simply navigate to the project directory.

### Step 2: Install Dependencies

The project depends on the Aptos Framework, which provides standard library functions for Move. To download these dependencies, run:

```bash
aptos move compile
```

This command does two things:
- Downloads the Aptos Framework from GitHub
- Compiles your smart contract to verify there are no errors

You should see a success message once compilation is complete.

### Step 3: Set Up Your Aptos Account

If you don't already have an Aptos account configured, you'll need to create one:

```bash
aptos init
```

This interactive command will:
- Ask you to choose a network (select `testnet` for development)
- Generate a new account or allow you to import an existing one
- Save your configuration to `.aptos/config.yaml`

The configuration file will contain your account address and private key. Keep this information secure and never commit it to public repositories.

### Step 4: Fund Your Account

To deploy contracts and execute transactions on the testnet, you need APT tokens (Aptos's native cryptocurrency). Get free testnet tokens using the faucet:

```bash
aptos account fund-with-faucet --account <your-account-address> --amount 100000000
```

Replace `<your-account-address>` with the address shown in your `.aptos/config.yaml` file. The amount is specified in Octas (1 APT = 100,000,000 Octas), so this command gives you 1 APT.

You can verify your balance with:

```bash
aptos account list --account <your-account-address>
```

### Step 5: Deploy the Contract

Now you're ready to publish your smart contract to the blockchain:

```bash
aptos move publish --named-addresses move_publisher=<your-account-address>
```

This command takes the compiled Move bytecode and stores it on-chain under your account. The `--named-addresses` flag replaces the placeholder address in `Move.toml` with your actual account address.

If successful, you'll see a transaction hash and confirmation that the module was published.

## Using the Contract

Once deployed, you can interact with your contract using the Aptos CLI.

### Storing a Message

To save a message to your account:

```bash
aptos move run \
  --function-id <your-account-address>::hello_aptos::set_message \
  --args string:"Hello, Aptos blockchain!"
```

This executes the `set_message` function, passing your desired text as an argument. The contract will:
- Check if you already have a message stored
- Remove the old message if one exists
- Store your new message

### Reading a Message

To retrieve a message from any account (including your own):

```bash
aptos move view \
  --function-id <your-account-address>::hello_aptos::get_message \
  --args address:<account-to-query>
```

Replace `<account-to-query>` with the address whose message you want to read. This is a read-only operation that doesn't cost any gas fees.

The command will return the stored message, or fail with an error if no message exists for that account.

## Understanding the Code

### The MessageHolder Resource

```move
struct MessageHolder has key, store, drop {
    message: string::String
}
```

This is the data structure that gets stored on the blockchain. The abilities (`key`, `store`, `drop`) define how the resource can be used:
- `key` - Can be stored directly in global storage
- `store` - Can be stored inside other resources
- `drop` - Can be automatically deleted when no longer needed

### The set_message Function

```move
public entry fun set_message(
    account: &signer, message: string::String
) acquires MessageHolder
```

This is an entry function, meaning it can be called directly through transactions. It takes two parameters:
- `account` - A reference to the signer (proves you own the account)
- `message` - The text string to store

The function removes any existing message before storing the new one, ensuring each account only has one message at a time.

### The get_message Function

```move
#[view]
public fun get_message(account_addr: address): string::String acquires MessageHolder
```

The `#[view]` attribute marks this as a read-only function that doesn't modify blockchain state. It simply reads and returns the stored message for a given address.

## Testing Your Changes

When developing, you should test your code before deploying. The test module in `tests/hello_aptos_test.move` includes debug logging that helps you understand what's happening during execution.

Run tests with:

```bash
aptos move test
```

This executes all test functions in your project and displays any debug output.

## Common Issues and Solutions

### "Unresolved reference" Errors

If you see errors about unresolved references (like `String` not being found), it usually means the Aptos Framework dependencies haven't been downloaded yet. Run:

```bash
aptos move compile
```

This fetches all required dependencies and should resolve the issue.

### "Unresolved addresses" Errors

If you get an error about unresolved addresses for `move_publisher`, you need to specify your account address when compiling or publishing:

```bash
aptos move compile --named-addresses move_publisher=<your-account-address>
```

### Insufficient Balance

If transactions fail due to insufficient funds, request more testnet tokens from the faucet:

```bash
aptos account fund-with-faucet --account <your-account-address> --amount 100000000
```

### Module Already Published

You can't republish a module at the same address unless you upgrade it properly. For development, either:
- Create a new account for each deployment
- Use the `--override` flag (only on devnet/testnet)
- Properly implement module upgrades with version management

## Next Steps

Once you're comfortable with this basic contract, consider exploring:

- **Events**: Add event emissions to track when messages are set or retrieved
- **Access Control**: Implement logic to restrict who can read certain messages
- **Collections**: Allow users to store multiple messages instead of just one
- **Integration**: Build a frontend application that interacts with your contract
- **Testing**: Write comprehensive unit tests covering edge cases

## Resources

- [Aptos Developer Documentation](https://aptos.dev/)
- [Move Language Book](https://move-language.github.io/move/)
- [Aptos Framework Source Code](https://github.com/aptos-labs/aptos-framework)
- [Aptos Discord Community](https://discord.gg/aptosnetwork)

## License

This project is open source and available for educational purposes. Feel free to modify and build upon it for your own learning.
