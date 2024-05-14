module tale::tale {
    use std::option:: {Self, Option};
    use std::string:: {Self, String};
    use sui::transfer;
    use sui::object:: {Self, UID, ID};
    use sui::tx_context:: {Self, TxContext};
    use sui::coin:: {Self, Coin};
    use sui::sui::SUI;
    use sui::event;

    // skin struct
    public struct Tale has key, store {
        id: UID,
        author: address,
        title: String,
        category: String,
        story: String,
    }

    // events
    public struct TaleCreated has copy, drop {
        tale_id: ID,
        author: address,
    }

    // mint tale
    public fun mint_tale (
        ctx: &mut TxContext,
        title: vector<u8>,
        category: vector<u8>,
        story: vector<u8>,   
    ) {
        let sender = tx_context::sender(ctx);
        let tale = Tale {
            id: object::new(ctx),
            author: sender,
            title: string::utf8(title),
            category: string::utf8(category),
            story: string::utf8(story),
        };

        event::emit(TaleCreated {
            tale_id: object::id(&tale),
            author: sender,
        });

        transfer::public_transfer(tale, sender);
    }
}