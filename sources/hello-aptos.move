module move_publisher::hello_aptos {
    use std::string;
    use std::signer;

    struct MessageHolder has key, store, drop {
        message: string::String
    }

    public entry fun set_message(
        account: &signer, message: string::String
    ) acquires MessageHolder {
        let account_addr: address = signer::address_of(account);

        // If a MessageHolder resource already exists, remove it
        if (exists<MessageHolder>(account_addr)) {
            move_from<MessageHolder>(account_addr);
        };

        // Store a new MessageHolder in the user's account
        move_to(account, MessageHolder { message })
    }

    #[view]
    public fun get_message(account_addr: address): string::String acquires MessageHolder {
        assert!(exists<MessageHolder>(account_addr), 0);

        let message_holder: &MessageHolder = borrow_global<MessageHolder>(account_addr);
        message_holder.message
    }
}

