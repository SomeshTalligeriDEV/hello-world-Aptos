module move_publisher::hello_aptos_test {
    use std::string;
    use std::signer;
    use std::debug;

    struct MessageHolder has key, store, drop {
        message: string::String
    }

    public entry fun set_message(
        account: &signer, message: string::String
    ) acquires MessageHolder {
        let account_addr: address = signer::address_of(account);

        debug::print(&string::utf8(b"Running set_message...\n"));
        debug::print(&string::utf8(b"Input message: "));
        debug::print(&message);

        if (exists<MessageHolder>(account_addr)) {
            debug::print(
                &string::utf8(b"\nExisting message found. Removing old value...\n")
            );
            move_from<MessageHolder>(account_addr);
        } else {
            debug::print(
                &string::utf8(b"\nNo previous message found. Creating new resource...\n")
            );
        };

        move_to(account, MessageHolder { message });

        debug::print(&string::utf8(b"Message stored successfully.\n"));
    }

    #[view]
    public fun get_message(account_addr: address): string::String acquires MessageHolder {
        debug::print(&string::utf8(b"Running get_message...\n"));

        assert!(exists<MessageHolder>(account_addr), 0);

        let message_holder: &MessageHolder = borrow_global<MessageHolder>(account_addr);

        debug::print(&string::utf8(b"Stored message: "));
        debug::print(&message_holder.message);
        debug::print(&string::utf8(b"\nReturning value...\n"));

        message_holder.message
    }
}

